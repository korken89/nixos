{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Analysis Tools
    ghidra
    nodejs_22 # REA needs 22.23.4+, the default nodejs (24.21) is too old
    binwalk
    unblob
    tokei
    xchm
  ];

  # REA finds Ghidra and its JDK through these
  home.sessionVariables = {
    GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra";
    JAVA_HOME = "${pkgs.jdk21}";
  };
}
