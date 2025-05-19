/**
 * Question 1: High-Value Customers with Multiple Products
 * 
 * This query identifies customers who have both at least one funded savings plan
 * AND one funded investment plan, sorted by their total deposits.
 * 
 * Logic:
 * - Join users with plans and savings accounts
 * - Count savings plans (is_regular_savings=1) and investment plans (is_a_fund=1) per customer
 * - Sum up deposit amounts from confirmed_amount field (as per the schema)
 * - Filter for customers with at least one of each plan type
 * - Sort by total deposits in descending order
 */

WITH customer_plans AS (
    SELECT 
        uc.id AS owner_id,
        uc.name,
        SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
        SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
        SUM(s.confirmed_amount) / 100.0 AS total_deposits -- Converting kobo to Naira
    FROM 
        users_customuser uc
    JOIN 
        plans_plan p ON p.owner_id = uc.id
    JOIN 
        savings_savingsaccount s ON s.plan_id = p.id
    WHERE 
        s.transaction_status = 'success' -- Only include successful transactions
    GROUP BY 
        uc.id, uc.name
)
SELECT 
    owner_id,
    name,
    savings_count,
    investment_count,
    total_deposits
FROM 
    customer_plans
WHERE 
    savings_count >= 1 
    AND investment_count >= 1
ORDER BY 
    total_deposits DESC;