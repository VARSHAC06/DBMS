create database car_service_center;
use car_service_center;

create table customers (
    cust_id int primary key auto_increment,
    cust_name varchar(100),
    phone varchar(15),
    email varchar(100)
);
create table vehicles (
    vehicle_id int primary key auto_increment,
    cust_id int,
    vehicle_model varchar(100),
    vehicle_number varchar(20),
    purchase_year int,
    foreign key (cust_id) references customers(cust_id)
);
create table service_records (
    service_id int primary key auto_increment,
    vehicle_id int,
    service_date date,
    service_type varchar(100),
    cost decimal(10,2),
    remarks varchar(255),
    foreign key (vehicle_id) references vehicles(vehicle_id)
);

insert into customers (cust_name, phone, email) values
('Amit Sharma', '9876543210', 'amit@gmail.com'),
('Priya Mehta', '9123456789', 'priya@gmail.com'),
('Rohan Das', '9988776655', 'rohan@gmail.com');

insert into vehicles (cust_id, vehicle_model, vehicle_number, purchase_year) values
(1, 'Hyundai i20', 'MH12AB1234', 2021),
(2, 'Honda City', 'MH14XY9876', 2020),
(3, 'Tata Nexon', 'DL05GH4567', 2022);

insert into service_records (vehicle_id, service_date, service_type, cost, remarks) values
(1, '2025-10-25', 'Oil Change', 1500.00, 'Engine oil replaced'),
(2, '2025-10-26', 'Full Service', 4000.00, 'Full inspection and cleaning'),
(3, '2025-10-27', 'Brake Repair', 2500.00, 'Brake pads replaced'),
(1, '2025-10-30', 'Tire Rotation', 1200.00, 'Front and rear tires swapped'),
(2, '2025-10-31', 'Battery Replacement', 3500.00, 'New battery installed');

select 
    s.service_id,
    c.cust_name,
    v.vehicle_model,
    v.vehicle_number,
    s.service_date,
    s.service_type,
    s.cost,
    s.remarks
from service_records s
join vehicles v on s.vehicle_id = v.vehicle_id
join customers c on v.cust_id = c.cust_id
order by s.service_date;
/*'1', 'Amit Sharma', 'Hyundai i20', 'MH12AB1234', '2025-10-25', 'Oil Change', '1500.00', 'Engine oil replaced'
'2', 'Priya Mehta', 'Honda City', 'MH14XY9876', '2025-10-26', 'Full Service', '4000.00', 'Full inspection and cleaning'
'3', 'Rohan Das', 'Tata Nexon', 'DL05GH4567', '2025-10-27', 'Brake Repair', '2500.00', 'Brake pads replaced'
'4', 'Amit Sharma', 'Hyundai i20', 'MH12AB1234', '2025-10-30', 'Tire Rotation', '1200.00', 'Front and rear tires swapped'
'5', 'Priya Mehta', 'Honda City', 'MH14XY9876', '2025-10-31', 'Battery Replacement', '3500.00', 'New battery installed'*/

select 
    c.cust_name,
    count(s.service_id) as total_services,
    sum(s.cost) as total_cost
from customers c
join vehicles v on c.cust_id = v.cust_id
join service_records s on v.vehicle_id = s.vehicle_id
group by c.cust_name
order by total_services desc;
/*'Amit Sharma', '2', '2700.00'
'Priya Mehta', '2', '7500.00'
'Rohan Das', '1', '2500.00'*/

delimiter $$

create procedure insert_service_record(
    in p_vehicle_id int,
    in p_service_date date,
    in p_service_type varchar(100),
    in p_cost decimal(10,2),
    in p_remarks varchar(255)
)
begin
    declare vehicle_exists int;

    select count(*) into vehicle_exists from vehicles where vehicle_id = p_vehicle_id;

    if vehicle_exists > 0 then
        insert into service_records (vehicle_id, service_date, service_type, cost, remarks)
        values (p_vehicle_id, p_service_date, p_service_type, p_cost, p_remarks);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Vehicle ID!';
    end if;
end $$

delimiter ;
call insert_service_record(3, '2025-11-01', 'AC Cleaning', 2000.00, 'AC vents cleaned');

delimiter $$

create procedure update_service_record(
    in p_service_id int,
    in p_new_type varchar(100),
    in p_new_cost decimal(10,2),
    in p_new_remarks varchar(255)
)
begin
    update service_records
    set 
        service_type = p_new_type,
        cost = p_new_cost,
        remarks = p_new_remarks
    where service_id = p_service_id;
end $$

delimiter ;
call update_service_record(2, 'Full Service + Polishing', 4500.00, 'Added car body polish');
