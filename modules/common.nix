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

    # WM stuff
    alacritty
    base16-schemes
    dunst
    kitty
    libnotify
    polkit_gnome
    rofimoji
    rofi-wayland
    swww
    waybar
    wl-mirror
    swayidle
    swaylock
    brightnessctl
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard
  ];

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
    isNormalUser = true;
    description = "Emil Fresk";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "plugdev"
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
  programs.fish.enable = true;
  documentation.man.generateCaches = false; # fish causes super slow builds if this is on
  programs.starship.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      # Start Hyprland automatically on TTY login (https://wiki.archlinux.org/title/Sway#Automatically_on_TTY_login)
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec ${pkgs.hyprland}/bin/Hyprland
      fi

      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

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

  # udev
  services.udev = {
    enable = true;
    extraRules = ''
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
