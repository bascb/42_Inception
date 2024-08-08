# Inception

This is a complete guide to build the 42 Inception project.

# List of Contents
- [How to install VirtualBox on Ubuntu](#vbox)
- [Create a VM with VBoxManage](#create_vm_1)
- [Create a VM with GUI](#create_vm_2)
- [Install Docker in VM](#install_docker)
- [Create a LEMP (Linux, Nginx, MariaDB, and PHP) server](#create_lemp_server)

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

<a id="create_vm_1"></a>
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
$ VBoxManage modifyvm "InceptionVM" --memory 2048 --cpus 1 --nic1 bridged
```

Create virtual hard disk:

```bash
$ VBoxManage createmedium --filename ~/VirtualBox\ VMs/InceptionVM/InceptionVM.vdi --size 10000 --format VDI
$ VBoxManage storagectl "InceptionVM" --name "SATA Controller" --add sata --controller IntelAHCI
$ VBoxManage storageattach "InceptionVM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox_VMs/InceptionVM/InceptionVM.vdi
```

Attach ISO image for OS installation:

```bash
$ VBoxManage storageattach "InceptionVM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium /path/to/debian.iso
```

Start VM in background:

```bash
$ VBoxManage startvm "InceptionVM" --type gui
```

For now, the automated process ends here.

Follow the Graphical installation steps to end the OS installation.

Source: [VBoxManage manual](https://www.virtualbox.org/manual/ch08.html)

<a id="create_vm_2"></a>
# Create a VM with GUI

The simplest way to create the VM. Follow my Born2beroot guide [42 Born2beroootl](https://github.com/bascb/Born2beroot/tree/master)

After the installation make sure that apt is not trying to get packages from cr.rom repo.
Edit file ```/etc/apt/sources.list```. Comment or remove the line:
```
deb cdrom:[Debian GNU/Linux 12.6.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20240629-10:19] bookworm main
```

And, to ensure that you have the necessary locales, run:
```bash
$ sudo nano /etc/locale.gen
# Uncomment the desired locales
$ sudo locale-gen
$ sudo systemctl reboot
```

<a id="install_docker"></a>
# Install Docker in VM

This is a guide to install Docker engine in Debian 12.

Folder utils of this project repo has a script install_docker.sh that automates this process.

Run the following command to uninstall all conflicting packages:
```bash
$ for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

Set up Docker's apt repository.
```bash
# Add Docker's official GPG key:
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl
$ sudo apt-get install build-essential
$ sudo install -m 0755 -d /etc/apt/keyrings
$ sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
$ sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update
```
To install the latest version, run:
```bash
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
```

If you want, you can Verify that the installation is successful by running the hello-world image:
```bash
$ sudo docker run hello-world
```

Optional: Manage Docker as a Non-root User
```bash
$ sudo usermod -aG docker $USER
```

Source: [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)

<a id="create_lemp_server"></a>
# Create a LEMP (Linux, Nginx, MariaDB, and PHP) server

Here is a list of sites that i used to create and run containers for MariaDB, Wordpress and Nginx:

- [How To Install WordPress with LEMP (Nginx, MariaDB and PHP) on Debian 10](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-nginx-mariadb-and-php-on-debian-10)
- [How To Install Linux, Nginx, MariaDB, PHP (LEMP stack) on Debian 10](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10)
- [How to install WordPress](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)