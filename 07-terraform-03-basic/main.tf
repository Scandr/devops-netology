variable "yandex_cloud_id" {
  default = "b1g2fffomokflpsrefif"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gse6fjmhipl4je57pj"
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "07-terraform-03-basic"
  region     = "ru-central"
  key        = "07-terraform-03-basic/terraform.tfstate"
  access_key = "YCAJEU9w67mNEd426kQ6o1op7"
  secret_key = "***"

  skip_region_validation      = true
  skip_credentials_validation = true
  }
}

provider "yandex" {
#  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "ru-central1-b"
}



data "yandex_compute_image" "last_ubuntu" {
  family = "ubuntu-2204-lts"  # ОС (Ubuntu, 22.04 LTS)
}

resource "yandex_compute_instance" "vm-1" {
  for_each = toset( "${terraform.workspace == "prod" ? ["1", "2"] : ["1"]}")
  name = "terraform-${terraform.workspace}-${each.key}"
#  name = "terraform-${terraform.workspace}-${count.index}"
#  count = "${terraform.workspace == "prod" ? 2 : 1}"
  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores  = "${terraform.workspace == "prod" ? 2 : 1}"
    memory = "${terraform.workspace == "prod" ? 2 : 1}"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1-${terraform.workspace}"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
#
#output "internal_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1[count.index].network_interface.0.ip_address
#}
#
#output "external_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1[count.index].network_interface.0.nat_ip_address
#}