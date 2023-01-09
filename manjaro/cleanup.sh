#!/bin/bash

volumes=($(virsh vol-list default | awk '{print $1}' | grep -E "^vagrant" | tr '\n' ' '))
for volume in "${volumes[@]}"; do
  virsh vol-info $volume --pool default > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    virsh vol-delete $volume --pool default > /dev/null 2>&1
  fi
done
