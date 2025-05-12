{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Hardware configuration
    inputs.x1e-nixos-config.nixosModules.x1e
    {
      networking.hostName = "emifre-yoga-7x-nixos";
      hardware.lenovo-yoga-slim7x.enable = true;

      nixpkgs.hostPlatform.system = "aarch64-linux";

      nix = {
        channel.enable = false;
      };
    }
  ];

  boot.loader.systemd-boot = {
    enable = true;

    # The default EFI partition created by Windows is really small, limit to 2
    # generations to be on the safe side.
    configurationLimit = 2;
  };

  boot.initrd.systemd = {
    enable = true;

    # This is not secure, but it makes diagnosing errors easier.
    emergencyAccess = true;
  };

  hardware.enableRedistributableFirmware = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/SYSTEM_DRV";
      fsType = "vfat";
    };
  };

  # Enable some SysRq keys (80 = sync + process kill)
  # See: https://docs.kernel.org/admin-guide/sysrq.html
  boot.kernel.sysctl."kernel.sysrq" = 80;

}
