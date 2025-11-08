create database p13;
use p13;

create table products (
    prod_id int primary key auto_increment,
    prod_name varchar(50),
    category varchar(30),
    price decimal(10,2),
    stock int
);

create table suppliers (
    supp_id int primary key auto_increment,
    supp_name varchar(50),
    contact varchar(15)
);

create table orders (
    order_id int primary key auto_increment,
    prod_id int,
    supp_id int,
    quantity int,
    order_date date,
    foreign key (prod_id) references products(prod_id),
    foreign key (supp_id) references suppliers(supp_id)
);

insert into products (prod_name, category, price, stock) values
('Mouse', 'Electronics', 350.00, 100),
('Keyboard', 'Electronics', 600.00, 80),
('Monitor', 'Electronics', 5000.00, 40),
('USB Cable', 'Accessories', 150.00, 200),
('Printer', 'Electronics', 8000.00, 20);
s
insert into suppliers (supp_name, contact) values
('TechSource Pvt Ltd', '9876543210'),
('GadgetMart Distributors', '9123456789'),
('CompuWorld Supplies', '9988776655');

insert into orders (prod_id, supp_id, quantity, order_date) values
(1, 1, 20, '2025-10-20'),
(2, 2, 15, '2025-10-21'),
(3, 3, 5, '2025-10-22'),
(4, 1, 30, '2025-10-23'),
(5, 2, 8, '2025-10-24');

select 
    o.order_id,
    p.prod_name,
    s.supp_name,
    o.quantity,
    o.order_date
from orders o
join products p on o.prod_id = p.prod_id
join suppliers s on o.supp_id = s.supp_id;

select 
    p.prod_id,
    p.prod_name,
    sum(o.quantity) as total_quantity_ordered
from products p
join orders o on p.prod_id = o.prod_id
group by p.prod_id, p.prod_name;

delimiter //
create procedure insert_order(
    in p_prod_id int,
    in p_supp_id int,
    in p_quantity int,
    in p_order_date date
)
begin
    -- insert new order
    insert into orders (prod_id, supp_id, quantity, order_date)
    values (p_prod_id, p_supp_id, p_quantity, p_order_date);

    -- update stock after supply
    update products
    set stock = stock + p_quantity
    where prod_id = p_prod_id;
end //
delimiter ;
call insert_order(2, 3, 10, '2025-10-31');

delimiter //
create procedure update_order(
    in p_order_id int,
    in p_new_quantity int
)
begin
    declare old_quantity int;
    declare prod_id_ref int;
    select quantity, prod_id into old_quantity, prod_id_ref
    from orders
    where order_id = p_order_id;
    update orders
    set quantity = p_new_quantity
    where order_id = p_order_id;
    update products
    set stock = stock - old_quantity + p_new_quantity
    where prod_id = prod_id_ref;
end //
delimiter ;
call insert_order(3, 2, 10, '2025-11-01');
