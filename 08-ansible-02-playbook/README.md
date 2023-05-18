# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Ответ:
playbook - [site_v2.yml](https://github.com/Scandr/devops-netology/blob/main/08-ansible-02-playbook/playbook/site_v2.yml)

### Описание плейбука:
Плейбук устанавливает clickhouse и vector на хосты с ОС Ubuntu </br>
Желаемую версию clickhouse следует указать в файле ./playbook/group_vars/clickhouse </br>
Желаемую версию vector - в файле ./playbook/group_vars/vector/vars.yml </br>
Директорию для установочных файлов vector также нужно указать в файле ./playbook/group_vars/vector/vars.yml </br>
Хосты для установки следует указать в файле ./playbook/inventory/prod.yml, для установки обоих приложений нужно записать хост в обе группы - clickhouse и vector </br>
Запуск плейбука осуществляется командой
```
$ ansible-playbook site_v2.yml -i inventory/prod.yml -K
```
После запуска необходимо ввести пароль для sudo </br>
Плейбук из 2х основных тасков: таск установки clickhouse и таск установки vector </br>
Первый выполняет следующие действия:
* скачивает и устанавливает дистрибутивы clickhouse с официального сайта 
* стартует сервис clickhouse
* создает БД logs в clickhouse

Действия второго:
* проверяет, существует ли директория для установочных файлов vector
* если да, то удаляет ее содержимое, если нет - создает ее
* скачивает архив с vector с официального сайта 
* распаковывает скаченный архив
* переносит файлы из внутренней дикректории, что была распаковына, в директорию для установочных файлов vector
* добавляет символьную ссылку на исполняемый файл vector в /usr/bin, если ее не существует, и предварительно удаляет ее, если она существует
* запускает конфигурацию vector 
---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

## Комментарии к работе:
Версии приложений и ОС:
#### ansible-lint
```
$ ansible-lint --version
WARNING: PATH altered to include /usr/bin
ansible-lint 5.4.0 using ansible 2.14.1
```
#### ansible
```
$ ansible --version
ansible [core 2.14.1]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/yelena/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/yelena/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/yelena/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/yelena/.local/bin/ansible
  python version = 3.10.6 (main, Mar 10 2023, 10:55:28) [GCC 11.3.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```
#### OS (1)
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.2 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
#### OS (2)
```
$ cat /proc/version
Linux version 5.15.90.1-microsoft-standard-WSL2 (oe-user@oe-host) (x86_64-msft-linux-gcc (GCC) 9.3.0, GNU ld (GNU Binutils) 2.34.0.20200220) #1 SMP Fri Jan 27 02:56:13 UTC 2023
```