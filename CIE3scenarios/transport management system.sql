create database transport_management;
use transport_management;

create table drivers (
    driver_id int primary key auto_increment,
    driver_name varchar(50),
    license_no varchar(20),
    contact varchar(15)
);


create table vehicles (
    vehicle_id int primary key auto_increment,
    vehicle_no varchar(20),
    model varchar(50),
    capacity int
);


create table trips (
    trip_id int primary key auto_increment,
    driver_id int,
    vehicle_id int,
    start_location varchar(100),
    end_location varchar(100),
    distance_km decimal(10,2),
    trip_date date,
    foreign key (driver_id) references drivers(driver_id),
    foreign key (vehicle_id) references vehicles(vehicle_id)
);


insert into drivers (driver_name, license_no, contact) values
('Ravi Kumar', 'DL12345', '9876543210'),
('Suresh Singh', 'DL67890', '9123456789'),
('Anita Das', 'DL54321', '9988776655');

insert into vehicles (vehicle_no, model, capacity) values
('MH12AB1234', 'Tata Ace', 1000),
('MH14CD5678', 'Ashok Leyland', 5000),
('MH13EF9101', 'Eicher Pro', 3000);

insert into trips (driver_id, vehicle_id, start_location, end_location, distance_km, trip_date) values
(1, 1, 'Pune', 'Mumbai', 150.50, '2025-10-30'),
(2, 2, 'Nashik', 'Nagpur', 420.75, '2025-10-31'),
(3, 3, 'Aurangabad', 'Pune', 220.25, '2025-11-01'),
(1, 1, 'Mumbai', 'Pune', 150.50, '2025-11-02'),
(2, 2, 'Nagpur', 'Nashik', 420.75, '2025-11-03');


select 
    t.trip_id,
    d.driver_name,
    v.vehicle_no,
    v.model,
    t.start_location,
    t.end_location,
    t.distance_km,
    t.trip_date
from trips t
join drivers d on t.driver_id = d.driver_id
join vehicles v on t.vehicle_id = v.vehicle_id;
/*'1', 'Ravi Kumar', 'MH12AB1234', 'Tata Ace', 'Pune', 'Mumbai', '150.50', '2025-10-30'
'4', 'Ravi Kumar', 'MH12AB1234', 'Tata Ace', 'Mumbai', 'Pune', '150.50', '2025-11-02'
'2', 'Suresh Singh', 'MH14CD5678', 'Ashok Leyland', 'Nashik', 'Nagpur', '420.75', '2025-10-31'
'5', 'Suresh Singh', 'MH14CD5678', 'Ashok Leyland', 'Nagpur', 'Nashik', '420.75', '2025-11-03'
'3', 'Anita Das', 'MH13EF9101', 'Eicher Pro', 'Aurangabad', 'Pune', '220.25', '2025-11-01'8*/


select 
    d.driver_name,
    sum(t.distance_km) as total_distance
from trips t
join drivers d on t.driver_id = d.driver_id
group by d.driver_name
order by total_distance desc;
/*'Suresh Singh', '841.50'
'Ravi Kumar', '301.00'
'Anita Das', '220.25'*/

delimiter $$

create procedure insert_trip(
    in p_driver_id int,
    in p_vehicle_id int,
    in p_start_location varchar(100),
    in p_end_location varchar(100),
    in p_distance_km decimal(10,2),
    in p_trip_date date
)
begin
    declare driver_exists int;
    declare vehicle_exists int;

    select count(*) into driver_exists from drivers where driver_id = p_driver_id;
    select count(*) into vehicle_exists from vehicles where vehicle_id = p_vehicle_id;

    if driver_exists > 0 and vehicle_exists > 0 then
        insert into trips (driver_id, vehicle_id, start_location, end_location, distance_km, trip_date)
        values (p_driver_id, p_vehicle_id, p_start_location, p_end_location, p_distance_km, p_trip_date);
    else
        signal sqlstate '45000'
        set message_text = 'Driver or Vehicle not found!';
    end if;
end $$

delimiter ;

call insert_trip(3, 1, 'Pune', 'Kolhapur', 230.80, '2025-11-04');

-- 7️⃣ Procedure: Update Trip Record

delimiter $$

create procedure update_trip(
    in p_trip_id int,
    in p_new_vehicle_id int,
    in p_new_distance decimal(10,2)
)
begin
    declare vehicle_exists int;

    select count(*) into vehicle_exists from vehicles where vehicle_id = p_new_vehicle_id;

    if vehicle_exists > 0 then
        update trips
        set vehicle_id = p_new_vehicle_id,
            distance_km = p_new_distance
        where trip_id = p_trip_id;
    else
        signal sqlstate '45000'
        set message_text = 'Vehicle not found!';
    end if;
end $$

delimiter ;

call update_trip(2, 3, 430.00);

