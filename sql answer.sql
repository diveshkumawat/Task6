CREATE DATABASE retail_sale_project;

-- create table 

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- DATA CLEANING
-- for check null present in which table

select * from retail_sales
WHERE   
		transactions_id is nulL 
		OR
		sale_date is nulL 
		OR
		customer_id is null 
		OR
		gender is null 
		OR
		age is null 
		OR
		category is null 
		OR
		price_per_unit is null 
		OR
		cogs is null 
		OR
		total_sale is null;

-- to delete null values tables from database

delete from  retail_sales
WHERE   
		transactions_id is nulL 
		OR
		sale_date is nulL 
		OR
		customer_id is null 
		OR
		gender is null 
		OR
		age is null 
		OR
		category is null 
		OR
		price_per_unit is null 
		OR
		cogs is null 
		OR

select count(*) from retail_sales;

alter table retail_sales
rename column quantiy to quantity

-- DATA EXPLORATIONS
-- Q) how many sales we have 
select count(*) as total_sale from retail_sales; 

-- how many unique customer we have
select count(distinct customer_id) as total_customer from retail_sales; 

-- unique category we have
select distinct category as category from retail_sales; 

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where sale_date= '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales
where category='Clothing' and to_char(sale_date,'YYYY,MM') = '2022,11'
AND quantity>=3;
	 

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as avg_age_beauty from retail_sales
where category= 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender,count(transactions_id) from retail_sales
group by category, gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year,month, av_sale from
(select Extract(year from sale_date) as year
	   Extract(month from sale_date) as month
	   avg(total_sale) as avg_sale
	   rank() over(partition by extract(year from sale_date order by avg(total_sale) desc) as rank
from retail_sales
group by year, month ) as table2
where rank=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id, sum(total_sale) as sum_sale from retail_sales 
group by customer_id 
order by sum_sale desc limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count(distinct customer_id) from retail_sales 
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select shifts, count(quantity) from 
(select *,
	CASE 
	when extract(HOUR from sale_time)<12 then 'Morning' 
	when extract(HOUR from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shifts
from retail_sales)
group by shifts;
