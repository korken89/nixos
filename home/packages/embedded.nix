{
  pkgs,
  lib,
  system,
  ...
}:
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
      kicad
    ]
    ++ lib.optionals (system == "x86_64-linux") [
      # x86_64 only
      saleae-logic-2
    ];
}
