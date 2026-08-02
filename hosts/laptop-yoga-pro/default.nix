{ username, ... }:
{
  # Host-specific configuration for home workstation
  home-manager.users.${username} = {
    notesDirectory = "/src/home_sync/Work Notes";
  };

  # Disable sleep, it's borked.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowSuspendThenHibernate = false;
    AllowHybridSleep = false;
    AllowHibernation = false;
  };
  services.logind.settings.Login.HandleLidSwitch = "lock";
}
