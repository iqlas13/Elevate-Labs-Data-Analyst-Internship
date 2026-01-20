SHOW DATABASES;
CREATE DATABASE task4_sql;
USE task4_sql;
SELECT DATABASE();
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    region VARCHAR(50)
);
DESCRIBE customers;
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);
DESCRIBE categories;
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
DESCRIBE products;
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
DESCRIBE orders;
INSERT INTO customers (customer_name, email, region) VALUES
('Aisha Khan', 'aisha@gmail.com', 'South'),
('Rahul Verma', 'rahul@gmail.com', 'North'),
('Neha Sharma', 'neha@gmail.com', 'East'),
('Arjun Patel', 'arjun@gmail.com', 'West');
SELECT * FROM customers;
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');
SELECT * FROM categories;
INSERT INTO products (product_name, price, category_id) VALUES
('Laptop', 55000.00, 1),
('Mobile Phone', 20000.00, 1),
('T-Shirt', 800.00, 2),
('Jeans', 1500.00, 2),
('Python Book', 600.00, 3);
SELECT * FROM products;
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
(1, 1, '2024-01-10', 1),   -- Aisha bought Laptop
(1, 2, '2024-01-15', 2),   -- Aisha bought Mobile Phone
(2, 3, '2024-02-05', 3),   -- Rahul bought T-Shirts
(3, 5, '2024-02-20', 1);   -- Neha bought Python Book
SELECT * FROM orders;
SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    o.order_id,
    o.order_date,
    o.quantity
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
SELECT 
    c.customer_id,
    c.customer_name,
    c.region
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT 
    p.product_name,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
SELECT 
    c.category_name,
    SUM(o.quantity * p.price) AS category_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
INNER JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;
SELECT
    c.customer_name,
    c.region,
    o.order_date,
    o.quantity,
    p.product_name
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN products p
ON o.product_id = p.product_id
WHERE c.region = 'South'
AND o.order_date >= '2024-01-01';
SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    o.order_id,
    o.order_date,
    o.quantity
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
