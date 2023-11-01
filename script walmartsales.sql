create database WalmartSales;

CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    groos_margin_perct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
);

-- select * from WalmartSales.sales




-- ---------------------------------------------------------------------------------------
-- ---------------------------------------- Feature Enginerring-----------------------------

-- time_of_day


SELECT
	time,
    (CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
        END
        ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
			WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
			ELSE "Evening"
		END
);

-- day_name

SELECT
	date,
    DAYNAME(date) AS day_name 
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------------------------------

-- -------------------------------------- Business Questions to Answer---------------------------------

-- How many unique cities does the data have?

SELECT
	DISTINCT city
FROM sales;

answer--  yagon, naypyitaw, manday

-- In which city is each branch?

SELECT
	DISTINCT branch
FROM sales;

answer-- A,B,C 

-- answer complete-- 

SELECT
	DISTINCT city,
    branch
FROM sales;

-- -------------------------------------------------------------------------------------------------
-- --------------------------------------Product --------------------------------------------------

-- How many unique product lines does the data have?

SELECT
	COUNT(DISTINCT product_line)
FROM sales;

ANSWER-- 
6

-- What is the most common payment method?

 SELECT
	count(payment_method) as cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Answer--
 309, 349, 344

 -- What is the most selling product line?

 SELECT 
	product_line,
    COUNT(product_line) AS cnt
 FROM sales
 GROUP BY product_line
 ORDER BY cnt DESC;
 
What is the total revenue by month?

 SELECT 
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;   

-- Answer--
January	116291.8680
March	108867.1500
February	95727.3765

-- What month had the largest COGS?

SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- Answer--
January	110754.16
March	103683.00
February	91168.93

-- What product line had the largest revenue?

SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC; 

-- Answer--
Food and beverages	56144.8440
Fashion accessories	54305.8950
Sports and travel	53936.1270
Home and lifestyle	53861.9130
Electronic accessories	53783.2365
Health and beauty	48854.3790 

-- What is the city with the largest revenue?

SELECT
	branch,
    city,
    SUM(total) AS total_revenue
from sales
Group by city, branch
order by total_revenue DESC;

-- Answer--
C	Naypyitaw	110490.7755
A	Yangon	105861.0105
B	Mandalay	104534.6085   

-- What product line had the largest VAT?

SELECT
	product_line,
    AVG(VAT) AS  avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax 

-- Asnwer--
  
Fashion accessories	14.52806181
Electronic accessories	15.15447632
Food and beverages	15.36531029
Health and beauty	15.40661591
Sports and travel	15.75697549
Home and lifestyle	16.03033124

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales. 

-- ---  Which branch sold more products than average product sold?

SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Answer-- 
A	1849
C	1828
B	1795


-- What is the most common product line by gender?

SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC; 

-- Answer-- 
Male	Food and beverages	84
Female	Electronic accessories	83
Male	Fashion accessories	82
Male	Home and lifestyle	81
Female	Home and lifestyle	79
Male	Sports and travel	77
Female	Health and beauty	63 

-- What is the average rating of each product line?

SELECT
	product_line,
    ROUND(AVG(rating), 2) AS avg_rating,
	product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Answer--

Food and beverages	7.11	Food and beverages
Fashion accessories	7.03	Fashion accessories
Health and beauty	6.98	Health and beauty
Electronic accessories	6.91	Electronic accessories
Sports and travel	6.86	Sports and travel
Home and lifestyle	6.84	Home and lifestyle
	

 -- ----------------------------------------------------------------------------------------------------------------
 -- ---------------------------------------------------SALES-------------------------------------------------
 
 
-- Number of sales made in each time of the day per weekday

SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

Answer-- 
Evening	429
Afternoon	376
Morning	190

-- Which of the customer types brings the most revenue?

SELECT
	customer_type,
    SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Asnwer --
Member	163625.1015
Normal	157261.2930 

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Answer -- 

Naypyitaw	16.09010850
Mandalay	15.13020824
Yangon	14.87020798	

-- Which customer type pays the most in VAT?

SELECT
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- Answer --
Member	15.61457214
Normal	15.09805040 
-- -------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------Customer -- ------------------------------------------------------

-- How many unique customer types does the data have?

SELECT
	DISTINCT customer_type
FROM sales;

-- Asnwer --
 Normal
Member 

-- How many unique payment methods does the data have?

SELECT
	DISTINCT payment_method
FROM sales;

-- Answer --
Credit card
Ewallet
Cash

-- What is the most common customer type?  
-- Which customer type buys the most?

SELECT
	customer_type,
    COUNT(*) AS cstm_cnt
FROM sales
GROUP BY customer_type;

 -- Answer --
Normal	496
Member	499

-- What is the gender of most of the customers?

SELECT
	gender,
    COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC; 

-- Answer --
Male	498
Female	497

-- What is the gender distribution per branch?

SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch = 'B'
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Answer --

Male	169
Female	160

-- Which time of the day do customers give most ratings?

SELECT
	time_of_day,
   ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- Aswer --
Evening	6.91
Morning	6.94
Afternoon	7.02
    
-- Which time of the day do customers give most ratings per branch?


SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC; 

-- Answer --

Evening	7.09859
Afternoon	7.06667
Morning	6.97458  	

-- Which day fo the week has the best avg ratings?

SELECT
	day_name,
    ROUND(AVG(rating), 2) AS avg_ratings
FROM sales
GROUP BY day_name
ORDER BY avg_ratings DESC;

 -- Answer --
Monday	7.13
Friday	7.06
Tuesday	7
Sunday	6.99
Saturday	6.9
Thursday	6.89
Wednesday	6.76
  
-- Which day of the week has the best average ratings per branch?

SELECT
	day_name,
    ROUND(AVG(rating), 2) AS avg_ratings
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_ratings DESC;

-- Answer --
Friday	7.31
Monday	7.1
Sunday	7.08
Tuesday	7.06
Thursday	6.96
Wednesday	6.84
Saturday	6.75
  


-- SELECT * FROM walmartsales.sales 







  










 
 







  


