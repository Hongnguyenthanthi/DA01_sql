--INTERVALS AND TIMESTAMP
select current_date, current_timestamp, 
customer_id,
rental_date,
return_date,
extract(day from return_date - rental_date)*24 + extract(hour from return_date - rental_date) || ' '|| 'giờ'
from rental 

--INTERVALS AND TIMESTAMP solution
select rental_date, return_date, customer_id
return_date-rental_date as rental_time
from rental
where customer_id = 35

select customer_id,
avg(return_date-rental_date) as avg_rental_time
from rental
group by customer_id
order by avg(return_date-rental_date) desc 

-- TO_CHAR

