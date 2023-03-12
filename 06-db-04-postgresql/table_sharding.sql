

CREATE TABLE orders_1 (LIKE orders);
INSERT INTO orders_1 SELECT * FROM orders WHERE
	price > 499;
DELETE FROM orders WHERE price > 499;
ALTER TABLE orders RENAME TO orders_2;

--CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
--

--CREATE TABLE orders_1 INHERITS (orders);
--CREATE TABLE orders_2 INHERITS (orders);
--INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499 ;
--INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499 ;