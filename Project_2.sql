SELECT  format_date('%Y-%m',delivered_at) as year_month, count(order_id) as total_user, count(user_id) as total_order
FROM bigquery-public-data.thelook_ecommerce.orders 
where (format_date('%Y-%m',delivered_at) between '2019-01' and '2022-04') and status ='Complete'
group by 1
order by 1
