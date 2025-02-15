
CREATE DATABASE PIZZA_SALES;
USE PIZZA_SALES;





-- Q.1) Retrieve the total number of orders placed.

select count(order_id) as No_of_orders  from orders


-- Q.2) Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2) as Revenue 
from order_details
inner join pizzas
on order_details.pizza_id =pizzas.pizza_id


-- Q.3) Identify the highest-priced pizza.

select top 1 PIZZA_TYPES.name,round(PIZZAS.price,2) as price
from PIZZA_TYPES
inner join PIZZAS
on PIZZA_TYPES.pizza_type_id = PIZZAS.pizza_type_id
order by price desc;


-- Q.4) Identify the most common pizza size ordered.

select pizzas.size,sum(order_details.quantity) as order_count
from pizzas 
inner join order_details
on pizzas.pizza_id = ORDER_DETAILS.pizza_id
group by pizzas.size;


-- Q.5) List the top 5 most ordered pizza types along with their quantities.

select top 5 PIZZA_TYPES.name, sum(ORDER_DETAILS.quantity) as quantity
from PIZZA_TYPES
inner join PIZZAS
on PIZZA_TYPES.pizza_type_id = PIZZAS.pizza_type_id
inner join order_details
on PIZZAS.pizza_id = ORDER_DETAILS.pizza_id
group by PIZZA_TYPES.name
order by quantity desc;


-- Q.6) Join the necessary tables to find the total quantity of each pizza category ordered.

select PIZZA_TYPES.category, sum(ORDER_DETAILS.quantity) as quantity
from PIZZA_TYPES
inner join PIZZAS
on PIZZA_TYPES.pizza_type_id = PIZZAS.pizza_type_id
inner join ORDER_DETAILS
on PIZZAS.pizza_id = ORDER_DETAILS.pizza_id
group by PIZZA_TYPES.category 
order by quantity desc;


-- Q.7) Determine the distribution of orders by hour of the day.

select datepart(hour,time) as hour ,count(order_id) as id from orders
group by datepart(hour,time)
order by id desc


-- Q.8) Join relevant tables to find the category-wise distribution of pizzas.

select category,count(name) quantity
from PIZZA_TYPES
group by category
order by quantity desc;


-- Q.9) Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(quantity) as avg_quantity
from
   (select orders.date,sum(order_details.quantity) as quantity
   from orders
   inner join order_details
   on orders.order_id = order_details.order_id
   group by orders.date) as avg_quantity;

-- Q.10) Determine the top 3 most ordered pizza types based on revenue.

select top 3 PIZZA_TYPES.name,sum(ORDER_DETAILS.quantity * pizzas.price) as revenue
from pizza_types
inner join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by PIZZA_TYPES.name
order by revenue desc;


-- Q.11) Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
	concat(round(sum(order_details.quantity * pizzas.price) / 
		  (select sum(order_details.quantity * pizzas.price) 
		  from order_details
		  inner join pizzas
		  on order_details.pizza_id = pizzas.pizza_id)*100 ,2),'%') as revenue
from pizza_types
inner join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category



-- Q.12) Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select category, name, revenue, row_number() over(partition by category order by revenue)
from
(select pizza_types.category,pizza_types.name,sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
inner join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category ,pizza_types.name) as a



SELECT * FROM ORDER_DETAILS
SELECT * FROM ORDERS
SELECT * FROM PIZZA_TYPES
SELECT * FROM PIZZAS
