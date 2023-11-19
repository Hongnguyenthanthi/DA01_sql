-- bai tap 1
select count(distinct company_id) from
(SELECT company_id, title, description, count(*)
FROM job_listings
group by company_id, title, description
having count(*)>=2) as a

