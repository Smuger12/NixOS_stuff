#!/bin/sh

sudo cp -v /etc/nixos/configuration.nix ./configuration.nix
cp -v ~/.config/nixpkgs/home.nix ./home.nix
git add -u
git commit -m "Updated config"
git push
echo "Done!"
