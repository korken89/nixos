final: prev:
let
  version = "0.144.1";
  assets = {
    aarch64-linux = {
      platform = "aarch64-unknown-linux-musl";
      hash = "sha256-IYq0i92pjd4+EN8YTMDE65LENy2cqSTvGqX8gbT2o44=";
    };
    x86_64-linux = {
      platform = "x86_64-unknown-linux-musl";
      hash = "sha256-P9UM+WgJse6ilLv7oKXDpXaHG0h2ofDpEiblIMGSO+E=";
    };
  };
  asset = assets.${prev.stdenv.hostPlatform.system};
in
{
  codex = prev.stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-${asset.platform}.tar.gz";
      inherit (asset) hash;
    };

    unpackPhase = ''
      runHook preUnpack
      tar -xzf "$src"
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R bin codex-package.json codex-path codex-resources "$out"/
      runHook postInstall
    '';

    meta = prev.codex.meta // {
      changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${version}/CHANGELOG.md";
      platforms = builtins.attrNames assets;
    };
  };
}
