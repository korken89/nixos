# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Kernel (latest)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Overlays
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable =
          import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
            { };
      };
    };
  };

  networking.hostName = "emifre-laptop-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emifre = {
    isNormalUser = true;
    description = "Emil Fresk";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  # Fish shell
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      # Check if Hyprland is running and start if not
      if ! pgrep -i "hyprland" > /dev/null; then
          ${pkgs.hyprland}/bin/hyprland &
      fi

      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Utilities
    curl
    git
    unstable.helix
    networkmanagerapplet
    unstable.nil
    unstable.nixfmt-rfc-style
    nvd
    wget
    ripgrep
    fd
    sd
    neofetch

    # WM stuff
    alacritty
    dunst
    kitty
    libnotify
    rofimoji
    rofi-wayland
    swww
    waybar
    wl-mirror
    swaylock
    brightnessctl

    # Development
    clang
    openssl
    pkg-config
    unstable.cargo-binutils
    unstable.cargo-bloat
    unstable.cargo-expand
    unstable.cargo-watch
    unstable.probe-rs-tools
    unstable.rust-analyzer
    unstable.rustup

    # Applications
    chromium
    mattermost-desktop
    telegram-desktop
    zathura

    # Tooling
    unstable.kicad
  ];

  # Make sure helix is used for commands
  environment.variables.SUDO_EDITOR = "hx";
  environment.variables.EDITOR = "hx";

  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "Fira Code"
          "Noto Color Emoji"
        ];
      };
    };
  };

  #
  # Enable hyprland
  #
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Enable this if cursors are missing
    NIXOS_OZONE_WL = "1";
  };

  # Hardware config
  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  services.blueman.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable screensharing
  services.dbus.enable = true;

  # Enable sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
