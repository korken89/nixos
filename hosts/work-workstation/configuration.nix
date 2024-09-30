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
  services.xserver = {
    xkb.layout = "us";
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

    openssh.authorizedKeys.keys = [
      # curl https://gitlab.com/korken89.keys
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1xvogP5S5I3Er6+O5ctuYQJxtJD90Kjy2S3x1wxB0L Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM33C+JR1Wqo8StKL0VA4gQE7TT37F2IIFgGko5e+WhR Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYii7BODLrfyvo8WfDnNu+4hxD0AxzBdKFtFcrO0gim Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5zmlJY9VDbDlFYxU3Q6jjT9yyBB3/FJajqMiPYvw6B Emil Fresk (gitlab.com)"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Fish shell
  programs.fish.enable = true;
  documentation.man.generateCaches = false; # fish causes super slow builds if this is on
  programs.starship.enable = true;
  programs.bash = {
    interactiveShellInit = ''
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
    fd
    git
    helix
    networkmanagerapplet
    nil
    nixfmt-rfc-style
    nvd
    ripgrep
    sd
    syncthing
    wget

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
    cargo-binutils
    cargo-bloat
    cargo-expand
    cargo-watch
    clang
    flip-link
    ltex-ls
    openssl
    pkg-config
    probe-rs-tools
    rust-analyzer
    rustup

    # Applications
    chromium
    element-desktop
    firefox
    mattermost-desktop
    slack
    spotify
    telegram-desktop
    zathura

    # Tooling
    kicad
  ];

  # Make sure helix is used for commands
  environment.variables.SUDO_EDITOR = "hx";
  environment.variables.EDITOR = "hx";
  environment.variables.TERM = "xterm-256color";

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
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # # Autostart hyprland
  # systemd.user.services.hyprland = {
  #   description = "Hyprland Wayland Compositor";
  #   after = [ "graphical-session.target" ];
  #   requires = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.hyprland}/bin/hyprland";
  #     # Restart = "always";
  #     Environment = "DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/%U PATH=/run/current-system/sw/bin";
  #     WorkingDirectory = "%h";
  #   };
  #   wantedBy = [ "default.target" ];
  # };

  # Hardware config
  hardware = {
    graphics.enable = true;
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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Syncthing
  services.syncthing.enable = true;

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
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];
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
