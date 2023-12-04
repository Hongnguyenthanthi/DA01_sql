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

4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?  
select * from  
(select year_id, productline,
sum(sales)  as revenue,
 rank() over(partition by year_id order by sum(sales) desc)
from
public.sales_dataset_rfm_prj_clean
where country='UK'
group by year_id, productline) as a 
where rank=1
-> Năm 2003, Classic Cars có doanh thu 66705.63 tốt nhất ở UK 
Năm 2004, Classic Cars có doanh thu 92672.07 tốt nhất ở UK
Năm 2005, Motorcycles có doanh thu 40802.81 tốt nhất ở UK



