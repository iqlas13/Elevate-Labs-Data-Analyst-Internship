-- Task 3: SQL Basics using Retail Sales Dataset

USE task3_sql;

SELECT * FROM retail_sales_dataset LIMIT 10;

SELECT COUNT(*) FROM retail_sales_dataset;

SELECT *
FROM retail_sales_dataset
WHERE `Product Category` = 'Electronics';

SELECT *
FROM retail_sales_dataset
WHERE Gender = 'Female';

SELECT *
FROM retail_sales_dataset
ORDER BY `Total Amount` DESC;

SELECT *
FROM retail_sales_dataset
ORDER BY Date ASC;

SELECT SUM(`Total Amount`) AS total_sales
FROM retail_sales_dataset;

SELECT AVG(`Total Amount`) AS avg_sales
FROM retail_sales_dataset;

SELECT COUNT(*) AS total_transactions
FROM retail_sales_dataset;

SELECT `Product Category`,
       SUM(`Total Amount`) AS total_sales
FROM retail_sales_dataset
GROUP BY `Product Category`;

SELECT `Product Category`,
       AVG(`Total Amount`) AS avg_sales
FROM retail_sales_dataset
GROUP BY `Product Category`;

SELECT `Product Category`,
       COUNT(*) AS transaction_count
FROM retail_sales_dataset
GROUP BY `Product Category`;

SELECT `Product Category`,
       SUM(`Total Amount`) AS total_sales
FROM retail_sales_dataset
GROUP BY `Product Category`
HAVING SUM(`Total Amount`) > 1000;

SELECT *
FROM retail_sales_dataset
WHERE Date BETWEEN '2023-01-01' AND '2023-06-30';

SELECT *
FROM retail_sales_dataset
WHERE `Customer ID` LIKE '%CUST0%';
