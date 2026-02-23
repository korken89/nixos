{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
    fonts = {
      monospace = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      sizes = {
        terminal = 12;
        applications = 10;
        popups = 11;
        desktop = 10;
      };
    };
    targets = {
      alacritty.enable = true;
      gtk.enable = true;
      lazygit.enable = true;
      opencode.enable = true;
    };
  };
}
