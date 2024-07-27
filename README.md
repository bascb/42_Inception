# Inception

This is a complete guide to build the 42 Inception project.

# List of Contents
- [How to install VirtualBox on Ubuntu](#vbox)
- [Create a VM with VBoxManage](#create_vm)

<a id="vbox"></a>
# How to install VirtualBox on Ubuntu

Steps to install VirtualBox on Ubuntu OS, using the offical repositories.

Update apt repos:

```bash
$ sudo apt update
```

If you wish, you can run this command to upgrade all packages installed in the machine

```bash
$ sudo apt upgrade
```

Now, install VirtualBox:

```bash
$ sudo apt install virtualbox
```

And VirtualBox extension pack

```bash
$ sudo apt install virtualbox-ext-pack
```

If you wish, you can install the VirtuaBox Guest additions, that improves the integration of the guest with the host machine:

```bash
$ sudo apt install virtualbox-guest-additions-iso
```

Source: [How to Install VirtualBox on Ubuntu](https://phoenixnap.com/kb/install-virtualbox-on-ubuntu)

<a id="create_vm"></a>
# Create a VM with VBoxManage

In this chapter, i will explain, step by step, how to create a new VM with VBoxManage,
Folder utils of this project repo has a script create_vm.sh that automates this process.
The OS that i use for this VM is Debian, so this example is based on that.

Creates the VM:

```bash
$ VBoxManage createvm --name "InceptionVM" --ostype "Debian_64" --register
```

Set VM params:

```bash
$ VBoxManage modifyvm "InceptionVM" --memory 2048 --cpus 1 --nic1 nat
```

Create virtual hard disk:

```bash
$ VBoxManage createmedium --filename ~/VirtualBox\ VMs/InceptionVM/InceptionVM.vdi --size 10000 --format VDI
$ VBoxManage storagectl "InceptionVM" --name "SATA Controller" --add sata --controller IntelAHCI
$ VBoxManage storageattach "InceptionVM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/InceptionVM/InceptionVM.vdi
```

Attach ISO image for OS installation

```bash
$ VBoxManage storageattach "InceptionVM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium /path/to/debian.iso
```

Source: [VBoxManage manual](https://www.virtualbox.org/manual/ch08.html)