create database ecommerce;
use ecommerce;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50),
    email varchar(100)
);

create table product (
    product_id int primary key,
    product_name varchar(50),
    price decimal(10,2),
    stock int
);

create table orders (
    order_id int primary key,
    customer_id int,
    product_id int,
    order_date date,
    quantity int,
    foreign key (customer_id) references customer(customer_id),
    foreign key (product_id) references product(product_id)
);

insert into customer (customer_id, customer_name, city, email) values
(1, 'Aarav', 'Delhi', 'aarav@gmail.com'),
(2, 'Bhavya', 'Mumbai', 'bhavya@gmail.com'),
(3, 'Chirag', 'Pune', 'chirag@gmail.com'),
(4, 'Diya', 'Chennai', 'diya@gmail.com');

insert into product (product_id, product_name, price, stock) values
(101, 'Laptop', 55000.00, 10),
(102, 'Headphones', 1500.00, 50),
(103, 'Smartphone', 25000.00, 20),
(104, 'Keyboard', 800.00, 30);


insert into orders (order_id, customer_id, product_id, order_date, quantity) values
(1, 1, 101, '2025-01-10', 1),
(2, 2, 103, '2025-01-12', 2),
(3, 3, 102, '2025-01-13', 3),
(4, 1, 104, '2025-01-14', 2),
(5, 4, 103, '2025-01-15', 1);

select 
    orders.order_id,
    customer.customer_name,
    product.product_name,
    orders.quantity,
    product.price,
    (orders.quantity * product.price) as total_amount,
    orders.order_date
from orders
inner join customer on orders.customer_id = customer.customer_id
inner join product on orders.product_id = product.product_id;
/*'1', 'Aarav', 'Laptop', '1', '55000.00', '55000.00', '2025-01-10'
'4', 'Aarav', 'Keyboard', '2', '800.00', '1600.00', '2025-01-14'
'2', 'Bhavya', 'Smartphone', '2', '25000.00', '50000.00', '2025-01-12'
'3', 'Chirag', 'Headphones', '3', '1500.00', '4500.00', '2025-01-13'
'5', 'Diya', 'Smartphone', '1', '25000.00', '25000.00', '2025-01-15'*/

select 
    product.product_name,
    sum(orders.quantity * product.price) as total_sales
from orders
inner join product on orders.product_id = product.product_id
group by product.product_name;
/*'Laptop', '55000.00'
'Headphones', '4500.00'
'Smartphone', '75000.00'
'Keyboard', '1600.00'*/

delimiter //
create procedure add_new_order (
    in p_order_id int,
    in p_customer_id int,
    in p_product_id int,
    in p_order_date date,
    in p_quantity int
)
begin
    declare current_stock int;

    -- Get current stock
    select stock into current_stock from product where product_id = p_product_id;

    -- Check if enough stock is available
    if current_stock >= p_quantity then
        -- Insert order
        insert into orders (order_id, customer_id, product_id, order_date, quantity)
        values (p_order_id, p_customer_id, p_product_id, p_order_date, p_quantity);

        -- Update stock
        update product
        set stock = stock - p_quantity
        where product_id = p_product_id;
    else
        signal sqlstate '45000'
        set message_text = 'Insufficient stock to complete order';
    end if;
end //
delimiter ;
call add_new_order(6, 2, 102, '2025-02-01', 2);

delimiter //

create procedure update_stock (
    in p_product_id int,
    in p_new_stock int
)
begin
    update product
    set stock = p_new_stock
    where product_id = p_product_id;
end //

delimiter ;
call update_stock(101, 15);

