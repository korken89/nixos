# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Kernel (latest)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # Overlays
  # nixpkgs = {
  #   config = {
  #     allowUnfree = true;
  #     packageOverrides = pkgs: {
  #       unstable =
  #         import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
  #           { };
  #     };
  #   };
  # };

  networking.hostName = "emifre-workstation"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Hardware config
  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable screensharing
  services.dbus.enable = true;

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "emifre";
    dataDir = "/home/emifre";
    configDir = "/home/emifre/.config/syncthing";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall (syncthing)
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
