# master-vm.tf

variable "os_image_master" {
  type    = string
  default = "ubuntu-2404-lts"
}

data "yandex_compute_image" "ubuntu-master" {
  family = var.os_image_master
}

variable "yandex_compute_instance_master" {
  type        = list(object({
    vm_name = string
    cores = number
    memory = number
    count_vms = number
    platform_id = string
  }))

  default = [{
      vm_name = "master"
      cores         = 2
      memory        = 4
      count_vms = 1
      platform_id = "standard-v3"
    }]
}

variable "boot_disk_master" {
  type        = list(object({
    size = number
    type = string
    }))
    default = [ {
    size = 10
    type = "network-ssd"
  }]
}


resource "yandex_compute_instance" "master" {
  name        = "${var.yandex_compute_instance_master[0].vm_name}-${count.index+1}"
  hostname    = "${var.yandex_compute_instance_master[0].vm_name}-${count.index+1}"
  platform_id = var.yandex_compute_instance_master[0].platform_id
  zone = var.zone1
  count = var.yandex_compute_instance_master[0].count_vms

  resources {
    cores         = var.yandex_compute_instance_master[0].cores
    memory        = var.yandex_compute_instance_master[0].memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-master.image_id
      type     = var.boot_disk_master[0].type
      size     = var.boot_disk_master[0].size
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "user:${var.ssh_public_key}"
    user-data = data.template_file.cloudinit.rendered
  }

  scheduling_policy { preemptible = false }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
}
