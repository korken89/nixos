{ pkgs, ... }:
{
  # libinput
  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      middleEmulation = true;
      tapping = true;

      additionalOptions = ''
        Option "PalmDetection" "on"
      '';
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Saleae
  hardware.saleae-logic.enable = true;

  # udev
  services.udev = {
    enable = true;
    packages = with pkgs; [ libsigrok ];
  };
  hardware.probe-rs.enable = true;
}
