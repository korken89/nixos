{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
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

              # make home-manager as a module of nixos
              # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.emifre = import ./home.nix;

                # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              }
            ];
          };
      };
    };
}
