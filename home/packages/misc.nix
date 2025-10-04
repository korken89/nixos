{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Miscellaneous

    # Math & Science
    octaveFull

    # System/Desktop
    gsettings-desktop-schemas
  ];
}
