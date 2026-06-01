{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Miscellaneous
    feh
    imv

    # Math & Science
    octaveFull

    # System/Desktop
    gsettings-desktop-schemas
  ];
}
