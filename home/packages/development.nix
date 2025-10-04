{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development Tools
    autoconf
    automake
    cmake
    gcc
    gcc-arm-embedded
    gnumake
    openssl
    pkg-config
    python3
    rustup

    # Rust tools
    cargo-binutils
    cargo-bloat
    cargo-expand
    cargo-watch
    flip-link

    # Version control
    gh
    jujutsu

    # Editors/IDEs
    claude-code

    # Nix tools
    nixfmt-rfc-style
    nixfmt-tree
    nvd
  ];
}
