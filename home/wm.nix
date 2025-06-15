{
  pkgs,
  lib,
  ...
}:

{
  # rofi
  home.packages = with pkgs; [
    rofimoji
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  stylix.targets.rofi.enable = true;

  # XWayland
  imports = [ ./xwayland-satellite.nix ];

  # Configure niri
  xdg.configFile."niri/config.kdl".source = ../dotfiles/niri/config.kdl;

  # Nix packages configure Chrome and Electron apps to run in native Wayland
  # mode if this environment variable is set.
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    config.common = {
      # Copy the original portal configuration of niri
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      # GNOME portal is used by default in `niri`.
      #
      # However, it expects nautilus in the system path to work,
      # otherwise attempting to open a file picker silently fails and
      # does nothing.
      #
      # Also, it is impossible to tell apart a window of
      # `nautilus` opened as a file picker and regularly which is a
      # pain when trying to define window rules to make it nice and
      # floating.
      #
      # Eeh.
      #
      # https://github.com/sodiboo/niri-flake/issues/946
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  services.blueman-applet.enable = true;
  systemd.user.services.blueman-applet.Install = lib.mkForce {
    # Replace "graphical-session.target" so that this only starts when Niri starts.
    WantedBy = [ "tray.target" ];
  };

  services.network-manager-applet.enable = true;
  systemd.user.services.network-manager-applet.Install = lib.mkForce {
    # Replace "graphical-session.target" so that this only starts when Niri starts.
    WantedBy = [ "tray.target" ];
  };

  # Some services, like blueman-applet, require a `tray` target. Typically Home
  # Manager sets this target in WM modules, but it's not set up for Niri yet.
  systemd.user.targets.tray = lib.mkForce {
    Unit = {
      Description = "Target for apps that want to start minimized to the system tray";
      After = [ "niri.service" ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };
}
