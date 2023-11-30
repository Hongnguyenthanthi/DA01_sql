SELECT  format_date('%Y-%m',delivered_at) as year_month, count(order_id) as total_order, count(user_id) as total_user
FROM bigquery-public-data.thelook_ecommerce.orders 
where (format_date('%Y-%m',delivered_at) between '2019-01' and '2022-04') and status ='Complete'
group by 1
order by 1
-> nhận xét: số lượng đơn hàng và số lượng người dùng tăng theo thời gian từ t1/2019 đến t4/2022

SELECT  format_date('%Y-%m',a.delivered_at) as year_month, sum(b.sale_price)/count(a.order_id) as average_order_value, count(distinct a.user_id) as distinct_users
FROM bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b 
on a.order_id=b.order_id
where (format_date('%Y-%m',a.delivered_at) between '2019-01' and '2022-04') 
group by 1
order by 1
-> nhận xét: giá trị đơn hàng trung bình và tổng số người dùng khác nhau tăng theo thời gian từ t1/2019 đến t4/2022

with dense_rank_age as (select *,
dense_rank() over(partition by gender order by age) as age_rank
from bigquery-public-data.thelook_ecommerce.users),
dense_rank_age_desc as (select *,
dense_rank() over(partition by gender order by age desc) as age_rank_desc
from bigquery-public-data.thelook_ecommerce.users),
tag_table as (select *, case when age_rank=1 then 'youngest' end as tag from dense_rank_age where age_rank=1
union all 
select *, case when age_rank_desc=1 then 'oldest' end as tag from dense_rank_age_desc where age_rank_desc=1)
select tag, age, gender, count(tag) as number_of_people
from tag_table
group by tag, age, gender 
-> nhận xét: trẻ nhất là 12 tuổi, số lượng là 1682 người, 831 nữ, 851 nam; lớn nhất là 70 tuổi, số lượng là 1717 người, 843 nữ, 874 nam. 

