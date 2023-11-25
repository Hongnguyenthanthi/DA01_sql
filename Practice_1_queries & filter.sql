–- bai tap 1 
select NAME from CITY
where POPULATION > 120000 and COUNTRYCODE = 'USA'

–- bai tap 2
select * from CITY 
where COUNTRYCODE = 'JPN'

–- bai tap 3
select CITY, STATE from STATION

–- bai tap 4
select distinct CITY from STATION
where CITY like 'a%' or CITY like 'e%' or CITY like 'i%' or CITY like 'o%' or CITY like 'u%' or CITY like 'A%' or CITY like 'E%' or CITY like 'I%' or CITY like 'O%' or CITY like 'U%'

–- bai tap 5 
select distinct CITY from STATION
where CITY like '%A' or CITY like '%E' or CITY like '%I' or CITY like '%O' or CITY like '%U'

–- bai tap 6 
select distinct CITY from STATION 
where not (CITY like 'A%' or CITY like 'E%' or CITY like 'I%' or CITY like 'O%' or CITY like 'U%')

–- bai tap 7
select name from Employee 
order by name

–- bai tap 8 
select name from Employee 
where salary > 2000
and months < 10 
order by employee_id 

–- bai tap 9 
select product_id from Products
where low_fats ='Y'
and recyclable = 'Y'

–- bai tap 10 
select name from Customer
where referee_id != 2 or referee_id is null

–- bai tap 11
select name, population, area from World
where area >= 3000000
or population >= 25000000

—- bai tap 12
select distinct author_id as id
from Views
where author_id = viewer_id
order by id

—- bai tap 13
SELECT part, assembly_step FROM parts_assembly
where finish_date is null

—- bai tap 14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000

–- bai tap 15
select * from uber_advertising
where money_spent > 100000 and year = 2019




 

