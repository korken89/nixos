{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI Tools & Utilities
    btop
    coreutils-full
    curl
    eza
    fd
    file
    fzf
    jq
    pigz
    ripgrep
    sd
    unzip
    usbutils
    wget
    xxd
    zip
  ];
}
