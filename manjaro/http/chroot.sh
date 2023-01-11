#!/bin/bash

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF8 UTF-8/g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF8' > /etc/locale.conf

ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc
echo manjaro > /etc/hostname
echo '127.0.0.1    localhost' >> /etc/hosts
echo '::1          localhost' >> /etc/hosts
echo '127.0.1.1    manjaro.localdomain manjaro' >> /etc/hosts
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/10-wheel
systemctl enable dhcpcd
systemctl enable systemd-timesyncd
echo 'root:vagrant' | chpasswd
mkinitcpio -P
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

rm --force /run/systemd/generator.early/sshd.service
systemctl enable sshd

# make sure a virsh console is enabled
systemctl enable serial-getty@ttyS0.service

# add vagrant user
useradd -m vagrant
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
echo 'vagrant:vagrant' | chpasswd
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/20-vagrant
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh

# do some cleanup
pacman --sync --noconfirm --clean --clean
rm -rf /var/log/journal/*
rm /var/log/* 2> /dev/null
rm -f /var/lib/systemd/random-seed
