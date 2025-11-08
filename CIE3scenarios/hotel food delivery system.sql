create database hotel_food_delivery_system;
use hotel_food_delivery_system;

create table customers (
    cust_id int primary key auto_increment,
    cust_name varchar(100),
    phone varchar(15),
    address varchar(255)
);
create table food_items (
    food_id int primary key auto_increment,
    food_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);
create table orders (
    order_id int primary key auto_increment,
    cust_id int,
    food_id int,
    quantity int,
    order_date date,
    status varchar(30),
    foreign key (cust_id) references customers(cust_id),
    foreign key (food_id) references food_items(food_id)
);

insert into customers (cust_name, phone, address) values
('Amit Sharma', '9876543210', 'Pune'),
('Priya Mehta', '9123456789', 'Mumbai'),
('Rohan Das', '9988776655', 'Delhi'),
('Sneha Iyer', '9865321470', 'Chennai');

insert into food_items (food_name, category, price) values
('Veg Burger', 'Fast Food', 120.00),
('Paneer Tikka', 'Starter', 200.00),
('Biryani', 'Main Course', 250.00),
('Cold Coffee', 'Beverage', 100.00),
('Chocolate Cake', 'Dessert', 150.00);

insert into orders (cust_id, food_id, quantity, order_date, status) values
(1, 1, 2, '2025-10-28', 'Delivered'),
(2, 3, 1, '2025-10-28', 'Delivered'),
(3, 5, 3, '2025-10-29', 'Pending'),
(4, 2, 1, '2025-10-29', 'Delivered'),
(1, 4, 2, '2025-10-30', 'Delivered'),
(2, 1, 1, '2025-10-31', 'Delivered');

select 
    o.order_id,
    c.cust_name,
    f.food_name,
    f.category,
    f.price,
    o.quantity,
    (f.price * o.quantity) as total_amount,
    o.order_date,
    o.status
from orders o
join customers c on o.cust_id = c.cust_id
join food_items f on o.food_id = f.food_id
order by o.order_date;
/*'1', 'Amit Sharma', 'Veg Burger', 'Fast Food', '120.00', '2', '240.00', '2025-10-28', 'Delivered'
'2', 'Priya Mehta', 'Biryani', 'Main Course', '250.00', '1', '250.00', '2025-10-28', 'Delivered'
'3', 'Rohan Das', 'Chocolate Cake', 'Dessert', '150.00', '3', '450.00', '2025-10-29', 'Pending'
'4', 'Sneha Iyer', 'Paneer Tikka', 'Starter', '200.00', '1', '200.00', '2025-10-29', 'Delivered'
'5', 'Amit Sharma', 'Cold Coffee', 'Beverage', '100.00', '2', '200.00', '2025-10-30', 'Delivered'
'6', 'Priya Mehta', 'Veg Burger', 'Fast Food', '120.00', '1', '120.00', '2025-10-31', 'Delivered'*/

select 
    order_date,
    sum(f.price * o.quantity) as total_sales
from orders o
join food_items f on o.food_id = f.food_id
where o.status = 'Delivered'
group by order_date
order by order_date;
/*'2025-10-28', '490.00'
'2025-10-29', '200.00'
'2025-10-30', '200.00'
'2025-10-31', '120.00'*/

delimiter $$

create procedure insert_order(
    in p_cust_id int,
    in p_food_id int,
    in p_quantity int,
    in p_order_date date,
    in p_status varchar(30)
)
begin
    declare cust_exists int;
    declare food_exists int;

    select count(*) into cust_exists from customers where cust_id = p_cust_id;
    select count(*) into food_exists from food_items where food_id = p_food_id;

    if cust_exists > 0 and food_exists > 0 then
        insert into orders (cust_id, food_id, quantity, order_date, status)
        values (p_cust_id, p_food_id, p_quantity, p_order_date, p_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Customer ID or Food ID!';
    end if;
end $$

delimiter ;
call insert_order(3, 2, 2, '2025-11-01', 'Pending');

delimiter $$

create procedure update_order_status(
    in p_order_id int,
    in p_new_status varchar(30)
)
begin
    update orders
    set status = p_new_status
    where order_id = p_order_id;
end $$

delimiter ;
call update_order_status(3, 'Delivered');

