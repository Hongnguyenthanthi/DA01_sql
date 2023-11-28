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
