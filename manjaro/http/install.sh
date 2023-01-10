#!/bin/bash

loadkeys us
systemctl enable --now systemd-timesyncd || exit $?

echo 'type=83,bootable' | sudo sfdisk /dev/vda || exit $?
sleep 5
mkfs.ext4 /dev/vda1 || exit $?
mount /dev/vda1 /mnt || exit $?

pacman-mirrors --api --set-branch stable --continent || exit $?
pacman-key --init || exit $?
pacman-key --populate archlinux manjaro || exit $?
basestrap /mnt base linux61 dhcpcd grub mkinitcpio vi sudo openssh cloud-guest-utils lsb-release || exit $?
fstabgen -U -p /mnt >> /mnt/etc/fstab || exit $?
cp chroot.sh /mnt/ || exit $?
cp /etc/lsb-release /mnt/etc/lsb-release
manjaro-chroot /mnt /chroot.sh || exit $?
rm /mnt/chroot.sh || exit $?
[ -f /mnt/etc/fstab.pacnew ] && rm -f /mnt/etc/fstab.pacnew
umount -R /mnt || exit $?
