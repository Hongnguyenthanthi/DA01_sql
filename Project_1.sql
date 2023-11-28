--1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường 
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

alter table sales_dataset_rfm_prj
add column CONTACTLASTNAME varchar(50)

insert into sales_dataset_rfm_prj(CONTACTLASTNAME,CONTACTFIRSTNAME)
(substring(contactfullname from 1 for position('-' in contactfullname)-1),
right(contactfullname,length(contactfullname)-position('-' in contactfullname))

