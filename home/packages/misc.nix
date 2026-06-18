{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Miscellaneous
    feh
    imv
    poppler-utils

    # Math & Science
    octaveFull

    # System/Desktop
    gsettings-desktop-schemas
  ];
}
