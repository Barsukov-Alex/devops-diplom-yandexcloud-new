## main.tf

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name_network
}
resource "yandex_vpc_subnet" "subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr1
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr2
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-config.yml")
  vars = {
    ssh_public_key =  var.ssh_public_key
    ssh_private_key = var.ssh_private_key
  }
}