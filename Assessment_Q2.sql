/**
 * Question 2: Transaction Frequency Analysis
 * 
 * This query analyzes customer transaction frequency by:
 * - Calculating average monthly transactions per customer
 * - Categorizing customers as:
 *   - "High Frequency" (≥10 transactions/month)
 *   - "Medium Frequency" (3-9 transactions/month)
 *   - "Low Frequency" (≤2 transactions/month)
 * - Counting customers in each category
 * - Calculating average transaction frequency for each category
 */

WITH customer_monthly_transactions AS (
    SELECT 
        uc.id AS customer_id,
        EXTRACT(YEAR FROM s.transaction_date) AS year,
        EXTRACT(MONTH FROM s.transaction_date) AS month,
        COUNT(*) AS transaction_count
    FROM 
        users_customuser uc
    JOIN 
        savings_savingsaccount s ON s.owner_id = uc.id
    WHERE 
        s.transaction_status = 'success' -- Only count successful transactions
        AND s.confirmed_amount > 0 -- Ensure we're counting actual deposits
    GROUP BY 
        uc.id, EXTRACT(YEAR FROM s.transaction_date), EXTRACT(MONTH FROM s.transaction_date)
),
customer_avg_transactions AS (
    SELECT 
        customer_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
        customer_monthly_transactions
    GROUP BY 
        customer_id
),
customer_categories AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        customer_id,
        avg_transactions_per_month
    FROM 
        customer_avg_transactions
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_categories
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;