with table_1 as (SELECT c.category as product_category, format_date('%Y-%m', a.created_at) as year_month, 
  extract(year from a.created_at) as year, 
  sum(b.sale_price) as TPV, 
  count(b.order_id) as TPO,
  sum(c.cost) as total_cost,
  sum(b.sale_price)-sum(c.cost) as total_profit
FROM bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c 
on c.id=b.order_id
group by 1,2,3
order by 2) 
select *, 
lag(TPV) over(partition by product_category order by year_month) as previous_TPV,
(TPV-lag(TPV) over(partition by product_category order by year_month))/lag(TPV) over(partition by product_category order by year_month) as revenue_growth,
lag(TPO) over(partition by product_category order by year_month) as previous_TPO,
(TPO-lag(TPO) over(partition by product_category order by year_month))/lag(TPO) over(partition by product_category order by year_month) as order_growth
from table_1



  
