-- 1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj
alter column ordernumber type int using (trim(ordernumber)::int);

ALTER TABLE sales_dataset_rfm_prj
alter column quantityordered type int using (trim(quantityordered)::int);

ALTER TABLE sales_dataset_rfm_prj
alter column orderlinenumber type int using (trim(orderlinenumber)::int);

ALTER TABLE sales_dataset_rfm_prj
alter column sales type numeric using (trim(sales)::numeric); 

ALTER TABLE sales_dataset_rfm_prj
alter column orderdate type timestamp using (trim(orderdate)::timestamp)
  
-- 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME 
alter table sales_dataset_rfm_prj
add column CONTACTLASTNAME varchar(50)

alter table sales_dataset_rfm_prj
add column CONTACTFIRSTNAME varchar(50)

update public.sales_dataset_rfm_prj
set contactfirstname = substring(contactfullname from 1 for position('-'in contactfullname)-1)

update public.sales_dataset_rfm_prj
set contactlastname = right(contactfullname,length(contactfullname)- position('-'in contactfullname))

  
 -- Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
update public.sales_dataset_rfm_prj
set contactlastname = upper(left(contactlastname,1)) || lower(right(contactlastname,length(contactlastname)-1))

update public.sales_dataset_rfm_prj
set contactfirstname = upper(left(contactfirstname,1)) || lower(right(contactfirstname,length(contactfirstname)-1))

 -- 4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
alter table sales_dataset_rfm_prj
add column QTR_ID INTEGER

alter table sales_dataset_rfm_prj
add column MONTH_ID INTEGER

alter table sales_dataset_rfm_prj
add column YEAR_ID INTEGER

update public.sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM ORDERDATE)

update public.sales_dataset_rfm_prj
SET YEAR_ID = EXTRACT(YEAR FROM ORDERDATE)

update public.sales_dataset_rfm_prj
SET QTR_ID = CASE WHEN MONTH_ID BETWEEN 1 AND 3 THEN 1 
WHEN MONTH_ID BETWEEN 4 AND 6 THEN 2 
WHEN MONTH_ID BETWEEN 7 AND 9 THEN 3
WHEN MONTH_ID BETWEEN 10 AND 12 THEN 4 END 

-- 5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED (2 cách) 
-- cách 1
with twt_min_max_value as 
(select Q1-1.5*IQR as min_value, 
Q3+1.5*IQR as max_value from 
(SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as Q1,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) as Q3,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED)
- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as IQR
from public.sales_dataset_rfm_prj) as a)
select * from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from twt_min_max_value)
or quantityordered > (select max_value from twt_min_max_value)

-- cách 2	
with cte as 
(select quantityordered, 
(select avg(quantityordered) as avg from public.sales_dataset_rfm_prj),			 
(select stddev(quantityordered) as stddev from public.sales_dataset_rfm_prj) 
from public.sales_dataset_rfm_prj)
select quantityordered, (quantityordered-avg)/stddev as z_score
from cte 
where abs((quantityordered-avg)/stddev)>3

-- cách xử lý cho bản ghi đó
-- cách 1
delete from public.sales_dataset_rfm_prj
where quantityordered in (with twt_min_max_value as (select Q1-1.5*IQR as min_value, 
Q3+1.5*IQR as max_value from 
(SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as Q1,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) as Q3,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED)
- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as IQR
from public.sales_dataset_rfm_prj) as a)
select quantityordered from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from twt_min_max_value)
or quantityordered > (select max_value from twt_min_max_value))
	
delete from public.sales_dataset_rfm_prj
where quantityordered in 
(with cte as 
(select quantityordered, (select avg(quantityordered) as avg
			from public.sales_dataset_rfm_prj),			 
(select stddev(quantityordered) as stddev
from public.sales_dataset_rfm_prj) from public.sales_dataset_rfm_prj)
select quantityordered
from cte 
where abs((quantityordered-avg)/stddev)>3)
	
-- 6. Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới tên là SALES_DATASET_RFM_PRJ_CLEAN
create table sales_dataset_rfm_prj_clean as 
(select * from sales_dataset_rfm_prj)
