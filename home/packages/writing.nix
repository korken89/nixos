{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Writing & Documentation

    # Typst
    typst
    tinymist
    typstyle

    # Markdown
    markdown-oxide
    marksman
    prettier
  ];
}
