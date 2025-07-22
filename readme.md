enter the nix shell using `nix develop` in order to perform sops actions

to add or remove secrets, ensure your age key is in ~/.config/age/keys.txt or $XDG_CONFIG_HOME/age/keys.txt 
then `sops path/to/file` to open the secrets