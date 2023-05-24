# Домашнее задание к занятию 3 «Использование Yandex Cloud»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Ответ:
[site.yml](https://github.com/Scandr/devops-netology/blob/main/08-ansible-03-yandex/playbook/site.yml)

Плейбук устанавливает clickhouse и vector на хосты с ОС Ubuntu </br>
Желаемую версию clickhouse следует указать в файле ./playbook/group_vars/clickhouse </br>
Желаемую версию vector - в файле ./playbook/group_vars/vector/vars.yml </br>
Директорию для установочных файлов vector также нужно указать в файле ./playbook/group_vars/vector/vars.yml </br>
Директорию для установочных файлов lighthouse также нужно указать в файле ./playbook/group_vars/lighthouse/vars.yml 
</br>
Хосты для установки следует указать в файле ./terraform/inventory.tf</br>
Для автоматического развертывания следует сгенерировать ssh ключ для соединения с хостами ($ ssh-keygen) и указать 
путь до публичного ключа в файлах 
* ./terraform/clickhouse01.tf, 
* ./terraform/lighthouse01.tf, 
* ./terraform/vector01.tf,
* ./playbook/group_vars/clickhouse/vars.yml, 
* ./playbook/group_vars/vector/vars.yml,
* ./playbook/group_vars/lighthouse/vars.yml

Плейбук из 3х основных тасков: таск установки clickhouse, таск установки vector и таск установки lighthouse </br>
Первый выполняет следующие действия:
* скачивает и устанавливает дистрибутивы clickhouse с официального сайта 
* стартует сервис clickhouse
* создает БД logs в clickhouse

Действия второго:
* проверяет, существует ли директория для установочных файлов vector
* если да, то удаляет ее содержимое, если нет - создает ее
* скачивает архив с vector с официального сайта 
* распаковывает скаченный архив
* переносит файлы из внутренней дикректории, что была распакована, в директорию для установочных файлов vector
* добавляет символьную ссылку на исполняемый файл vector в /usr/bin, если ее не существует, и предварительно удаляет ее, если она существует
* запускает конфигурацию vector

Действия третьего:
* клонирует репозиторий Lighthouse
* устанавливает веб-сервер nginx
* создает ссылку на склонированный репозиторий для директории сайтов nginx
* перезапускает nginx

### Ответ
Получилось разобраться, по какой-то причине не цепляет по внутренней сети, но через внешний IP работает
![image](https://github.com/Scandr/devops-netology/blob/main/08-ansible-03-yandex/lighthouse_working.PNG)

## Комментарии
Не получилось подключиться к clickhouse через веб-интерфейс lighthouse, при попытке сделать запрос выводится следующая ошибка:
![image](https://github.com/Scandr/devops-netology/blob/main/08-ansible-03-yandex/lighthouse_error.PNG)

Текст ошибки:
```
Error: XMLHttpRequest error: got status 0, error text:
```

Прописывание в /etc/clickhouse-server/config.xml строки
```
<listen_host>::</listen_host>
```
не помогло (но с этой строкой не появляются всплывающие окна-ошибки с подобным описанием)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
