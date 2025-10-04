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
      inherit (self) inputs outputs;
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
    in
    {
      specialArgs = {
        inherit inputs;
      };

      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      nixosConfigurations = {
        # Intel 12900k workstation @ work
        emifre-work-workstation =
          let
            system = "x86_64-linux";
          in
          lib.nixosSystem {
            specialArgs = {
              inherit inputs system;
            };

            modules = [
              ./hosts/work-workstation/hardware-configuration.nix
              ./hosts/work-workstation
              ./nixos
            ];
          };
        # Intel 12900k workstation @ home
        emifre-home-workstation =
          let
            system = "x86_64-linux";
          in
          lib.nixosSystem {
            specialArgs = {
              inherit inputs system;
            };

            modules = [
              ./hosts/home-workstation/hardware-configuration.nix
              ./hosts/home-workstation
              ./nixos
              ./nixos/storage.nix
            ];
          };
        # Lenovo Yoga Slim 7x laptop
        emifre-yoga-7x-nixos =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs system;
            };

            modules = [
              ./hosts/laptop-yoga-7x/hardware-configuration.nix
              ./hosts/laptop-yoga-7x
              ./nixos
            ];
          };
      };
    };
}
