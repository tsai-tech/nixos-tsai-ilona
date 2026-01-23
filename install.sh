grep -q "experimental-features" /etc/nix/nix.conf || \
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

sudo nixos-rebuild switch --flake ./#nixos
