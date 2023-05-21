resource "yandex_compute_instance" "clickhouse01" {
  name                      = "clickhouse01"
  zone                      = "ru-central1-b"
  hostname                  = "clickhouse01.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.os_destrib}"
      name        = "root-clickhouse01"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "192.168.101.11"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/opt/yandex_cloud/id_rsa.pub")}"
  }
}
