\o /opt/files/task4_output.txt


UPDATE clients SET orders = (SELECT id FROM orders WHERE name = 'Книга') WHERE surname = 'Иванов Иван Иванович';
UPDATE clients SET orders = (SELECT id FROM orders WHERE name = 'Монитор') WHERE surname = 'Петров Петр Петрович';
UPDATE clients SET orders = (SELECT id FROM orders WHERE name = 'Гитара') WHERE surname = 'Иоганн Себастьян Бах';


SELECT surname FROM clients WHERE orders IS NOT NULL;
EXPLAIN SELECT surname FROM clients WHERE orders IS NOT NULL;
EXPLAIN (FORMAT YAML) SELECT surname FROM clients WHERE orders IS NOT NULL;
