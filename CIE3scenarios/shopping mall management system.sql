create database shopping_mall_management;
use shopping_mall_management;

create table shops (
    shop_id int primary key auto_increment,
    shop_name varchar(100),
    category varchar(50),
    floor int
);

create table employees (
    emp_id int primary key auto_increment,
    emp_name varchar(50),
    position varchar(50),
    salary decimal(10,2),
    shop_id int,
    foreign key (shop_id) references shops(shop_id)
);

create table sales (
    sale_id int primary key auto_increment,
    shop_id int,
    emp_id int,
    sale_date date,
    amount decimal(10,2),
    foreign key (shop_id) references shops(shop_id),
    foreign key (emp_id) references employees(emp_id)
);


insert into shops (shop_name, category, floor) values
('Trendy Wear', 'Clothing', 1),
('Tech World', 'Electronics', 2),
('Sweet Treats', 'Bakery', 1),
('Book Haven', 'Books', 3);

insert into employees (emp_name, position, salary, shop_id) values
('Ravi Kumar', 'Sales Executive', 25000.00, 1),
('Priya Mehta', 'Cashier', 22000.00, 1),
('Amit Sharma', 'Sales Manager', 30000.00, 2),
('Sneha Iyer', 'Sales Executive', 24000.00, 3),
('Rohan Das', 'Store Keeper', 20000.00, 4);

insert into sales (shop_id, emp_id, sale_date, amount) values
(1, 1, '2025-10-28', 15000.00),
(1, 2, '2025-10-29', 12000.00),
(2, 3, '2025-10-30', 35000.00),
(3, 4, '2025-10-31', 8000.00),
(4, 5, '2025-11-01', 5000.00),
(2, 3, '2025-11-02', 40000.00);


select 
    e.emp_name,
    e.position,
    e.salary,
    s.shop_name,
    s.category,
    s.floor
from employees e
join shops s on e.shop_id = s.shop_id
order by s.shop_name;
/*'Rohan Das', 'Store Keeper', '20000.00', 'Book Haven', 'Books', '3'
'Sneha Iyer', 'Sales Executive', '24000.00', 'Sweet Treats', 'Bakery', '1'
'Amit Sharma', 'Sales Manager', '30000.00', 'Tech World', 'Electronics', '2'
'Ravi Kumar', 'Sales Executive', '25000.00', 'Trendy Wear', 'Clothing', '1'
'Priya Mehta', 'Cashier', '22000.00', 'Trendy Wear', 'Clothing', '1'*/

select 
    s.shop_name,
    s.category,
    sum(sa.amount) as total_sales
from sales sa
join shops s on sa.shop_id = s.shop_id
group by s.shop_name, s.category
order by total_sales desc;
/*'Tech World', 'Electronics', '75000.00'
'Trendy Wear', 'Clothing', '27000.00'
'Sweet Treats', 'Bakery', '8000.00'
'Book Haven', 'Books', '5000.00'*/

delimiter $$

create procedure add_sale(
    in p_shop_id int,
    in p_emp_id int,
    in p_sale_date date,
    in p_amount decimal(10,2)
)
begin
    declare shop_exists int;
    declare emp_exists int;

    select count(*) into shop_exists from shops where shop_id = p_shop_id;
    select count(*) into emp_exists from employees where emp_id = p_emp_id;

    if shop_exists > 0 and emp_exists > 0 then
        insert into sales (shop_id, emp_id, sale_date, amount)
        values (p_shop_id, p_emp_id, p_sale_date, p_amount);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Shop ID or Employee ID!';
    end if;
end $$

delimiter ;
call add_sale(3, 4, '2025-11-02', 9500.00);

delimiter $$

create procedure update_sale(
    in p_sale_id int,
    in p_new_amount decimal(10,2),
    in p_new_date date
)
begin
    update sales
    set amount = p_new_amount,
        sale_date = p_new_date
    where sale_id = p_sale_id;
end $$

delimiter ;
call update_sale(2, 13000.00, '2025-11-01');

