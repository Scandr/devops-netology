# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,

```
test_db=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```
- описание таблиц (describe)

```
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
test_db=# \d+ clients
                                                 Table "public.clients"
 Column  |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
---------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id      | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 surname | text    |           |          |                                     | extended |              |
 country | text    |           |          |                                     | extended |              |
 orders  | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" UNIQUE, btree (country)
Foreign-key constraints:
    "clients_orders_fkey" FOREIGN KEY (orders) REFERENCES orders(id)
Access method: heap

test_db=# \d+ orders
                                                Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 name   | text    |           |          |                                    | extended |              |
 price  | integer |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orders_fkey" FOREIGN KEY (orders) REFERENCES orders(id)
Access method: heap
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db
```
test_db=# SELECT table_name, grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='orders' OR table_name='clients';
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | postgres         | INSERT
 orders     | postgres         | SELECT
 orders     | postgres         | UPDATE
 orders     | postgres         | DELETE
 orders     | postgres         | TRUNCATE
 orders     | postgres         | REFERENCES
 orders     | postgres         | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 clients    | postgres         | INSERT
 clients    | postgres         | SELECT
 clients    | postgres         | UPDATE
 clients    | postgres         | DELETE
 clients    | postgres         | TRUNCATE
 clients    | postgres         | REFERENCES
 clients    | postgres         | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
(22 rows)
```


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```
test_db=# INSERT INTO orders(name, price) VALUES
Шоколад'test_db-#     ('Шоколад',10),
test_db-#     ('Принтер',3000),
test_db-#     ('Книга',500),
test_db-#     ('Монитор',7000),
test_db-#     ('Гитара',4000);
INSERT 0 5
test_db=# INSERT INTO clients(surname, country) VALUES
test_db-#     ('Иванов Иван Иванович','USA'),
test_db-#     ('Петров Петр Петрович','Canada'),
test_db-#     ('Иоганн Себастьян Бах','Japan'),
test_db-#     ('Ронни Джеймс Дио','Russia'),
test_db-#     ('Ritchie Blackmore','Russia');
INSERT 0 5
test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT surname FROM clients WHERE orders IS NOT NULL;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=32)
   Filter: (orders IS NOT NULL)
(2 rows)

test_db=# EXPLAIN (FORMAT YAML) SELECT surname FROM clients WHERE orders IS NOT NULL;
             QUERY PLAN
------------------------------------
 - Plan:                           +
     Node Type: "Seq Scan"         +
     Parallel Aware: false         +
     Relation Name: "clients"      +
     Alias: "clients"              +
     Startup Cost: 0.00            +
     Total Cost: 18.10             +
     Plan Rows: 806                +
     Plan Width: 32                +
     Filter: "(orders IS NOT NULL)"
(1 row)

```
Node Type: "Seq Scan" - Тип узла сканирования, в данном случае Seq Scan - простое последовательное сканирование </br>
Parallel Aware: false - Не использовать параллельное сканирование, выставляется true, когда больше одной рабочей ноды</br>
Relation Name: "clients" - Целевой объект сканирования</br>
Alias: "clients" - алиас целевого объекта</br>
Startup Cost: 0.00 - сколько потребуется времени на выдачу первой строки</br>
Total Cost: 18.10 - сколько потребуется на выдачу всех строк</br>
Данные величины изменяются в последовательно прочитанных страницах - количество времени, которое потребуется на последовательное чтение 1 страницы = 1 единица -> 18.10 единиц = время последовательного прочтения 18.10 страниц</br>
Plan Rows: 806 - примерное количество строк</br>
Plan Width: 32  - размер строк в байтах</br>
Filter: "(orders IS NOT NULL)" - фильтр для строк</br>
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
