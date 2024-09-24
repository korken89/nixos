{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      specialArgs = {
        inherit inputs;
      };

      nixosConfigurations = {
        work-workstation =
          let
            system = "x86_64-linux";
          in
          lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            };

            inherit system;
            modules = [
              ./hosts/work-workstation/configuration.nix
              ./hosts/work-workstation/hardware-configuration.nix
            ];
          };
      };
    };
}
