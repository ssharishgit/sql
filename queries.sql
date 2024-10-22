-- *** SQL TASK ***

-- Create a database ecommerce.
CREATE DATABASE IF NOT EXISTS ecommerce;

-- create table structure for customers and Inserting sample data
CREATE TABLE IF NOT EXISTS customers (
  customer_id INTEGER PRIMARY KEY  NOT NULL AUTOINCREMENT,
  customer_name TEXT,
  email VARCHAR,
  address VARCHAR
)

INSERT INTO customers (customer_id, customer_name, email,address) VALUES
 (1, 'ram', 'abc@al.in', 'sample address'),
 (2, 'sam', 'jw@al.in', 'sample address'),
 (3, 'bala', 'xyz@al.in', 'sample address'),
 (4, 'raju', 'qwe@al.in', 'sample address');

-- create table structure for orders
CREATE TABLE IF NOT EXISTS orders (
  order_id INTEGER PRIMARY KEY  NOT NULL AUTOINCREMENT,
  customer_id INTEGER FOREIGN KEY,
  product_id INTEGER,
  order_date DATE,
  total_amount FLOAT
)

INSERT INTO orders (customer_id, product_id, order_date, total_amount) VALUES
 (1, 2, '2024-09-01', 300.00),
 (1, 1, '2024-10-20', 120.00),
 (2, 2, '2024-09-22', 100.00),
 (4, 2, '2024-10-10', 400.00),
 (3, 3, '2024-10-01', 250.50),
 (2, 3, '2024-09-05', 501.00);

-- create table structure for products
CREATE TABLE IF NOT EXISTS products (
  product_id INTEGER PRIMARY KEY  NOT NULL AUTOINCREMENT,
  product_name TEXT,
  price FLOAT,
  description VARCHAR
)

INSERT INTO products (product_id, product_name, price, description) VALUES
 (1, A, 120.00, "prd a"),
 (2, B, 100.00, "prd b"),
 (3, C, 250.50, "prd c"),
 (4, D, 200.00, "prd d");


--  *** Queries ***

-- Retrieve the average total of all orders
SELECT ROUND( AVG(total_amount), 2) AS average_total FROM orders

-- Retrieve the orders with a total amount greater than 150.00
SELECT * FROM orders WHERE total_amount > 150 

-- Retrieve all customers who have placed an order in the last 30 days
SELECT c.*,o.order_date FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) 

-- Retrieve the top 3 products with the highest price
SELECT * FROM products ORDER BY price DESC LIMIT 3 

-- Update the price of Product C to 45.00
UPDATE products SET price = 45.00 WHERE products.product_name = "C";

-- Add a new column discount to the products table
ALTER TABLE products ADD discount FLOAT DEFAULT 0.00 AFTER description 

-- Get the total amount of all orders placed by each customer
SELECT customer_name,SUM(orders.total_amount) FROM customers 
JOIN orders ON orders.customer_id = customers.customer_id GROUP BY customer_name

-- Join the orders and customers tables to retrieve the customer's name and order date for each order
SELECT customer_name,orders.order_date FROM customers 
JOIN orders ON orders.customer_id = customers.customer_id GROUP BY orders.order_id 

-- Get the names of customers who have ordered Product A
SELECT customers.customer_name FROM customers 
JOIN orders ON orders.customer_id = customers.customer_id 
WHERE orders.product_id = (SELECT product_id FROM products WHERE products.product_name = "A")

-- Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table
CREATE TABLE IF NOT EXISTS orderitems (
  orderitem_id INTEGER PRIMARY KEY  NOT NULL AUTOINCREMENT,
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER
)

INSERT INTO orderitems (orderitem_id, order_id, product_id, quantity) VALUES
 (1, 1, 2, 3),
 (2, 2, 1, 1),
 (3, 3, 2, 1),
 (4, 4, 2, 4),
 (5, 5, 3, 1),
 (6, 6, 3, 2);

ALTER TABLE orders
DROP COLUMN product_id;