/* ============================================================
   RETAIL CUSTOMER BEHAVIOR ANALYSIS
   End-to-End SQL Business Intelligence Script
   Database: retail_project
   Author: Rishav Sharma
   ============================================================ */

/* ============================================================
   1. DATABASE VALIDATION
   ============================================================ */
USE retail_project;
SHOW TABLES;
DESCRIBE retail_transactions;

/* ============================================================
   2. EXECUTIVE KPI METRICS
   ============================================================ */
-- 2.1 Total Revenue
SELECT ROUND(SUM(total_amount),2) AS Total_Revenue
FROM retail_transactions;

-- 2.2 Total Orders
SELECT COUNT(DISTINCT transaction_id) AS Total_Orders
FROM retail_transactions;

-- 2.3 Unique Customers
SELECT COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_transactions;

-- 2.4 Average Order Value(AOV)
SELECT 
    ROUND(SUM(total_amount) / COUNT(DISTINCT transaction_id), 2) AS AOV
FROM retail_transactions;

/* ============================================================
   3. CATEGORY & CHANNEL PERFORMANCE ANALYSIS
   ============================================================ */
-- 3.1 Revenue by Category
SELECT 
    category,
    ROUND(SUM(total_amount),2) AS Revenue
FROM retail_transactions
GROUP BY category
ORDER BY Revenue DESC;

-- 3.2 Revenue by Channel
SELECT 
    channel,
    ROUND(SUM(total_amount),2) AS Revenue
FROM retail_transactions
GROUP BY channel;

-- 3.3 Revenue by City
SELECT 
    city,
    ROUND(SUM(total_amount),2) AS Revenue
FROM retail_transactions
GROUP BY city
ORDER BY Revenue DESC;

/* ============================================================
   4. TIME-SERIES ANALYSIS
   ============================================================ */
-- 4.1 Monthly Revenue Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS Month,
    ROUND(SUM(total_amount),2) AS Monthly_Revenue
FROM retail_transactions
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY DATE_FORMAT(order_date, '%Y-%m');

/* ============================================================
   5. Customer Ranking by Total Spend
   ============================================================ */
SELECT 
    customer_id,
    ROUND(SUM(total_amount),2) AS Total_Spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS Customer_Rank
FROM retail_transactions
GROUP BY customer_id;

/* ============================================================
   6. MULTI-DIMENSIONAL ANALYSIS
   ============================================================ */
   -- Channel × Category Performance
SELECT 
    channel,
    category,
    ROUND(SUM(total_amount),2) AS Revenue
FROM retail_transactions
GROUP BY channel, category
ORDER BY Revenue DESC;

/* ============================================================
   7. Top 10 Customers Contribution
   ============================================================ */
SELECT 
    SUM(total_spent) AS Top10_Revenue
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM retail_transactions
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 10
) AS top_customers;


/* ============================================================
   END OF SCRIPT
   ============================================================ */
