select * from customer;
select * from sales;
select * from segment_score;
with customer_rfm as (
select a.customer_id, current_date-max(order_date) as R,
count(distinct order_id) as F,
sum(sales) as M
from customer as a 
join sales as b
on a.customer_id=b.customer_id
group by a.customer_id),
rfm_score as(
select customer_id,
ntile(5) over(order by R desc) as R_score,
ntile(5) over(order by F) as F_score,
ntile(5) over(order by M) as M_score 
from customer_rfm),
rfm_final as (
select customer_id, 
cast (R_score as varchar)||cast(F_score as varchar)||cast(M_score as varchar) as rfm_score
from rfm_score)
select segment,count(*) from (
select c.customer_id,d.segment from rfm_final as c
join segment_score as d
on c.rfm_score=d.scores) as a
group by segment 
order by count(*)
