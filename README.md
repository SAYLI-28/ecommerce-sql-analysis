# Ecommerce Sales Analysis using SQL Server.
# 🛒 E-Commerce Revenue & Customer Behaviour Analysis (SQL Server)

An end-to-end **Microsoft SQL Server (T-SQL) data analysis project** querying **100,000+ relational e-commerce records** across `dbo.orders`, `dbo.customers`, and `dbo.payments` to uncover payment trends, regional order density, high-value customer rankings, and cumulative monthly revenue growth.

🛠️ **Tools:** Microsoft SQL Server · SSMS · T-SQL (CTEs, Window Functions, Joins, Data Type Casting) · Excel  
📁 **Scope:** 100K+ Orders, Customers & Payments Records (15 Business Queries)

---

## 🎯 Business Problem

E-commerce leadership needed structured SQL reporting to answer four operational questions:
- **Which payment channels** drive the highest share of total revenue and average order value?
- **How does monthly revenue trend** over time, and what is the cumulative running revenue trajectory?
- **Who are the top-spending customers**, and how are customers ranked by lifetime spend?
- **Which states/regions** generate the highest order concentration to guide warehouse and logistics planning?

---

## 🗂️ Relational Schema Overview

The analysis joins three core normalized tables in SQL Server (`dbo` schema):
- **`dbo.orders`** — `order_id`, `customer_id`, `order_purchase_timestamp`
- **`dbo.customers`** — `customer_id`, `customer_state`
- **`dbo.payments`** — `order_id`, `payment_type`, `payment_value`

---

## 💻 Key T-SQL Techniques & Query Highlights

### 1. Date Standardization & Cumulative Running Revenue (`TRY_CONVERT` + `DATEFROMPARTS` + `SUM() OVER`)
Resolved `dd-mm-yyyy` string-to-datetime conversion issues using `TRY_CONVERT(..., 105)` and `DATEFROMPARTS`, while casting currency fields to `DECIMAL(10,2)` for exact financial precision:

```sql
WITH monthly_revenue AS (
    SELECT 
        DATEFROMPARTS(
            YEAR(TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105)),
            MONTH(TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105)),
            1
        ) AS month_date,
        SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS revenue
    FROM dbo.orders o
    JOIN dbo.payments p
        ON o.order_id = p.order_id
    GROUP BY DATEFROMPARTS(
        YEAR(TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105)),
        MONTH(TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105)),
        1
    )
)
SELECT
    FORMAT(month_date, 'yyyy-MM') AS month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY month_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM monthly_revenue
ORDER BY month_date;
```

### 2. Customer Lifetime Spend Ranking (`JOIN` + `RANK() OVER`)
Joined customer, order, and payment tables to rank customers by total spend:

```sql
SELECT
    c.customer_id,
    SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(CAST(p.payment_value AS DECIMAL(10,2))) DESC
    ) AS customer_rank
FROM dbo.customers c
JOIN dbo.orders o
    ON c.customer_id = o.customer_id
JOIN dbo.payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_id;
```

---

## 📋 Complete Analysis Coverage (15 SQL Queries)
1. **KPI Baselines:** Total Orders, Total Customers, Total Payments, Total Revenue, and Average Order Value (AOV).
2. **Channel & Regional Breakdown:** Revenue by Payment Type, Highest Revenue Payment Method (`TOP 1`), and Total Orders by State.
3. **Customer Segmentation:** Top Spending Customers, Top 5 Customers by Revenue (`TOP 5`), and Window Function Customer Ranking (`RANK()`).
4. **Time-Series & Running Totals:** Monthly Order Trend, Monthly Revenue Trend, Monthly Revenue CTE, and Cumulative Running Revenue (`SUM() OVER`).

---

## 💡 Key Business Insights & Recommendations

1. **Credit Cards Dominate Revenue Share:** Credit card payments generated the highest total revenue contribution—optimizing installment checkout flows can further lift average order value.
2. **High Regional Concentration in São Paulo (SP):** State-level aggregation showed **SP** leading all regions in order volume, supporting localized fulfillment hubs to reduce delivery times.
3. **Pareto Customer Spend Distribution:** Window-function ranking (`RANK()`) revealed that a concentrated tier of high-spending customers contributes a disproportionate share of revenue—ideal for targeted VIP retention campaigns.
4. **Clear Monthly Growth Trajectory:** Running-total analysis highlighted seasonal revenue peaks, establishing a reliable baseline for inventory and cash-flow forecasting.

---

## 👩‍💻 About

Built by **Sayli Markandey** — Data Analyst & Power BI Developer  
📧 saylimarkandey@gmail.com  
🐙 [github.com/SAYLI-28](https://github.com)

*Open to Data Analyst, Power BI Developer & Business Intelligence roles.*

---

⭐ If you found this SQL analysis helpful, feel free to star the repository!
