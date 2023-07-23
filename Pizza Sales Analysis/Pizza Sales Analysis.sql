--Dataset : Pizza sales data - 2015
--Schema : /*
pizza_id - int  primary_key	
order_id - int	
pizza_name_id - varchar(20)	
Quantity - int	
order_date - date	
order_time - timestamp	
unit_price - int	
total_price - int	
pizza_size - varchar(10) 	
pizza_category - varchar(15) 	
pizza_ingredients - varchar(80) 	
pizza_name - varchar(50)   */
--Nature of data - Structured
--Number of record - 48621
--Queried using: MySQL

-- #Gathering & Cleaning the Data using MySQL Workbench :

--Updated date records from ‘01-01-2015’ to ‘01/01/2015’ :
UPDATE pizza_sales SET order_date = REPLACE(order_date, '-' , '/');

--Converted data type from string to date & changed date format from ‘01/01/2015’ to ‘2015/01/01’ :
UPDATE pizza_sales SET order_date = DATE_FORMAT(STR_TO_DATE (order_date,"%d/%m/%Y"),"%y/%m/%d");

-- #Analysing the Data using MySQL Workbench :
-- #Key Performance Indicators :

--Total Revenue
SELECT ROUND(SUM(total_price),2) as Total_Revenue FROM pizza_sales;

--Average Order Value
SELECT ROUND((SUM(total_price) / COUNT(DISTINCT(order_id))),2)  as Average_Order_Value FROM pizza_sales;

--Total Pizzas Sold
SELECT SUM(quantity) Total_Pizzas_Sold FROM pizza_sales;

--Total Orders
SELECT COUNT(DISTINCT(order_id)) Total_Orders FROM pizza_sales;

--Average pizzas per order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT(order_id)) , 2) as Average_Pizzas_Per_Order FROM pizza_sales;

-- #Finding trends :

--Daily trend for total orders
SELECT DAYNAME(order_date) as Order_Day, COUNT(DISTINCT(order_id)) as Total_Orders FROM pizza_sales GROUP BY dayname(order_date);

--Hourly trend for total orders
SELECT HOUR(order_time) as Order_Time , COUNT(DISTINCT(order_id)) as Total_Order from pizza_sales GROUP BY hour(order_time);

--Monthly trend for total orders
SELECT MONTHNAME(order_date) as Month , COUNT(DISTINCT(order_id)) as Total_Order from pizza_sales GROUP BY monthname(order_date);

--Percentage of sales by pizza category
select pizza_category , round(sum(total_price),2) as Total_Sales, 
round(sum(total_price) / (select sum(total_price) from pizza_sales),4) * 100 as Ptg_Sale_Per_Category from pizza_sales group by pizza_category;

--Percentage of sales by pizza size
select pizza_size , round(sum(total_price),2) as Total_Sales,
round(((sum(total_price) / (select sum(total_price) from pizza_sales)) * 100),2) as Total_Ptg    from pizza_sales group by pizza_size;

--Total pizzas sold by category 
select pizza_category , sum(quantity) as Total_Sales from pizza_sales group by pizza_category;

--Top 5 best sellers by Revenue
select pizza_name , sum(total_price) total_Sales
from pizza_sales group by pizza_name order by sum(total_price) desc
limit 5;

--Bottom 5 best sellers by Revenue
select pizza_name , sum(total_price) total_Sales
from pizza_sales group by pizza_name order by sum(total_price) asc
limit 5;

--Top 5 best sellers by Quantity
select pizza_name , sum(quantity) Total_Quantity
from pizza_sales group by pizza_name order by sum(quantity) desc limit 5;

--Bottom 5 best sellers by Quantity
select pizza_name , sum(quantity) Total_Quantity
from pizza_sales group by pizza_name order by sum(quantity) asc limit 5;

--Top 5 best sellers by Orders
select pizza_name , count(distinct(order_id)) Total_Orders from pizza_sales group by pizza_name order by count(distinct(order_id)) desc limit 5;

--Bottom 5 best sellers by Orders
select pizza_name , count(distinct(order_id)) Total_Orders from pizza_sales group by pizza_name order by count(distinct(order_id)) asc limit 5;
