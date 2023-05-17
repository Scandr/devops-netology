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