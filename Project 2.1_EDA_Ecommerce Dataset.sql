-- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT  format_date('%Y-%m',created_at) as year_month, count(order_id) as total_order, count(user_id) as total_user
FROM bigquery-public-data.thelook_ecommerce.orders 
where (format_date('%Y-%m',created_at) between '2019-01' and '2022-04') and status ='Complete'
group by 1
order by 1
-> nhận xét: số lượng đơn hàng và số lượng người dùng tăng theo thời gian từ t1/2019 đến t4/2022
  
-- 2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
SELECT  format_date('%Y-%m',a.created_at) as year_month, 
round(avg(b.sale_price),2) as average_order_value, 
count(distinct a.user_id) as distinct_users
FROM bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b 
on a.order_id=b.order_id
where (format_date('%Y-%m',a.created_at) between '2019-01' and '2022-04') 
group by 1
order by 1
-> nhận xét: giá trị đơn hàng trung bình và tổng số người dùng khác nhau tăng theo thời gian từ t1/2019 đến t4/2022
  
-- 3. Nhóm khách hàng theo độ tuổi
create temp table customer_age as 
(with dense_rank_age as 
(select *,
dense_rank() over(partition by gender order by age) as age_rank
from bigquery-public-data.thelook_ecommerce.users),
dense_rank_age_desc as 
(select *,
dense_rank() over(partition by gender order by age desc) as age_rank_desc
from bigquery-public-data.thelook_ecommerce.users),
tag_table as 
(select *, 
case when age_rank=1 then 'youngest' end as tag 
from dense_rank_age 
where age_rank=1
union all 
select *, 
case when age_rank_desc=1 then 'oldest' end as tag 
from dense_rank_age_desc 
where age_rank_desc=1)
select tag, age, gender, count(tag) as number_of_people
from tag_table
group by tag, age, gender)
 
select * from customer_age 
-> nhận xét: trẻ nhất là 12 tuổi, số lượng là 1682 người, 831 nữ, 851 nam; lớn nhất là 70 tuổi, số lượng là 1717 người, 843 nữ, 874 nam. 

 -- 4. Top 5 sản phẩm mỗi tháng 

  with rank_per_month_table as 
(select format_date('%Y-%m',a.created_at) as year_month, 
b.id as product_id, b.name as product_name, round((a.sale_price-b.cost),2) as profit, 
dense_rank() over(partition by format_date('%Y-%m',a.created_at) order by (a.sale_price-b.cost)) as rank_per_month
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id)
select * from rank_per_month_table 
where rank_per_month <=5
order by year_month

-- 5. Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục

with new_table as 
(select date(a.created_at) as year_month_day, 
b.category as product_category, round(sum(a.sale_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
group by 1, 2)
select * from new_table 
where year_month_day>=date_sub(date'2022-04-15', interval 3 month) and year_month_day<=date'2022-04-15'
order by year_month_day, product_category

