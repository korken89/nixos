{ pkgs, ... }:
{
  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.replaceStrings
      [ "@niri@" "@direnv@" "@keychain@" "@eza@" ]
      [ "${pkgs.niri}" "${pkgs.direnv}" "${pkgs.keychain}" "${pkgs.eza}" ]
      (builtins.readFile ../dotfiles/fish/config.fish);
  };
  documentation.man.generateCaches = false; # fish causes super slow builds if this is on
  programs.starship.enable = true;
}
