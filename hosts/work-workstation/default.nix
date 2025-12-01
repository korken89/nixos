{ ... }:
{
  # Host-specific configuration for work workstation
  home-manager.users.emifre = {
    notesDirectory = "$HOME/Sync/Work Notes";
  };

  services.kanata.keyboards.internalKeyboard.devices = [
    "/dev/input/by-path/pci-0000:00:14.0-usb-0:4.4:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usb-0:4.4:1.1-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:4.4:1.0-event-kbd"
    "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:4.4:1.1-event-kbd"
  ];
}
