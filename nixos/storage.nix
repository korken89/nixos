{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
let
  ns = "emifre";
  cfg = config.${ns}.storage;
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options.${ns}.storage = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable custom ${ns} storage configuration";
    };
    size = mkOption {
      type = types.str;
      description = "The size of the final (large) partition";
      default = "100%";
    };
    device = mkOption {
      type = types.path;
      description = "root block device for the system";
    };
    bootType = mkOption {
      type = types.enum [
        "bios"
        "uefi"
      ];
      description = "choose boot variant";
    };
    encryption = mkOption {
      type = types.bool;
      description = "encrypt root ZFS pool";
    };
    persist_dirs = mkOption {
      # TODO: Enable the same type-checking as the underlying impermanence?
      # https://github.com/nix-community/impermanence/blob/master/nixos.nix#L404
      # type = types.listOf types.path;
      description = "additional directories to persist (for systems using impermanence)";
      default = [ ];
    };
    persist_files = mkOption {
      # TODO: Enable the same type-checking as the underlying impermanence?
      # https://github.com/nix-community/impermanence/blob/master/nixos.nix#L392
      # type = types.listOf types.path;
      description = "additional files to persist (for systems using impermanence)";
      default = [ ];
    };
  };

  config = mkIf cfg.enable (
    let
      zfsRootPool = "zroot";
      zfsSystemDataset = "system";
      zfsRootDataset = "${zfsSystemDataset}/root";
      zfsRootDatasetBlankSnapshot = "${zfsRootPool}/${zfsRootDataset}@blank";
    in
    mkMerge [
      {
        disko.devices = {
          disk = {
            main = {
              type = "disk";
              device = cfg.device;
              content = {
                type = "gpt";
                partitions = (
                  {
                    boot = {
                      label = "BIOS-Boot-Partition";
                      size = "1M";
                      type = "EF02";
                    };
                  }
                  // (
                    if cfg.bootType == "uefi" then
                      {
                        ESP = {
                          label = "EFI-Partition";
                          size = "1G";
                          type = "EF00";
                          content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                          };
                        };
                      }
                    else
                      { }
                  )
                  // (
                    if cfg.bootType == "bios" then
                      {
                        grub = {
                          label = "Boot-Partition";
                          size = "400M";
                          content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/boot";
                          };
                        };
                      }
                    else
                      { }
                  )
                  // (
                    if cfg.encryption then
                      {
                        luks = {
                          label = "ZFS-Root-Via-LUKS-Partition";
                          size = cfg.size;
                          content = {
                            type = "luks";
                            name = "crypted-${zfsRootPool}";
                            content = {
                              type = "zfs";
                              pool = zfsRootPool;
                            };
                          };
                        };
                      }
                    else
                      {
                        zroot = {
                          label = "ZFS-Root-Partition";
                          size = cfg.size;
                          content = {
                            type = "zfs";
                            pool = zfsRootPool;
                          };
                        };
                      }
                  )
                );
              };
            };
          };
        };
      }
      {
        networking.hostId = "deadbeef"; # ZFS requirement
        boot.loader.grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
          configurationLimit = 4;
        };
        disko.devices = {
          zpool = {
            ${zfsRootPool} = {
              type = "zpool";
              rootFsOptions = {
                # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
                acltype = "posixacl";
                atime = "off";
                compression = "zstd";
                mountpoint = "none";
                xattr = "sa";
              };
              options.ashift = "12";

              datasets = {
                ${zfsSystemDataset} = {
                  type = "zfs_fs";
                  options.mountpoint = "none";
                };
                ${zfsRootDataset} = {
                  type = "zfs_fs";
                  options.mountpoint = "legacy";
                  mountpoint = "/";
                  options."com.sun:auto-snapshot" = "false";
                  postCreateHook = "zfs snapshot ${zfsRootDatasetBlankSnapshot}"; # TODO: How to move this to cfg.impermanence part?
                };
                "${zfsSystemDataset}/nix" = {
                  type = "zfs_fs";
                  options.mountpoint = "legacy";
                  mountpoint = "/nix";
                  options."com.sun:auto-snapshot" = "false";
                };
                "${zfsSystemDataset}/configuration" = {
                  type = "zfs_fs";
                  mountpoint = "/etc/nixos";
                  options."com.sun:auto-snapshot" = "false";
                };
                "${zfsSystemDataset}/home/root" = {
                  type = "zfs_fs";
                  mountpoint = "/root";
                  options."com.sun:auto-snapshot" = "false";
                };
                "${zfsSystemDataset}/home" = {
                  type = "zfs_fs";
                  mountpoint = "/home";
                  options."com.sun:auto-snapshot" = "false";
                };
              };
            };
          };
        };
      }
    ]
  );
}
