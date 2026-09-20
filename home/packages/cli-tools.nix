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
    hyperfine
    jq
    moreutils
    pigz
    ripgrep
    sd
    sqlite
    tree
    unzip
    usbutils
    wget
    xdot
    xxd
    yq-go
    zip
  ];
}
