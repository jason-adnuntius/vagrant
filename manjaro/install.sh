#!/bin/bash

loadkeys us
systemctl enable --now systemd-timesyncd
pacman-mirrors --geoip
pacman -Syy --noconfirm archlinux-keyring manjaro-keyring
pacman-key --init
pacman-key --populate archlinux manjaro
pacman-key --refresh-keys
echo 'type=83,bootable' | sudo sfdisk /dev/vda
mkfs.ext4 /dev/vda1
mount /dev/vda1 /mnt
basestrap /mnt base linux61 dhcpcd networkmanager grub mkinitcpio vi sudo links
cp chroot.sh /mnt/tmp
manjaro-chroot /mnt /mnt/tmp/chroot.sh
rm /mnt/chroot.sh
umount -R /mnt
