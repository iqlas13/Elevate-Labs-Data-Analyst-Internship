
# Retail Sales ETL Pipeline

## Project Overview
This project implements an ETL (Extract, Transform, Load) pipeline using a retail sales dataset.

The pipeline:
- Extracts data from a CSV file
- Cleans and transforms the data
- Creates derived features
- Splits data into analytical tables
- Loads data into SQLite and CSV files

## Steps
1. Load raw dataset
2. Clean missing values and duplicates
3. Standardize columns and datatypes
4. Create derived columns (calculated_total, high_value_order, order_year, order_month, age_group)
5. Split into customers, orders, products tables
6. Export to CSV and load into SQLite
7. Validate row counts before and after transformation

## Validation Results
- Raw dataset rows: 1000
- Rows after cleaning: 1000
- Orders table rows: 1000
- Customers table rows: 1000 (unique customers)
- Products table rows: 3 (Beauty, Clothing, Electronics)
- No data loss during transformation
- Row counts match expectations

## Outputs
- task14_etl.ipynb
- output/customers.csv
- output/orders.csv
- output/products.csv
- database.sqlite
