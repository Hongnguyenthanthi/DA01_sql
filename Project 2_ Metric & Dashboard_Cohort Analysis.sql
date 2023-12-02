SELECT format_date('%Y-%m', a.created_at) as year_month, 
  extract(year from a.created_at) as year, 
  b.category as product_category, 
  sum(c.sale_price) as TPV, 
  count(c.order_id) as TPO,
  lag(format_date('%Y-%m', a.created_at)) over(order by format_date('%Y-%m', a.created_at)) as previous_month,
  lag(sum(c.sale_price)) over(order by sum(c.sale_price) as previous_TPV,
  lag(count(c.order_id)) over(order by count(c.order_id)) as previous_TPO
  sum(b.cost) as total_cost,
  sum(c.sale_price-b.cost) as total_profit,
  sum(c.sale_price-b.cost)/ sum(b.cost) as profit_to_cost_ratio 
FROM bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.products as b
on a.order_id=b.id
join bigquery-public-data.thelook_ecommerce.order_items as c
on a.order_id=c.order_id


  
