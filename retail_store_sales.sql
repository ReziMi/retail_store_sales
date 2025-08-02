DROP TABLE IF EXISTS retail_store_sales;

CREATE TABLE retail_store_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    category VARCHAR(50),
    item VARCHAR(100),
    price_per_unit VARCHAR(20),
    quantity VARCHAR(10),
    total_spent VARCHAR(20), 
    payment_method VARCHAR(50),
    location VARCHAR(50),
    transaction_date DATE NOT NULL,
    discount_applied VARCHAR(10)
);


SELECT COUNT(*) FROM retail_store_sales;

ALTER TABLE retail_store_sales
    ALTER COLUMN price_per_unit TYPE NUMERIC(10,2) USING NULLIF(price_per_unit, '')::NUMERIC,
    ALTER COLUMN quantity TYPE INTEGER USING 
        ROUND(NULLIF(quantity, '')::NUMERIC),
    ALTER COLUMN total_spent TYPE NUMERIC(12,2) USING NULLIF(total_spent, '')::NUMERIC,
    ALTER COLUMN discount_applied TYPE BOOLEAN USING
      CASE
        WHEN LOWER(discount_applied) = 'true' THEN TRUE
        WHEN LOWER(discount_applied) = 'false' THEN FALSE
        ELSE NULL
      END;

SELECT * FROM retail_store_sales LIMIT 10;

-- 1. Retrieve all rows where the quantity is greater than 10.
SELECT *
FROM retail_store_sales
WHERE quantity>10;

-- 2. Show the top 5 most expensive items by price_per_unit.
SELECT *,
       COALESCE(price_per_unit, 0) AS fixed_price
FROM retail_store_sales
ORDER BY fixed_price DESC
LIMIT 5;


-- 3. Count how many transactions used each payment method.
SELECT
	payment_method,
	count(transaction_id)
FROM retail_store_sales
GROUP BY payment_method;

-- 4. List all unique product categories sold.
SELECT
	DISTINCT category
FROM retail_store_sales;

-- 5. Show total revenue (SUM(total_spent)) from the entire dataset.
SELECT
	SUM(total_spent) as total_revenue
FROM retail_store_sales;

-- 6. Retrieve all transactions that occurred in a location that starts with the letter “L”.
SELECT
	*
FROM retail_store_sales
WHERE location ILIKE 'L%';


-- 7. Find the number of transactions that had a discount applied.
SELECT
	count(*) as transactions_discounted
FROM retail_store_sales
WHERE discount_applied=true;

-- 8. Show only the locations with more than 6300 sales.
SELECT
	location,
	COUNT(*) as total_sales
FROM retail_store_sales
GROUP BY location
HAVING COUNT(*)>6300;


-- 9. Show the top 5 product categories by total sales amount.
SELECT category,
	SUM(total_spent) AS total_sales_per_category
FROM retail_store_sales
GROUP BY category
ORDER BY total_sales_per_category DESC
limit 5;


-- 10. Show average total_sale by location.
SELECT
	location,
	AVG(total_spent) as average_spent_by_location
FROM retail_store_sales
GROUP BY location;

-- 11. Find which product category sold the highest total quantity.
SELECT category,
	SUM(quantity) AS total_quantity_by_category
FROM retail_store_sales
GROUP BY category
ORDER BY total_quantity_by_category DESC
LIMIT 1;

-- 12. Show only the rows where price_per_unit is missing (null).
SELECT*
FROM retail_store_sales
WHERE price_per_unit IS NULL;

-- 13. Find the average total_sale for transactions made in-store.
SELECT
	AVG(total_spent) as in_store_sales
FROM retail_store_sales
WHERE location='In-store';

-- 14. Count how many sales happened in each unique location.
SELECT 
	location,
	COUNT(transaction_id)
FROM retail_store_sales
GROUP BY location;

-- 15. Extract the year and month from the transaction_date and show total revenue per month.
SELECT
	year,
	month,
	SUM(total_spent) AS total_revenue_per_month
FROM
	(
		SELECT 
			total_spent,
			EXTRACT(YEAR FROM transaction_date) AS year,
			EXTRACT(MONTH FROM transaction_date) AS month
		FROM retail_store_sales
	) sub
GROUP BY year, month
ORDER BY year, month;


-- 16. Find the day of the week (Monday, Tuesday, etc.) for each transaction and count how many transactions happen on each weekday.
SELECT 
	day_of_week,	
	COUNT(transaction_id)
FROM
	(
		SELECT
			transaction_id,
			TO_CHAR(transaction_date, 'FMDay') AS day_of_week
		FROM retail_store_sales
	)
GROUP BY day_of_week
ORDER BY day_of_week;


-- 17. List all transactions where the item name contains the word “MILK”.
SELECT *
FROM retail_store_sales
WHERE item ILIKE '%MILK%';

-- 18. Show all transactions where the payment_method starts with “Credit”.
SELECT *
FROM retail_store_sales
WHERE payment_method ILIKE 'CREDIT%';

-- 19. Find the average price per unit for items that end with “bev”.
SELECT
	item,
	AVG(price_per_unit) as average_price
FROM retail_store_sales
WHERE item ILIKE '%BEV'
GROUP By item;

-- 20. Extract the hour from transaction_date (assume transaction times exist or simulate if needed) and find peak transaction hours.
SELECT 
    EXTRACT(HOUR FROM simulated_timestamp) AS transaction_hour,
    COUNT(*) AS transaction_count
FROM (
    SELECT 
        transaction_date + 
        (floor(random() * 24)::integer || ' hours')::interval AS simulated_timestamp
    FROM retail_store_sales
) subquery
GROUP BY EXTRACT(HOUR FROM simulated_timestamp)
ORDER BY transaction_count DESC;

-- 21. Replace all NULL item values with “Unknown Item” in your query output.
SELECT
	transaction_id,
	customer_id,
	category,
	COALESCE(item, 'Unknown Item') AS item,
	price_per_unit,
	quantity,
	total_spent,
	payment_method,
	location,
	transaction_date,
	discount_applied
FROM retail_store_sales;

-- 22. Find customers who made transactions with a total_spent greater than the average total_spent across all transactions.
WITH customer_totals AS (
    SELECT customer_id, SUM(total_spent) AS total_spent
    FROM retail_store_sales
    GROUP BY customer_id
),
average_spent AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM customer_totals
)
SELECT customer_id, total_spent,
FROM customer_totals, average_spent
WHERE total_spent > avg_spent;


-- 23. List all transactions where the quantity is greater than the average quantity for that product category.
WITH category_avg AS (
    SELECT category, AVG(quantity) AS avg_quantity
    FROM retail_store_sales
    GROUP BY category
)
SELECT r.*
FROM retail_store_sales r
JOIN category_avg a ON r.category = a.category
WHERE r.quantity > a.avg_quantity;



-- 24. Show categories where total revenue exceeds 190,000.
SELECT
	category,
	SUM(total_spent) AS total_spent_by_category
FROM retail_store_sales
GROUP BY category
HAVING SUM(total_spent)>190000;

-- 25. Find transactions where total_spent is higher than the average total_spent for the same payment_method.
WITH average_spent AS (
    SELECT payment_method, AVG(total_spent) AS avg_spent
    FROM retail_store_sales
    GROUP BY payment_method
)
SELECT r.*
FROM retail_store_sales r
JOIN average_spent a ON r.payment_method = a.payment_method
WHERE r.total_spent > a.avg_spent;


-- 26. Retrieve transactions where the customer has made more than 500 purchases overall.
SELECT
	customer_id,
	COUNT(customer_id) AS purchases_per_customer
FROM retail_store_sales
GROUP BY customer_id
HAVING COUNT(customer_id)>500;

-- 27. List customers who have never used “Cash” as a payment method.
SELECT DISTINCT customer_id
FROM retail_store_sales
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM retail_store_sales
    WHERE payment_method = 'Cash'
);


-- 28. Show the highest total_spent transaction per customer.
SELECT DISTINCT ON (customer_id) *
FROM retail_store_sales
ORDER BY customer_id, total_spent DESC;

-- 29. Calculate the running total of sales (total_spent) ordered by transaction_date.
SELECT 
  transaction_date,
  SUM(total_spent) OVER (ORDER BY transaction_date) AS running_total
FROM retail_store_sales;


-- 30. For each category, find the average quantity sold per transaction.
SELECT
	category,
	AVG(quantity) AS average_quanity_per_category
FROM retail_store_sales
GROUP BY category
ORDER BY average_quanity_per_category;

-- 31. Find the rank of each transaction by total_spent within its category.
SELECT 
    transaction_id,
    total_spent,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_spent DESC
    ) AS rank
FROM retail_store_sales
WHERE total_spent IS NOT NULL;

-- 32. Show the percentage contribution of each transaction’s total_spent to the total sales.
SELECT 
    transaction_id,
    total_spent,
    (total_spent * 100.0 / SUM(total_spent) OVER ()) AS percentage_contribution
FROM retail_store_sales
WHERE total_spent IS NOT NULL;

-- 33. Find the first and last transaction date for each customer.
-- SOLUTION 1
SELECT 
    customer_id,
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date
FROM retail_store_sales
WHERE transaction_date IS NOT NULL
GROUP BY customer_id;

-- SOLUTION 2
WITH RankedTransactions AS (
    SELECT 
        customer_id,
        transaction_date,
        transaction_id,
        total_spent,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date ASC
        ) AS first_rank,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date DESC
        ) AS last_rank
    FROM retail_store_sales
    WHERE transaction_date IS NOT NULL
)
SELECT 
    customer_id,
    MAX(CASE WHEN first_rank = 1 THEN transaction_date END) AS first_transaction_date,
    MAX(CASE WHEN last_rank = 1 THEN transaction_date END) AS last_transaction_date
FROM RankedTransactions
GROUP BY customer_id;

-- 34. Calculate the difference in days between each transaction and the previous transaction for the same customer.
SELECT 
    customer_id,
    transaction_id,
    transaction_date,
    transaction_date - LAG(transaction_date) OVER (
        PARTITION BY customer_id
        ORDER BY transaction_date
    ) AS days_since_previous_transaction
FROM retail_store_sales
WHERE transaction_date IS NOT NULL
ORDER BY customer_id, transaction_date;

-- 35. Find categories where more than 20% of transactions had a discount applied.
SELECT 
    category,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN discount_applied = TRUE THEN 1 END) AS discounted_transactions,
    ROUND(COUNT(CASE WHEN discount_applied = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) AS discount_percentage
FROM retail_store_sales
WHERE category IS NOT NULL
GROUP BY category
HAVING (COUNT(CASE WHEN discount_applied = TRUE THEN 1 END) * 100.0 / COUNT(*)) > 20;

-- 36. Show the median total_spent per category.
SELECT 
    category,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spent)::NUMERIC, 2) AS median_total_spent
FROM retail_store_sales
WHERE total_spent IS NOT NULL
    AND category IS NOT NULL
GROUP BY category;


-- 37. For each customer, calculate the total number of transactions they made.
SELECT customer_id,
	count(transaction_id)
FROM retail_store_sales
GROUP BY customer_id;

-- 38. List all transactions that are above the average total_spent across all transactions.
WITH transactions_made AS(
	SELECT transaction_id, total_spent
    FROM retail_store_sales
),
avg_total_spent AS (
	SELECT AVG(total_spent) AS avg_spent
	FROM retail_store_sales
)
SELECT transaction_id, total_spent
FROM transactions_made, avg_total_spent
WHERE total_spent > avg_spent;

-- 39. For each category, find the product with the highest average total_spent per transaction.
WITH ProductAverages AS(
	SELECT 
	    category,
	    item,
	    AVG(total_spent) AS avg_total_spent,
		RANK() OVER (
	        PARTITION BY category
	        ORDER BY AVG(total_spent) DESC
	    ) AS rank_in_category
	FROM retail_store_sales
	WHERE total_spent IS NOT NULL
	    AND category IS NOT NULL
	    AND item IS NOT NULL
	GROUP BY category, item
)
SELECT 
    category,
    item,
    avg_total_spent
FROM ProductAverages
WHERE rank_in_category = 1;


-- 40. Calculate a rolling 3-day average of total_spent for each customer ordered by transaction_date.
SELECT customer_id,
       transaction_date,
       total_spent,
       ROUND(AVG(total_spent) OVER (
           PARTITION BY customer_id
           ORDER BY transaction_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS rolling_3_day_avg
FROM retail_store_sales;


-- 41. Show the top 3 products by total quantity sold within each category.
WITH ranked_products AS (
    SELECT 
        category,
        item,
        SUM(quantity) AS total_quantity,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(quantity) DESC
        ) AS rank_in_category
    FROM retail_store_sales
    GROUP BY category, item
)
SELECT category, item, total_quantity
FROM ranked_products
WHERE rank_in_category <= 3;


-- 42. Find the customers whose first transaction had a discount applied.
WITH ranked_discount AS(
	SELECT customer_id,
		transaction_date,
		discount_applied,
		RANK() OVER(PARTITION BY customer_id
		ORDER BY transaction_date) AS transaction_rank
	FROM retail_store_sales
	WHERE discount_applied=true
	ORDER BY customer_id, transaction_rank
)
SELECT customer_id,
		transaction_date,
		discount_applied
FROM ranked_discount
WHERE transaction_rank=1;


-- 43. Calculate the cumulative quantity sold per product ordered by transaction_date.
SELECT 
	item,
	transaction_date,
	SUM(quantity) OVER(
		PARTITION BY item
		ORDER BY transaction_date
	)
FROM retail_store_sales
ORDER BY item, transaction_date;

-- 44. Show the category-wise change in average total_spent compared to the previous month.
SELECT
  category,
  TO_CHAR(transaction_date, 'YYYY-MM') AS month,
  ROUND(AVG(total_spent), 2) AS avg_spent,
  ROUND(
    AVG(total_spent) - LAG(AVG(total_spent)) OVER (
      PARTITION BY category ORDER BY TO_CHAR(transaction_date, 'YYYY-MM')
    ),
    2
  ) AS change_from_last_month
FROM retail_store_sales
GROUP BY category, TO_CHAR(transaction_date, 'YYYY-MM')
ORDER BY category, month;

-- 45. For each category, find the total and average total_spent.
WITH total_category_spent AS(SELECT category,
	SUM(total_spent) AS total_spent_by_category,
	AVG(total_spent) AS average_spent_by_category
FROM retail_store_sales
GROUP BY category)
SELECT category, total_spent_by_category, average_spent_by_category
FROM total_category_spent;

-- 46. For each customer, show the number of months in which they had at least one transaction.
WITH transactions_by_month AS(
SELECT 
    customer_id,
    EXTRACT(MONTH FROM transaction_date) as transaction_month,
    COUNT(*) as transaction_count
FROM retail_store_sales
GROUP BY customer_id, EXTRACT(MONTH FROM transaction_date)
)
SELECT 
	customer_id,
	COUNT(transaction_month) AS number_of_active_months
FROM transactions_by_month
GROUP BY customer_id;

-- 47. List the top 3 customers (by total spending) for each month.
WITH sales_ranking AS (
    SELECT 
        customer_id,
        EXTRACT(YEAR FROM transaction_date) AS transaction_year,
        EXTRACT(MONTH FROM transaction_date) AS transaction_month,
        SUM(total_spent) AS total_spent_per_month,
        ROW_NUMBER() OVER (
            PARTITION BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
            ORDER BY SUM(total_spent) DESC, customer_id ASC
        ) AS rank_number
    FROM retail_store_sales
    WHERE total_spent IS NOT NULL
    GROUP BY customer_id, EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    customer_id,
    transaction_year,
    transaction_month,
    total_spent_per_month,
    rank_number
FROM sales_ranking
WHERE rank_number <= 3;

-- 48. Find the customer who had the highest average spending per transaction over the whole period.
SELECT 
    customer_id,
    AVG(total_spent) AS average_spending
FROM retail_store_sales
WHERE total_spent IS NOT NULL
GROUP BY customer_id
ORDER BY average_spending DESC
LIMIT 1;

-- 49. For each customer, show the percentage change in their spending from one month to the next.
WITH monthly_sales AS (
    SELECT 
        customer_id,
        EXTRACT(YEAR FROM transaction_date) AS transaction_year,
        EXTRACT(MONTH FROM transaction_date) AS transaction_month,
        SUM(total_spent) AS total_spent_per_month
    FROM retail_store_sales
    WHERE total_spent IS NOT NULL
    GROUP BY customer_id, EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    customer_id,
    transaction_year,
    transaction_month,
    total_spent_per_month,
    LAG(total_spent_per_month) OVER (
        PARTITION BY customer_id 
        ORDER BY transaction_year, transaction_month
    ) AS previous_month_spending,
    ROUND(
        ((total_spent_per_month - LAG(total_spent_per_month) OVER (
            PARTITION BY customer_id 
            ORDER BY transaction_year, transaction_month
        )) / NULLIF(LAG(total_spent_per_month) OVER (
            PARTITION BY customer_id 
            ORDER BY transaction_year, transaction_month
        ), 0)) * 100, 2
    ) AS percentage_change
FROM monthly_sales
ORDER BY customer_id, transaction_year, transaction_month;

-- 50. For each customer, show the difference between their highest and lowest total_spent across all their transactions.
SELECT 
    customer_id,
    MAX(total_spent) - MIN(total_spent) AS max_difference
FROM retail_store_sales
WHERE total_spent IS NOT NULL
GROUP BY customer_id;
