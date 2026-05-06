{ pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };
}
