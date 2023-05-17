ð# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/virt-11/additional).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
#### Ответ: noSQL документоориентированные СУБД
Данные БД опитимизированны для работы с документами, в том числе с файлами типа JSON. То есть данные будут храниться в БД как есть
- Склады и автомобильные дороги для логистической компании
#### Ответ: noSQL Графовые СУБД
Соотношения дороги/склады будет удобно хранить как связи между узлами в графовой БД
- Генеалогические деревья
#### Ответ: noSQL Иерархические СУБД или Сетевые 
Генеалогические деревья имеют зависимости родитель/потомок, конкретный тип СУБД зависит от того, сколько родителей будет указано у потомков: если будет указано 2, то иерархическая не подойдет и, скорее всего, придется использовать сетевую
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
#### Ответ: noSQL СУБД Ключ-значение 
Здесь типа данных только 2: id клиента и кэш -> ключ-значние подойдет, также во многих СУБД данного типа реализован механизм задания времени жизни ключа и работа с использованием RAM, что повысит скорость работы аутентификации
- Отношения клиент-покупка для интернет-магазина
#### Ответ: Реляционные СУБД или noSQL СУБД Ключ-значение 
Скорее Реляционные СУБД, так как потенциально кроме клиент-покупка будут еще данные, которые будет полезно хранить в том же скопе и длительное время. Но если нет и нужно хранить только id клиента и id покупки и не продолжительное время, то СУБД Ключ-значение 

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
#### Ответ: PC, PC+EC
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
#### Ответ: PA, PA+EL
- Система может не прислать корректный ответ или сбросить соединение
#### Ответ: P, P+EL

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
#### Ответ: нет, так как это будет противоречить теореме CAP:
BASE система предлагает подоход PC, при котором достигается высокая степень согласованности системы, но всвязи с этим снижается доступность. При ACID подходе система будет PA, то есть высокая доступность при сбоях в ущерб согласованности данных. Совместить эти два подхода не представляется возможным, т.к. при увеличении доступности неизбежно будет снижаться доступность и наоборот, а делать систему без разделения на узлы (AC) не рационально, так как при утрате одного единственно узла вся система будет также утрачена - потеряется и доступность, и согласованность

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. 
Что это за система? Какие минусы выбора данной системы?

#### Ответ: Есть noSQL БД Ключ-значение Redis, в которой реализован механизм Pub/Sub и есть возможность ограничивать время жизни сохраненных данных. Для обеспечения реакции на истечение таймаута (TTL) можно использовать уведомления на событие EXPIRE 
#### Недостатки данной системы: 
- задержки при установлении статуса ключа (истек или нет), так как статус определяется при запросе ключа командой или при обнаружении истекшего ключа запущенной в бэкграунде системой - до наступления одного из этих событий не известно, истек ли ключ или нет; 
- у Redis нет встроенного механизма консенсуса - нужно дополнительно ставить еще систему управления (например, Redis Sentinel);
- Все данные Redis хранятся в оперативной памяти - нерационально использовать для больших объемов данных

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---