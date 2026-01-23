{ pkgs, ... }:
{
  # File manager
  programs.thunar.enable = true;
  environment.systemPackages = with pkgs; [
    file-roller
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
