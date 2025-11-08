create database p9;
use p9;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50),
    contact_no varchar(15)
);

create table vehicle (
    vehicle_id int primary key,
    vehicle_model varchar(50),
    vehicle_type varchar(30),
    rent_per_day decimal(10,2),
    availability_status varchar(20)
);

create table rental (
    rental_id int primary key,
    customer_id int,
    vehicle_id int,
    rental_date date,
    return_date date,
    total_rent decimal(10,2),
    foreign key (customer_id) references customer(customer_id),
    foreign key (vehicle_id) references vehicle(vehicle_id)
);

insert into customer (customer_id, customer_name, city, contact_no) values
(1, 'Aarav Mehta', 'Delhi', '9876543210'),
(2, 'Bhavya Patel', 'Mumbai', '9988776655'),
(3, 'Chirag Singh', 'Pune', '9123456789'),
(4, 'Diya Sharma', 'Chennai', '9090909090'),
(5, 'Esha Nair', 'Kolkata', '9898989898');

insert into vehicle (vehicle_id, vehicle_model, vehicle_type, rent_per_day, availability_status) values
(101, 'Honda City', 'Sedan', 2000.00, 'Available'),
(102, 'Hyundai Creta', 'SUV', 2500.00, 'Available'),
(103, 'Suzuki Swift', 'Hatchback', 1500.00, 'Available'),
(104, 'Toyota Innova', 'MPV', 3000.00, 'Available'),
(105, 'Kia Seltos', 'SUV', 2700.00, 'Available');

insert into rental (rental_id, customer_id, vehicle_id, rental_date, return_date, total_rent) values
(1, 1, 101, '2025-01-10', '2025-01-12', 4000.00),
(2, 2, 102, '2025-01-14', '2025-01-17', 7500.00),
(3, 3, 103, '2025-01-15', '2025-01-16', 1500.00),
(4, 4, 104, '2025-01-20', '2025-01-23', 9000.00),
(5, 5, 105, '2025-01-25', '2025-01-27', 5400.00);

select 
    r.rental_id,
    c.customer_name,
    v.vehicle_model,
    v.vehicle_type,
    r.rental_date,
    r.return_date,
    r.total_rent
from rental r
inner join customer c on r.customer_id = c.customer_id
inner join vehicle v on r.vehicle_id = v.vehicle_id
order by c.customer_name;
/*'1', 'Aarav Mehta', 'Honda City', 'Sedan', '2025-01-10', '2025-01-12', '4000.00'
'2', 'Bhavya Patel', 'Hyundai Creta', 'SUV', '2025-01-14', '2025-01-17', '7500.00'
'3', 'Chirag Singh', 'Suzuki Swift', 'Hatchback', '2025-01-15', '2025-01-16', '1500.00'
'4', 'Diya Sharma', 'Toyota Innova', 'MPV', '2025-01-20', '2025-01-23', '9000.00'
'5', 'Esha Nair', 'Kia Seltos', 'SUV', '2025-01-25', '2025-01-27', '5400.00'*/

select 
    c.customer_name,
    sum(r.total_rent) as total_rent_paid
from rental r
inner join customer c on r.customer_id = c.customer_id
group by c.customer_name;
/*'Aarav Mehta', '4000.00'
'Bhavya Patel', '7500.00'
'Chirag Singh', '1500.00'
'Diya Sharma', '9000.00'
'Esha Nair', '5400.00'*/

select vehicle_model, vehicle_type, rent_per_day
from vehicle
where availability_status = 'Available';
/*'Honda City', 'Sedan', '2000.00'
'Hyundai Creta', 'SUV', '2500.00'
'Suzuki Swift', 'Hatchback', '1500.00'
'Toyota Innova', 'MPV', '3000.00'
'Kia Seltos', 'SUV', '2700.00'*/

delimiter //
create procedure add_rental (
    in p_rental_id int,
    in p_customer_id int,
    in p_vehicle_id int,
    in p_rental_date date,
    in p_return_date date,
    in p_total_rent decimal(10,2)
)
begin
    -- Insert rental record
    insert into rental (rental_id, customer_id, vehicle_id, rental_date, return_date, total_rent)
    values (p_rental_id, p_customer_id, p_vehicle_id, p_rental_date, p_return_date, p_total_rent);

    -- Update vehicle status
    update vehicle
    set availability_status = 'Booked'
    where vehicle_id = p_vehicle_id;
end //
delimiter ;
call add_rental(6, 3, 101, '2025-02-05', '2025-02-07', 4000.00);

delimiter //
create procedure update_return_date (
    in p_rental_id int,
    in p_new_return_date date
)
begin
    update rental
    set return_date = p_new_return_date
    where rental_id = p_rental_id;
end //
delimiter ;
call update_return_date(2, '2025-01-18');
