create database scenario9;
use scenario9;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50)
);

create table vehicle (
    vehicle_id int primary key,
    model varchar(50),
    rent_per_day decimal(10,2)
);

create table rental (
    rental_id int primary key,
    customer_id int,
    vehicle_id int,
    rental_days int,
    total_rent decimal(10,2),
    foreign key (customer_id) references customer(customer_id),
    foreign key (vehicle_id) references vehicle(vehicle_id)
);

insert into customer (customer_id, customer_name, city) values
(1, 'Aarav', 'Delhi'),
(2, 'Bhavya', 'Mumbai'),
(3, 'Chirag', 'Pune'),
(4, 'Diya', 'Chennai');

insert into vehicle (vehicle_id, model, rent_per_day) values
(101, 'Honda City', 2500.00),
(102, 'Hyundai Creta', 3000.00),
(103, 'Toyota Innova', 3500.00),
(104, 'Mahindra Thar', 4000.00);

insert into rental (rental_id, customer_id, vehicle_id, rental_days, total_rent) values
(1, 1, 101, 3, 7500.00),
(2, 2, 102, 2, 6000.00),
(3, 3, 103, 4, 14000.00),
(4, 1, 104, 1, 4000.00);

select customer.customer_name, vehicle.model
from customer
inner join rental
on customer.customer_id = rental.customer_id
inner join vehicle
on rental.vehicle_id = vehicle.vehicle_id;
/*'Aarav', 'Honda City'
'Aarav', 'Mahindra Thar'
'Bhavya', 'Hyundai Creta'
'Chirag', 'Toyota Innova'*/

select customer.customer_name, rental.rental_id, rental.total_rent
from customer
left outer join rental
on customer.customer_id = rental.customer_id;
/*'Aarav', '1', '7500.00'
'Aarav', '4', '4000.00'
'Bhavya', '2', '6000.00'
'Chirag', '3', '14000.00'
'Diya', NULL, NULL*/

select vehicle.model, count(rental.rental_id) as total_rentals
from vehicle
left join rental
on vehicle.vehicle_id = rental.vehicle_id
group by vehicle.model;
/*'Honda City', '1'
'Hyundai Creta', '1'
'Toyota Innova', '1'
'Mahindra Thar', '1'*/

select sum(total_rent) as total_rent_collected
from rental;
/*'31500.00'*/

select avg(total_rent) as average_rent_per_vehicle
from rental;
/*7875.000000*/