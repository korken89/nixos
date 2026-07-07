final: prev:
let
  version = "2.1.202";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  checksums = {
    "aarch64-darwin" = {
      platformKey = "darwin-arm64";
      sha256 = "7414f707861e2fe5afef33a466f888a8d2170e5028f5e9d2858f1d3ef45ffca5";
    };
    "x86_64-darwin" = {
      platformKey = "darwin-x64";
      sha256 = "0dc578bb294094f5041e99a0444030ac6ae7236b387e56f00d4a5214816763bd";
    };
    "aarch64-linux" = {
      platformKey = "linux-arm64";
      sha256 = "de5e0bb28e2b32409444ed4c1431e2931001c05ed270a3dc96c6706b0693867f";
    };
    "x86_64-linux" = {
      platformKey = "linux-x64";
      sha256 = "71590202249892db3805ecd5b867f831f04b8129eaabd3f9a5bd4ba16b52c839";
    };
  };
  entry = checksums.${prev.stdenv.hostPlatform.system};
in
{
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;
    src = prev.fetchurl {
      url = "${baseUrl}/${version}/${entry.platformKey}/claude";
      inherit (entry) sha256;
    };
  });
}
