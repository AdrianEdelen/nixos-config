enter the nix shell using `nix develop` in order to perform sops actions

to add or remove secrets, ensure your age key is in ~/.config/age/keys.txt or $XDG_CONFIG_HOME/age/keys.txt 
then `sops path/to/file` to open the secrets

to install a flake on a machine:
either match the disk layout to the disko config, or create a new flake with a new disko config.

boot the machine into live nixos environment

clone this repo anywhere

run sudo nixos-generate-config --root /mnt --show-hardware-config > /path/to/host