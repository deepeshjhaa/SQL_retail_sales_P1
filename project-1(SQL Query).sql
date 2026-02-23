create database sql_project_p1;
use sql_project_p1;
Create table sales_data (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,	
gender varchar(15),
age	int,
category varchar(15),
quantiy int,
price_per_unit Float,	
cogs Float,
total_sale float);

select * from Sales_data
limit 10
;
select count( *) from Sales_data
;

select * from sales_data
where transactions_ID is null;

select * from sales_data
where sale_time is null;

select * from sales_data
where sale_time is null
	or
    transactions_ID is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantiy is null
    or
    cogs is null
    or
    total_sale is null;
    
    
-- Data exploration    
-- how many sales we have 
select count(*) as total_sales from sales_data;

-- how many unique customers we have
select count(distinct customer_id) as total_cust from sales_data;

-- How many category
select distinct category  from sales_data;

-- Data Analaysis & business key problem and answer-- 

-- q1. write a sql query to retrive all columns for sales made on 2022-11-05

select * from sales_data
where sale_date= "2022-11-05";

-- q2. write a sql query to retrive all transitions  where  the category  is clothing  and the quantity sold is more than 10 in the month of nov 2022;

select *
from sales_data
where category="Clothing"
and
DATE_FORMAT(sale_date, '%Y-%m')= "2022-11"
and quantiy >=4;

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as net_sales,
count(*) as tota_orders
from Sales_data
group by category;

-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
round(avg(age),2) as avg_age
from sales_data
where category='beauty';

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from sales_data
where total_sale>1000;

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) AS total_sales
FROM sales_data
GROUP BY category, gender
order by 1;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year, month, avg_sales from (
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as ranks
from sales_data
group by 1, 2
) as t1
where ranks=1
;

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales.
select 
customer_id,
sum(total_sale)as total_sales
from sales_data
group by 1 
order by 2 desc
limit 5;


-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) AS unique_cust
from sales_data
group by category;


-- Q10 Write a SQL query to create each shift and number of orders (Example Morning (<12), Afternoon Between 12 & 17, Evening (>17))

with hourly_sales as (
select * ,
case
when extract(HOUR from sale_time) <12 then "Morning"
when extract(HOUR from sale_time) between 12 and 17 then "Afternoon"
else "Evening"
end as shift
from sales_data)
select 
shift, count(*)as total_orders from hourly_sales
group by shift

-- End of project-- 