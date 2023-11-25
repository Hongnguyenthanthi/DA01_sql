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

-- bai tap 4
-- tạo bảng cte count và row_number, gộp user_id, order by desc (recent transaction date) 
-- select từ bảng cte điều kiện rank1=1 
with twt_new as 
(SELECT 
transaction_date, user_id, 
count(*) over(partition by user_id order by transaction_date desc) as purchase_count,
row_number() over(partition by user_id order by transaction_date desc) as rank1
FROM user_transactions)
select transaction_date, user_id, purchase_count
from twt_new
where rank1=1
order by transaction_date

-- bai tap 5
  SELECT    
  user_id,    
  tweet_date,
  round(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date
    rows between 2 preceding and current row),2) AS rolling_avg_3d
FROM tweets 

-- bai tap 6
-- bảng cte : tạo lag của transaction_timestamp rồi trừ với transaction_timestamp = minute 
-- select, đếm với điều kiện minute < 10 
with twt_new as 
(SELECT *,
lag(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp),
extract (minute from transaction_timestamp - lag(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp))
as minute 
FROM transactions) 
select count( merchant_id)
from twt_new
where minute<10

-- bai tap 7 
-- tạo bảng cte new_table để group by category, product và sum(spend)
-- tạo bảng cte new_table_1 để tạo rank1 
-- select từ new_table_1 điều kiện rank=1 or rank=2
with new_table as 
(select category, product, sum(spend) as total_spend
from product_spend
where extract(year from transaction_date)=2022
group by category, product),
new_table_1 as 
(select *, 
rank() over(partition by category order by total_spend desc) as rank1
from new_table)
select category, product, total_spend
from new_table_1 
where rank1=2 or rank1=1

-- bai tap 8 
-- tạo bảng cte new_table để join 3 bảng lại vs nhau, đếm số lần được rank của mỗi artist_name, điều kiện. rank<=10
-- tạo bảng cte new_table_1 để xếp hạng rank của artist_name bằng số lần count ở trên desc 
-- select từ bảng new_table_1 khi artist_rank<=5 
with new_table as 
(SELECT a.artist_name,
count(artist_name) as ranking
FROM artists as a  
join songs as b 
on a.artist_id=b.artist_id
join global_song_rank as c 
on b.song_id=c.song_id
where c.rank<=10
group by artist_name),
new_table_1 as
(select artist_name,
dense_rank() over(order by ranking desc) as artist_rank
from new_table)
select artist_name, artist_rank
from new_table_1
where artist_rank<=5



