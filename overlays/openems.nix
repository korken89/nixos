final: prev: {
  # Boost 1.89 removed the boost_system stub library, breaking openEMS build
  openems = prev.openems.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      sed -i 's/  system//' CMakeLists.txt
    '';
  });

  # Upstream postFixup deletes AppCSXCAD.sh, but octave's CSXGeomPlot needs it
  appcsxcad = prev.appcsxcad.overrideAttrs (old: {
    postFixup = "";
  });
}
