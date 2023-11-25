-- bai tap 1
select Name
from STUDENTS
where Marks > 75
order by right(Name,3), ID

-- bai tap 2 
select user_id, 
concat(upper(left(name,1)), lower(right(name,length(name)-1))) as name
from Users

-- bai tap 3 
SELECT manufacturer, concat('$',round(sum(total_sales)/10^6), ' ','million') as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer

-- bai tap 4 
SELECT extract(month from submit_date) as mth,
product_id as product,
round(avg(stars),2) as avg_stars
FROM reviews
group by mth, product 
order by mth, product

-- bai tap 5
SELECT sender_id, count(message_id) 
FROM messages
where extract(year from sent_date)=2022 and extract(month from sent_date) = 08
group by sender_id
order by count(message_id) desc 
limit 2

-- bai tap 6 
select tweet_id
from Tweets
where length(content) > 15

-- bai tap 7 
select activity_date as day,
count(distinct user_id) as active_users
from Activity
where activity_type is not null
and activity_date between '2019-06-28' and '2019-07-27'
group by activity_date

-- bai tap 8 
select count(id) as number_employees
from employees
where extract(year from joining_date)=2022 and extract(month from joining_date) between 01 and 07


-- bai tap 9 
select first_name, position('a' in first_name)
from worker
where first_name = 'Amitah' 

-- bai tap 10 
select title, substring(title from length(winery)+2 for 4)
from winemag_p2
where country = 'Macedonia'



