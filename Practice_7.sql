-- bai tap 1
-- tạo bảng cte có trường prev_year_end 
-- select từ bảng cte và tính yoy_rate
with twt_new
as 
(SELECT extract(year from transaction_date) as year, product_id,spend as curr_year_spend,
lag(spend) over(partition by product_id) as prev_year_spend
FROM user_transactions)
select year, product_id, curr_year_spend, prev_year_spend,
round((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate 
from twt_new

