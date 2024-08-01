# List available disks
list_disks() {
    echo "Available disks:"
    lsblk -d -n -o NAME,SIZE
}

# Ask user for the disk to partition
select_disk() {
    read -p "Enter the disk to partition (e.g., sda): " DISK
    DISK="/dev/$DISK"
}

# Ask user for the swap space size
select_swap_size() {
    read -p "Enter the size of the swap space (e.g., 8G): " SWAP_SIZE
}

# Function to create partitions
create_partitions() {
    echo "Creating partitions on $DISK..."

    # Create root partition
    sudo parted $DISK --script mkpart primary ext4 512MB -$SWAP_SIZE
    echo "Root partition created."

    # Create swap partition
    sudo parted $DISK --script mkpart primary linux-swap -$SWAP_SIZE 100%
    echo "Swap partition created."

    # Create ESP partition
    sudo parted $DISK --script mkpart primary fat32 1MB 512MB
    echo "ESP partition created."

    # Set ESP flag on the third partition
    sudo parted $DISK --script set 3 esp on
    echo "ESP flag set on partition 3."
}

# Function to format partitions
format_partitions() {
    echo "Formatting partitions..."

    # Format root partition as ext4
    sudo mkfs.ext4 -L nixos ${DISK}1
    echo "Root partition formatted as ext4."

    # Format swap partition
    sudo mkswap -L swap ${DISK}2
    echo "Swap partition formatted as swap."

    # Format ESP partition as FAT32
    sudo mkfs.fat -F 32 -n boot ${DISK}3
    echo "ESP partition formatted as FAT32."
}

# Function to mount partitions
mount_partitions() {
    echo "Mounting partitions..."

    # Mount root partition
    sudo mount /dev/disk/by-label/nixos /mnt
    echo "Root partition mounted."

    # Create boot directory and mount ESP partition
    sudo mkdir -p /mnt/boot
    sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
    echo "ESP partition mounted."

    # Enable swap
    sudo swapon ${DISK}2
    echo "Swap partition enabled."
}

# Function to generate base config and run the NixOS installer
install_nixos() {
    echo "Generating base config and running NixOS installer..."

    # Generate NixOS configuration
    sudo nixos-generate-config --root /mnt
    sudo nano /mnt/etc/nixos/configuration.nix

    # Run NixOS installer
    sudo nixos-install
    echo "NixOS installation complete."

    # Reboot the system
    sudo reboot
}

# Main script execution
list_disks
select_disk
select_swap_size
create_partitions
format_partitions
mount_partitions
install_nixos
