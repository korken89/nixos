{
  pkgs,
  lib,
  system,
  ...
}:
let
  solidcraft =
    let
      pname = "solidcraft";
      version = "0.40.0-rc.3";
      arch = lib.head (lib.splitString "-" system);
      src = pkgs.fetchurl {
        url = "https://github.com/tangency-labs/solidcraft/releases/download/v${version}/solidcraft-${version}-linux-${arch}.AppImage";
        hash =
          {
            x86_64 = "sha256-Z+jepAuAchfW1qiP8fK2Qzzfv0tHXuJRldNhLYhrX1s=";
            aarch64 = "sha256-KjGDd2w8n1HsRsfrL6Qa9x+Yqe82N9PJopOuJ4oxhRg=";
          }
          .${arch};
      };
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # AppRun otherwise writes a .desktop file and a CLI wrapper into $HOME on each start
      extraInstallCommands = ''
        wrapProgram $out/bin/solidcraft \
          --set SOLIDCRAFT_WAYLAND 1 \
          --set SOLIDCRAFT_NO_DESKTOP_INTEGRATION 1
        install -Dm444 ${contents}/io.tangencylabs.solidcraft.desktop -t $out/share/applications
        cp -r ${contents}/usr/share/{icons,mime,metainfo} $out/share
      '';
    };

  # Bambu Studio with Zink (OpenGL-over-Vulkan), it does not render on the NVIDIA GL driver
  bambu-studio-zink = pkgs.symlinkJoin {
    name = "bambu-studio-zink";
    # Unmodified so it is fetched from nix-community.cachix.org
    paths = [ pkgs.bambu-studio ];
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

      # CAD
      solidcraft

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
