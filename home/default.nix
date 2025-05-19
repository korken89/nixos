{
  system,
  pkgs,
  inputs,
  ...
}:
let
  lib = inputs.nixpkgs.lib;
in
{
  imports = [
    ./git.nix
    ./helix.nix
    ./openems.nix
    ./screens.nix
    ./stylix.nix
    ./tmux.nix
    ./waybar.nix
    ./wm.nix
    ./zoxide.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages =
    with pkgs;
    [
      btop
      coreutils-full
      curl
      eza
      fd
      file
      fzf
      gimp
      gnumake
      gsettings-desktop-schemas
      helvum
      kdePackages.okular
      mqttui
      nixfmt-rfc-style
      nixfmt-tree
      nvd
      octaveFull
      pavucontrol
      pigz
      ripgrep
      sd
      unzip
      usbutils
      wget
      wireshark
      xxd
      zip

      # Development
      autoconf
      automake
      cargo-binutils
      cargo-bloat
      cargo-expand
      cargo-watch
      cmake
      flip-link
      gcc
      gcc-arm-embedded
      jujutsu
      openssl
      pkg-config
      probe-rs-tools
      python3
      rustup
      sdcc
      udev
      usbtop
      xchm

      # Applications
      chromium
      element-desktop
      firefox
      inkscape
      mattermost-desktop
      netbird
      pulseview
      signal-desktop
      sigrok-firmware-fx2lafw
      sigrok-cli
      telegram-desktop
      tokei
      vlc
      zathura

      # Writing
      tinymist
      typst
      typstyle

      # Tooling
      freecad
      kicad
      mumble
      obsidian
      stm32cubemx
      tio # TUI serial console
    ]
    ++ lib.optionals (system == "x86_64-linux") [
      spotify
      slack
    ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "emifre";
  home.homeDirectory = "/home/emifre";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable ssh agent (https://wiki.nixos.org/wiki/SSH_public_key_authentication)
  services.ssh-agent.enable = true;

}
