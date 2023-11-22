-- bai tap 1
select (count(distinct company_id)) as duplicate_companies from 
(SELECT company_id, title, description, count(job_id)
FROM job_listings
group by company_id, title, description
having count(*)>=2) as a 

-- bai tap 2
with twt_appliance as
(select product, sum(spend) as total_spend, 'appliance' as category
from product_spend
where category ='appliance' and extract(year from transaction_date)=2022
group by product
order by total_spend DESC
limit 2),
twt_electronics as 
(select product, sum(spend) as total_spend, 'electronics' as category
from product_spend
where category ='electronics' and extract(year from transaction_date)=2022
group by product
order by total_spend DESC
limit 2)
select category, product, total_spend
from twt_appliance
union all 
select category, product, total_spend
from twt_electronics

-- bai tap 3
  select count(policy_holder_id) as member_count 
from (SELECT policy_holder_id, count(*)
from callers
where call_category is not null
group by policy_holder_id
having count(*)>=3) as a  


-- bai tap 4
SELECT a.page_id
FROM pages as a 
left join page_likes as b 
on a.page_id = b.page_id
where b.page_id is null
order by a.page_id

-- bai tap 5 
with month_7 as
(SELECT extract(month from event_date), extract(year from event_date), user_id, count(*) as number_actions
FROM user_actions
group by extract(month from event_date), extract(year from event_date), user_id
having extract(month from event_date)=7 and extract(year from event_date)=2022),
month_6 as 
(SELECT extract(month from event_date), extract(year from event_date), user_id, count(*) as number_actions
FROM user_actions
group by extract(month from event_date), extract(year from event_date), user_id
having extract(month from event_date)=6 and extract(year from event_date)=2022)
select 7 as mth, count(*) as monthly_active_users 
from (select * 
from month_7 as a
inner join
month_6 as b 
on a.user_id = b.user_id) as c 

-- bai tap 6
select substring(trans_date from 1 for 7) as month, country, 
count(*) as trans_count,
count(case when state='approved' then id end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by substring(trans_date from 1 for 7), country

-- bai tap 7 
with year_product
as (select product_id, min(year) as first_year from sales
group by product_id)
select b.product_id, b.first_year, a.quantity, a.price
from sales as a
inner join year_product as b
on a.product_id=b.product_id and a.year=b.first_year

-- bai tap 8
select distinct customer_id
from customer
group by customer_id
having count(distinct product_key)= (select count(*) from product)

-- bai tap 10 
select (count(distinct company_id)) as duplicate_companies from 
(SELECT company_id, title, description, count(job_id)
FROM job_listings
group by company_id, title, description
having count(*)>=2) as a 

-- bai tap 11
select results from 
(select d.name as results from (select user_id, count(movie_id) as count_movie
from movierating
group by user_id) as c
inner join users as d 
on c.user_id=d.user_id
order by c.count_movie desc, d.name
limit 1) as e
union all
select results from
(select b.title as results from (select movie_id, avg(rating) as avg_rating
from movierating
where extract(month from created_at)=02 and extract(year from created_at)=2020
group by movie_id) as a
inner join movies as b
on a.movie_id = b.movie_id
order by a.avg_rating desc, b.title
limit 1) as f 

-- bai tap 12
# Write your MySQL query statement below
select accept as id, count(*) as num from 
(select requester_id as accept, accepter_id as request
from requestaccepted
union all
select accepter_id as accept, requester_id as request
from requestaccepted) as a
group by accept 
order by count(*) desc 
limit 1 



