{
  system,
  pkgs,
  inputs,
  ...
}:
let
  lib = inputs.nixpkgs.lib;
in
{
  imports = [
    ./git.nix
    ./gtk.nix
    ./helix.nix
    ./notes.nix
    # ./openems.nix
    ./packages/analysis.nix
    ./packages/applications.nix
    ./packages/cli-tools.nix
    ./packages/development.nix
    ./packages/embedded.nix
    ./packages/misc.nix
    ./packages/writing.nix
    ./screens.nix
    ./shell-tools.nix
    ./stylix.nix
    ./swayidle.nix
    ./tmux.nix
    ./waybar.nix
    ./wm.nix
    ./zoxide.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "emifre";
  home.homeDirectory = "/home/emifre";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable ssh agent (https://wiki.nixos.org/wiki/SSH_public_key_authentication)
  services.ssh-agent.enable = true;

}
