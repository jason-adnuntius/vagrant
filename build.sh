#!/bin/bash

export VERSION=1.0.0

PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu1604-libvirt generic-libvirt.json
PACKER_CACHE_DIR=/var/tmp PACKER_IMAGES_OUTPUT_DIR=/var/tmp/packer/images packer build -on-error=cleanup -parallel=false -only=generic-ubuntu1804-libvirt generic-libvirt.json

