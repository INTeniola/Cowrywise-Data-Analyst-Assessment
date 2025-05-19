# Cowrywise-Data-Analyst-Assessment
This repository contains my solution to the **SQL Data Analytics Assessment**. The assessment tested my SQL proficiency, requiring me to query a relational database involving customer accounts, plans, deposits, and withdrawals.

---

## 🗃️ Database Schema Overview

The assessment involved working with the following key tables:

- **`users_customuser`**: Contains customer demographic and contact information  
- **`plans_plan`**: Stores plan details with boolean flags like `is_regular_savings` and `is_a_fund`  
- **`savings_savingsaccount`**: Records deposit transactions (e.g., `confirmed_amount`, `transaction_status`)  
- **`withdrawals_withdrawal`**: Records withdrawal transactions  

---

## ✅ Solution Breakdown

### **Question 1: High-Value Customers with Multiple Products**

**Task:**  
Identify customers with both savings and investment plans, ordered by total deposits.

**Approach:**

- Used a **CTE**(Common Table Expression) to count savings (`is_regular_savings = 1`) and investment (`is_a_fund = 1`) plans per customer
- Converted `confirmed_amount` from kobo to naira
- Filtered customers with at least one of each plan type
- Sorted by total deposits in descending order

**Challenges:**

- Correctly identifying plan types using flag fields
- Ensuring proper handling of `confirmed_amount` (stored as `double`)

---

### **Question 2: Transaction Frequency Analysis**

**Task:**  
Calculate average monthly transactions per customer and categorize by frequency.

**Approach:**

- Built a **3-step CTE pipeline**:
  1. Monthly transaction count per customer
  2. Average transactions per customer
  3. Categorize customers by frequency (low, medium, high)

- Used a `CASE` statement for category classification

**Challenges:**

- Extracting **year/month** from transaction dates
- Handling **different activity durations** per customer

---

### **Question 3: Account Inactivity Alert**

**Task:**  
Identify active accounts with **no transactions in the past 365 days**

**Approach:**

- Used a CTE to get **last transaction date** for each account
- Identified account type via `is_regular_savings` or `is_a_fund`
- Used `DATEDIFF()` to calculate days since last transaction
- Filtered out inactive accounts with:
  - `is_deleted = 0`
  - `is_archived = 0`
  - Inactivity > 365 days

**Challenges:**

- Handling **NULL** transaction dates
- Proper usage of `DATEDIFF` for date comparison
- Ensuring data accuracy with `transaction_status = 'success'`

---

### **Question 4: Customer Lifetime Value (CLV) Estimation**

**Task:**  
Estimate CLV based on **account tenure** and **transaction volume**

**Approach:**

- Used a CTE to calculate:
  - Tenure in months
  - Total number of transactions
  - Total transaction value
- Applied CLV formula:  
  `CLV = (total_transactions / tenure_months) * 12 * (total_amount * 0.001 / 100)`
- Filtered out zero-tenure customers to avoid division errors
- Ordered by estimated CLV in descending order

**Challenges:**

- Using MySQL’s `PERIOD_DIFF()` instead of SQL Server’s `DATEDIFF(MONTH, ...)`
- Accurate application of **0.1% profit rate**

---

## 🧠 Overall Methodology

Throughout the assessment, I focused on:

- **Query Readability**: Utilizing **CTEs** for modular, readable logic
- **Performance**: Reduced unnecessary joins and filtered early
- **Currency Handling**: Converted kobo → naira consistently
- **Schema Mastery**: Fully utilized plan flags and status indicators
- **Error Prevention**: Safeguarded against division by zero and nulls
- **Documentation**: Included detailed in-query comments

---
