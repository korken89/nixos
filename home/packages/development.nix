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

    # Editors/IDEs
    claude-code

    # Nix tools
    nixfmt
    nixfmt-tree
    nvd
  ];

  programs.opencode = {
    enable = true;
    settings = {
      "permission" = {
        "*" = "ask";
        "read" = "allow";
        "edit" = "ask";
        "glob" = "allow";
        "grep" = "allow";
        "list" = "allow";
        "bash" = "ask";
        "task" = "ask";
        "skill" = "ask";
        "lsp" = "ask";
        "todoread" = "ask";
        "webfetch" = "ask";
        "websearch" = "ask";
        "external_directory" = "ask";
        "doom_loop" = "ask";
        "*.env" = "deny";
        "*.env.*" = "deny";
      };
    };
  };
}
