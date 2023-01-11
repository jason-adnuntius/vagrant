Vagrant.configure("2") do |config|
  config.vm.box = "adnuntius/manjaro"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 1
    libvirt.memory = 1024
    libvirt.machine_virtual_size = 20
  end

  config.vm.provision :shell do |s|
    s.inline = <<-SHELL
      growpart /dev/vda 1
      resize2fs /dev/vda1 2>&1
    SHELL
  end
end
