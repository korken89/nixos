{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    # OpenEMS tooling
    appcsxcad
    csxcad
    openems
    paraview
  ];

  # Configure openEMS to octave
  home.file.".octaverc".text = ''
    addpath ('${pkgs.openems}/share/openEMS/matlab', '-begin');
    addpath ('${pkgs.csxcad}/share/CSXCAD/matlab', '-begin');
  '';
}
