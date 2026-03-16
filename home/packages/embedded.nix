{
  pkgs,
  lib,
  system,
  ...
}:
let
  # FreeCAD with Zink (OpenGL-over-Vulkan) workaround for NVIDIA on Wayland
  # https://github.com/NixOS/nixpkgs/issues/468456
  freecad-zink = pkgs.runCommand "freecad-zink" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.freecad-wayland}/bin/FreeCAD $out/bin/freecad-zink \
      --set MESA_LOADER_DRIVER_OVERRIDE zink \
      --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
  '';
in
{
  home.packages =
    with pkgs;
    [
      # Embedded/Hardware Development
      probe-rs-tools
      qemu
      sdcc
      tio
      usbtop
      udev

      # Hardware analysis
      pulseview
      sigrok-cli
      sigrok-firmware-fx2lafw

      # Microcontroller tools
      stm32cubemx

      # EDA tools
      freecad
      freecad-zink
      (kicad.override { compressStep = false; })
      librepcb
    ]
    ++ lib.optionals (system == "x86_64-linux") [
      # x86_64 only
      saleae-logic-2
    ];
}
