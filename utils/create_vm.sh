#! /usr/bin/env bash

# Creates variables, with default values
VM_NAME="InceptionVM" # Name of the virtual machine
STORAGE_FOLDER="$HOME/VirtualBox_VMs" #Folder where hard disk storage file will be placed
PATH_TO_ISO="" # Path to iso image with Debian OS image
PATH_TO_CONFIG="preseed.cfg" # Path to installation config file

# Define the options using getopt
OPTIONS=$(getopt -o n:f:p:c: -l name:,folder:,path_to_iso:,path_to_config: -- "$@")

eval set -- "$OPTIONS"

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
VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $PATH_TO_ISO

# Modify boot parameters to use preseed file
VBoxManage modifyvm $VM_NAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage unattended install $VM_NAME --iso="$PATH_TO_ISO" --user="bcastelo" --password="inception123" --full-user-name="Bernardo" --install-additions --locale="en_US" --time-zone="UTC" --script-template="$PATH_TO_CONFIG"

# Starts VM in background
VBoxManage startvm $VM_NAME --type headless