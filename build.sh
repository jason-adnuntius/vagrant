#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

export VERSION=1.0.1

PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu1604-libvirt generic-libvirt.json
PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu1804-libvirt generic-libvirt.json

vagrant box remove adnuntius/ubuntu1604
vagrant box remove adnuntius/ubuntu1804

# FIXME - is this overkill 
sudo rm /var/lib/libvirt/images/*
virsh pool-destroy default
virsh pool-delete default
virsh pool-undefine default

vagrant box add --provider libvirt --name adnuntius/ubuntu1604 $CURRENT_DIR/output/generic-ubuntu1604-libvirt-$VERSION.box
vagrant box add --provider libvirt --name adnuntius/ubuntu1804 $CURRENT_DIR/output/generic-ubuntu1804-libvirt-$VERSION.box


