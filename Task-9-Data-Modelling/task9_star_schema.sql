CREATE DATABASE task9_star_schema;
USE task9_star_schema;
CREATE DATABASE task9_star_schema;
USE task9_star_schema;
SHOW TABLES;
USE task9_star_schema;
SELECT COUNT(*) FROM raw_sales;
SELECT * FROM raw_sales LIMIT 5;
DESCRIBE raw_sales;
DROP TABLE IF EXISTS staging_sales;
CREATE TABLE staging_sales AS
SELECT
  `Order ID`        AS order_id,
  STR_TO_DATE(`Order Date`, '%d-%m-%Y') AS order_date,
  `Customer ID`     AS customer_id,
  `Customer Name`   AS customer_name,
  Segment           AS segment,
  `Product ID`      AS product_id,
  `Product Name`    AS product_name,
  Category          AS category,
  `Sub-Category`    AS sub_category,
  Country           AS country,
  Region            AS region,
  State             AS state,
  Sales             AS sales
FROM raw_sales;
SELECT COUNT(*) FROM staging_sales;
SELECT * FROM staging_sales LIMIT 5;
CREATE TABLE dim_customer (
  customer_key INT AUTO_INCREMENT PRIMARY KEY,
  customer_id VARCHAR(50),
  customer_name VARCHAR(100),
  segment VARCHAR(50)
);
CREATE TABLE dim_product (
  product_key INT AUTO_INCREMENT PRIMARY KEY,
  product_id VARCHAR(50),
  product_name VARCHAR(150),
  category VARCHAR(50),
  sub_category VARCHAR(50)
);
CREATE TABLE dim_region (
  region_key INT AUTO_INCREMENT PRIMARY KEY,
  country VARCHAR(50),
  region VARCHAR(50),
  state VARCHAR(50)
);
CREATE TABLE dim_date (
  date_key INT AUTO_INCREMENT PRIMARY KEY,
  order_date DATE,
  year INT,
  month INT,
  month_name VARCHAR(20),
  quarter VARCHAR(2)
);
INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM staging_sales;
INSERT INTO dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, sub_category
FROM staging_sales;
INSERT INTO dim_region (country, region, state)
SELECT DISTINCT country, region, state
FROM staging_sales;
INSERT INTO dim_date (order_date, year, month, month_name, quarter)
SELECT DISTINCT
  order_date,
  YEAR(order_date),
  MONTH(order_date),
  MONTHNAME(order_date),
  CONCAT('Q', QUARTER(order_date))
FROM staging_sales;
SELECT COUNT(*) FROM staging_sales;
CREATE TABLE fact_sales (
  sales_key INT AUTO_INCREMENT PRIMARY KEY,
  customer_key INT,
  product_key INT,
  region_key INT,
  date_key INT,
  sales DECIMAL(10,2),

  FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
  FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
  FOREIGN KEY (region_key) REFERENCES dim_region(region_key),
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
INSERT INTO fact_sales (
  customer_key,
  product_key,
  region_key,
  date_key,
  sales
)
SELECT
  dc.customer_key,
  dp.product_key,
  dr.region_key,
  dd.date_key,
  s.sales
FROM staging_sales s
JOIN dim_customer dc 
  ON s.customer_id = dc.customer_id
JOIN dim_product dp 
  ON s.product_id = dp.product_id
JOIN dim_region dr
  ON s.country = dr.country
 AND s.region = dr.region
 AND s.state = dr.state
JOIN dim_date dd 
  ON s.order_date = dd.order_date;
  SELECT COUNT(*) FROM fact_sales;
SELECT * FROM fact_sales LIMIT 5;
CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product  ON fact_sales(product_key);
CREATE INDEX idx_fact_region   ON fact_sales(region_key);
CREATE INDEX idx_fact_date     ON fact_sales(date_key);
SELECT p.category, SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_product p 
  ON f.product_key = p.product_key
GROUP BY p.category;
SELECT r.region, SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_region r 
  ON f.region_key = r.region_key
GROUP BY r.region;
SELECT d.year, d.month_name, SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_date d 
  ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
CREATE TABLE analysis_outputs (
  analysis_type VARCHAR(50),
  dimension_value VARCHAR(100),
  total_sales DECIMAL(12,2)
);
INSERT INTO analysis_outputs (analysis_type, dimension_value, total_sales)
SELECT 
  'Sales by Category' AS analysis_type,
  p.category AS dimension_value,
  SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_product p 
  ON f.product_key = p.product_key
GROUP BY p.category;
INSERT INTO analysis_outputs (analysis_type, dimension_value, total_sales)
SELECT 
  'Sales by Region' AS analysis_type,
  r.region AS dimension_value,
  SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_region r 
  ON f.region_key = r.region_key
GROUP BY r.region;
INSERT INTO analysis_outputs (analysis_type, dimension_value, total_sales)
SELECT
  'Monthly Sales' AS analysis_type,
  CONCAT(d.year, '-', d.month_name) AS dimension_value,
  SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_date d 
  ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
SELECT * FROM analysis_outputs;
