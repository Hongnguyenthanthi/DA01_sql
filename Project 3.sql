1) Doanh thu theo từng ProductLine, Year  và DealSize?
select
productline,year_id, dealsize,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by year_id, productline, dealsize
order by productline,year_id,dealsize

2) Đâu là tháng có bán tốt nhất mỗi năm? 
select * from 
(select *, rank() over(order by revenue desc) 
from
(select 
month_id, ordernumber,
sum(sales) over(partition by month_id) as revenue
from public.sales_dataset_rfm_prj_clean) as a) as b 		   
where rank=1
 -> tháng 11 có doanh thu bán tốt nhất tổng 2118885.67

 3) Product line nào được bán nhiều ở tháng 11?
select * from 
(select *, 
rank() over(order by revenue desc) as rank1,
rank() over(order by productline_count desc) as rank2
from
(select productline, month_id, ordernumber,
sum(sales) over(partition by productline) as revenue,
count(productline) over(partition by productline) as productline_count
from public.sales_dataset_rfm_prj_clean
where month_id=11) as a) as b
where rank1=1 or rank2=1
-> productline Classic Cars có số lượng 219 và doanh thu 825156.26 cao nhất ở tháng 11 



