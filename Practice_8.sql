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
– bảng cte newtable để tìm first_login bằng min(event_date) gộp player_id lại
– tìm datediff giữa event_date và first_login
– select từ bảng newtable với datediff=1  
with newtable as (select player_id, event_date,
min(event_date) over(partition by player_id) as min_event_date,
datediff(event_date,min(event_date) over(partition by player_id)) as date_diff
from activity)
select round(sum(case when date_diff=1 then 1 else 0
end)/count(distinct player_id),2) as fraction
from newtable
  
-- bai tap 5
  # Write your MySQL query statement below
select tiv_2016 
from insurance 
where tiv_2015 in 
(select tiv_2015,count( tiv_2015) as count_2015
from insurance
group by tiv_2015
having count(tiv_2015)!=1) and lat in
(select lat, lon, count(lat) as count_lat, count(lon) as count_lon
from insurance
group by lat, lon
having count(lat)=1 and count(lon)=1)
 and lon in (select lat, lon, count(lat) as count_lat, count(lon) as count_lon
from insurance
group by lat, lon
having count(lat)=1 and count(lon)=1)
  
-- bai tap 6 
-- join 2 bảng employee và department lại với nhau
-- tạo newtable1 cte để rank salary gộp department gần nhau 
-- select từ newtable1 điều kiện rank<=3
with newtable as (select b.name as Department, a.name as Employee, a.salary as Salary 
from employee as a
join department as b 
on a.departmentId=b.id),
newtable1 as (select Department, Employee, Salary,
dense_rank() over(partition by department order by salary desc) as rank1
from newtable)
select Department, Employee, Salary
from newtable1
where rank1<=3

-- bai tap 7
-- cte newtable để rank turn, và cộng dồn weight bằng over(order by)
-- cte newtable1 để rank turn desc, người cuối cùng lên đầu, điều kiện total weight<=1000
-- select từ newtable1 để chọn turn_desc=1
with newtable as (select *, 
rank() over(order by turn),
sum(weight) over(order by turn) as total_weight
from queue),
newtable1 as (select *,
rank() over(order by turn desc) as turn_desc
from newtable
where total_weight<=1000)
select person_name from newtable1
where turn_desc=1

-- bai tap 8
-- bảng cte newtable để rank change_date desc gộp product_id, điều kiện change_date<='2019-08-16'
-- bảng cte newtable1 để rank change_date desc gộp product_id, điều kiện change_date>='2019-08-16' và product_id not in bảng cte newtable, thêm cột 10 as price 
-- bảng cte newtable2 để union all 2 bảng newtable và newtable1 
-- select từ bảng newtable2 với điều kiện rank1=1 
with newtable as (select product_id, new_price as price, change_date,
rank() over(partition by product_id order by change_date desc) as rank1
from products
where change_date<='2019-08-16'),
newtable1 as 
(select product_id, new_price, change_date, 10 as price,
rank() over(partition by product_id order by change_date desc) as rank1
from products
where change_date>='2019-08-16' and product_id not in (select product_id from newtable)),
newtable2 as (select a.product_id, a.price, a.rank1
from newtable as a
union all 
select b.product_id, b.price, b.rank1
from newtable1 as b)
select c.product_id as product_id, c.price as price
from newtable2 as c
where c.rank1=1





