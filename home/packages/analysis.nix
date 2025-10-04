{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Analysis Tools
    ghidra
    tokei
    xchm
  ];
}
