
use data_analytics;

create table customers ( vendor_id int, vendor_name varchar(20));

insert into customers (vendor_id , vendor_name ) values 
(1, 'AlphaCrop'),
(2, 'BetaTech'),
(3, 'NovaWare'),
(4, 'PixelHub');

create table orders ( product_id int, vendor_id int);

insert into orders (product_id, vendor_id) values 
(100, 1),
(101, 1),
(102, 2),
(103, 3),
(104, 4);

create table order_items ( product_id int, quantity int, unit_price int);

insert into order_items (product_id, quantity, unit_price) values 
(100, 2, 300),
(100, 1, 200),
(101, 3, 100),
(102, 5, 100),
(103, 1, 450),
(104, 2, 200);

-- solution using a Common Joins

select
c.vendor_name,
sum(i.quantity * i.unit_price) as total_revenue
from customers c
left join orders o
	on c.vendor_id = o.vendor_id
left join order_items i
	on o.product_id = i.product_id
group by c.vendor_name
having total_revenue >1000;

-- Solution using CTE table

with product_sale_detail as(
select 
c.vendor_id, 
c.vendor_name, 
i.quantity * i.unit_price as revenue
from customers c
left join orders o
	on c.vendor_id = o.vendor_id
left join order_items i
	on o.product_id = i.product_id
)

select vendor_name, sum(revenue) as total_revenue
from product_sale_detail
group by vendor_name
having total_revenue >1000;

-- Using Temporary tables

create temporary table product_sales as 
select c.vendor_id, c.vendor_name, o.product_id
from customers c
left join  orders o 
on c.vendor_id = o.vendor_id;

select * from product_sales;

create temporary table detail_table as
select 
p.*,
oi.quantity,
oi.unit_price
from product_saless p
left join order_items oi
on p.product_id = oi.product_id;

select * from detail_table;

select  vendor_name, sum(quantity * unit_price) as total_revenue from detail_table group by	vendor_name having total_revenue > 1000;
