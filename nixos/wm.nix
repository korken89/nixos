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

  environment.sessionVariables = {
    # Nix packages configure Chrome and Electron apps to run in native Wayland
    # mode if this environment variable is set.
    NIXOS_OZONE_WL = "1";

    # Fixes some Java apps, e.g. file picker not showing (stm32cubemx)
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # If xwayland-satellite.service is running it defines an Xwayland display
    # with this identifier.
    DISPLAY = ":0";
  };

}
