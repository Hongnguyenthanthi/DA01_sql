--bai tap 1
SELECT
sum(case when device_type = 'laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type = 'tablet' or device_type = 'phone' then 1 else 0 end) as mobile_views
FROM viewership;

-- bai tap 2
select x,y,z,
(case when x+y>z and y+z>x and x+z>y then 'Yes' else 'No' end) as triangle
from Triangle

-- bai tap 3
SELECT round(cast(sum(case when call_category is null or cate_category ='n/a' then 1 else 0 end)/count(case_id)*100) as decimal,1)
from callers
  
-- bai tap 4
select name from Customer 
where referee_id != 2 or referee_id is null

-- bai tap 5 
select survived,
sum(case when pclass=1 then 1 else 0 end) as first_class,
sum(case when pclass=2 then 1 else 0 end) as second_class,
sum(case when pclass=3 then 1 else 0 end) as third_class
from titanic
group by survived
