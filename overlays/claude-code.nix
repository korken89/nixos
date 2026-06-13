final: prev:
let
  version = "2.1.177";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  checksums = {
    "aarch64-darwin" = {
      platformKey = "darwin-arm64";
      sha256 = "eb0730351be2f02b482b1855870f5877489085aac86b0c4c1db4e458d9e40ed9";
    };
    "x86_64-darwin" = {
      platformKey = "darwin-x64";
      sha256 = "fcdc6c6679d4e1e3a0a3812f24e8b08ab73156732072c2ca5ee6248bee8313bd";
    };
    "aarch64-linux" = {
      platformKey = "linux-arm64";
      sha256 = "baf3926dc166215772f959e367da9784ff4c75157aaafe4524fdc79ebff984b1";
    };
    "x86_64-linux" = {
      platformKey = "linux-x64";
      sha256 = "ff41753634b20c869ef6a32a20863521b33d4186ac0d6a49379ab48a48395ee7";
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
