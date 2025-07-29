enter the nix shell using `nix develop` in order to perform sops actions

to add or remove secrets, ensure your age key is in ~/.config/age/keys.txt or $XDG_CONFIG_HOME/age/keys.txt 
then `sops path/to/file` to open the secrets


notes on nixos-anywhere `--extra-files` this copies the entire directory and path, so in your local repo, you must recreate the entire path for files you want to send. e.g. `./tmp/var/lib/sops/age/keys.txt` this will create, on the target machine `/var/lib/sops/age/keys.txt`. you can do this with multiple files and directories.

to install a flake on a machine:
1. either match the disk layout to the disko config, or create a new flake with a new disko config.
2. build the custom live nix iso (or use the most recent iso from the build)
3. boot the machine into the live nixos environment
4. clone this repo to somewhere that can run `nix develop`
5. enter the nix develop environment.
6. provision the private age key for sops-nix 
7. run `nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./facter.json --extra-files <path/to/sops/key/dir> -f <flake-location>#<target-flake> --target-host root@<target-ip>` -note its not the file, but instead a directory where the file is.
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./hosts/bb/facter.json -f .#bb --target-host root@192.168.1.64 #note: this is the current working command, tweak to make better sense in the readme