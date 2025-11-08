
create database real_estate_management;
use real_estate_management;

create table properties (
    prop_id int primary key auto_increment,
    prop_name varchar(100),
    location varchar(100),
    price decimal(12,2),
    status varchar(20) -- 'Available' or 'Sold'
);

create table agents (
    agent_id int primary key auto_increment,
    agent_name varchar(50),
    contact varchar(15)
);

create table sales (
    sale_id int primary key auto_increment,
    prop_id int,
    agent_id int,
    customer_name varchar(50),
    sale_amount decimal(12,2),
    sale_date date,
    foreign key (prop_id) references properties(prop_id),
    foreign key (agent_id) references agents(agent_id)
);

insert into properties (prop_name, location, price, status) values
('Sunshine Apartments', 'Mumbai', 8500000.00, 'Available'),
('Green Villa', 'Pune', 6200000.00, 'Available'),
('Ocean View Flat', 'Chennai', 7800000.00, 'Available'),
('Hilltop Cottage', 'Shimla', 5400000.00, 'Available');

insert into agents (agent_name, contact) values
('Amit Desai', '9876543210'),
('Priya Nair', '9123456789'),
('Rohit Mehta', '9988776655');

insert into sales (prop_id, agent_id, customer_name, sale_amount, sale_date) values
(1, 1, 'Rahul Sharma', 8500000.00, '2025-10-20'),
(2, 2, 'Neha Verma', 6200000.00, '2025-10-22'),
(3, 3, 'Karan Patel', 7800000.00, '2025-10-25');

select 
    p.prop_id,
    p.prop_name,
    p.location,
    a.agent_name,
    a.contact,
    s.sale_amount,
    s.sale_date
from properties p
join sales s on p.prop_id = s.prop_id
join agents a on s.agent_id = a.agent_id;
/*'1', 'Sunshine Apartments', 'Mumbai', 'Amit Desai', '9876543210', '8500000.00', '2025-10-20'
'2', 'Green Villa', 'Pune', 'Priya Nair', '9123456789', '6200000.00', '2025-10-22'
'3', 'Ocean View Flat', 'Chennai', 'Rohit Mehta', '9988776655', '7800000.00', '2025-10-25'*/

select 
    a.agent_id,
    a.agent_name,
    sum(s.sale_amount) as total_sales_amount,
    count(s.sale_id) as total_properties_sold
from agents a
join sales s on a.agent_id = s.agent_id
group by a.agent_id, a.agent_name;
/*'1', 'Amit Desai', '8500000.00', '1'
'2', 'Priya Nair', '6200000.00', '1'
'3', 'Rohit Mehta', '7800000.00', '1'*/

delimiter $$
create procedure insert_sale(
    in p_prop_id int,
    in p_agent_id int,
    in p_customer_name varchar(50),
    in p_sale_amount decimal(12,2),
    in p_sale_date date
)
begin
    declare prop_status varchar(20);

    -- check if property is available
    select status into prop_status from properties where prop_id = p_prop_id;

    if prop_status = 'Available' then
        -- insert sale record
        insert into sales (prop_id, agent_id, customer_name, sale_amount, sale_date)
        values (p_prop_id, p_agent_id, p_customer_name, p_sale_amount, p_sale_date);

        -- mark property as sold
        update properties
        set status = 'Sold'
        where prop_id = p_prop_id;
    else
        signal sqlstate '45000'
        set message_text = 'Property is already sold!';
    end if;
end $$

delimiter ;
call insert_sale(4, 1, 'Ritu Sharma', 5400000.00, '2025-10-31');

delimiter $$
create procedure update_sale(
    in p_sale_id int,
    in p_new_amount decimal(12,2),
    in p_new_date date
)
begin
    update sales
    set sale_amount = p_new_amount,
        sale_date = p_new_date
    where sale_id = p_sale_id;
end $$
delimiter ;
call update_sale(2, 6400000.00, '2025-11-01');

