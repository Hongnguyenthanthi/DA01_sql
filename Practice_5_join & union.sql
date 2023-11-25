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

------ MID-COURSE
-- bai tap 1
select title, replacement_cost
from film
order by 
replacement_cost

-- bai tap 2
select count(*),
case when replacement_cost between 9.99 and 19.99 then 'low' 
when replacement_cost between 20.00 and 24.99 then 'medium'
when replacement_cost between 25.00 and 29.99 then 'high' end as category 
from film
group by category

-- bai tap 3
select a.title, a.length, c.name
from film as a
join film_category as b 
on a.film_id=b.film_id
join category as c 
on b.category_id=c.category_id
where c.name in ('Sports', 'Drama')
order by a.length desc 

-- bai tap 4
select c.name, count(*)
from film as a
join film_category as b 
on a.film_id=b.film_id
join category as c 
on b.category_id=c.category_id
where c.name ='Sports'
group by c.name

-- bai tap 5
select a.first_name || ' ' || a.last_name as full_name, count(*)
from actor as a
join film_actor as b 
on a.actor_id=b.actor_id
group by a.first_name || ' ' || a.last_name
order by count(*) desc 

-- bai tap 6
select count(*)
from address as b
left join customer as a
on a.address_id=b.address_id
where a.address_id is null

-- bai tap 7 
select a.city, sum(amount)
from city as a
join address as b on a.city_id=b.city_id
join customer as c on b.address_id=c.address_id
join payment as d on c.customer_id=d.customer_id
group by a.city
order by sum(amount) desc 

-- bai tap 8 
select e.country || ' ' || a.city , sum(amount)
from country as e
join city as a on e.country_id=a.country_id
join address as b on a.city_id=b.city_id
join customer as c on b.address_id=c.address_id
join payment as d on c.customer_id=d.customer_id
group by e.country || ' ' || a.city
order by sum(amount) 
