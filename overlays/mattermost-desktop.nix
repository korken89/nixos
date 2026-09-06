final: prev: {
  # The bundled prebuilt koffi.node has no RPATH, so it cannot dlopen
  # libstdc++ and the app dies during main-process module load
  mattermost-desktop = prev.mattermost-desktop.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      patchelf --add-rpath ${final.lib.makeLibraryPath [ final.stdenv.cc.cc ]} \
        $out/share/mattermost-desktop/app.asar.unpacked/node_modules/@koromix/koffi-linux-x64/linux_x64/koffi.node
    '';
  });
}
