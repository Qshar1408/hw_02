resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = "${yandex_vpc_network.develop.id}"
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop2" {
  name           = var.vpc_name2
  zone           = var.default_zone2
  network_id     = "${yandex_vpc_network.develop.id}"
  v4_cidr_blocks = var.default_cidr2
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
###  name        = var.vm_web_name
  name = local.vm_web_instance_name
  platform_id = var.vm_web_platform_id
  zone = var.default_zone
  metadata = var.common_metadata
  resources {
    cores         = var.vms_resources.vm_web_resources.cores
    memory        = var.vms_resources.vm_web_resources.memory
    core_fraction = var.vms_resources.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

###  metadata = {
###   serial-port-enable = 1
###    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
###  }

}

data "yandex_compute_image" "ubuntu2" {
  family = var.vm_db_family
}

resource "yandex_compute_instance" "platform2" {
###  name        = var.vm_db_name
  name = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone = var.default_zone2
  metadata = var.common_metadata
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop2.id
    nat       = true
  }

 ###  metadata = {
 ###   serial-port-enable = 1
 ###   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
 ### }

}