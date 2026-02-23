{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

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

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.follows = "niri-stable";
    };
    niri-stable.url = "github:YaLTeR/niri/v25.02";
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

      # overlays = builtins.attrValues (import ./overlays { inherit inputs outputs; });

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
          # overlays = overlays;
        }
      );

      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
        }:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./hosts/${hostname}/hardware-configuration.nix
            ./hosts/${hostname}
            ./nixos
          ];
        };
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      nixosConfigurations = {
        emifre-work-workstation = mkHost { hostname = "work-workstation"; };
        emifre-home-workstation = mkHost { hostname = "home-workstation"; };
        emifre-yoga-7x-nixos = mkHost {
          hostname = "laptop-yoga-7x";
          system = "aarch64-linux";
        };
        emifre-thinkpad-x230 = mkHost { hostname = "laptop-x230"; };
        emifre-thinkpad-e14 = mkHost { hostname = "laptop-e14"; };
      };
    };
}
