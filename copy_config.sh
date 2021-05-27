#!/bin/sh

cp /etc/nixos/configuration.nix ./laptop-config/configuration.nix
git add -u
git commit -m "Updated config"
git push
echo "Done!"
