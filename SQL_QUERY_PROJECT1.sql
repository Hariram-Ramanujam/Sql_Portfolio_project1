--Sql Retail sales analysis - P1
create database Sql_project_2


--create table
create table retail_sales(
         transactions_id  INT PRIMARY KEY,
         sale_date  DATE,
         sale_time   TIME,
         customer_id	INT,
		 gender  VARCHAR(15),
         age  INT,
         category  VARCHAR(15),
         quantiy  INT,
         price_per_unit  FLOAT,
         cogs  FLOAT,
         total_sale  FLOAT

)

select * from retail_sales
limit 10;

--count the records
select count(*) from retail_sales;

--DATA CLEANING

--null handling
select * from retail_sales
where transactions_id is NULL;

--To check Null in the rest of the columns
select * from retail_sales
where sale_date is NULL;

select * from retail_sales
where sale_date is NULL;


--To write one code instead of writing multiple code to see null
select * from retail_sales
where 
transactions_id is NULL
or
sale_date is NULL
or
sale_date is NULL
or
customer_id is NULL
or
gender is NULL
or 
category is NULL
or
quantiy is NULL
or
price_per_unit is NULL
or 
cogs is NULL
or
total_sale is NULL;

-- Delete the NULL rows
delete from retail_sales
where 
transactions_id is NULL
or
sale_date is NULL
or
sale_date is NULL
or
customer_id is NULL
or
gender is NULL
or 
category is NULL
or
quantiy is NULL
or
price_per_unit is NULL
or 
cogs is NULL
or
total_sale is NULL;

--DATA EXPLORATION 

-- How sales we have?

Select count(*) as total_sales from Retail_sales;

--How many unique customers we have?

Select count(distinct customer_id) as total_customers from Retail_sales;

--How many unique categories we have and what are they?

Select count(distinct category) as total_categories from Retail_sales;

Select distinct category as category_list from Retail_sales;

-- DATA ANALYSIS and BUSINESS Key problem and answer

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales
where
 category = 'clothing'
 and 
 to_char(sale_date,'YYYY-MM') = '2022-11'
 and 
 quantiy >= 4
;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS net_sale, count(*) as total_orders
FROM retail_sales
WHERE category IN ('Clothing', 'Electronics', 'Beauty')
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select ROUND(avg(age),3) AS AVG_AGE from retail_sales
where category = 'Beauty'
;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM RETAIL_SALES
WHERE TOTAL_SALE > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT CATEGORY,
        GENDER,
		COUNT(*)
		FROM RETAIL_SALES
		GROUP BY CATEGORY, GENDER
		ORDER BY CATEGORY, GENDER;
		
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        ROUND(AVG(total_sale)::numeric, 3) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY ROUND(AVG(total_sale)::numeric, 3) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT CUSTOMER_ID,
        SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY 1
ORDER BY TOTAL_SALES DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT CATEGORY,
       COUNT(DISTINCT CUSTOMER_Id) AS UNIQUE_CUSTOMER
	   FROM RETAIL_SALES
GROUP BY 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_TABLE
AS
(
SELECT *,
         CASE
		    WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
		    WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		    ELSE 'EVENING'
		 END AS SHIFT
FROM RETAIL_SALES
) 

SELECT 
       SHIFT,
	   COUNT(*) AS TOTAL_ORDERS
	   FROM HOURLY_TABLE
	   GROUP BY 1


--END OF PROJECT