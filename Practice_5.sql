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
