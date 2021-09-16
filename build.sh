#!/bin/bash

sudo true

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

export UBUNTU_1804_VERSION=1.0.4
export UBUNTU_2004_VERSION=1.0.2

mkdir -p $CURRENT_DIR/output

VERSION=$UBUNTU_1804_VERSION PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu1804-libvirt generic-libvirt.json
VERSION=$UBUNTU_2004_VERSION PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu2004-libvirt generic-libvirt.json

# cleanup temporary boxes here, so they can be redeployed for testing
vagrant box remove -f adnuntius/ubuntu1804 --box-version 0
vagrant box remove -f adnuntius/ubuntu2004 --box-version 0
vagrant box add --provider libvirt --name adnuntius/ubuntu1804 $CURRENT_DIR/output/generic-ubuntu1804-libvirt-$UBUNTU_1804_VERSION.box
vagrant box add --provider libvirt --name adnuntius/ubuntu2004 $CURRENT_DIR/output/generic-ubuntu2004-libvirt-$UBUNTU_2004_VERSION.box
