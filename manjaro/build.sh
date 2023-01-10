#!/usr/bin/env bash

BOX_VERSION=1.0.2
ISO_URL=$(curl -s https://manjaro.org/download/ | grep -o "https://.*manjaro-gnome.*minimal.*iso" | tail -1)
ISO_CHECKSUM=$(curl -s ${ISO_URL}.sha1 | awk '{print $1}')

echo $ISO_URL
echo $ISO_CHECKSUM

PACKER_LOG=1 packer build -var iso_url=$ISO_URL -var iso_checksum=$ISO_CHECKSUM -var box_version=$BOX_VERSION manjaro.pkr.hcl

#vagrant box remove -f adnuntius/manjaro --box-version 0
#vagrant box add --name adnuntius/manjaro ../output/manjaro-$BOX_VERSION.box
