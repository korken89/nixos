{
  pkgs,
  lib,
  system,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # Desktop Applications

      # Browsers
      chromium
      firefox

      # Communication
      element-desktop
      mattermost-desktop
      signal-desktop
      telegram-desktop
      mumble

      # Media
      vlc
      helvum
      pavucontrol

      # Graphics
      gimp3
      inkscape

      # Documents
      kdePackages.okular
      libreoffice-qt6-fresh
      zathura
      obsidian

      # Security
      wireshark

      # Network
      netbird
      mqttui
    ]
    ++ lib.optionals (system == "x86_64-linux") [
      # x86_64 only
      # bambu-studio
      spotify
      slack
    ];
}
