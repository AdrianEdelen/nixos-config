#!/bin/bash

list_disks() {
    echo "Available disks:"
    lsblk -d -n -o NAME,SIZE
}

select_disk() {
    read -p "Enter the disk to partition (e.g., sda): " DISK
    DISK="/dev/$DISK"
}

select_swap_size() {
    read -p "Enter the size of the swap space (e.g., 8G): " SWAP_SIZE
}

pull_existing_config() {
    read -p "Do you want to pull an existing configuration? (y/n): " PULL_CONFIG
    if [[ "$PULL_CONFIG" == "y" || "$PULL_CONFIG" == "Y" ]]; then
        read -p "Enter the hostname to pull the configuration for: " HOSTNAME
        CONFIG_URL="https://raw.githubusercontent.com/AdrianEdelen/nixos-config/main/configurations/$HOSTNAME/configuration.nix"
        HARDWARE_CONFIG_URL="https://raw.githubusercontent.com/AdrianEdelen/nixos-config/main/configurations/$HOSTNAME/hardware-configuration.nix"
        REPO_URL="https://github.com/AdrianEdelen/nixos-config.git"
        PULL_CONFIG="true"
    else
        PULL_CONFIG="false"
    fi
}

create_partitions() {
    echo "Creating partitions on $DISK..."

    sudo parted $DISK -- mkpart ESP fat32 1MB 512MB
    sudo parted $DISK -- set 1 esp on
    echo "ESP partition created and set."

    sudo parted $DISK -- mkpart primary ext4 512MB -$SWAP_SIZE
    echo "Root partition created."

    sudo parted $DISK -- mkpart primary linux-swap -$SWAP_SIZE 100%
    echo "Swap partition created."
}

format_partitions() {
    echo "Formatting partitions..."

    sudo mkfs.fat -F 32 -n boot ${DISK}1
    echo "ESP partition formatted as FAT32."

    sudo mkfs.ext4 -L nixos ${DISK}2
    echo "Root partition formatted as ext4."

    sudo mkswap -L swap ${DISK}3
    echo "Swap partition formatted as swap."
}

mount_partitions() {
    echo "Mounting partitions..."

    sudo mount /dev/disk/by-label/nixos /mnt
    echo "Root partition mounted."

    sudo mkdir -p /mnt/boot
    sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
    echo "ESP partition mounted."

    sudo swapon ${DISK}3
    echo "Swap partition enabled."
}

install_nixos() {
    if [ "$PULL_CONFIG" == "true" ]; then
        echo "Pulling existing configuration for hostname $HOSTNAME..."

        wget -O /mnt/etc/nixos/configuration.nix $CONFIG_URL
        wget -O /mnt/etc/nixos/hardware-configuration.nix $HARDWARE_CONFIG_URL

        echo "Custom configuration files have been downloaded and replaced."
    else
        echo "Generating default NixOS configuration..."

        sudo nixos-generate-config --root /mnt
    fi

    sudo nixos-install
    echo "NixOS installation complete."

    sudo mount --bind /dev /mnt/dev
    sudo mount --bind /proc /mnt/proc
    sudo mount --bind /sys /mnt/sys

    sudo chroot /mnt /bin/bash <<'EOF'
    git clone $REPO_URL /root/nixos-config

    # Symlink the configuration files
    ln -sf /root/nixos-config/configurations/$HOSTNAME/configuration.nix /etc/nixos/configuration.nix
    ln -sf /root/nixos-config/configurations/$HOSTNAME/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

    # Run nixos-rebuild switch
    nixos-rebuild switch
EOF

    sudo reboot
}

list_disks
select_disk
select_swap_size
pull_existing_config
create_partitions
format_partitions
mount_partitions
install_nixos
