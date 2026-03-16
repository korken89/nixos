{ username, ... }:
{
  # Host-specific configuration for home workstation
  home-manager.users.${username} = {
    notesDirectory = "/src/home_sync/Work Notes";
  };
}
