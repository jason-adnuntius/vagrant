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

virsh --connect qemu:///system undefine $(cat vm.name)
virsh --connect qemu:///system vol-delete --pool default $(cat vm.name).qcow2
rm vm.name
