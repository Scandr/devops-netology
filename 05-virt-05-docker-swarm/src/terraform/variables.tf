# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1g2fffomokflpsrefif"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gse6fjmhipl4je57pj"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd8pcn1vkjv4qirpacje"
}
variable "centos-7-base-ansible" {
  default = "fd8c45n6l0i34prkcm15"
}
