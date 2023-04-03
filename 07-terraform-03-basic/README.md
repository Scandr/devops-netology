# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
```
$ yc iam service-account create --name terraform
id: ajebammc63vn28ab8tjp
folder_id: b1gse6fjmhipl4je57pj
created_at: "2023-03-28T21:29:56.410072256Z"
name: terraform
$ yc resource-manager folder add-access-binding b1gse6fjmhipl4je57pj \
> --role editor \
> --subject serviceAccount:ajebammc63vn28ab8tjp
done (8s)
$ yc iam access-key create --service-account-name terraform

```

2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 
```
$ yc storage bucket create --name 07-terraform-03-basic --default-storage-class standard --max-size 5368709
name: 07-terraform-03-basic
folder_id: b1gse6fjmhipl4je57pj
anonymous_access_flags:
  read: false
  list: false
default_storage_class: STANDARD
versioning: VERSIONING_DISABLED
max_size: "5368709"
acl: {}
created_at: "2023-03-28T21:48:29.574105Z"
```
(https://console.cloud.yandex.ru/folders/b1gse6fjmhipl4je57pj/storage/buckets)

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  

<details>

```
$ terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.88.0...
- Installed yandex-cloud/yandex v0.88.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - yandex-cloud/yandex
│
│ The current .terraform.lock.hcl file only includes checksums for linux_386, so Terraform running on another platform will fail to install these providers.
│
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
</details>

1. Создайте два воркспейса `stage` и `prod`.
```
$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```
2. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
3. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
```
...
  name = "terraform-${terraform.workspace}-${count.index}"
  count = "${terraform.workspace == "prod" ? 2 : 1}"
...
```
4. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
```
...
  for_each = toset( "${terraform.workspace == "prod" ? ["vm01", "vm02"] : ["vm01"]}")
  name = "terraform-${terraform.workspace}-${each.key}"
...
```

5. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
```
...
  lifecycle {
    create_before_destroy = true
  }
...
```
По какой-то причине нет разницы между запуском terraform apply с данным параметром и без него:

<details>
   <summary> с create_before_destroy = true: </summary>

```
yandex_compute_instance.vm-1[0]: Destroying... [id=epdsgk11kp071l1a3m18]
yandex_compute_instance.vm-1[1]: Destroying... [id=epdoa964572n0erskp0t]
yandex_compute_instance.vm-1["vm02"]: Creating...
yandex_compute_instance.vm-1["vm01"]: Creating...
yandex_compute_instance.vm-1[0]: Still destroying... [id=epdsgk11kp071l1a3m18, 10s elapsed]
yandex_compute_instance.vm-1[1]: Still destroying... [id=epdoa964572n0erskp0t, 10s elapsed]
yandex_compute_instance.vm-1["vm02"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1[0]: Still destroying... [id=epdsgk11kp071l1a3m18, 20s elapsed]
yandex_compute_instance.vm-1[1]: Still destroying... [id=epdoa964572n0erskp0t, 20s elapsed]
yandex_compute_instance.vm-1["vm02"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1[0]: Destruction complete after 29s
yandex_compute_instance.vm-1[1]: Destruction complete after 29s
yandex_compute_instance.vm-1["vm02"]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1["vm02"]: Creation complete after 36s [id=epduhqv1l22uj6d2lthf]
yandex_compute_instance.vm-1["vm01"]: Still creating... [40s elapsed]
yandex_compute_instance.vm-1["vm01"]: Creation complete after 46s [id=epdbb2jacrbgf0v013ti]
```

</details>

<details>
   <summary>без create_before_destroy = true: </summary>


```
yandex_compute_instance.vm-1["vm02"]: Destroying... [id=epdl3bqnl5ihgcf2uvpa]
yandex_compute_instance.vm-1["vm01"]: Destroying... [id=epd846e7uq4g62h74hrb]
yandex_compute_instance.vm-1[1]: Creating...
yandex_compute_instance.vm-1[0]: Creating...
yandex_compute_instance.vm-1["vm02"]: Still destroying... [id=epdl3bqnl5ihgcf2uvpa, 10s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still destroying... [id=epd846e7uq4g62h74hrb, 10s elapsed]
yandex_compute_instance.vm-1[1]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1[0]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1["vm02"]: Still destroying... [id=epdl3bqnl5ihgcf2uvpa, 20s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still destroying... [id=epd846e7uq4g62h74hrb, 20s elapsed]
yandex_compute_instance.vm-1[0]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1[1]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1["vm02"]: Still destroying... [id=epdl3bqnl5ihgcf2uvpa, 30s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still destroying... [id=epd846e7uq4g62h74hrb, 30s elapsed]
yandex_compute_instance.vm-1[0]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1[1]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1["vm01"]: Still destroying... [id=epd846e7uq4g62h74hrb, 40s elapsed]
yandex_compute_instance.vm-1["vm02"]: Still destroying... [id=epdl3bqnl5ihgcf2uvpa, 40s elapsed]
yandex_compute_instance.vm-1[0]: Still creating... [40s elapsed]
yandex_compute_instance.vm-1[1]: Still creating... [40s elapsed]
yandex_compute_instance.vm-1["vm01"]: Destruction complete after 40s
yandex_compute_instance.vm-1["vm02"]: Destruction complete after 42s
yandex_compute_instance.vm-1[0]: Creation complete after 44s [id=epdsgk11kp071l1a3m18]
yandex_compute_instance.vm-1[1]: Creation complete after 45s [id=epdoa964572n0erskp0t]
```

</details>

6. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
### Ответ
```
$ terraform workspace list
  default
* prod
  stage
```
* Вывод команды `terraform plan` для воркспейса `prod`.  
### Ответ

count - [prod_terraform_out](https://github.com/Scandr/devops-netology/blob/main/07-terraform-03-basic/prod_terraform_out.txt) </br>
for_each - [prod_terraform_for_each_out](https://github.com/Scandr/devops-netology/blob/main/07-terraform-03-basic/prod_terraform_for_each_out.txt)</br>

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
