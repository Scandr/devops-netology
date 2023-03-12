CREATE TABLE orders_1 (
    CHECK ( price > 499 )
) INHERITS (orders);

CREATE TABLE orders_2 (
    CHECK ( price <= 499 )
) INHERITS (orders);

CREATE OR REPLACE FUNCTION orders_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.price > 499 ) THEN
        INSERT INTO orders_1 VALUES (NEW.*);
    ELSE
        INSERT INTO orders_2 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_orders_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE PROCEDURE orders_insert_trigger();