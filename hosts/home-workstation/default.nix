{ ... }:
{
  # Host-specific configuration for home workstation
  home-manager.users.emifre = {
    notesDirectory = "/src/home_sync/Work Notes";
  };

  services.kanata.keyboards.internalKeyboard.devices = [
    "/dev/input/by-path/pci-0000:00:14.0-usb-0:9.3.1:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usb-0:9.4:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usb-0:9.4:1.1-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9.3.1:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9.4:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9.4:1.1-event-kbd"
  ];
}
