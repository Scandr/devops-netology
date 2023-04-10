CREATE USER "test-admin-user" CREATEDB CREATEUSER;
CREATE DATABASE test_db;
CREATE TABLE orders (
    id serial PRIMARY KEY,
    name text,
    price int
);
CREATE TABLE clients (
    id serial PRIMARY KEY,
    surname text,
    country text,
    orders int references orders(id)
);
CREATE UNIQUE INDEX country_idx ON clients(country);
GRANT ALL PRIVILEGES ON DATABASE "test_db" TO "test-admin-user";
CREATE USER "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
