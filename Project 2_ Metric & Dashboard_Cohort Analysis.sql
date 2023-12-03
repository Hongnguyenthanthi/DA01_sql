with table_1 as 
(SELECT c.category as product_category, 
extract(year from a.created_at) as year, 
extract(month from a.created_at) as month,
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
order by 2,3),

table_2 as 
(select *, 
lag(TPV) over(partition by product_category order by year, month) as previous_TPV,
(TPV-lag(TPV) over(partition by product_category order by year, month))/lag(TPV) over(partition by product_category order by year, month) as revenue_growth,
lag(TPO) over(partition by product_category order by year, month) as previous_TPO,
(TPO-lag(TPO) over(partition by product_category order by year, month))/lag(TPO) over(partition by product_category order by year, month) as order_growth,
from table_1),

table_3 as 
(select *, 
min(month) over(partition by product_category order by year) as first_month,
min(year) over(partition by product_category) as first_year
from table_2),

table_4 as (
select product_category, TPV, TPO, total_profit, 
(year-first_year)*12+(month-first_month)+1 as index, 
concat(first_year,'-',first_month) as cohort_date 
from table_3),

TPV_cohort as(
select cohort_date,
sum(case when index =1 then TPV else 0  end) as m1,
sum(case when index =2 then TPV else 0  end) as m2,
sum(case when index =3 then TPV else 0  end) as m3,
sum(case when index =4 then TPV else 0  end) as m4
from table_4
group by cohort_date
order by cohort_date)

select cohort_date,
sum(case when index =1 then TPO else 0  end) as m1,
sum(case when index =2 then TPO else 0  end) as m2,
sum(case when index =3 then TPO else 0  end) as m3,
sum(case when index =4 then TPO else 0  end) as m4
from table_4
group by cohort_date
order by cohort_date



  
