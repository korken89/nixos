{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    x1e-nixos-config = {
      url = "github:kuruczgy/x1e-nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      x1e-nixos-config,
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

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = {
                    inherit inputs;
                  };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.emifre = import ./home.nix;
                };
              }
            ];
          };
        yoga-x7 = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/laptop-yoga-x7/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.emifre = import ./home.nix;
              };
            }

            # Hardware configuration
            x1e-nixos-config.nixosModules.x1e
            (
              { ... }:
              {
                networking.hostName = "emifre-yoga-7x-nixos";
                hardware.deviceTree.name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";

                nixpkgs.pkgs = nixpkgs.legacyPackages.aarch64-linux;
                nix = {
                  channel.enable = false;
                  settings.experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                };
              }
            )
            ./configuration.nix
          ];
        };
      };
    };
}
