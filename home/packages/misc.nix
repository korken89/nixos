{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Miscellaneous
    feh
    imagemagick
    imv
    poppler-utils

    # Math & Science
    octaveFull

    # System/Desktop
    gsettings-desktop-schemas
  ];
}
