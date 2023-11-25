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

-- bai tap 2
-- tạo bảng cte rank theo năm, tháng và gộp card_name 
-- select từ bảng cte điều kiện rank=1
with twt_new AS
(SELECT *,
rank() over(partition by card_name order by issue_year, issue_month) as rank1
FROM monthly_cards_issued)
select card_name, issued_amount
from twt_new
where rank1=1
order by issued_amount desc  

-- bai tap 3
-- tạo bảng cte rank theo transaction_date, gộp user_id 
-- select từ bảng cte điều kiện rank=3
with twt_new AS
(SELECT user_id, spend, transaction_date,
rank() over(partition by user_id order by transaction_date) as rank1
FROM transactions)
select user_id, spend, transaction_date
from twt_new
where rank1=3
