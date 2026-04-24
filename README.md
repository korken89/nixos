# Installing

- Add new computer in `github.com/korken89/nixos` with new hostname `my-hostname`
- Disk partitioning `sudo nix --extra-experimental-features "nix-command flakes" run nixpkgs#disko -- --mode disko --flake github:korken89/nixos#my-hostname`
- Install `sudo nixos-install --flake github:korken89/nixos#my-hostname`

