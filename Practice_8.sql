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
  
-- bai tap 2 
select sum(case when a.diff=1 then 1 else 0 end)/count(b.player_id)
from table1 as a
join activity as b 
on a.player_id=b.player_id

select round(sum(case when diff=1 then 1 else 0 end )/count(distinct player_id),2) as fraction 
from table1

select tiv_2015,count( tiv_2015)
from insurance
group by tiv_2015


