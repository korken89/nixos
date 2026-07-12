final: prev:
let
  version = "2.1.207";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  checksums = {
    "aarch64-darwin" = {
      platformKey = "darwin-arm64";
      sha256 = "1397a062c6889675055e3314dd956376ac51262a7734ad9e819c26975d71547a";
    };
    "x86_64-darwin" = {
      platformKey = "darwin-x64";
      sha256 = "8a4355d251a60c90d8cf08f32fdb22a8157dd3d085542f95d0da0475f9a2c57c";
    };
    "aarch64-linux" = {
      platformKey = "linux-arm64";
      sha256 = "8bc14a284065383460f37981d724b8f7aa7ca93c9849d2fe367e08f03383f454";
    };
    "x86_64-linux" = {
      platformKey = "linux-x64";
      sha256 = "85e7e988a392d859f90802ca21fb26e89d3c9ab527f5ed0b08df3955e34d5c83";
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
