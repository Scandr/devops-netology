# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
#### Ответ 
```
$ sudo podman-compose up -d
['podman', '--version', '']
using podman version: 3.4.4
** excluding:  set()
['podman', 'network', 'exists', '06-db-04-postgresql_default']
podman run --name=06-db-04-postgresql_db_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=06-db-04-postgresql --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=06-db-04-postgresql --label com.docker.compose.project.working_dir=/mnt/c/Users/yaitk/Documents/courses/netologia/git_repo_v2/devops-netology/06-db-04-postgresql --label com.docker.compose.project.config_files=docker-compose.yml --label com.docker.compose.container-number=1 --label com.docker.compose.service=db -e POSTGRES_PASSWORD=1234 -e PGDATA=/opt/postgresql/data -v /opt/volume:/opt/postgresql/data --net 06-db-04-postgresql_default --network-alias db --restart always postgres:13
db3b69ab4195d6905918d35c53b99b944e807bf0e149b6747ff1dbf7173a998f
exit code: 0
```
Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

#### Ответ
```
$ sudo docker exec -ti db3b69ab4195  /usr/bin/psql --username=postgres
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                         \g with no arguments is equivalent to a semicolon
  \gdesc                 describe result of query, without executing it
  \gexec                 execute query, then execute each value in its result
  \gset [PREFIX]         execute query and store results in psql variables
  \gx [(OPTIONS)] [FILE] as \g, but forces expanded output mode
  \q                     quit psql
  \watch [SEC]           execute query every SEC seconds
...
```

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
  \l[+]   [PATTERN]      list databases
```
- подключения к БД
```
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
- вывода списка таблиц
```
  \dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```
  \dd[S]  [PATTERN]      show object descriptions not displayed elsewhere
```
- выхода из psql
```
  \q                     quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```
postgres@8623ecd470b9:/$ psql -d test_database < /files/test_data/test_dump.sql
```
Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```
test_database=# SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders';
 max
-----
  16
(1 row)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
postgres@3dd643a49c64:/$  psql -d test_database -f /files/table_sharding.sql
CREATE TABLE
INSERT 0 3
DELETE 3
ALTER TABLE
postgres@3dd643a49c64:/$ psql
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Можно, создав партиции для данной таблицы и триггер на распрееделение значений при вставке в исходную таблицу

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Добавить ограничение UNIQUE [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats)


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
