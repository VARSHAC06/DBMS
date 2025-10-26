-- Lab Experiment 05: To implement different types of joins: Inner Join, Outer Join (Left, Right, Full), and Natural Join.

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- STUDENT NAME: JANHAVI B 
-- USN: 1RUA24BCA037
-- SECTION: A
-- -----------------------------------------------------------------------------------------------------------------------------------------
SELECT USER(), 
       @@hostname AS Host_Name, 
       VERSION() AS MySQL_Version, 
       NOW() AS Current_Date_Time;

-- 'root@localhost', 'RVU-PC-007', '8.4.6', '2025-09-22 05:53:48'

-- Write your code below this line along with the output 

-- table 01: Customers
-- CREATE  a TABLE named Customers (customer_id INT PRIMARY KEY,customer_name VARCHAR(50),city VARCHAR(50)

-- insert 5 records

-- TABLE:02 Orders Table

-- CREATE a TABLE named Orders (order_id INT PRIMARY KEY,customer_id INT foreign key,product_name VARCHAR(50),order_date DATE,
    -- insert 5 records

create database LAB5;
use LAB5;

-- TASK FOR STUDENTS 
create table  Customers (
    customer_id int primary key ,
    customer_name varchar(50),
    city varchar (50)
);

insert into Customers values
(1, 'Ramya', 'Bangalore'),
(2, 'Yash', 'Mumbai'),
(3, 'Radhika', 'Bangalore'),
(4, 'Puneet', 'Delhi'),
(5, 'Sudeep', 'Bangalore');

create table Orders (
    order_id int primary key,
    customer_id int,
    product_name varchar(50),
    order_date date,
    foreign key (customer_id) references  Customers(customer_id)
);

insert Orders values
(101, 1, 'Laptop', '2025-09-15'),
(102, 2, 'Smartphone', '2025-09-16'),
(103, 3, 'Tablet', '2025-09-17'),
(104, 4, 'Monitor', '2025-09-18'),
(105, 5, 'Keyboard', '2025-09-19');

 -- Write and Execute Queries
/*
1. Inner Join – 
   Find all orders placed by customers from the city "Bangalore."
   List all customers with the products they ordered.
   Show customer names and their order dates.
   Display order IDs with the corresponding customer names.
   Find the number of orders placed by each customer.
   Show city names along with the products ordered by customers.
*/
select  c.customer_name, o.product_name, o.order_date
from Customers c
inner join  Orders o on c.customer_id = o.customer_id
where c.city = 'Bangalore';
/*'Ramya', 'Laptop', '2025-09-15'
'Radhika', 'Tablet', '2025-09-17'
'Sudeep', 'Keyboard', '2025-09-19'*/

select c.customer_name, o.product_name
from Customers c 
inner join  Orders o on c.customer_id = o.customer_id;
/*'Ramya', 'Laptop'
'Yash', 'Smartphone'
'Radhika', 'Tablet'
'Puneet', 'Monitor'
'Sudeep', 'Keyboard'*/

select c.customer_name, o.order_date
from Customers c
inner join  Orders o on c.customer_id = o.customer_id;
/*'Ramya', '2025-09-15'
'Yash', '2025-09-16'
'Radhika', '2025-09-17'
'Puneet', '2025-09-18'
'Sudeep', '2025-09-19'*/

select o.order_id, c.customer_name
from Orders o
inner join  Customers c on  o.customer_id = c.customer_id;
/*'101', 'Ramya'
'102', 'Yash'
'103', 'Radhika'
'104', 'Puneet'
'105', 'Sudeep'*/

select c.customer_name, COUNT(o.order_id) as number_of_orders
from Customers c
inner join  Orders o on c.customer_id = o.customer_id
group by c.customer_name;
/*'Ramya', '1'
'Yash', '1'
'Radhika', '1'
'Puneet', '1'
'Sudeep', '1'*/

select c.city, o.product_name
from Customers c
inner join Orders o on c.customer_id = o.customer_id;
/*'Bangalore', 'Laptop'
'Mumbai', 'Smartphone'
'Bangalore', 'Tablet'
'Delhi', 'Monitor'
'Bangalore', 'Keyboard'*/

/*
2  Left Outer Join – 
    Find all customers and their orders, even if a customer has no orders.
    List all customers and the products they ordered.
    Show customer IDs, names, and their order IDs.
    Find the total number of orders (if any) placed by each customer.
    Retrieve customers who have not placed any orders.
	Display customer names with their order dates.
-- Write your code below this line along with the output 
*/
select c.customer_id, c.customer_name, o.order_id, o.product_name
from Customers c
left join Orders o on c.customer_id = o.customer_id;
/*'1', 'Ramya', '101', 'Laptop'
'2', 'Yash', '102', 'Smartphone'
'3', 'Radhika', '103', 'Tablet'
'4', 'Puneet', '104', 'Monitor'
'5', 'Sudeep', '105', 'Keyboard'*/

select c.customer_name, o.product_name
from Customers c
left join Orders o on c.customer_id = o.customer_id;
/*'1', 'Ramya', '101', 'Laptop'
'2', 'Yash', '102', 'Smartphone'
'3', 'Radhika', '103', 'Tablet'
'4', 'Puneet', '104', 'Monitor'
'5', 'Sudeep', '105', 'Keyboard'*/

select c.customer_id, c.customer_name, o.order_id
from Customers c
left join Orders o on c.customer_id = o.customer_id;
/*'1', 'Ramya', '101'
'2', 'Yash', '102'
'3', 'Radhika', '103'
'4', 'Puneet', '104'
'5', 'Sudeep', '105'*/

select c.customer_name, COUNT(o.order_id) as total_orders
from Customers c
left join Orders o on c.customer_id = o.customer_id
group by c.customer_name;
/*'Ramya', '1'
'Yash', '1'
'Radhika', '1'
'Puneet', '1'
'Sudeep', '1'*/

select c.customer_id, c.customer_name
from Customers c
left join Orders o on c.customer_id = o.customer_id
where o.order_id is  null;

select c.customer_name, o.order_date
from Customers c
left join Orders o on c.customer_id = o.customer_id;
/*'Ramya', '2025-09-15'
'Yash', '2025-09-16'
'Radhika', '2025-09-17'
'Puneet', '2025-09-18'
'Sudeep', '2025-09-19'*/

/* 3: Right Outer Join – 
      Find all orders and their corresponding customers, even if an order doesn't have a customer associated with it.
      Show all orders with the customer names.
      Display product names with the customers who ordered them.
	  List order IDs with customer cities.
      Find the number of orders per customer (include those without orders).
	  Retrieve customers who do not have any matching orders.
     Write your code below this line along with the output 
 */
select o.order_id, c.customer_name
from Orders o
right join Customers c on o.customer_id = c.customer_id;
/*'101', 'Ramya'
'102', 'Yash'
'103', 'Radhika'
'104', 'Puneet'
'105', 'Sudeep'*/

select o.order_id, c.customer_name
from Customers c
right join Orders o on o.customer_id = c.customer_id;
/*'101', 'Ramya'
'102', 'Yash'
'103', 'Radhika'
'104', 'Puneet'
'105', 'Sudeep'*/

select o.product_name, c.customer_name
from Orders o
right join Customers c on o.customer_id = c.customer_id;
/*'Laptop', 'Ramya'
'Smartphone', 'Yash'
'Tablet', 'Radhika'
'Monitor', 'Puneet'
'Keyboard', 'Sudeep'*/

select o.order_id, c.city
from Orders o
right join Customers c on o.customer_id = c.customer_id;
/*'101', 'Bangalore'
'102', 'Mumbai'
'103', 'Bangalore'
'104', 'Delhi'
'105', 'Bangalore'*/

select c.customer_name, COUNT(o.order_id) as order_count
from Customers c
right join Orders o on o.customer_id = c.customer_id
group by c.customer_name;
/*'Ramya', '1'
'Yash', '1'
'Radhika', '1'
'Puneet', '1'
'Sudeep', '1'*/

select c.customer_id, c.customer_name
from Customers c
right join Orders o on o.customer_id = c.customer_id
where o.order_id is null;

/* 4: Full Outer Join – 
        Find all customers and their orders, including those customers with no orders and orders without a customer.
        List all customers and products, whether they placed an order or not.
        Show customer IDs with order IDs (include unmatched ones).
		Display customer names with order dates.
		Find all unmatched records (customers without orders and orders without customers).
        Show customer cities with products.
     Write your code below this line along with the output 
  */   
  
select c.customer_id, c.customer_name, o.order_id, o.product_name
from Customers c
left join Orders o on c.customer_id = o.customer_id
union
select c.customer_id, c.customer_name, o.order_id, o.product_name
from Customers c
right join Orders o on c.customer_id = o.customer_id;
/*'1', 'Ramya', '101', 'Laptop'
'2', 'Yash', '102', 'Smartphone'
'3', 'Radhika', '103', 'Tablet'
'4', 'Puneet', '104', 'Monitor'
'5', 'Sudeep', '105', 'Keyboard'*/

select c.customer_name, o.product_name
from Customers c
left join Orders o on c.customer_id = o.customer_id
union
select c.customer_name, o.product_name
from Customers c
right join Orders o on c.customer_id = o.customer_id;
/*'1', 'Ramya', '101', 'Laptop'
'2', 'Yash', '102', 'Smartphone'
'3', 'Radhika', '103', 'Tablet'
'4', 'Puneet', '104', 'Monitor'
'5', 'Sudeep', '105', 'Keyboard'*/

select c.customer_id, o.order_id
from Customers c
left join Orders o on c.customer_id = o.customer_id
union
select c.customer_id, o.order_id
from Customers c
right join Orders o on c.customer_id = o.customer_id;
/*'1', '101'
'2', '102'
'3', '103'
'4', '104'
'5', '105'*/

select c.customer_name, o.order_date
from Customers c
left join Orders o on c.customer_id = o.customer_id
union
select c.customer_name, o.order_date
from Customers c
right join Orders o on c.customer_id = o.customer_id;
/*'Ramya', '2025-09-15'
'Yash', '2025-09-16'
'Radhika', '2025-09-17'
'Puneet', '2025-09-18'
'Sudeep', '2025-09-19'*/

select c.customer_id, c.customer_name, o.order_id, o.product_name
from Customers c
left join  Orders o on c.customer_id = o.customer_id
where o.order_id is null
union
select c.customer_id, c.customer_name, o.order_id, o.product_name
from Customers c
right join Orders o on c.customer_id = o.customer_id
where  c.customer_id is null;

select c.city, o.product_name
from Customers c
left join Orders o on c.customer_id = o.customer_id
union
select c.city, o.product_name
from Customers c
right join Orders o on c.customer_id = o.customer_id;
/*'Bangalore', 'Laptop'
'Mumbai', 'Smartphone'
'Bangalore', 'Tablet'
'Delhi', 'Monitor'
'Bangalore', 'Keyboard'*/

  /* 5: Natural Join – 
          Find all orders placed by customers.
          List all customers with the products they ordered using NATURAL JOIN.
          Show customer names along with their order dates using NATURAL JOIN.
          Find all customer cities and the products ordered by those customers using NATURAL JOIN.
    Write your code below this line along with the output
    */
    
select*from Customers natural join Orders;
    /*'1', 'Ramya', 'Bangalore', '101', 'Laptop', '2025-09-15'
'2', 'Yash', 'Mumbai', '102', 'Smartphone', '2025-09-16'
'3', 'Radhika', 'Bangalore', '103', 'Tablet', '2025-09-17'
'4', 'Puneet', 'Delhi', '104', 'Monitor', '2025-09-18'
'5', 'Sudeep', 'Bangalore', '105', 'Keyboard', '2025-09-19'*/
 
select customer_name, product_name
from Customers natural join Orders;
/*'Ramya', 'Laptop'
'Yash', 'Smartphone'
'Radhika', 'Tablet'
'Puneet', 'Monitor'
'Sudeep', 'Keyboard'*/

select customer_name, order_date
from Customers natural join Orders;
/*'Ramya', '2025-09-15'
'Yash', '2025-09-16'
'Radhika', '2025-09-17'
'Puneet', '2025-09-18'
'Sudeep', '2025-09-19'*/

select city, product_name
from Customers natural join Orders;
/*'Bangalore', 'Laptop'
'Mumbai', 'Smartphone'
'Bangalore', 'Tablet'
'Delhi', 'Monitor'
'Bangalore', 'Keyboard'*/

  -- END OF THE EXPERIMENT