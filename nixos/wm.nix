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

  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
