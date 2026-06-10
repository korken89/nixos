final: prev:
let
  version = "2.1.170";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  checksums = {
    "aarch64-darwin" = {
      platformKey = "darwin-arm64";
      sha256 = "e903646d8b7a31882a80ecd27569a27d8ac57b3708745f349709632c84117fdf";
    };
    "x86_64-darwin" = {
      platformKey = "darwin-x64";
      sha256 = "914f23a70bbed5d9ae567e3e04b86206ed9971b371bc9baca3f79c8885bfddb4";
    };
    "aarch64-linux" = {
      platformKey = "linux-arm64";
      sha256 = "1bb9d032440a75532f7dd4cafbc687f220aaf16c63eba17e192dfbec2f04bd25";
    };
    "x86_64-linux" = {
      platformKey = "linux-x64";
      sha256 = "849e007277a0442ab27570d3e3d6d43787507946590e8dd1947e5a39b7081f9e";
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
