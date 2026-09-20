{ inputs, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # `, <cmd>` runs any program in nixpkgs without installing it
  programs.nix-index-database.comma.enable = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.command-not-found.enable = false;
}
