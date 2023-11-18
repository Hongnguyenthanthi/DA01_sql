-- bai tap 1
select distinct CITY
from STATION
where ID%2=0

-- bai tap 2
select count(CITY) - count(distinct CITY)
from STATION

-- bai tap 4
SELECT round(cast(sum(order_occurrences*item_count)/ sum(order_occurrences) as decimal),1) as mean
FROM items_per_order

-- bai tap 5 
SELECT candidate_id
FROM candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill)=3

-- bai tap 6 
SELECT user_id,
(max(date(post_date)) - min(date(post_date))) as days_between 
FROM posts
where post_date >= '2021-01-01' and post_date <= '2022-01-01'
group by user_id
having count(post_id)>= 2

-- bai tap 7 
SELECT card_name,
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc;

-- bai tap 8 
SELECT manufacturer, count(drug) as drug_count, abs(sum(total_sales - cogs)) as total_loss
FROM pharmacy_sales
where total_sales - cogs <=0
group by manufacturer 
order by total_loss desc 

-- bai tap 9 
select * from Cinema
where id%2 <>0 and not description = 'boring'
order by rating desc 

-- bai tap 10 
select teacher_id, count(distinct subject_id) as cnt from Teacher
group by teacher_id

-- bai tap 11
select user_id, count(follower_id) as followers_count from Followers
group by user_id
order by user_id

-- bai tap 12
select class
from Courses
group by class
having count(student)>=5

-- bai tap 3
select
ceiling(avg(salary)-avg(replace(salary,0,'')))
from EMPLOYEES
