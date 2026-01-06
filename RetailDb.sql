

CREATE DATABASE retail_db;
use database retail_db;

create schema sales;
use schema sales;

create or replace table products (
 product_id INT primary key,
 product_name STRING not null,
 category STRING,
 price NUMBER(10,2) DEFAULT 0,
 attributes VARIANT
);

CREATE OR REPLACE TABLE customers(
 customer_id INT PRIMARY KEY,
 first_name STRING NOT NULL, 
 last_name STRING,
 email STRING UNIQUE,
 signup_date DATE DEFAULT CURRENT_DATE
);
create or replace table orders (
order_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
product_id INT REFERENCES products(product_id),
order_date DATE DEFAULT CURRENT_DATE,
quantity INT DEFAULT 1,
status STRING DEFAULT 'PENDING'
)

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 1200.00, PARSE_JSON('{"brand":"Dell","color":"Black"}')),
(2, 'Shoes', 'Fashion', 80.00, PARSE_JSON('{"brand":"Nike","size":"10"}'));

INSERT INTO customers VALUES
(101, 'Alice', 'Smith', 'alice@example.com', '2025-01-01'),
(102, 'Bob', 'Jones', 'bob@example.com', '2025-01-02');

INSERT INTO orders VALUES
(1001, 101, 1, '2025-01-05', 1, 'SHIPPED'),
(1002, 102, 2, '2025-01-06', 2, 'PENDING');


