{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.tmux
    pkgs.sesh
    pkgs.gum
  ];

  xdg.configFile."tmux/tmux.conf".source = ../dotfiles/tmux/tmux.conf;
  xdg.configFile."fish/config.fish".text = lib.mkBefore ''
    bind \cf 'sesh connect $(sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder "Pick a sesh" --height 50 --no-strip-ansi)'
  '';
}
