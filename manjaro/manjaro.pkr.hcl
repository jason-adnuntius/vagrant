variable "iso_url" {
  type =  string
}

variable "iso_checksum" {
  type = string
}

variable "box_version" {
  type = string
}

source "qemu" "main" {
    accelerator            = "kvm"  
    boot_command           = [
    "<spacebar><wait2>e<wait2><end><left> systemd.wants=sshd<f10>",
    "<wait30><wait30>"
    ]
    boot_wait              = "2s"  
    communicator           = "ssh"
    cpus                   = 1
    disk_interface         = "virtio"  
    disk_size              = 2048
    format                 = "qcow2"  
    headless               = "false"
    http_directory         = "http"
    iso_checksum           = "${var.iso_checksum}"
    iso_url                = "${var.iso_url}"
    memory                 = 2048
    net_device             = "virtio-net"  
    output_directory       = "../output"
    shutdown_command       = "sudo shutdown now"
    ssh_username           = "manjaro"
    ssh_password           = "manjaro"
    ssh_port               = 22
    ssh_timeout            = "20m"
    vm_name                = "manjaro.qcow2"
    vnc_port_max           = 5910
    vnc_port_min           = 5910
}

build { 
  name = "manjaro"
  sources = ["source.qemu.main"]

  provisioner "shell" {
    inline = [
      "/usr/bin/curl -O $PACKER_HTTP_ADDR/install.sh",
      "/usr/bin/curl -O $PACKER_HTTP_ADDR/chroot.sh",
      "chmod 777 *.sh",
      "/usr/bin/sudo ./install.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output = "../output/manjaro-${var.box_version}.box"
    vagrantfile_template = "templates/vagrantfile.tpl"
  }
}
