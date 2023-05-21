output "internal_ip_address_node01" {
  value = "${yandex_compute_instance.clickhouse01.network_interface.0.ip_address}"
}

output "external_ip_address_node01" {
  value = "${yandex_compute_instance.clickhouse01.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_node02" {
  value = "${yandex_compute_instance.vector01.network_interface.0.ip_address}"
}

output "external_ip_address_node02" {
  value = "${yandex_compute_instance.vector01.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_node03" {
  value = "${yandex_compute_instance.lighthouse01.network_interface.0.ip_address}"
}

output "external_ip_address_node03" {
  value = "${yandex_compute_instance.lighthouse01.network_interface.0.nat_ip_address}"
}

