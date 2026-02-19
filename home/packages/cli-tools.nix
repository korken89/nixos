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
    graphviz
    jq
    pigz
    ripgrep
    sd
    unzip
    usbutils
    wget
    xdot
    xxd
    zip
  ];
}
