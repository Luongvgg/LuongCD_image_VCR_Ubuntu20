#!/bin/bash -x

# set GRUB_TIMEOUT to 0
sudo sed -i "s/^GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/" /etc/default/grub
sudo update-grub

# disable root login using password
#sudo passwd -l root

