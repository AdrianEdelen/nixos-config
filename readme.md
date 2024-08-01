# SETUP

## QUICK START
enter this in your terminal to get up and going: running this script will format your drives and install attempt to install a new operating system
`nix-env -f '<nixpkgs>' -iA wget git && wget https://dblt.rip/nixos-setup -O nixos_install.sh && chmod +x nixos_install.sh && sudo ./nixos_install.sh` 


On a fresh system where you want to install nix as the only os on the disk run `setup.sh` this script creates partitions for you and begins the setup process.

The script will also restore the nix config from source, set up your symlinks,
and if available, build the configuration for the given machine.

otherwise:\

create the following partitions with parted:\
`parted /dev/sda -- mklabel gpt`\
`parted /dev/sda -- mkpart root ext4 512MB -8GB` (`-8GB` should be your desired swap size)\
`parted /dev/sda -- mkpart swap linux-swap -8GB 100%` (`-8GB` is again the swap)\
`parted /dev/sda -- mkpart ESP fat32 1MB 512MB`\
`parted /dev/sda -- set 3 esp on`

create the file systems:
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

Mount the partitions:
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot

mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2

generate the base config:

nixos-generate-config --root /mnt
nano /mnt/etc/nixos/configuration.nix

run the nix installer:
nixos-install

reboot
