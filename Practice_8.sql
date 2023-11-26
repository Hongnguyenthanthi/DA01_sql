-- bai tap 1
-- bảng cte table1 để tính rank từ đó chọn ra first order 
-- select từ table1 điều kiện rank1=1 
-- count tất cả first order (rank1=1) -> mẫu số
-- count tất cả first order (rank1=1) thêm điều kiện immediate order -> tử số 
with table1 as 
(select *,
rank() over(partition by customer_id order by order_date) as rank1
from delivery)
select
round(sum(case when order_date=customer_pref_delivery_date then 1 else 0 end )/ count(*)*100,2) as immediate_percentage
from table1 
where rank1=1
