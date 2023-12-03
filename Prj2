WITH cte1 AS (
SELECT
FORMAT_DATE('%Y-%m', DATE (a.created_at)) AS month_year, EXTRACT (YEAR FROM a.created_at) AS year,
c.category AS product_category, (SUM (b.sale_price) - SUM (c.cost)) AS TPV,
COUNT (a.order_id) AS TPO, SUM (c.cost) AS total_cost,
((SUM (b.sale_price) - SUM (c.cost)) - SUM (c.cost)) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.orders AS a 
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c
ON b.product_id=c.id
GROUP BY FORMAT_DATE('%Y-%m', DATE (a.created_at)), c.category, EXTRACT (YEAR FROM a.created_at))

-- CREATE view table with revenue growth, order growth, profit to cost ratio
SELECT month_year, year, product_category, TPV, TPO,
100*(TPV - LAG (TPV) OVER (PARTITION BY product_category ORDER BY month_year ASC))/(TPV + LAG (TPV) OVER (PARTITION BY product_category ORDER BY month_year ASC)) ||'%' AS revenue_growth,
100*(TPO - LAG (TPO) OVER (PARTITION BY product_category ORDER BY month_year ASC))/(TPO + LAG (TPO) OVER (PARTITION BY product_category ORDER BY month_year ASC)) ||'%' AS order_growth,
total_cost, 
total_profit, total_profit/cte1.total_cost AS profit_to_cost_ratio
FROM cte1

--COHORT ANALYSIS

WITH cte AS 
 (
 SELECT user_id,sale_price,
  FORMAT_DATE('%Y-%m', DATE (first_puchase_date)) as cohort_date,
  created_at,
  (extract(year from created_at)-extract(year from first_puchase_date))*12 
  + (extract(month from created_at)-extract(month from first_puchase_date))+ 1 as index
 FROM 
 (
 SELECT user_id,sale_price,
  MIN(created_at) OVER (PARTITION BY user_id) as first_puchase_date,
 created_at
 FROM bigquery-public-data.thelook_ecommerce.order_items
 WHERE status ='Complete'
)
 )

 ,cte2 as (
 SELECT cohort_date, index,
  COUNT(DISTINCT user_id) as cnt,
  SUM (sale_price) as revenue
 FROM cte
 WHERE index <=4
 GROUp BY 1,2
 ORDER BY cohort_date)

,customer_cohort AS (
 SELECT cohort_date,
 SUM(case when index = 1 then cnt else 0 end) as t1,
 SUM(case when index = 2 then cnt else 0 end) as t2,
 SUM(case when index = 3 then cnt else 0 end) as t3,
 SUM(case when index = 4 then cnt else 0 end) as t4
 FROM cte2
 GROUP BY cohort_date
 ORDER BY cohort_date
)

--retention cohort
, retention_cohort AS (
SELECT cohort_date,
ROUND(100.00* t1/t1,2)||'%' t1,
ROUND(100.00* t2/t1,2)||'%' t2,
ROUND(100.00* t3/t1,2)||'%' t3,
ROUND(100.00* t4/t1,2)||'%' t4
FROM customer_cohort)

--churn cohort
SELECT cohort_date,
(100-ROUND(100.00* t1/t1,2))||'%' t1,
(100-ROUND(100.00* t2/t1,2))||'%' t2,
(100-ROUND(100.00* t3/t1,2))||'%' t3,
(100-ROUND(100.00* t4/t1,2))||'%' t4
FROM customer_cohort
