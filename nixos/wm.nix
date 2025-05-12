{
  inputs,
  pkgs,
  # lib,
  ...
}:

{
  imports = [ inputs.niri-flake.nixosModules.niri ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
}
