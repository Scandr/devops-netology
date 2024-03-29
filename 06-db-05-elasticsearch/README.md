# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch 
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
#### Ответ: [Dockerfile](https://github.com/Scandr/devops-netology/blob/main/06-db-05-elasticsearch/Dockerfile)
- ссылку на образ в репозитории dockerhub
#### Ответ: [06-db-05-elasticsearch:all_in_one](https://hub.docker.com/layers/xillah/06-db-05-elasticsearch/all_in_one/images/sha256-096ab545b43f7ee5dccfae8afcaa2d11266565ee48709528911e224380acd170?context=repo)
- ответ `elasticsearch` на запрос пути `/` в json виде
#### Ответ:
```
$ curl --cacert ./http_ca.crt -u elastic https://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "1UYH8LgzQd2klnfrkA_Nyg",
  "version" : {
    "number" : "8.6.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2d58d0f136141f03239816a4e360a8d17b6d8f29",
    "build_date" : "2023-02-13T09:35:20.314882762Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
#### Ответ: 
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X PUT "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
...
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cat/indices/*?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 qw_BOBzPQia2dEK6UkwwGw   1   0          0            0       225b           225b
yellow open   ind-2 ifIYUYN6TVOkdWLwIia9aQ   2   1          0            0       450b           450b
yellow open   ind-3 jMhrDad8SMKGPe5MLuAJ7w   4   2          0            0       900b           900b
```
Получите состояние кластера `elasticsearch`, используя API.
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=50s&pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
#### Ответ: 
Часть индексов не распределены по нодам, так как нода только одна:
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cat/shards?v=true&h=index,shard,prirep,state,node,unassigned.reason&s=state&pretty"
index            shard prirep state      node          unassigned.reason
ind-3            0     r      UNASSIGNED               INDEX_CREATED
ind-3            0     r      UNASSIGNED               INDEX_CREATED
ind-3            1     r      UNASSIGNED               INDEX_CREATED
ind-3            1     r      UNASSIGNED               INDEX_CREATED
ind-3            2     r      UNASSIGNED               INDEX_CREATED
ind-3            2     r      UNASSIGNED               INDEX_CREATED
ind-3            3     r      UNASSIGNED               INDEX_CREATED
ind-3            3     r      UNASSIGNED               INDEX_CREATED
ind-2            0     r      UNASSIGNED               INDEX_CREATED
ind-2            1     r      UNASSIGNED               INDEX_CREATED
ind-1            0     p      STARTED    netology_test
ind-3            0     p      STARTED    netology_test
ind-3            1     p      STARTED    netology_test
ind-3            2     p      STARTED    netology_test
ind-3            3     p      STARTED    netology_test
.geoip_databases 0     p      STARTED    netology_test
.security-7      0     p      STARTED    netology_test
ind-2            0     p      STARTED    netology_test
ind-2            1     p      STARTED    netology_test
```
Удалите все индексы.
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X DELETE "https://localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
...
```
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
#### Ответ: 
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X PUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
 "type"> {
>   "type": "fs",
>   "settings": {
>     "location": "snapshots"
>   }
> }
> '
{
  "acknowledged" : true
}
```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
#### Ответ: 
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cat/indices/*?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  tmgxCwkzQ_qCLsgvawSY4A   1   0          0            0       225b           225b
```
[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X PUT "https://localhost:9200/_snapshot/netology_backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty"
{
  "accepted" : true
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.
#### Ответ: 
```
[elastic@3214934788da elasticsearch-8.6.2]$ ls -la snapshots/snapshots/
total 44
drwxr-xr-x 3 elastic elastic  4096 Mar 20 21:33 .
drwxrwxr-x 3 elastic elastic  4096 Mar 20 21:24 ..
-rw-r--r-- 1 elastic elastic  1107 Mar 20 21:33 index-0
-rw-r--r-- 1 elastic elastic     8 Mar 20 21:33 index.latest
drwxr-xr-x 5 elastic elastic  4096 Mar 20 21:33 indices
-rw-r--r-- 1 elastic elastic 18700 Mar 20 21:33 meta-nO1FtOkHT0eA7rz6f1RZxA.dat
-rw-r--r-- 1 elastic elastic   400 Mar 20 21:33 snap-nO1FtOkHT0eA7rz6f1RZxA.dat
```
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
#### Ответ: 
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X DELETE "https://localhost:9200/test?pretty"
{
  "acknowledged" : true
}
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X PUT "https://localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
   "num>       "number_of_replicas": 0
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cat/indices/*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 BeSbunNgScaHMVUHGr1QNg   1   0          0            0       225b           225b
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
```
$ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X  -X GET "https://localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
{
  "snapshots" : [
    {
      "snapshot" : "my_snapshot_2023.03.20",
      "uuid" : "nO1FtOkHT0eA7rz6f1RZxA",
      "repository" : "netology_backup",
      "indices" : [
        ".geoip_databases",
        ".security-7",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}
```
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
#### Ответ: 
```
$ curl  --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X POST "https://localhost:9200/_snapshot/netology_backup/my_snapshot_2023.03.20/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "test"
> }
> '
{
  "accepted" : true
}
> $ curl --cacert ./http_ca.crt -u elastic:5C=wDdknjM20pNi6Y4-X -X GET "https://localhost:9200/_cat/indices/*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   gsKbNPZcT6OaWQhZuGaeqA   1   0          0            0       225b           225b
green  open   test-2 BeSbunNgScaHMVUHGr1QNg   1   0          0            0       225b           225b
```
Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
