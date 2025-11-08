create database restaurant_management;
use restaurant_management;

create table customers (
    cust_id int primary key auto_increment,
    cust_name varchar(50),
    contact varchar(15)
);

create table menu_items (
    item_id int primary key auto_increment,
    item_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

create table orders (
    order_id int primary key auto_increment,
    cust_id int,
    item_id int,
    quantity int,
    order_date date,
    foreign key (cust_id) references customers(cust_id),
    foreign key (item_id) references menu_items(item_id)
);

insert into customers (cust_name, contact) values
('Amit Sharma', '9876543210'),
('Priya Mehta', '9123456789'),
('Rohan Das', '9988776655');

insert into menu_items (item_name, category, price) values
('Margherita Pizza', 'Main Course', 350.00),
('Pasta Alfredo', 'Main Course', 300.00),
('French Fries', 'Snacks', 120.00),
('Cold Coffee', 'Beverage', 100.00),
('Chocolate Cake', 'Dessert', 180.00);

insert into orders (cust_id, item_id, quantity, order_date) values
(1, 1, 2, '2025-11-01'),
(1, 4, 2, '2025-11-01'),
(2, 2, 1, '2025-11-01'),
(3, 3, 3, '2025-11-02'),
(3, 5, 1, '2025-11-02');

select 
    o.order_id,
    c.cust_name,
    m.item_name,
    m.category,
    o.quantity,
    m.price,
    (o.quantity * m.price) as total_amount,
    o.order_date
from orders o
join customers c on o.cust_id = c.cust_id
join menu_items m on o.item_id = m.item_id;
/*'1', 'Amit Sharma', 'Margherita Pizza', 'Main Course', '2', '350.00', '700.00', '2025-11-01'
'2', 'Amit Sharma', 'Cold Coffee', 'Beverage', '2', '100.00', '200.00', '2025-11-01'
'3', 'Priya Mehta', 'Pasta Alfredo', 'Main Course', '1', '300.00', '300.00', '2025-11-01'
'4', 'Rohan Das', 'French Fries', 'Snacks', '3', '120.00', '360.00', '2025-11-02'
'5', 'Rohan Das', 'Chocolate Cake', 'Dessert', '1', '180.00', '180.00', '2025-11-02'*/

select 
    order_date,
    sum(o.quantity * m.price) as total_revenue
from orders o
join menu_items m on o.item_id = m.item_id
group by order_date
order by order_date;
/*'2025-11-01', '1200.00'
'2025-11-02', '540.00'*/

delimiter $$
create procedure insert_order(
    in p_cust_id int,
    in p_item_id int,
    in p_quantity int,
    in p_order_date date
)
begin
    declare item_exists int;

    -- check if menu item exists
    select count(*) into item_exists from menu_items where item_id = p_item_id;

    if item_exists > 0 then
        insert into orders (cust_id, item_id, quantity, order_date)
        values (p_cust_id, p_item_id, p_quantity, p_order_date);
    else
        signal sqlstate '45000'
        set message_text = 'Menu item does not exist!';
    end if;
end $$

delimiter ;
call insert_order(2, 5, 2, '2025-11-02');

delimiter $$
create procedure update_order(
    in p_order_id int,
    in p_new_item_id int,
    in p_new_quantity int
)
begin
    declare item_exists int;

    -- check if menu item exists
    select count(*) into item_exists from menu_items where item_id = p_new_item_id;

    if item_exists > 0 then
        update orders
        set item_id = p_new_item_id,
            quantity = p_new_quantity
        where order_id = p_order_id;
    else
        signal sqlstate '45000'
        set message_text = 'Invalid menu item!';
    end if;
end $$

delimiter ;
call update_order(3, 1, 3);

