# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  pkgs,
  lib,
  system,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = {
        inherit inputs system;
      };
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.users.emifre = import ../home;
    }
    inputs.probe-rs-rules.nixosModules.${system}.default

    ./file-manager.nix
    ./fonts.nix
    ./hardware.nix
    ./locale.nix
    ./security.nix
    ./services.nix
    ./shell.nix
    ./users.nix
    ./wm.nix
  ];

  environment.systemPackages = with pkgs; [

    # Utilities
    blueman
    keychain
    networkmanagerapplet
    syncthing

    # Audio utils
    alsa-utils
    pulseaudio

    # WM stuff
    alacritty
    libnotify
    polkit_gnome
    dunst
    swaylock-effects
    swww
    wl-mirror
    brightnessctl
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard
  ];

  programs.ydotool = {
    enable = true;
    group = "wheel";
  };

  # Wireshark
  programs.wireshark.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Make sure helix is used for commands
  environment.variables.SUDO_EDITOR = "hx";
  environment.variables.EDITOR = "hx";
  environment.variables.TERM = "xterm-256color";

  # Fix /etc/hosts
  environment.etc.hosts.mode = "0644";

  # Networking
  networking.networkmanager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
