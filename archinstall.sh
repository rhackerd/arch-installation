#!/bin/bash

# Function to display disk picker
disk_picker() {
    echo "Available disks:"
    lsblk -d -n -o NAME,SIZE | awk '{print NR".",$1,"("$2")"}'
    echo "Enter the number of the disk you want to use for installation:"
    read -r disk_number
}

# Main function
main() {
    disk_picker
    selected_disk=$(lsblk -d -n -o NAME | sed -n "${disk_number}p")

    echo "You selected disk $selected_disk."
    # Proceed with partitioning, formatting, etc. using $selected_disk
}

# Call main function
main