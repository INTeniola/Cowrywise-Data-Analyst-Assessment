/**
 * Question 4: Customer Lifetime Value (CLV) Estimation
 * 
 * This query calculates an estimated CLV for each customer based on:
 * - Tenure (months since signup)
 * - Total transaction count
 * - Transaction value (with profit_per_transaction as 0.1% of transaction value)
 * 
 * The CLV formula used:
 * CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
 * 
 * Results are ordered by estimated CLV from highest to lowest.
 */

WITH customer_transaction_metrics AS (
    SELECT 
        uc.id AS customer_id,
        uc.name,
        PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(uc.date_joined, '%Y%m')) AS tenure_months, -- calculates the month difference between the current date and the date_joined
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_amount
    FROM 
        users_customuser uc
    JOIN 
        savings_savingsaccount s ON s.owner_id = uc.id
    WHERE 
        s.transaction_status = 'success'
        AND s.confirmed_amount > 0 -- Only include actual deposits
    GROUP BY 
        uc.id, uc.name, uc.date_joined
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        (total_transactions / tenure_months) * 12 * 
        (total_amount * 0.001 / 100.0), -- 0.1% profit per transaction and converts from kobo to naira
        2
    ) AS estimated_clv
FROM 
    customer_transaction_metrics
WHERE 
    tenure_months > 0 -- Avoids error from division by zero
ORDER BY 
    estimated_clv DESC;