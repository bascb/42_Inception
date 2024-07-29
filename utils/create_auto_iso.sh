#! /usr/bin/env bash

# Creates variables, with default values
PATH_TO_ISO="" # Path to iso image with Debian OS image
PATH_TO_CONFIG="preseed.cfg" # Path to installation config file

# Define the options using getopt
OPTIONS=$(getopt -o i:c: -l path_to_iso:,path_to_config: -- "$@")

eval set -- "$OPTIONS"

# Process options
while true; do
    case "$1" in
        -i|--path_to_iso)
            PATH_TO_ISO=$2
            shift 2
            ;;
        -c|--path_to_config)
            PATH_TO_CONFIG=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac
done

# Check if path to iso image was given
if [ "$PATH_TO_ISO" == "" ]; then
    echo "Error: Path to ISO image not supplied"
    exit
fi

# Check if path to iso image was given
if [ "$PATH_TO_CONFIG" == "" ]; then
    echo "Error: Path to preseed config file not supplied"
    exit
fi

# Mount the Original ISO
if [ -e /mnt/debian ]; then
    sudo umount /mnt/debian
    sudo chmod -R +w /mnt/debian
    sudo rm -rf /mnt/debian
fi
echo "Going to create mount point"
sudo mkdir /mnt/debian
sudo mount -o loop "$PATH_TO_ISO" /mnt/debian

# Copy the ISO Contents
if [ -e /tmp/debian-iso ]; then
    chmod -R +w /tmp/debian-iso
    rm -rf /tmp/debian-iso
fi
echo "Going to copy ISO files to temp"
mkdir /tmp/debian-iso
chmod -R +w /tmp/debian-iso
echo "Going to copy ISO files to temp 2"
cp -r /mnt/debian/* /tmp/debian-iso/
echo "Copied files"
sudo umount /mnt/debian

# Copy the config file
echo "Going to coy $PATH_TO_CONFIG"
chmod -R +w /tmp/debian-iso/
gunzip /tmp/debian-iso/install.amd/initrd.gz
echo $PATH_TO_CONFIG | cpio -H newc -o -A -F /tmp/debian-iso/install.amd/initrd
gzip /tmp/debian-iso/install.amd/initrd
find /tmp/debian-iso -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > /tmp/debian-iso/md5sum.txt
echo "Copied config file to initrd"

# Find the parent folder of original ISO
ISO_FOLDER=$(echo $PATH_TO_ISO | sed 's![^/]*$!!')

echo $ISO_FOLDER

# Creates and copies new iso
chmod -R +w /tmp/debian-iso
mkisofs -o ${ISO_FOLDER}debian-preseed.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -r -V "Custom Debian" /tmp/debian-iso/

echo "Created new ISO named debian-preseed.iso and copied it to $ISO_FOLDER"