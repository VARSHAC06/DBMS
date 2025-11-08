create database logistics_delivery_system;
use logistics_delivery_system;

create table couriers (
    courier_id int primary key auto_increment,
    courier_name varchar(100),
    contact varchar(15),
    city varchar(50)
);
create table packages (
    package_id int primary key auto_increment,
    sender_name varchar(100),
    receiver_name varchar(100),
    weight decimal(10,2),
    destination varchar(100)
);
create table deliveries (
    delivery_id int primary key auto_increment,
    courier_id int,
    package_id int,
    delivery_date date,
    status varchar(30),
    foreign key (courier_id) references couriers(courier_id),
    foreign key (package_id) references packages(package_id)
);

insert into couriers (courier_name, contact, city) values
('Ravi Sharma', '9876543210', 'Delhi'),
('Priya Mehta', '9123456789', 'Mumbai'),
('Amit Verma', '9988776655', 'Pune'),
('Sneha Iyer', '9865321470', 'Bangalore');

insert into packages (sender_name, receiver_name, weight, destination) values
('TechCorp Pvt Ltd', 'Rohan Das', 4.5, 'Delhi'),
('GreenLeaf Foods', 'Amit Sharma', 2.0, 'Mumbai'),
('UrbanStyle Fashions', 'Sneha Iyer', 3.2, 'Chennai'),
('ElectroMart', 'Priya Singh', 5.8, 'Pune'),
('BookWorld', 'Ravi Patel', 1.5, 'Hyderabad');

insert into deliveries (courier_id, package_id, delivery_date, status) values
(1, 1, '2025-10-25', 'Delivered'),
(2, 2, '2025-10-26', 'Delivered'),
(3, 3, '2025-10-27', 'In Transit'),
(4, 4, '2025-10-28', 'Pending'),
(1, 5, '2025-10-29', 'Delivered');

select 
    d.delivery_id,
    c.courier_name,
    c.city,
    p.sender_name,
    p.receiver_name,
    p.destination,
    p.weight,
    d.delivery_date,
    d.status
from deliveries d
join couriers c on d.courier_id = c.courier_id
join packages p on d.package_id = p.package_id
order by d.delivery_date;
/*'1', 'Ravi Sharma', 'Delhi', 'TechCorp Pvt Ltd', 'Rohan Das', 'Delhi', '4.50', '2025-10-25', 'Delivered'
'2', 'Priya Mehta', 'Mumbai', 'GreenLeaf Foods', 'Amit Sharma', 'Mumbai', '2.00', '2025-10-26', 'Delivered'
'3', 'Amit Verma', 'Pune', 'UrbanStyle Fashions', 'Sneha Iyer', 'Chennai', '3.20', '2025-10-27', 'In Transit'
'4', 'Sneha Iyer', 'Bangalore', 'ElectroMart', 'Priya Singh', 'Pune', '5.80', '2025-10-28', 'Pending'
'5', 'Ravi Sharma', 'Delhi', 'BookWorld', 'Ravi Patel', 'Hyderabad', '1.50', '2025-10-29', 'Delivered'*/

select 
    c.courier_name,
    c.city,
    count(d.delivery_id) as total_deliveries
from deliveries d
join couriers c on d.courier_id = c.courier_id
group by c.courier_name, c.city
order by total_deliveries desc;
/*'Ravi Sharma', 'Delhi', '2'
'Priya Mehta', 'Mumbai', '1'
'Amit Verma', 'Pune', '1'
'Sneha Iyer', 'Bangalore', '1'*/

delimiter $$

create procedure insert_delivery(
    in p_courier_id int,
    in p_package_id int,
    in p_delivery_date date,
    in p_status varchar(30)
)
begin
    declare courier_exists int;
    declare package_exists int;

    select count(*) into courier_exists from couriers where courier_id = p_courier_id;
    select count(*) into package_exists from packages where package_id = p_package_id;

    if courier_exists > 0 and package_exists > 0 then
        insert into deliveries (courier_id, package_id, delivery_date, status)
        values (p_courier_id, p_package_id, p_delivery_date, p_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Courier ID or Package ID!';
    end if;
end $$

delimiter ;
call insert_delivery(2, 3, '2025-11-02', 'Delivered');

delimiter $$

create procedure update_delivery(
    in p_delivery_id int,
    in p_new_status varchar(30),
    in p_new_date date
)
begin
    update deliveries
    set status = p_new_status,
        delivery_date = p_new_date
    where delivery_id = p_delivery_id;
end $$

delimiter ;
call update_delivery(3, 'Delivered', '2025-11-01');
