#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

ISO_FILE=manjaro-gnome-22.0-minimal-221224-linux61.iso
name=manjaro_$$

virsh --connect qemu:///system net-start default

echo $name > $CURRENT_DIR/vm.name

sudo virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name=$name \
  --vcpus=1 \
  --memory=2048 \
  --cdrom=/var/lib/libvirt/images/$ISO_FILE \
  --disk size=2 \
  --import \
  --noautoconsole \
  --os-variant manjaro || exit $?

virt-viewer -a --connect qemu:///system $name &

echo "The following must be done once the Live Env has finished starting:"
echo "    sudo systemctl start serial-getty@ttyS0.service"

virsh --connect qemu:///system attach-disk $name " " hdc --type cdrom --mode readonly