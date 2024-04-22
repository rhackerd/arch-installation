#!/bin/bash

# Function to display disk picker
disk_picker() {
    echo "Available disks:"
    lsblk -d -n -o NAME,SIZE | awk '{print NR".",$1,"("$2")"}'
    echo "Enter the number of the disk you want to use for installation:"
    read -r disk_number
}

# Function to display partitions and types using fdisk
display_partitions() {
    echo "Partitions on disk $selected_disk:"
    sudo fdisk -l "/dev/$selected_disk"
}

# Function to format partitions
format_partitions() {
    # EFI partition
    echo "Creating EFI partition..."
    sudo parted -s "/dev/$selected_disk" mkpart primary fat32 1MiB 1GiB
    sudo mkfs.fat -F32 "/dev/${selected_disk}1"
    
    # SWAP partition
    echo "Creating SWAP partition..."
    sudo parted -s "/dev/$selected_disk" mkpart primary linux-swap 1GiB 11GiB
    sudo mkswap "/dev/${selected_disk}2"
    
    # x86_root partition
    echo "Creating x86_root partition..."
    sudo parted -s "/dev/$selected_disk" mkpart primary ext4 11GiB 100%
    sudo mkfs.ext4 "/dev/${selected_disk}3"
}

# Main function
main() {
    disk_picker
    selected_disk=$(lsblk -d -n -o NAME | sed -n "${disk_number}p")

    echo "You selected disk $selected_disk."
    display_partitions

    # Prompt user for confirmation
    read -p "Are you sure you want to proceed with formatting partitions on disk $selected_disk? (yes/no): " confirmation

    if [ "$confirmation" == "yes" ]; then
        format_partitions
        echo "Partitioning and formatting completed successfully."
    else
        echo "Exiting script."
        exit 0
    fi
}

# Call main function
main
