# Virtual image template

The goal of this repository is to provide a template and a guide for creating new virtual images. The template is based on the [kali repository](https://gitlab.ics.muni.cz/muni-kypo-images/kali-2019.4). The image is created using [packer](https://www.packer.io/intro) and two variants are currently created. The first is for QEMU and Openstack, the second is for VirtualBox and Vagrant.

# How to create a new virtual image

## The packer image creation process

A summary of how packer creates images for reference.

1. Downloads and verifies ISO image
2. Creates a virtual machine, which boots from the ISO image and which has mounted a disk where the OS will be installed
3. Waits for a certain amount of time and then types the `boot_command` if specified to start the installation
4. Waits for connection (ssh or winrm) to become available
5. Connects to the machine and runs `provisioners`
6. Shuts down the machine, creating the virtual image 
7. Runs `post-processors` if specified


## Packer configuration

Packer configuration is specified in json file in the root of the repository, for example `kali.json`. It should be renamed to match the image name. The folowing variables, found in the bottom of this file, have to be changed.

* `iso_url` and `iso_checksum` which specify the ISO image to be downloaded. The url shouldn't point to latest release, because it may not work after a new release of the ISO image. The ISO image is locally cached in `packer_cache` directory, so it may work locally even when the url is broken.
* `boot_command` is an array of strings describing keystrokes sent to the machine after `boot_wait` time. Is is used to start the installation, typically choosing non-interactive installation, pressed file location and settings unable to be answered by the preseed file. It is not mandatory and for windows images wasn't necessary.
* `guest_os_type` used by vbox builder, to view all available values, run `VBoxManage list ostypes`
* `vm_name` to match the image name


If you are building the image locally and you would like to see the GUI of the virtual machine, change the `headless` variable to false. Remember to change this back when commiting, otherwise the CI/CD process will fail. This doesn't work on all host systems. If that is the case, you can still view thr GUI by connecting via VNC or VRDP on `localhost:5900`, as instructed by packer. That is after changing back the `headless` variable to true.

## Preseed file

In `http` directory, there is a `preseed.cfg` (debian), `ks.cfg` (shortened 'kickstart', centos) or `Autounattend.xml` (windows) file, which is made available to the machine. This file contains answers to questions of the installer, such as language, country, user accounts, disk partitioning, packages and so on.
This file in conjuction with the `boot_command` has to answer all mandatory questions of the installer, in order to finish the installation without user interaction.
Creation of this file and the `boot_command` usually revolves around copying existing preseed file, reading documentation of the format of the file, finishing with trial and error, so no interactive windows pops up.

## Provisioning

Defined in the packer configuration, the [provisioners](https://www.packer.io/docs/provisioners) are run after packer connects to the machine. These usually consists of scripts, which are stored in the `scripts` directory. There are files from the kali repository in the `scripts` directory as an example, feel free to delete them. Provisioning is used to prepare the system for use. It is also used for platform-specific settings, such as cloud-init (cloudbase-init on windows) for QEMU or vagrant user and VBox Guest Additions for VBox.

## Other files that need to be modified

* `.gitlab-ci.yml` explained in the file
* `cloud.cfg` for linux images, at least the distro and default_user name at the bottom of the file
* `CHANGELOG.md` with the proper date and urls
* `README.md`


