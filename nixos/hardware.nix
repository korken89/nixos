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
  services.blueman = {
    enable = true;
  };

  # Saleae
  hardware.saleae-logic.enable = true;

  # udev
  environment.systemPackages = with pkgs; [
    openocd
  ];
  services.udev = {
    enable = true;
    packages = with pkgs; [
      libsigrok
      openocd
    ];

    # WCH CH347 (wch-probe)
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d[a-e]", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      # uhubctl: Realtek RTS5411 hubs (0bda:5411) switchable by plugdev
      SUBSYSTEM=="usb", DRIVER=="hub|usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="5411", MODE="0664", GROUP="plugdev"
      SUBSYSTEM=="usb", DRIVER=="hub", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="5411", RUN+="${pkgs.bash}/bin/sh -c '${pkgs.coreutils}/bin/chgrp -f plugdev $sys$devpath/*-port*/disable; ${pkgs.coreutils}/bin/chmod -f 664 $sys$devpath/*-port*/disable; true'"
    '';
  };
  hardware.probe-rs.enable = true;
}
