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
