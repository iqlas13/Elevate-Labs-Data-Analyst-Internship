CREATE DATABASE ecommerce_task8;
USE ecommerce_task8;
SHOW DATABASES;
SELECT * FROM international_sales LIMIT 10;
SELECT
    `CUSTOMER`,
    SUM(`GROSS AMT`) AS total_sales
FROM international_sales
GROUP BY `CUSTOMER`;
SELECT
    `CUSTOMER`,
    SUM(`GROSS AMT`) AS total_sales,
    ROW_NUMBER() OVER (
        ORDER BY SUM(`GROSS AMT`) DESC
    ) AS customer_rank
FROM international_sales
GROUP BY `CUSTOMER`;
SELECT
    `CUSTOMER`,
    SUM(`GROSS AMT`) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(`GROSS AMT`) DESC
    ) AS rank_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(`GROSS AMT`) DESC
    ) AS dense_rank_sales
FROM international_sales
GROUP BY `CUSTOMER`;
SELECT
    `DATE`,
    SUM(`GROSS AMT`) AS daily_sales,
    SUM(SUM(`GROSS AMT`)) OVER (
        ORDER BY `DATE`
    ) AS running_total_sales
FROM international_sales
GROUP BY `DATE`
ORDER BY `DATE`;
WITH monthly_sales AS (
    SELECT
        `Months` AS month,
        SUM(`GROSS AMT`) AS total_sales
    FROM international_sales
    GROUP BY `Months`
)
SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / LAG(total_sales) OVER (ORDER BY month) * 100,
        2
    ) AS mom_growth_percentage
FROM monthly_sales;
WITH product_sales AS (
    SELECT
        `Style`,
        SUM(`GROSS AMT`) AS total_sales
    FROM international_sales
    GROUP BY `Style`
),
ranked_products AS (
    SELECT
        `Style`,
        total_sales,
        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS product_rank
    FROM product_sales
)
SELECT *
FROM ranked_products
WHERE product_rank <= 3;

