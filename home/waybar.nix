{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
  };

  xdg.configFile."waybar/config".source = lib.mkForce ../dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source = lib.mkForce ../dotfiles/waybar/style.css;
}
