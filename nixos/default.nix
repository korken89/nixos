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
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.emifre = import ../home;
    }
    inputs.probe-rs-rules.nixosModules.${system}.default

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

  programs.ydotool = {
    enable = true;
    group = "wheel";
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
  programs.file-roller.enable = true;
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
      "audio"
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0H4FwVWDsnGrIXU2J590raVWhbGc5vx5qwVzrH5Vs8 Emil Fresk (gitlab.com)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoXn2bjd1dQjSTE8ZdnwEUqvDDbJNUmcRMIIzkgwASa Emil Fresk (gitlab.com)"
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if test -z "$WAYLAND_DISPLAY" && test "$XDG_VTNR" -eq 1
        exec ${pkgs.niri}/bin/niri-session
      end

      if status --is-interactive
          keychain --eval --quiet -Q id_ed25519 | source
      end

      begin
          set -l HOSTNAME (hostname)
          if test -f ~/.keychain/$HOSTNAME-fish
              source ~/.keychain/$HOSTNAME-fish
          end
      end

      function ls -d 'eza instead of ls when output is a terminal'
        if isatty 1
          if type --quiet eza
            eza --group-directories-first --git --icons $argv
          else
            command ls --color=auto $argv
          end
        else
          command ls $argv
        end
      end

      function ll -d 'alias ls -l'
        ls -l $argv
      end

      function lt
        ls -l --tree $argv
      end

      function la -d 'alias ls -la'
        ls -la $argv
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

  # Fix /etc/hosts
  environment.etc.hosts.mode = "0644";

  fonts = {
    packages = with pkgs; [
      corefonts # Microsoft fonts
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

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  # security.pam.services.swaylock = {};
  services.dbus.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
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
    packages = with pkgs; [ libsigrok ];
  };
  hardware.probe-rs.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
