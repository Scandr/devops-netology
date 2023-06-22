# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры.
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

## Ответ
[requirements.yml](requirements.yml). <br />
Репозитории с ролями для vector и lighthouse:
- [vector-role](https://github.com/Scandr/vector-role.git)
- [lighthouse-role](https://github.com/Scandr/lighthouse-role.git)

### vector-role
Устанавливает Vector указанной версии в указанную папку
#### Параметры: 
- vector_version - версия Vector для установки (по умолчанию "0.18.0")
- vector_dir - куда класть установочные файлы Vector (по умолчанию "/opt/vector")
#### Описание работы:
* проверяет, существует ли директория для установочных файлов vector
* если да, то удаляет ее содержимое, если нет - создает ее
* скачивает архив с vector с официального сайта 
* распаковывает скаченный архив
* переносит файлы из внутренней дикректории, что была распакована, в директорию для установочных файлов vector
* добавляет символьную ссылку на исполняемый файл vector в /usr/bin, если ее не существует, и предварительно удаляет ее, если она существует
* запускает конфигурацию vector

### lighthouse-role
Устанавливает Lighthouse в указанную папку
#### Параметры:
- lighthouse_dir - куда класть установочные файлы Vector (по умолчанию "/opt/lighthouse")
#### Описание работы:
* клонирует репозиторий Lighthouse
* устанавливает веб-сервер nginx
* создает ссылку на склонированный репозиторий для директории сайтов nginx
* перезапускает nginx

## Комментарии:
Не удалось воспользоваться предложенной ролью git@github.com:AlexeySetevoi/ansible-clickhouse.git, были следующие ошибки

<summary>Ошибка</summary>
<details>

```
│ PLAY [clickhouse] **************************************************************
│
│ TASK [Gathering Facts] *********************************************************
│ ok: [clickhouse01.netology.yc]
│
│ TASK [clickhouse : Get clickhouse distrib] *************************************
│ changed: [clickhouse01.netology.yc]
│
│ TASK [clickhouse : Get clickhouse distrib] *************************************
│ fatal: [clickhouse01.netology.yc]: FAILED! => {}
│
│ MSG:
│
│ 'clickhouse_packages' is undefined. 'clickhouse_packages' is undefined
│
│ TASK [clickhouse : Get clickhouse distrib] *************************************
│ ok: [clickhouse01.netology.yc]
│
│ TASK [clickhouse : Flush handlers] *********************************************
│
│ RUNNING HANDLER [clickhouse : Start clickhouse service] ************************
│ fatal: [clickhouse01.netology.yc]: FAILED! => {
│     "changed": false
│ }
│
│ MSG:
│
│ Could not find the requested service clickhouse-server: host

```

</details>

Похоже на то, что несмотря на команду 
```
ansible-galaxy install --force -r ../requirements.yml
```
Роль не переустановилась, в итоге была использована собственная роль:
- [clickhouse-role](https://github.com/Scandr/clickhouse-role.git)

Получилось исправить: проблема была в одинаковом названии локальной роли в папке ./roles и удаленной роли, устанавливаемой из гита через файл requirements.yml, - роль в папке ./roles приоритетнее. Название удаленной роли в requirements.yml было изменено на clickhouse-vendor, что решило проблему

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
