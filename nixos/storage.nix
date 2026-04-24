{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:
with lib;
let
  ns = username;
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
      description = "The size of the final (large) partition. Use absolute sizes like '500G' or '100%' for remaining space. Note: percentages other than 100% are not supported by disko.";
      default = "100%";
    };
    device = mkOption {
      type = types.path;
      description = "root block device for the system";
    };
    encryption = mkOption {
      type = types.bool;
      description = "encrypt root ZFS pool";
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
                partitions = {
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
                } // (
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
          device = "nodev";
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
                relatime = "on";
                dnodesize = "auto";
                # We skip unicode normalization in filenames
                # Let's not crash when we try to store some suspicious non-unicode-named files
                # on syncthing, for example.
                normalization = "none";
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
