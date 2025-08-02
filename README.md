🧠 7-Day SQL Challenge – Retail Store Sales Analysis
This repository contains 50 SQL queries written by Revaz Mikadze over a 7-day challenge to analyze a retail store sales dataset sourced from Kaggle.com. The queries, tested in pgAdmin 4 with PostgreSQL 15+, extract meaningful business insights from the retail_store_sales table, covering filtering, aggregations, window functions, and trend analysis. The project is ideal for beginner and intermediate SQL learners looking to master practical data analysis.
📁 Dataset
The dataset, sourced from Kaggle.com, represents retail transactions. It’s stored in the retail_store_sales table with the following schema:
CREATE TABLE retail_store_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    category VARCHAR(50),
    item VARCHAR(100),
    price_per_unit NUMERIC(10,2),
    quantity INTEGER,
    total_spent NUMERIC(12,2),
    payment_method VARCHAR(50),
    location VARCHAR(50),
    transaction_date DATE NOT NULL,
    discount_applied BOOLEAN
);

Column Descriptions

Transaction ID: Unique identifier for each transaction.
Customer ID: Unique identifier for each customer.
Category: Product category (e.g., Bakery, Beverages).
Item: Specific product purchased.
Price Per Unit: Cost of one unit of the product (NUMERIC).
Quantity: Number of units purchased (INTEGER).
Total Spent: Total price paid for the transaction (NUMERIC).
Payment Method: Mode of payment (e.g., Credit Card, Cash).
Location: Purchase channel (e.g., In-store, Online).
Transaction Date: Date of the transaction (DATE).
Discount Applied: Whether a discount was applied (BOOLEAN).

Data Setup
The table is initially created with VARCHAR columns for price_per_unit, quantity, total_spent, and discount_applied. These are converted to appropriate types using:
ALTER TABLE retail_store_sales
    ALTER COLUMN price_per_unit TYPE NUMERIC(10,2) USING NULLIF(price_per_unit, '')::NUMERIC,
    ALTER COLUMN quantity TYPE INTEGER USING ROUND(NULLIF(quantity, '')::NUMERIC),
    ALTER COLUMN total_spent TYPE NUMERIC(12,2) USING NULLIF(total_spent, '')::NUMERIC,
    ALTER COLUMN discount_applied TYPE BOOLEAN USING
        CASE
            WHEN LOWER(discount_applied) = 'true' THEN TRUE
            WHEN LOWER(discount_applied) = 'false' THEN FALSE
            ELSE NULL
        END;

🧩 Project Structure
The 50 queries are organized into seven .sql files, each representing one day of the challenge:

queries_day_1.sql: Queries 1–10 (Basic filtering, sorting, grouping)
queries_day_2.sql: Queries 11–20 (Aggregations, time-based analysis)
queries_day_3.sql: Queries 21–30 (Subqueries, window functions)
queries_day_4.sql: Queries 31–35 (Ranking, percentage calculations)
queries_day_5.sql: Queries 36–40 (Median, rolling averages)
queries_day_6.sql: Queries 41–45 (Advanced joins, category analysis)
queries_day_7.sql: Queries 46–50 (Customer trends, rankings)

Each query addresses a specific analytical task, such as counting transactions, ranking customers, or calculating month-to-month spending changes.
✅ Tools Used

PostgreSQL (version 15+)
pgAdmin 4 for query execution and result inspection

📊 What You’ll Learn

Filtering and Sorting: Using WHERE, ORDER BY, and LIKE.
Aggregations: GROUP BY, HAVING, SUM, AVG, COUNT.
Time-Based Analysis: EXTRACT, TO_CHAR, date manipulations.
Window Functions: RANK, ROW_NUMBER, LAG, LEAD.
Subqueries: Correlated and non-correlated subqueries.
Advanced Analytics: Median calculations, rolling averages, percentage contributions.
Clean Code: Writing readable, maintainable SQL queries.

🏁 Status

✔️ All 50 queries completed
📅 Challenge completed over 7 days (August 2025)
🧠 Ideal for beginner/intermediate SQL learners

📌 How to Use

Clone the Repository:git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git


Download the Dataset:
Obtain the dataset from Kaggle.com.
Import it into PostgreSQL (e.g., via COPY or a CSV loader).


Set Up the Database:
Create the retail_store_sales table using the CREATE TABLE statement above.
Run the ALTER TABLE statement to convert column types.
Load the dataset into the table.


Run Queries:
Open pgAdmin 4 or another PostgreSQL client.
Execute the .sql files sequentially (queries_day_1.sql to queries_day_7.sql).
Review results and modify queries for your specific dataset or analysis needs.



Sample Data
For testing, you can insert sample data like:
INSERT INTO retail_store_sales VALUES
('T001', 'C001', 'Electronics', 'Laptop', '999.99', '1', '999.99', 'Credit Card', 'In-store', '2025-01-15', 'TRUE'),
('T002', 'C002', 'Clothing', 'Shirt', '29.99', '2', '59.98', 'Cash', 'Online', '2025-01-20', 'FALSE');



📝 Notes

Dataset Source: The dataset is from Kaggle.com. Replace YOUR_KAGGLE_DATASET_LINK with the specific dataset URL or name.
Database Compatibility:
Queries are written for PostgreSQL. For MySQL, replace EXTRACT with YEAR/MONTH; for SQL Server, use DATEPART. Replace LIMIT with TOP (SQL Server) or ROWNUM (Oracle pre-12c).
Window functions require MySQL 8.0+. PERCENTILE_CONT (Query 36) is PostgreSQL-specific; use alternatives for MySQL.


Performance: For large datasets, index customer_id, transaction_date, and category for faster queries.
Author: All queries were written by Revaz Mikadze.
