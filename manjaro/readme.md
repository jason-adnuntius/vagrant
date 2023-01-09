# Create Base Manjaro QEMU / LIBVIRT Image

1. Run the `./create.sh` script to start the new VM

2. Switch to the GUI Viewer, and open a terminal and run the following:
```
  sudo systemctl enable serial-getty@ttyS0.service
  sudo systemctl start serial-getty@ttyS0.service
``` 

3. Login to the console with `./login.sh`
    
4. Run the install.sh on the VM via expect install.xp
```
    sudo expect install.xp $(cat vm.name)
```

  FIXME - figure out if there is a way to do all of this automatically
  FIXME - remove the CD ROM

5. Create the vagrant box
```
./vagrant.sh
```

## References

- https://unix.stackexchange.com/questions/222427/how-to-create-custom-vagrant-box-from-libvirt-kvm-instance
- https://forum.manjaro.org/t/root-tip-how-to-do-a-manual-manjaro-installation/12507
- https://linuxconfig.org/how-to-create-and-manage-kvm-virtual-machines-from-cli
- https://gist.github.com/shalk/7003628
- https://mysnippets443.wordpress.com/2016/03/20/expect-script-read-write-file/
