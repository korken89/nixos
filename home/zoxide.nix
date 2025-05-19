{
  pkgs,
  lib,
  ...
}:

{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  xdg.configFile."fish/config.fish".text = ''
    zoxide init fish --cmd cd | source
  '';
}
