#!/bin/bash

su
loadkeys us
systemctl enable --now systemd-timesyncd
pacman-mirrors --geoip
pacman -Syy archlinux-keyring manjaro-keyring
pacman-key --init
pacman-key --populate archlinux manjaro
pacman-key --refresh-keys
printf "n\nn\np\n1\n\n\na\nw\n" | fdisk /dev/vda
mkfs.ext4 /dev/vda1
mount /dev/vda1 /mnt
basestrap /mnt base linux61 dhcpcd networkmanager grub mkinitcpio vi sudo links
manjaro-chroot /mnt /bin/bash

# FIXME - enable en_US.UTF8,
#echo "LANG=en_US.UTF8" > /etc/locale.conf

ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc
echo manjaro > /etc/hostname
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1          localhost" >> /etc/hosts
echo "127.0.1.1    manjaro.localdomain manjaro" >> /etc/hosts
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/10-wheel
systemctl enable dhcpcd
systemctl enable systemd-timesyncd
echo "root:vagrant" | chpasswd
mkinitcpio -P
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m vagrant
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/20-vagrant
pacman -S openssh
systemctl enable sshd
systemctl start sshd
exit
shutdown

