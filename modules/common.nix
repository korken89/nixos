# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  pkgs,
  ...
}:
{

  imports = [
    # inputs.home-manager.nixosModules.home-manager
    # ./acme.nix
    # ./auto-upgrade.nix
    # ./fish.nix
    # ./locale.nix
    # ./nix.nix
    # ./openssh.nix
    # ./optin-persistence.nix
    # ./podman.nix
    # ./sops.nix
    # ./ssh-serve-store.nix
    # ./steam-hardware.nix
    # ./systemd-initrd.nix
    # ./tailscale.nix
    # ./gamemode.nix
    # ./nix-ld.nix
    # ./prometheus-node-exporter.nix
    # ./kdeconnect.nix
    # ./upower.nix
  ]; # ++ (builtins.attrValues outputs.nixosModules);

  environment.systemPackages = with pkgs; [
    # Utilities
    coreutils-full
    curl
    fd
    git
    gnumake
    helix
    networkmanagerapplet
    nil
    nixfmt-rfc-style
    nvd
    pigz
    ripgrep
    sd
    syncthing
    wget
    wireshark

    # WM stuff
    alacritty
    base16-schemes
    dunst
    libnotify
    polkit_gnome
    rofimoji
    rofi-wayland
    swww
    waybar
    wl-mirror
    swayidle
    swaylock-effects
    brightnessctl
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard
  ];

  # libinput
  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      middleEmulation = true;
      tapping = true;

      additionalOptions = ''
        Option "PalmDetection" "on"
      '';
    };
  };

  # Wireshark
  programs.wireshark.enable = true;

  #
  # File manager
  #
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emifre = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Emil Fresk";
    extraGroups = [
      "docker"
      "networkmanager"
      "plugdev"
      "wheel"
      "wireshark"
    ];

    openssh.authorizedKeys.keys = [
      # curl https://gitlab.com/korken89.keys
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1xvogP5S5I3Er6+O5ctuYQJxtJD90Kjy2S3x1wxB0L Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM33C+JR1Wqo8StKL0VA4gQE7TT37F2IIFgGko5e+WhR Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoXn2bjd1dQjSTE8ZdnwEUqvDDbJNUmcRMIIzkgwASa Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5zmlJY9VDbDlFYxU3Q6jjT9yyBB3/FJajqMiPYvw6B Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYii7BODLrfyvo8WfDnNu+4hxD0AxzBdKFtFcrO0gim Emil Fresk (gitlab.com)"
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if test -z "$WAYLAND_DISPLAY" && test "$XDG_VTNR" -eq 1
        exec ${pkgs.hyprland}/bin/Hyprland
      end
    '';
  };
  documentation.man.generateCaches = false; # fish causes super slow builds if this is on
  programs.starship.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable netbird daemon
  services.netbird.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Make sure helix is used for commands
  environment.variables.SUDO_EDITOR = "hx";
  environment.variables.EDITOR = "hx";
  environment.variables.TERM = "xterm-256color";

  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      nerd-fonts.fira-code
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

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  # security.pam.services.swaylock = {};

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "emifre";
    dataDir = "/home/emifre";
    configDir = "/home/emifre/.config/syncthing";
  };

  # udev
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"

      # sigrok FX2 LA (8ch)
      # fx2grok-flat (before and after renumeration)
      ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608c", MODE="660", GROUP="users", TAG+="uaccess"

      # sigrok FX2 LA (16ch)
      ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="608d", MODE="660", GROUP="users", TAG+="uaccess"

      # Cypress FX2 eval boards without EEPROM:
      # fx2grok-tiny
      ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="8613", MODE="660", GROUP="users", TAG+="uaccess"

      # DAP
      ATTRS{product}=="*CMSIS-DAP*", MODE="660", TAG+="uaccess"

      # STMicroelectronics ST-LINK/V1
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE="660", TAG+="uaccess"

      # STMicroelectronics ST-LINK/V2
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="660", TAG+="uaccess"

      # STMicroelectronics ST-LINK/V2.1
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="660", TAG+="uaccess"
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="660", TAG+="uaccess"

      # STMicroelectronics STLINK-V3
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE="660", TAG+="uaccess"
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="660", TAG+="uaccess"
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="660", TAG+="uaccess"
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="660", TAG+="uaccess"
      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE="660", TAG+="uaccess"
    '';
  };

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
