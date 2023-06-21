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
variable "os_destrib" {
  default = "fd80d16oleqvtagvi2ht"
}
