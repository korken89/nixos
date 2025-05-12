{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    helix
    nil
    markdown-oxide
    ltex-ls
  ];

  xdg.configFile."helix/config.toml".source = ../dotfiles/helix/config.toml;
  xdg.configFile."helix/languages.toml".source = ../dotfiles/helix/languages.toml;
  xdg.configFile."helix/themes/dark_plus_oled.toml".source =
    ../dotfiles/helix/themes/dark_plus_oled.toml;
}
