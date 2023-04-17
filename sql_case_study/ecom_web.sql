# Case Study - Ecomm Website Analysis

create database sql_case_study
use sql_case_study

create table ecom_web(
event_time varchar(40),
event_type varchar(30),	
product_id	varchar(40),
category_id	varchar(40),
category_code varchar(40),
brand	varchar(40),
price	double,
user_id	varchar(40),
user_session varchar(40));

/*Data has been inserted using command prompt as the data is large, consists of 800000+ rows. If
data is small then import wizard will work fine  but for larger data it will take hours to import.
open cmd prompt, change directory to C:\Program Files\MySQL\MySQL Server 8.0\bin hit enter,
mysql -u root -p enter password- root@12345,
SET GLOBAL local_infile=1 enter, quit, again login - mysql --local-infile=1 -u root -p password,
SHOW DATABASES; , USE database, enter, then -
/*LOAD DATA INFILE
'D:\sql_case_study\events'
into table ecom_web
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;  */

select * from ecom_web;

# created a column 'event_date' where only dates have been stored which are extracted from 'event_time' column.
alter table ecom_web
add column event_date date after event_time;
UPDATE ecom_web
SET event_date = LEFT(event_time,10);

# created a column 'event_time_new' where only dates have been stored which are extracted from 'event_time' column.

alter table ecom_web
add column event_time_new time after event_date;
update ecom_web
set event_time_new = mid(event_time,12,8);


select * from ecom_web
where event_type = "purchase"


# sales of months 

select year(event_date) as year ,month(event_date) as month_number,monthname(event_date) as month,
round(sum(price)) as total_sells
from ecom_web
where event_type = "purchase"
group by month(event_date),year(event_date)
order by sum(price) desc

# top time of visit

select hour(event_time_new),count(1)
from ecom_web 
where event_type='view' or event_type='cart'
group by hour(event_time_new)
order by count(1) desc
limit 6

# top time of purchase

select hour(event_time_new),count(1)
from ecom_web 
where event_type='purchase'
group by hour(event_time_new)
order by count(1) desc
limit 6

# top brand by sale

select brand,count(brand)
from ecom_web
where event_type = "purchase" and brand <> ""
group by brand
order by count(brand) desc
limit 5


# top category by sale

select count(category_code),category_code
from ecom_web
where event_type = "purchase" and category_code <> "" 
group by category_code
order by count(category_code) desc
limit 5

# frequency of purchase

select user_id,count(user_id) as times
from ecom_web
where event_type = "purchase"  
group by user_id
order by count(user_id) desc


select * from ecom_web
