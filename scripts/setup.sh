set -e

get_packages() {
    nix-env -f '<nixpkgs>' -iA git
}

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

# generate_temp_ssh_key() {
#     ssh-keygen -t ed25519 -C "temporary-key" -f /root/.ssh/temp_id_ed25519
#     cat /root/.ssh/temp_id_ed25519.pub
#     read -p "Press Enter once you have added the public key to your server..."

#     #setup an endpoint for the server
#     ssh -i /root/.ssh/temp_id_ed25519 user@server << EOF
#     scp user@secure-server:/path/to/gpg-private-key /root/.gnupg/private-keys-v1.d/private.key
#     chmod 600 /root/.gnupg/private-keys-v1.d/private.key
# EOF

#     rm -f /root/.ssh/temp_id_ed25519
#     rm -f /root/.ssh/temp_id_ed25519.pub
#     rmdir /root/.ssh 2>/dev/null || true

# }

unmount_existing_partitions() {
    echo "Unmounting existing partitions on $DISK..."
    PARTITIONS=$(lsblk -ln -o NAME $DISK | tail -n +2)

    for PART in $PARTITIONS; do
        MOUNTPOINT=$(lsblk -ln -o MOUNTPOINT /dev/$PART)
        if [ -n "$MOUNTPOINT" ]; then
            sudo umount /dev/$PART || true
        fi
    done

    for PART in $PARTITIONS; do
        sudo swapoff /dev/$PART || true
    done

    echo "Existing partitions on $DISK unmounted."
}

pull_existing_config() {
    read -p "Do you want to pull an existing configuration? (y/n): " PULL_CONFIG
    REPO_URL="https://github.com/AdrianEdelen/nixos-config.git"

    if [[ "$PULL_CONFIG" == "y" || "$PULL_CONFIG" == "Y" ]]; then
        read -p "Enter the hostname to pull the configuration for: " HOSTNAME
        PULL_CONFIG="true"
    else
        read -p "Enter the hostname for the new configuration: " HOSTNAME
        PULL_CONFIG="false"
    fi
}

create_partitions() {

    read -p "Clearing existing partitions... continue? (y/n): " DO_CLEAR
    
    if [[ "$DO_CLEAR" == "y" || "$DO_CLEAR" == "Y" ]]; then
        unmount_existing_partitions
    else 
        exit 1
    fi
    
    sudo parted $DISK -- mklabel gpt
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

enable_flakes() {
    echo "Enabling flakes..."
    mkdir -p /etc/nix
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    echo "Flakes enabled."
}

install_nixos() {
    echo "Cloning the repository..."
    sudo git clone $REPO_URL /mnt/etc/nixos-config
    echo "Repository cloned."

    if [ "$PULL_CONFIG" == "true" ]; then
        echo "Pulling existing configuration for hostname $HOSTNAME..."
        sudo mkdir -p /mnt/etc/nixos
        
        echo "Custom configuration files have been downloaded."
    else
        echo "Generating new NixOS configuration..."

        sudo nixos-generate-config --root /mnt
        sudo mv /mnt/etc/nixos/configuration.nix /mnt/etc/nixos-config/configurations/$HOSTNAME/configuration.nix
        sudo mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos-config/configurations/$HOSTNAME/hardware-configuration.nix

        echo "New configuration files have been generated and moved to the repository."
    fi

    sudo nixos-install --flake /mnt/etc/nixos-config#$HOSTNAME
    echo "NixOS installation complete."

    

    sudo reboot
}
get_packages
list_disks
select_disk
select_swap_size
pull_existing_config

create_partitions
format_partitions
mount_partitions
install_nixos
