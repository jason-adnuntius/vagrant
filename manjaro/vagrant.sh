#!/bin/bash

name=$(cat vm.name)

virsh shutdown $name
cp $HOME/.local/share/libvirt/images/$name.qcow2 box.box
tar cvzf manjaro-libvirt.box ./metadata.json ./Vagrantfile ./box.img
vagrant box add --name adnuntius/manjaro manjaro-libvirt.box
