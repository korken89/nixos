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
    ./swayidle.nix
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
      gh
      gimp3
      gnumake
      gsettings-desktop-schemas
      helvum
      jq
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

      # Markdown
      markdown-oxide
      marksman
      prettier

      # Development
      autoconf
      automake
      cargo-binutils
      cargo-bloat
      cargo-expand
      cargo-watch
      claude-code
      cmake
      flip-link
      gcc
      gcc-arm-embedded
      ghidra
      jujutsu
      openssl
      pkg-config
      probe-rs-tools
      python3
      qemu
      rustup
      sdcc
      udev
      usbtop
      xchm

      # Applications
      bambu-studio
      chromium
      element-desktop
      firefox
      inkscape
      libreoffice-qt6-fresh
      mattermost-desktop
      netbird
      pulseview
      saleae-logic-2
      signal-desktop
      sigrok-cli
      sigrok-firmware-fx2lafw
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
  programs.direnv = {
    enable = true;
    enableFishIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
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
