{
  pkgs,
  lib,
  system,
  ...
}:
let
  # Bambu Studio with Zink (OpenGL-over-Vulkan), it does not render on the NVIDIA GL driver
  bambu-studio-zink = pkgs.symlinkJoin {
    name = "bambu-studio-zink";
    paths = [
      # Not in the binary cache, and a full-width local build runs out of RAM
      (pkgs.bambu-studio.overrideAttrs (old: {
        preBuild = (old.preBuild or "") + ''
          NIX_BUILD_CORES=4
        '';
      }))
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bambu-studio \
        --set __GLX_VENDOR_LIBRARY_NAME mesa \
        --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
        --set MESA_LOADER_DRIVER_OVERRIDE zink \
        --set GALLIUM_DRIVER zink
    '';
  };
in
{
  home.packages =
    with pkgs;
    [
      # Desktop Applications
      waypipe

      # Browsers
      chromium
      firefox

      # Communication
      element-desktop
      mattermost-desktop
      signal-desktop
      telegram-desktop
      mumble

      # Media
      crosspipe
      vlc
      pavucontrol

      # Graphics
      gimp3
      inkscape

      # Documents
      kdePackages.okular
      libreoffice-qt
      zathura
      obsidian

      # Security
      wireshark

      # Network
      netbird
      mqttui

      # Desktop streaming
      moonlight-qt
    ]
    ++ lib.optionals (system == "x86_64-linux") [
      # x86_64 only
      bambu-studio-zink
      spotify
      slack
    ];
}
