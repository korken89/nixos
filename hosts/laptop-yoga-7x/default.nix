{ ... }:
{
  # Host-specific configuration for laptop
  home-manager.users.emifre = {
    notesDirectory = "$HOME/Sync/Work Notes";
  };

  services.kanata.keyboards.internalKeyboard.devices = [
    "/dev/input/by-path/platform-b80000.i2c-event-kbd"
  ];
}
