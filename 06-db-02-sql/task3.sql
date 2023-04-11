\o /opt/files/task3_output.txt

INSERT INTO orders(name, price) VALUES
    ('Шоколад',10),
    ('Принтер',3000),
    ('Книга',500),
    ('Монитор',7000),
    ('Гитара',4000);
INSERT INTO clients(surname, country) VALUES
    ('Иванов Иван Иванович','USA'),
    ('Петров Петр Петрович','Canada'),
    ('Иоганн Себастьян Бах','Japan'),
    ('Ронни Джеймс Дио','Russia'),
    ('Ritchie Blackmore','Russia');

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM clients;