#!/usr/bin/env bash
set -e

pushd /etc/nixos
sudoedit configuration.nix

git diff -U0 *.nix

echo "NixOS Rebuilding..."
sudo nixos-rebuild switch &>/tmp/nixos-switch.log || (
 cat /tmp/nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"

ls -v1 /nix/var/nix/profiles | tail -n 2 | awk '{print "/nix/var/nix/profiles/" $0}' - | xargs nvd --color always diff

popd
