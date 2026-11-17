-- Customer Churn Analysis: SQL queries (SQLite)
-- Tables: customers, subscriptions, support (cleaned tables loaded from the notebook)

-- Q1. Churn rate by plan type
SELECT plan_type,
       COUNT(*) AS customers,
       SUM(churn_flag) AS churned,
       ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate_pct
FROM subscriptions
GROUP BY plan_type
ORDER BY churn_rate_pct DESC;

-- Q2. Why customers cancel
SELECT cancellation_reason, COUNT(*) AS customers
FROM subscriptions
WHERE cancellation_reason IS NOT NULL
GROUP BY cancellation_reason
ORDER BY customers DESC;

-- Q3. Churn by state (customer + subscription tables joined)
SELECT c.state,
       COUNT(*) AS customers,
       SUM(s.churn_flag) AS churned
FROM subscriptions s
JOIN customers c ON c.customerid = s.customerid
GROUP BY c.state
ORDER BY churned DESC, customers DESC;

-- Q4. Active customers with churn score >= 50 (retention watch list)
SELECT c.customer_name, c.state, s.plan_type, s.monthly_charges, s.churn_score
FROM subscriptions s
JOIN customers c ON c.customerid = s.customerid
WHERE s.churn_flag = 0 AND s.churn_score >= 50
ORDER BY s.churn_score DESC;

-- Q5. Average monthly charges and CLTV by plan
SELECT plan_type,
       ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
       ROUND(AVG(cltv), 0) AS avg_cltv
FROM subscriptions
GROUP BY plan_type;
