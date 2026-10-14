{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.tmux
    # pkgs.sesh
    pkgs.gum
  ];

  xdg.configFile."tmux/tmux.conf".source = ../dotfiles/tmux/tmux.conf;
}
