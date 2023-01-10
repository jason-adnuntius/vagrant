#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
cd $CURRENT_DIR

if [ ! -f vm.name ]; then
  >&2 echo "No current VM"
  exit 1
fi

state=$(virsh --connect qemu:///system dominfo $(cat vm.name) | grep State | sed 's/State:\s*//g')
if [ "$state" != "shut off" ]; then
  >&2 echo "Instance $(cat vm.name) has not stopped"
  exit 1
fi

volume=$(virsh --connect qemu:///system vol-path --pool default $(cat vm.name).qcow2 | tr -d '\n')
sudo cp $volume box.img
sudo chown $USER: box.img

[ -f manjaro-libvirt.box ] && rm manjaro-libvirt.box
tar cvzf manjaro-libvirt.box ./metadata.json ./box.img

vagrant box remove -f adnuntius/manjaro --box-version 0
vagrant box add --name adnuntius/manjaro manjaro-libvirt.box
