#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
cd $CURRENT_DIR

if [ ! -f vm.name ]; then
  >&2 echo "No current VM"
  exit 1
fi

volumes=($(virsh --connect qemu:///system vol-list default | grep "manjaro_[0-9]*.qcow2" | awk '{print $1}' | grep -v $(cat vm.name)))
for volume in "${volumes[@]}"; do
  virsh --connect qemu:///system vol-info $volume --pool default > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    virsh --connect qemu:///system vol-delete $volume --pool default > /dev/null 2>&1
  fi
done
