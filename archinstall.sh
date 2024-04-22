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

# Main function
main() {
    disk_picker
    selected_disk=$(lsblk -d -n -o NAME | sed -n "${disk_number}p")

    echo "You selected disk $selected_disk."
    display_partitions

    # Prompt user for confirmation
    read -p "Are you sure you want to proceed? (yes/no): " confirmation

    if [ "$confirmation" == "yes" ]; then
        echo "Proceeding with formatting..."
        sleep 5
        echo "Formatting partitions on disk $selected_disk..."
        # Proceed with partitioning, formatting, etc. using $selected_disk
    else
        echo "Exiting script."
        exit 0
    fi
}

# Call main function
main
