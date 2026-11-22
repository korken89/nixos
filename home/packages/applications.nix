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
      version = "0.46.2";
      arch = lib.head (lib.splitString "-" system);
      src = pkgs.fetchurl {
        url = "https://github.com/tangency-labs/solidcraft/releases/download/v${version}/solidcraft-${version}-linux-${arch}.AppImage";
        hash =
          {
            x86_64 = "sha256-w4hgVGKVaToClUUzwGDSzWhbfikFmj7JzIB77JVCLnM=";
            aarch64 = "sha256-LZHGKuWHFEGRGJmrdVLYrpDGVAu+vH8OsG4weLXl7FM=";
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
        makeWrapper $out/bin/solidcraft $out/bin/solidcraft-cli \
          --set SOLIDCRAFT_APPIMAGE_CLI 1
        install -Dm444 ${contents}/io.tangencylabs.solidcraft.desktop -t $out/share/applications
        cp -r ${contents}/usr/share/{icons,mime,metainfo} $out/share
      '';
    };

  # Upstream AppImage, nixpkgs lags behind the releases
  bambu-studio =
    let
      pname = "bambu-studio";
      version = "02.09.01.70";
      build = "20261103183404";
      src = pkgs.fetchurl {
        url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/BambuStudio_ubu24-v${version}-${build}.AppImage";
        hash = "sha256-Zo2rsb5Tx1gYnta8iZNShd6l4K9GIWVGsbr9aILpr/A=";
      };
      contents = pkgs.appimageTools.extract { inherit pname version src; };
      gstPlugins = with pkgs.gst_all_1; [
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
      ];
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraPkgs =
        pkgs: with pkgs; [
          webkitgtk_4_1
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
        ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # The FHS locale archive has en_GB, which the app requires for English.
      # WebKit flags fix the login callback, Zink (OpenGL-over-Vulkan) fixes rendering on the NVIDIA GL driver.
      extraInstallCommands = ''
        wrapProgram $out/bin/bambu-studio \
          --set LOCALE_ARCHIVE /usr/lib/locale/locale-archive \
          --set LOCALE_ARCHIVE_2_27 /usr/lib/locale/locale-archive \
          --set-default SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default CURL_CA_BUNDLE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --prefix GIO_EXTRA_MODULES : ${pkgs.glib-networking}/lib/gio/modules \
          --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${pkgs.lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins} \
          --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --set __GLX_VENDOR_LIBRARY_NAME mesa \
          --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
          --set MESA_LOADER_DRIVER_OVERRIDE zink \
          --set GALLIUM_DRIVER zink
        install -Dm444 ${contents}/BambuStudio.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/BambuStudio.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=bambu-studio'
        install -Dm444 ${contents}/BambuStudio.png -t $out/share/icons/hicolor/192x192/apps
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
      bambu-studio
      spotify
      slack
    ];
}
