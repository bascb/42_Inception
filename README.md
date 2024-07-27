# Inception

This is a complete guide to build the 42 Inception project.

# List of Contents
- [How to install VirtualBox on Ubuntu](#vbox)

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