1) Doanh thu theo từng ProductLine, Year  và DealSize?
select
productline,year_id, dealsize,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by year_id, productline, dealsize
order by productline,year_id,dealsize

2) Đâu là tháng có bán tốt nhất mỗi năm?
-- cách 1: 
  select *, sum(revenue) over(order by month_id)
from (select
month_id, ordernumber, 
sum(sales) as revenue 
from public.sales_dataset_rfm_prj_clean
group by  ordernumber, month_id) as a
order by sum(revenue) over(order by month_id) desc

  -- cách 2:   
select 
month_id, ordernumber, sales,
sum(sales) over(order by month_id) as total_revenue_of_month 
from public.sales_dataset_rfm_prj_clean
order by sum(sales) over(order by month_id) desc, ordernumber


