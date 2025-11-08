create database scenario10;
use scenario10;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50)
);

create table menu (
    item_id int primary key,
    item_name varchar(50),
    price decimal(10,2)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    foreign key (customer_id) references customer(customer_id)
);

create table order_details (
    order_detail_id int primary key,
    order_id int,
    item_id int,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (item_id) references menu(item_id)
);

-- Insert data into Customer table
insert into customer (customer_id, customer_name, city) values
(1, 'Aarav', 'Delhi'),
(2, 'Bhavya', 'Mumbai'),
(3, 'Chirag', 'Pune'),
(4, 'Diya', 'Chennai');

insert into menu (item_id, item_name, price) values
(101, 'Pizza', 250.00),
(102, 'Burger', 150.00),
(103, 'Pasta', 200.00),
(104, 'Sandwich', 120.00);

insert into orders (order_id, customer_id, order_date, total_amount) values
(1, 1, '2025-10-01', 500.00),
(2, 2, '2025-10-02', 450.00),
(3, 3, '2025-10-03', 600.00),
(4, 1, '2025-10-04', 370.00);

insert into order_details (order_detail_id, order_id, item_id, quantity) values
(1, 1, 101, 2),  
(2, 2, 102, 3),   
(3, 3, 103, 2),  
(4, 4, 104, 2),   
(5, 3, 101, 1);   

select orders.order_id, customer.customer_name, orders.total_amount, orders.order_date
from orders
inner join customer
on orders.customer_id = customer.customer_id;
/*'1', 'Aarav', '500.00', '2025-10-01'
'2', 'Bhavya', '450.00', '2025-10-02'
'3', 'Chirag', '600.00', '2025-10-03'
'4', 'Aarav', '370.00', '2025-10-04'*/

select menu.item_name, order_details.order_id, order_details.quantity
from menu
left outer join order_details
on menu.item_id = order_details.item_id;
/*'Pizza', '1', '2'
'Pizza', '3', '1'
'Burger', '2', '3'
'Pasta', '3', '2'
'Sandwich', '4', '2'*/

select menu.item_name, sum(order_details.quantity) as total_quantity_sold
from menu
left join order_details
on menu.item_id = order_details.item_id
group by menu.item_name;
/*'Pizza', '3'
'Burger', '3'
'Pasta', '2'
'Sandwich', '2'*/

select max(total_amount) as highest_order_amount
from orders;
/*'600.00'*/

select avg(price) as average_item_price
from menu;
/*180.000000*/