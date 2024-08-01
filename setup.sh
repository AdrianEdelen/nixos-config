#!/bin/bash

# Define the disk to be partitioned
DISK="/dev/sda"

# Function to create partitions
create_partitions() {
    echo "Creating partitions on $DISK..."

    # Create root partition
    sudo parted $DISK --script mkpart primary ext4 512MB -8GB
    echo "Root partition created."

    # Create swap partition
    sudo parted $DISK --script mkpart primary linux-swap -8GB 100%
    echo "Swap partition created."

    # Create ESP partition
    sudo parted $DISK --script mkpart primary fat32 1MB 512MB
    echo "ESP partition created."

    # Set ESP flag on the third partition
    sudo parted $DISK --script set 3 esp on
    echo "ESP flag set on partition 3."
}

# Execute the function to create partitions
create_partitions

# Format the partitions
format_partitions() {
    echo "Formatting partitions..."

    # Format root partition as ext4
    sudo mkfs.ext4 ${DISK}1
    echo "Root partition formatted as ext4."

    # Format swap partition
    sudo mkswap ${DISK}2
    echo "Swap partition formatted as swap."

    # Format ESP partition as FAT32
    sudo mkfs.fat -F32 ${DISK}3
    echo "ESP partition formatted as FAT32."
}

# Execute the function to format partitions
format_partitions

echo "Disk partitioning and formatting completed successfully."
