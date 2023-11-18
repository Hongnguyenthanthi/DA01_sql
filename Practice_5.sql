-- BAI TAP 1
select COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
from COUNTRY
JOIN CITY 
ON COUNTRY.CODE=CITY.COUNTRYCODE
GROUP BY COUNTRY.CONTINENT

-- BAI TAP 2
SELECT round(cast(count(b.email_id) as decimal)/count(distinct a.email_id),2)
FROM emails as a 
left join texts as b
on a.email_id=b.email_id
and b.signup_action='Confirmed'

-- BAI TAP 3
SELECT b.age_bucket,
round(sum(case when a.activity_type='send' then time_spent end)/sum(case when a.activity_type in ('send','open') then time_spent end)*100.0,2) as send_perc,
round(sum(case when a.activity_type='open' then time_spent end)/sum(case when a.activity_type in ('send','open') then time_spent end)*100.0,2) as open_perc
FROM activities as a 
right join age_breakdown as b 
on a.user_id = b.user_id
group by b.age_bucket
order by b.age_bucket

-- bai tap 4 
SELECT a.customer_id
from customer_contracts as a
join products as b 
on a.product_id = b.product_id
where b.product_category in ('Analytics','Containers','Compute') and b.product_name like 'Azure%'
group by a.customer_id
having count(a.customer_id)=3

-- bai tap 5
select mng.reports_to as employee_id, emp.name as name, count(*) as reports_count, round(cast(avg(mng.age) as decimal),0) as average_age
from Employees as mng
join Employees as emp
on mng.reports_to = emp.employee_id
where mng.reports_to=emp.employee_id

-- bai tap 6
select a.product_name, sum(b.unit) as unit 
from products as a 
join orders as b 
on a.product_id=b.product_id
where extract(month from b.order_date)=02 and extract(year from b.order_date)=2020 
group by a.product_name
having sum(b.unit)>=100

-- bai tap 7 
  SELECT a.page_id
FROM pages as a 
left join page_likes as b 
on a.page_id = b.page_id
where b.page_id is null
order by a.page_id

