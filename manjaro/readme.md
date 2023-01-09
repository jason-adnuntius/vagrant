1. Run the create.sh script to start the new VM
2. Open a terminal and run the following:
  sudo systemctl enable serial-getty@ttyS0.service
  sudo systemctl start serial-getty@ttyS0.service

3. Login to the console with:
    ./login.sh
    
4. create an install.sh on the VM and paste the contents of the install.sh into it

    name=$(cat vm.name)
    sudo virsh console $name
    vi install.sh
    chmod 777 install.sh
    ./install.sh

  FIXME - figure out if there is a way to do all of this automatically
  FIXME - remove the CD ROM

5. Create the vagrant box

  cp $HOME/.local/share/libvirt/images/$name.qcow2 box.box
  tar cvzf manjaro-libvirt.box ./metadata.json ./Vagrantfile ./box.img 
  vagrant box add --name adnuntius/manjaro manjaro-libvirt.box

## References

- https://unix.stackexchange.com/questions/222427/how-to-create-custom-vagrant-box-from-libvirt-kvm-instance
- https://forum.manjaro.org/t/root-tip-how-to-do-a-manual-manjaro-installation/12507
- https://linuxconfig.org/how-to-create-and-manage-kvm-virtual-machines-from-cli
