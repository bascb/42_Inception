#! /usr/bin/env bash

# Creates variables, with default values
VM_NAME="InceptionVM" # Name of the virtual machine
STORAGE_FOLDER="~/VirtualBox\ VMs" #Folder where hard disk storage file will be placed
PATH_TO_ISO="" # Path to iso image with Debian OS image

# Define the options using getopt
OPTIONS=$(getopt -o n:f:p: -l name:,folder:,path_to_iso: -- "$@")

# Process options
while true; do
    case "$1" in
        -n|--name)
            VM_NAME=$2
            shift 2
            ;;
        -f|--folder)
            STORAGE_FOLDER=$2
            shift 2
            ;;
        -p|--path_to_iso)
            PATH_TO_ISO=$2
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
if [ $PATH_TO_ISO == "" ]; then
    echo "Error: Path to ISO image not setted"
    exit
fi

# Creates VM
VBoxManage createvm --name $VM_NAME --ostype "Debian_64" --register

# Set VM params
VBoxManage modifyvm $VM_NAME --memory 2048 --cpus 1 --nic1 nat

# Create virtual hard disk
VBoxManage createmedium --filename $STORAGE_FOLDER/$VM_NAME/$VM_NAME.vdi --size 10000 --format VDI
#  Attach the hard disk
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $STORAGE_FOLDER/$VM_NAME/$VM_NAME.vdi

# Attach ISO image for OS installation
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium $PATH_TO_ISO