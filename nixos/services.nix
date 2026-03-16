{ config, username, ... }:
let
  user = config.users.users.${username};
in
{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Enable netbird daemon
  services.netbird.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = username;
    dataDir = user.home;
    configDir = "${user.home}/.config/syncthing";
  };

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
