/**
 * Question 3: Account Inactivity Alert
 * 
 * This query identifies accounts with no transactions in the last year (365 days) by:
 * - Finding the last transaction date for each account (savings or investments)
 * - Calculating inactivity days compared to current date
 * - Filtering for accounts inactive for over 365 days
 * - Identifying the account type (Savings or Investment)
 */

WITH last_transactions AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM 
        plans_plan p
    LEFT JOIN 
        savings_savingsaccount s ON s.plan_id = p.id AND s.transaction_status = 'success'
    WHERE
        p.is_deleted = 0 -- Only include active plans
        AND p.is_archived = 0
    GROUP BY 
        p.id, p.owner_id
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
FROM 
    last_transactions
WHERE 
    DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;