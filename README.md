# Customer Churn Analysis & Retention Insights

[![Python](https://img.shields.io/badge/Python-Pandas-blue)](#technical-specifications) [![SQL](https://img.shields.io/badge/SQL-SQLite-lightgrey)](#technical-specifications)

A Python and SQL portfolio project analyzing customer churn for a subscription business: which plans, regions and complaint patterns are linked to cancellations, and which active customers need attention.

The project combines customer, subscription and support data to build KPIs, SQL analysis and visual insights from a sample of 21 customers.

## Table of Contents
- [About This Project](#about-this-project)
- [Problem Statement](#problem-statement)
- [Business Questions](#business-questions)
- [Dataset Overview](#dataset-overview)
- [Project Structure](#project-structure)
- [Methodology](#methodology)
- [Charts](#charts)
- [SQL Queries and Results](#sql-queries-and-results)
- [Key Findings](#key-findings)
- [Business Recommendations](#business-recommendations)
- [Technical Specifications](#technical-specifications)
- [How to Review the Project](#how-to-review-the-project)
- [Limitations](#limitations)

## About This Project
This project uses Python for data cleaning, merging, KPI calculation and visualization, and SQL (SQLite) for business analysis.

It demonstrates:
- **Data preparation:** loading Excel sheets, storing them in SQLite, cleaning and standardizing fields, resolving duplicate records.
- **Data merging with checks:** left joins across three tables, with row counts verified before and after.
- **KPI calculation:** churn rate, retention, ARPU, tenure, revenue lost, revenue at risk, escalation rate.
- **SQL analysis:** GROUP BY, WHERE, JOIN and ORDER BY queries answering defined business questions.
- **Visualization:** Matplotlib and Seaborn charts, correlation heatmap, pivot tables.
- **Business interpretation:** insights and recommendations, with limitations stated.

## Problem Statement
Customer churn reduces recurring revenue. Looking at one metric alone (for example overall churn rate) hides where the problem is. This project looks at churn by plan, state, cancellation reason, time and support history to find where customers leave and what warns of it early.

## Business Questions
1. **Overall churn:** What share of customers churned, and what revenue was lost?
2. **Plan performance:** Which plan types churn the most?
3. **Cancellation reasons:** Why do customers cancel?
4. **Geography:** Which states have the most churn?
5. **Support signals:** Is complaint escalation linked to churn?
6. **Retention focus:** Which active customers are at risk right now?

## Dataset Overview
Source file: `Dataset/customer_churn_data_raw.xlsx` (3 sheets).

| Sheet | Rows | Description |
|---|---|---|
| `db_customer` | 21 | Name, country, state, gender, date of birth |
| `db_subscription` | 21 | Plan, contract, start/renewal/cancellation dates, charges, CLTV, churn score |
| `db_support` | 9 | Complaint date, escalation flag, CSAT score |

| Attribute | Details |
|---|---|
| Customers | 21 |
| Churned customers | 6 |
| Subscription start dates | 2019 - 2023 |
| Source format | Excel (.xlsx) |
| Cleaned output | `SQL Output/Cleaned_Churn_Data.csv` |

## Project Structure
```
Customer-Churn-Analysis/
│
├── Dataset/
│   └── customer_churn_data_raw.xlsx
│
├── Notebook/
│   └── Churn_analysis_project.ipynb
│
├── SQL/
│   └── churn_analysis_queries.sql
│
├── SQL Output/
│   ├── Cleaned_Churn_Data.csv
│   ├── Q01_Churn_By_Plan.csv
│   ├── Q02_Cancellation_Reasons.csv
│   ├── Q03_Churn_By_State.csv
│   ├── Q04_Active_Watch_List.csv
│   └── Q05_Avg_Charges_CLTV_By_Plan.csv
│
├── Screenshots/
│   ├── 01_Churn_Rate_By_Plan.png
│   ├── 02_Monthly_Churn_Trend.png
│   ├── 03_Cancellation_Reasons.png
│   ├── 04_Churn_By_State.png
│   ├── 05_Escalation_vs_Churn.png
│   └── 06_Correlation_Heatmap.png
│
└── README.md
```

## Methodology
### 1. Data Preparation
- Loaded the three Excel sheets with Pandas and stored them in SQLite.
- Renamed `name` to `customer_name`; dropped unused columns (`interests`, `pincode`, `col_1`, `comment`).
- Standardized gender values (`Men`/`Women` to `Male`/`Female`).
- Filled missing `country` using a state-to-country mapping built from existing rows.
- Converted date columns to datetime.

### 2. Feature Engineering and Merge
- `churn_flag`: 1 if a cancellation date exists.
- `tenure_days`: days from subscription start to cancellation, or to a fixed snapshot date (2025-03-31) for active customers, so results are reproducible.
- `churn_risk`: low (score < 50), med (50-69), high (70+).
- The support table had several complaints per customer. The latest complaint was kept and `complaint_count` was added (9 rows reduced to 7 customers).
- Merged subscription, customer and support tables with left joins; the result keeps 21 rows (one per customer).

### 3. KPI Calculation
| KPI | Definition |
|---|---|
| Churn rate | Churned customers / total customers |
| Retention rate | 100 - churn rate |
| ARPU | Average monthly charges per customer |
| Avg tenure | Average days between start and cancellation (or snapshot date) |
| Revenue lost | Monthly charges of customers who already churned |
| Revenue at risk | Monthly charges of **active** customers with med/high churn risk |
| Escalation rate | Share of customers whose latest complaint was escalated |

### 4. SQL Analysis
Five queries on the cleaned tables (see below). Outputs are saved in `SQL Output/`.

### 5. Visualization
Charts for churn by plan, monthly trend, cancellation reasons, state, escalation and a correlation heatmap. The heatmap leaves out `churn_risk` because it is derived from `churn_score` and would add a circular correlation.

## Charts
### Churn rate by plan
<img width="1040" height="640" alt="01_Churn_Rate_By_Plan" src="https://github.com/user-attachments/assets/acfa6b84-ca0e-417e-84a8-1d3e127d3276" />


### Escalation vs churn

<img width="1040" height="640" alt="05_Escalation_vs_Churn" src="https://github.com/user-attachments/assets/edfac696-3b52-4da2-8098-5d5950a6bf2b" />


### Cancellation reasons

<img width="1120" height="608" alt="03_Cancellation_Reasons" src="https://github.com/user-attachments/assets/2c7abf3d-81f0-41da-95ab-a2c1ae9b7af5" />


### Churn by state

<img width="1200" height="736" alt="04_Churn_By_State" src="https://github.com/user-attachments/assets/d80a3c3c-85fd-4d86-971c-2f5137476362" />


### Monthly churn trend

<img width="1200" height="640" alt="02_Monthly_Churn_Trend" src="https://github.com/user-attachments/assets/66160b00-7694-4f3b-9bd4-813fa9c0a5a8" />


### Correlation heatmap

<img width="992" height="800" alt="06_Correlation_Heatmap" src="https://github.com/user-attachments/assets/3a616a37-6a6e-4dd9-9fd7-0aaffecea488" />


## SQL Queries and Results
Full file: [`SQL/churn_analysis_queries.sql`](SQL/churn_analysis_queries.sql)

### Q1. Churn rate by plan
```sql
SELECT plan_type,
       COUNT(*) AS customers,
       SUM(churn_flag) AS churned,
       ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate_pct
FROM subscriptions
GROUP BY plan_type
ORDER BY churn_rate_pct DESC;
```
| plan_type | customers | churned | churn_rate_pct |
|---|---|---|---|
| Basic | 5 | 3 | 60.00 |
| Standard | 9 | 2 | 22.22 |
| Premium | 7 | 1 | 14.29 |

### Q2. Cancellation reasons
```sql
SELECT cancellation_reason, COUNT(*) AS customers
FROM subscriptions
WHERE cancellation_reason IS NOT NULL
GROUP BY cancellation_reason
ORDER BY customers DESC;
```
| cancellation_reason | customers |
|---|---|
| Switched to competitor | 2 |
| Too expensive | 1 |
| Poor streaming quality | 1 |
| Not enough content | 1 |
| Forgot to cancel trial | 1 |

### Q3. Churn by state
```sql
SELECT c.state,
       COUNT(*) AS customers,
       SUM(s.churn_flag) AS churned
FROM subscriptions s
JOIN customers c ON c.customerid = s.customerid
GROUP BY c.state
ORDER BY churned DESC, customers DESC;
```
Top rows: Meghalaya (3 customers, 2 churned), Karnataka (2, 2), Delhi (4, 1), Telangana (2, 1). Full output in `SQL Output/Q03_Churn_By_State.csv`.

### Q4. Active watch list (churn score >= 50)
```sql
SELECT c.customer_name, c.state, s.plan_type, s.monthly_charges, s.churn_score
FROM subscriptions s
JOIN customers c ON c.customerid = s.customerid
WHERE s.churn_flag = 0 AND s.churn_score >= 50
ORDER BY s.churn_score DESC;
```
| customer_name | state | plan_type | monthly_charges | churn_score |
|---|---|---|---|---|
| rikim | Meghalaya | Premium | 20.99 | 62 |
| parvati | Delhi | Standard | 13.99 | 58 |

### Q5. Average charges and CLTV by plan
```sql
SELECT plan_type,
       ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
       ROUND(AVG(cltv), 0) AS avg_cltv
FROM subscriptions
GROUP BY plan_type;
```
| plan_type | avg_monthly_charges | avg_cltv |
|---|---|---|
| Basic | 10.59 | 195 |
| Standard | 13.77 | 589 |
| Premium | 31.28 | 1574 |

## Key Findings
### 1. Overall churn
6 of 21 customers churned (28.57%); retention is 71.43%.
**Interpretation:** more than one in four customers in the sample has left.

### 2. Plan performance
Basic churns at 60% (3 of 5), against 22% for Standard (2 of 9) and 14% for Premium (1 of 7).
**Interpretation:** the lowest-priced plan loses customers fastest, and higher-priced plans hold them better.

### 3. Support signals
All 4 customers whose latest complaint was escalated churned (100%), against 12% (2 of 17) for the rest. Correlation between escalation and churn is 0.77.
**Interpretation:** an escalated complaint is a strong early warning, though with 4 cases it is a pattern to watch, not proof.

### 4. Cancellation reasons
"Switched to competitor" is the most common reason (2 of 6). Price, content, streaming quality and a forgotten trial account for one each.
**Interpretation:** reasons are spread out; no single fix explains the churn.

### 5. Geography
Meghalaya and Karnataka had 2 churned customers each. Five states had no churn.

### 6. Revenue
| Metric | Result |
|---|---|
| Churn rate | 28.57% |
| Retention rate | 71.43% |
| ARPU | 18.85 |
| Avg tenure | 1,159 days |
| Escalation rate | 19.05% |
| Avg complaints per customer | 0.43 |
| Monthly revenue lost | 73.94 |
| Monthly revenue at risk | 34.98 (2 active customers) |

**Data note:** one Premium customer is charged 92.99 against about 23 for other Premium customers, which looks like an entry error and lifts ARPU and Premium average charges.

## Business Recommendations
1. **Protect the Basic plan:** offer upgrade paths or discounts before renewal.
2. **Act on escalations:** start retention outreach as soon as a complaint is escalated or CSAT is low.
3. **Use the watch list:** contact the 2 active customers with churn score of 50 or more first.
4. **Track competitors:** review why customers switch and compare plan value.

These recommendations reflect patterns in a small sample and are not a substitute for a larger study.

## Technical Specifications
| Component | Technology / Approach |
|---|---|
| Data input | Excel (.xlsx) |
| Data preparation | Python, Pandas, NumPy |
| Storage and SQL analysis | SQLite, SQL (joins, aggregation, filtering) |
| Visualization | Matplotlib, Seaborn |
| Analysis type | Descriptive and exploratory |
| Outputs | Notebook, CSV, PNG, Markdown |

## How to Review the Project
1. **Source data:** open `Dataset/customer_churn_data_raw.xlsx`.
2. **Notebook:** open `Notebook/Churn_analysis_project.ipynb` (outputs are included). To rerun it, place the Excel file next to the notebook, or update the file path in the first data cell.
3. **SQL:** read `SQL/churn_analysis_queries.sql`; the queries run on tables `customers`, `subscriptions` and `support` created in the notebook.
4. **Outputs:** see the CSVs in `SQL Output/` and the charts in `Screenshots/`.

## Limitations
- **Small sample:** 21 customers, so percentages move a lot with one customer and are not statistically significant.
- **Escalation link:** based on 4 escalated cases.
- **Churn score:** supplied in the data and not validated; no predictive model was built.
- **Data quality:** at least one charge value looks like an entry error.
- **Scope:** findings describe this dataset and should not be generalized.
