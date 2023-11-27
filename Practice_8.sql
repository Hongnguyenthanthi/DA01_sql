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

  
-- bai tap 3
-- dùng case when nếu id chia 2 khác 0 thì id+1, nếu id chia 2 bằn 0 thì id -1, nếu id chia 2 khác 0 và id bằng tổng số seat thì vẫn là id 
select
(case when id % 2<>0 and (select count(*) from seat) =id then id 
when id % 2 =0 then id-1 
when id % 2 <>0 then id+1 end) as id, student
from seat
order by id

  
-- bai tap 4
-- bảng cte newtable để group by visited_on và tính sum(amount)
-- bảng cte newtable1 để tính accumulated sum(amount) và accumulated avg(amount) từ '2019-01-01', rank theo visited_on 
-- select từ newtable1 điều kiện rank>6 
with newtable as (select visited_on,
sum(amount) as amount
from customer
group by visited_on),
newtable1 as (select visited_on,
sum(amount) over(order by visited_on rows between 6 preceding and current row) as amount,
round(avg(amount) over(order by visited_on rows between 6 preceding and current row),2) as average_amount,
row_number() over(order by visited_on) as rank1
from newtable)
select visited_on, amount, average_amount 
from newtable1 
where rank1>6

  
-- bai tap 5
-- bảng cte newtable để select tiv_2015 có same value bằng cách đếm count(*) khác 1
-- bảng cte newtable1 để select lat, lon không có same value bằng cách đếm count(*) bằng 1 
-- select tiv_2016 từ bảng insurance điều kiện lat, lon, và tiv_2015 có trong newtable1 và newtable 
with newtable as (select tiv_2015, count(*)
from insurance
group by tiv_2015
having count(*)<>1),
newtable1 as (select lat, lon, count(*)
from insurance
group by lat, lon
having count(*)=1)
select round(sum(tiv_2016),2) as tiv_2016
from insurance 
where lat in (select lat from newtable1) and lon in (select lon from newtable1)
and tiv_2015 in (select tiv_2015 from newtable)

  
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

