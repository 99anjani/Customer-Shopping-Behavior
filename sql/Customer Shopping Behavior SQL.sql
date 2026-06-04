select * from customer

--Customer revenue analysis by gender.
select gender, sum(purchase_amount) as revenue
from customer
group by gender

--Identifies customers who applied a discount and still spent above the overall average purchase amount
select customer_id, purchase_amount from customer
where discount_applied = 'Yes' and purchase_amount > (select avg(purchase_amount) from customer)


--Product satisfaction analysis.
select item_purchased, avg(review_rating) as avg_review_rate
from customer
group by (item_purchased)
order by (avg_review_rate) desc
limit 5

--Shipping method comparison (Standard vs Express Shipping)
select shipping_type, round(avg(purchase_amount),2) as avg_purchase_amount
from customer
where shipping_type in ('Standard','Express')
group by (shipping_type)

--Subscription impact on customer spending behavior.

select subscription_status, COUNT(customer_id) AS total_customers, 
round(avg(purchase_amount),2) as avg_purchase_amount, sum(purchase_amount) as total_revenue
from customer
group by subscription_status
order by total_revenue

--Discount utilization analysis by product

select item_purchased, round(100* sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5


--Customer segmentation based on purchase history.
with customer_type as (
select customer_id, previous_purchases, 
case 
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from customer
)
--select * from customer_type
select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

--Product popularity analysis within categories.
with item_count as (
select item_purchased, count(customer_id) as total_orders, category,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY count(customer_id) DESC) AS item_rank
from customer
group by item_purchased, category
)

select item_rank,item_purchased, category, total_orders
from item_count
where item_rank <=3

 
--Subscription tendency among repeat buyers.
select COUNT(customer_id) AS repeat_buyers, subscription_status
from customer
where previous_purchases > 5 
group by subscription_status


--Revenue contribution analysis by age group.
select age_group , sum(purchase_amount) as revenue
from customer
group by age_group
order by revenue desc


--Product performance analysis.
select item_purchased, sum(purchase_amount), avg(purchase_amount) as avg_purchased
from customer
group by item_purchased
order by avg_purchased desc
