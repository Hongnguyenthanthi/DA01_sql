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

