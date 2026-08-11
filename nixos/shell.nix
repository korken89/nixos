{ pkgs, ... }:
{
  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit =
      builtins.replaceStrings
        [ "@niri@" "@direnv@" "@keychain@" "@eza@" ]
        [ "${pkgs.niri}" "${pkgs.direnv}" "${pkgs.keychain}" "${pkgs.eza}" ]
        (builtins.readFile ../dotfiles/fish/config.fish);
  };
  documentation.man.cache.enable = false; # fish causes super slow builds if this is on

  # Starship prompt with jj-aware vcs info via jj-starship
  programs.starship = {
    enable = true;
    settings = {
      custom.jj = {
        when = "jj-starship detect";
        shell = [ "jj-starship" ];
        format = "$output ";
      };
      git_branch.disabled = true;
      git_status.disabled = true;
    };
  };
  environment.systemPackages = [ pkgs.jj-starship ];
}
