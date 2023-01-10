#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
cd $CURRENT_DIR

ISO_FILE=manjaro-gnome-22.0-minimal-221224-linux61.iso
if [ ! -f /var/lib/libvirt/images/$ISO_FILE ]; then
  >&2 echo "Missing $ISO_FILE in /var/lib/libvirt/images/"
  exit 1
fi

virsh --connect qemu:///system net-start default

echo manjaro_$$ > vm.name

sudo virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name=$(cat vm.name) \
  --vcpus=1 \
  --memory=2048 \
  --cdrom=/var/lib/libvirt/images/$ISO_FILE \
  --disk size=2 \
  --import \
  --noautoconsole \
  --os-variant manjaro || exit $?

echo
echo "When the boot menu appears:"
echo "  1. Choose boot with open source drivers and use 'E' to edit options"
echo "  2. Append ' console=ttyS0,115200' after 'splash'"
echo "  3. Press F10 to continue booting"
echo "  4. Wait until the GUI Installer starts"
echo "  5. Close the UI Viewer"

virt-viewer -a --connect qemu:///system $(cat vm.name) 2> /dev/null || exit $?

echo
sudo ./install.xp
echo

echo
read -p "Press enter to continue"
echo

echo
virsh --connect qemu:///system shutdown $(cat vm.name)
