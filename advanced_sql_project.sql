create database practice;
use practice;
select * from ecommerce_advanced;
select count(*) from ecommerce_advanced;
select count(*)customer_name from ecommerce_advanced;
alter table ecommerce_advanced 
add primary key (order_id);
select * from ecommerce_advanced
order by order_id asc;
alter table ecommerce_advanced
modify column customer_name char(100);
select * from ecommerce_advanced;
alter table ecommerce_advanced
modify column gender char(100),
modify column city char(100),
modify column state char(100),
modify column customer_segment char(100),
modify column order_date date,
modify column shipping_date date,
modify column payment_method char(100),
modify column order_status char(100),
modify column product_name char(100),
modify column category char(100);

update ecommerce_advanced
set shipping_date = NULL
where shipping_date = "";

SELECT gender, COUNT(*)
FROM ecommerce_advanced
GROUP BY gender;

SELECT order_status, COUNT(*)
FROM ecommerce_advanced
GROUP BY order_status;
select * from ecommerce_advanced;
DESCRIBE ecommerce_advanced;
select sum(gross_sales) from ecommerce_advanced;

select sum(profit) as profit from ecommerce_advanced;

describe ecommerce_advanced;

SELECT category, SUM(gross_sales) AS total_sales FROM ecommerce_advanced GROUP BY category;
select category , sum(profit) as total_profit from ecommerce_advanced group by category;
select city , sum(gross_sales) as totalsales from ecommerce_advanced group by city;
select state,sum(gross_sales) as total_sales from ecommerce_advanced group by state;
select payment_method,sum(gross_sales) from ecommerce_advanced group by payment_method;
select gender,sum(net_sales) from ecommerce_advanced group by gender;
select customer_segment,sum(net_sales) as total_revenue from ecommerce_advanced group by customer_segment;
select product_name, sum(quantity) as quanatity_sold from ecommerce_advanced group by product_name;
select order_status , sum(gross_sales) as total_sales from ecommerce_advanced group by order_status;

describe ecommerce_advanced;
select product_name, sum(net_sales) as quantity_sold from ecommerce_advanced group by product_name having quantity_sold > 50;
select city, sum(gross_sales) as total_sales from ecommerce_advanced group by city having total_sales > 50000;
select customer_name, sum(order_id) as total_orders from ecommerce_advanced group by customer_name having total_orders > 5;
select category , sum(profit) as total_profit from ecommerce_advanced group by category having total_profit > 500;
select payment_method , sum(order_id) as total_order from ecommerce_advanced group by payment_method having total_order > 100;


select order_id,
       net_sales,
       CASE
           WHEN net_sales > 10000 THEN 'High'
           WHEN net_sales >= 5000 THEN 'Medium'
           ELSE 'Low'
       END AS order_value
FROM ecommerce_advanced;
select max(gross_sales) from ecommerce_advanced;
select min(gross_sales) from ecommerce_advanced;
select avg(gross_sales) from ecommerce_advanced;
select customer_name , gross_sales,
case
when gross_sales > 4000 then 'VIP'
when gross_sales >= 3999 then "PRMIUM"
else "regular"
end as customer_type
from ecommerce_advanced;

describe ecommerce_advanced;
select max(profit) from ecommerce_advanced;
select min(gross_sales) from ecommerce_advanced;
select avg(gross_sales) from ecommerce_advanced;

select order_id,profit,
case
when profit >0 then "profitable"
when profit< 0 then "loss"
else "no profit no loss"
end as profit 
from ecommerce_advanced;

select max(discount) from ecommerce_advanced;
select min(discount) from ecommerce_advanced;
select avg(discount) from ecommerce_advanced;


select discount,
case
when discount >= 0.2 then "highly discounted"
when discount <= 0 then "no discount"
else "medium discounted"
end as total_discount 
from ecommerce_advanced;

-- subquaries
-- Q1 Average customer spending se zyada spend karne wale customers find karo.

select net_sales
from ecommerce_advanced
where net_sales > (select avg(net_sales) from ecommerce_advanced);

-- Average product sales se zyada sales wale products find karo.
select product_name , sum(net_sales) as total_sales from ecommerce_advanced group by product_name having sum(net_sales) 
> ( select avg(net_sales) from ecommerce_advanced);

-- Highest spending customer find karo

select customer_name , sum(gross_sales) from ecommerce_advanced group by customer_name having sum(gross_sales)
> (select max(gross_sales) from ecommerce_advanced ) ;

-- Second-highest spending customer find karo.

SELECT customer_name, total_spending
FROM (
    SELECT customer_name, SUM(gross_sales) AS total_spending
    FROM ecommerce_advanced
    GROUP BY customer_name
) AS customer_totals
WHERE total_spending = (
    SELECT MAX(total_spending)
    FROM (
        SELECT customer_name, SUM(gross_sales) AS total_spending
        FROM ecommerce_advanced
        GROUP BY customer_name
        ORDER BY total_spending DESC
        LIMIT 1 OFFSET 1
    ) AS second_highest
);

-- Average city revenue se zyada revenue generate karne wali cities find karo.

SELECT city, SUM(net_sales) AS city_revenue
FROM ecommerce_advanced
GROUP BY city
HAVING SUM(net_sales) > (
    SELECT AVG(net_sales)
    FROM ecommerce_advanced
); 

SELECT
    city,
    customer_name,
    gross_sales,
    ROW_NUMBER() OVER (
        PARTITION BY city
        ORDER BY gross_sales DESC
    ) AS row_num
FROM ecommerce_advanced;

-- Customers ko spending ke basis par RANK() do.

select 
customer_name,
gross_sales,
rank() over (order by gross_sales desc) as sales_rank
from ecommerce_advanced;

-- Har city ke andar customers ko spending ke basis par rank karo.
select 
city,
customer_name,
gross_sales,
rank() over (partition by city order by gross_sales desc) as city_rank
from ecommerce_advanced;

-- Har category ke andar products ko sales ke basis par rank karo.
select category,product_name,gross_sales,
rank() over (partition by category order by gross_sales desc) as category_rank
from ecommerce_advanced;

-- Har category ke Top 3 products find karo.
SELECT *
FROM (
    SELECT 
        category,
        product_name,
        gross_sales,
        RANK() OVER (
            PARTITION BY category
            ORDER BY gross_sales DESC
        ) AS category_rank
    FROM ecommerce_advanced
) AS ranked_products
WHERE category_rank <= 3;

-- Har city ke Top 3 customers find karo
select * 
from (
select city , customer_name, gross_sales,
rank() over (partition by city order by gross_sales desc) as customer_rank
from ecommerce_advanced) as ranked_constumer where customer_rank <=3;

SELECT
    customer_name,
    order_date,
    gross_sales,
    LAG(gross_sales) OVER (
        PARTITION BY customer_name
        ORDER BY order_date
    ) AS previous_order_sales
FROM ecommerce_advanced;