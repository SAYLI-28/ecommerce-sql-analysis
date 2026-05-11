# Ecommerce SQL Analysis Project

---

1. Total Orders

---

SELECT COUNT(*) AS total_orders
FROM dbo.orders;

---

2. Total Customers

---

SELECT COUNT(*) AS total_customers
FROM dbo.customers;

---

3. Total Payments

---

SELECT COUNT(*) AS total_payments
FROM dbo.payments;

---

4. Total Revenue

---

SELECT
SUM(CAST(payment_value AS DECIMAL(10,2))) AS total_revenue
FROM dbo.payments;

---

5. Average Order Value

---

SELECT
AVG(CAST(payment_value AS DECIMAL(10,2))) AS avg_order_value
FROM dbo.payments;

---

6. Revenue by Payment Type

---

SELECT
payment_type,
SUM(CAST(payment_value AS DECIMAL(10,2))) AS revenue
FROM dbo.payments
GROUP BY payment_type
ORDER BY revenue DESC;

---

7. Total Orders by State

---

SELECT
c.customer_state,
COUNT(o.order_id) AS total_orders
FROM dbo.customers c

JOIN dbo.orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_state
ORDER BY total_orders DESC;

---

8. Top Spending Customers

---

SELECT
c.customer_id,
SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS total_spent

FROM dbo.customers c

JOIN dbo.orders o
ON c.customer_id = o.customer_id

JOIN dbo.payments p
ON o.order_id = p.order_id

GROUP BY c.customer_id
ORDER BY total_spent DESC;

---

9. Monthly Order Trend

---

SELECT
FORMAT(
TRY_CONVERT(DATETIME, order_purchase_timestamp, 105),
'yyyy-MM'
) AS month,

```
COUNT(order_id) AS total_orders
```

FROM dbo.orders

GROUP BY FORMAT(
TRY_CONVERT(DATETIME, order_purchase_timestamp, 105),
'yyyy-MM'
)

ORDER BY month;

---

10. Monthly Revenue Trend

---

SELECT
FORMAT(
TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105),
'yyyy-MM'
) AS month,

```
SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS revenue
```

FROM dbo.orders o

JOIN dbo.payments p
ON o.order_id = p.order_id

GROUP BY FORMAT(
TRY_CONVERT(DATETIME, o.order_purchase_timestamp, 105),
'yyyy-MM'
)

ORDER BY month;

---

11. Customer Ranking using Window Function

---

SELECT

```
c.customer_id,

SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS total_spent,

RANK() OVER (
    ORDER BY SUM(CAST(p.payment_value AS DECIMAL(10,2))) DESC
) AS customer_rank
```

FROM dbo.customers c

JOIN dbo.orders o
ON c.customer_id = o.customer_id

JOIN dbo.payments p
ON o.order_id = p.order_id

GROUP BY c.customer_id;

---

12. Monthly Revenue CTE

---

WITH monthly_revenue AS (

```
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
```

)

SELECT

```
FORMAT(month_date, 'yyyy-MM') AS month,

revenue
```

FROM monthly_revenue

ORDER BY month_date;

---

13. Running Revenue using Window Function

---

WITH monthly_revenue AS (

```
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
```

)

SELECT

```
FORMAT(month_date, 'yyyy-MM') AS month,

revenue,

SUM(revenue) OVER (
    ORDER BY month_date
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND CURRENT ROW
) AS running_revenue
```

FROM monthly_revenue

ORDER BY month_date;

---

14. Highest Revenue Payment Method

---

SELECT TOP 1

```
payment_type,

SUM(CAST(payment_value AS DECIMAL(10,2))) AS total_revenue
```

FROM dbo.payments

GROUP BY payment_type

ORDER BY total_revenue DESC;

---

15. Top 5 Customers by Revenue

---

SELECT TOP 5

```
c.customer_id,

SUM(CAST(p.payment_value AS DECIMAL(10,2))) AS total_spent
```

FROM dbo.customers c

JOIN dbo.orders o
ON c.customer_id = o.customer_id

JOIN dbo.payments p
ON o.order_id = p.order_id

GROUP BY c.customer_id

ORDER BY total_spent DESC;
