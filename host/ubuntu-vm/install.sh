#!/bin/sh

#################################################
# Install Nix
#################################################
export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

root_dir=$(readlink -f "$PWD"/../..)

#################################################
# Install home-manager
#################################################

mv "$HOME"/.bashrc "$HOME"/.bashrc.bak
mv "$HOME"/.profile "$HOME"/.profile.bak

mkdir -p "$HOME"/.config
ln -sfn "$root_dir"/home-manager "$HOME"/.config/home-manager

ln -sf "$root_dir"/home-manager/custom.ubuntu-vm.nix "$root_dir"/home-manager/custom.nix

nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

#################################################
# Fonts
#################################################

mkdir -p "$HOME"/.local/share
ln -sfn "$root_dir"/fonts "$HOME"/.local/share/fonts
sudo fc-cache

#################################################
# Others
#################################################

ln -sfn "$root_dir"/nvim "$HOME"/.config/nvim
ln -sfn "$root_dir"/ghostty "$HOME"/.config/ghostty
ln -sfn "$PWD"/xsessionrc "$HOME"/.xsessionrc
