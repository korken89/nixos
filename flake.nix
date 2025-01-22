{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    x1e-nixos-config = {
      url = "github:kuruczgy/x1e-nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    probe-rs-rules = {
      url = "github:jneem/probe-rs-rules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      probe-rs-rules,
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
        # Intel 12900k workstation @ work
        emifre-work-workstation =
          let
            system = "x86_64-linux";
          in
          lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [
                  (final: prev: {
                    appcsxcad = prev.appcsxcad.overrideAttrs (old: {
                      postFixup = "";
                      patches = (old.patches or [ ]) ++ [
                        ./overlays/appcsxcad-wayland.patch
                      ];
                    });
                  })
                ];
              };
            };

            inherit system;

            modules = [
              ./hosts/work-workstation/configuration.nix
              ./hosts/work-workstation/hardware-configuration.nix
              ./modules/common.nix

              # Why cant prprobe-rs-rules and home-manager be in common.nix?
              probe-rs-rules.nixosModules.${system}.default
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.emifre = import ./home.nix;
              }
            ];
          };
        # Lenovo Yoga Slim 7x laptop
        emifre-yoga-7x-nixos =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              ./hosts/laptop-yoga-7x/configuration.nix
              ./modules/common.nix

              # Why cant prprobe-rs-rules and home-manager be in common.nix?
              probe-rs-rules.nixosModules.${system}.default
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.emifre = import ./home.nix;
              }

              # Hardware configuration
              x1e-nixos-config.nixosModules.x1e
              {
                networking.hostName = "emifre-yoga-7x-nixos";
                hardware.deviceTree.name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";

                nixpkgs.hostPlatform.system = "aarch64-linux";

                # Uncomment this to allow unfree packages.
                nixpkgs.config = {
                  allowUnfree = true;
                  allowUnsupportedSystem = true; # Until openems in release on nixpkgs
                };

                nixpkgs.overlays = [
                  (final: prev: {
                    appcsxcad = prev.appcsxcad.overrideAttrs (old: {
                      postFixup = "";
                      patches = (old.patches or [ ]) ++ [
                        ./overlays/appcsxcad-wayland.patch
                      ];
                    });
                  })
                ];
                nix = {
                  channel.enable = false;
                };
              }
            ];
          };
      };
    };
}
