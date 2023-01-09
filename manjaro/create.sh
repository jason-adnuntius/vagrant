#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

ISO_FILE=manjaro-gnome-22.0-minimal-221224-linux61.iso
name=manjaro_$$

if [ ! -f /tmp/$ISO_FILE ]; then
  cp $CURRENT_DIR/$ISO_FILE /tmp/
fi

sudo virsh net-start default

echo $name > $CURRENT_DIR/vm.name

virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name=$name \
  --vcpus=1 \
  --memory=2048 \
  --cdrom=/tmp/$ISO_FILE \
  --disk size=2 \
  --import \
  --os-variant manjaro

