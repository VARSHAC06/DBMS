create database tourist_package_booking_system;
use tourist_package_booking_system;

create table tourists (
    tourist_id int primary key auto_increment,
    tourist_name varchar(100),
    email varchar(100),
    phone varchar(15)
);
create table packages (
    package_id int primary key auto_increment,
    destination varchar(100),
    duration_days int,
    price_per_person decimal(10,2),
    start_date date,
    end_date date
);
create table bookings (
    booking_id int primary key auto_increment,
    tourist_id int,
    package_id int,
    booking_date date,
    num_persons int,
    total_amount decimal(10,2),
    status varchar(30),
    foreign key (tourist_id) references tourists(tourist_id),
    foreign key (package_id) references packages(package_id)
);

insert into tourists (tourist_name, email, phone) values
('Amit Sharma', 'amit@gmail.com', '9876543210'),
('Priya Mehta', 'priya@gmail.com', '9123456789'),
('Rohan Das', 'rohan@gmail.com', '9988776655'),
('Sneha Iyer', 'sneha@gmail.com', '9865321470');

insert into packages (destination, duration_days, price_per_person, start_date, end_date) values
('Goa', 5, 15000.00, '2025-11-10', '2025-11-15'),
('Manali', 6, 18000.00, '2025-12-01', '2025-12-06'),
('Jaipur', 4, 12000.00, '2025-11-20', '2025-11-24'),
('Kerala', 7, 22000.00, '2025-12-10', '2025-12-17');

insert into bookings (tourist_id, package_id, booking_date, num_persons, total_amount, status) values
(1, 1, '2025-10-25', 2, 30000.00, 'Confirmed'),
(2, 2, '2025-10-26', 3, 54000.00, 'Pending'),
(3, 3, '2025-10-27', 1, 12000.00, 'Cancelled'),
(4, 4, '2025-10-28', 2, 44000.00, 'Confirmed'),
(1, 2, '2025-10-29', 1, 18000.00, 'Confirmed');

select 
    b.booking_id,
    t.tourist_name,
    p.destination,
    p.duration_days,
    b.num_persons,
    p.price_per_person,
    b.total_amount,
    b.booking_date,
    p.start_date,
    p.end_date,
    b.status
from bookings b
join tourists t on b.tourist_id = t.tourist_id
join packages p on b.package_id = p.package_id
order by b.booking_date;
/*'1', 'Amit Sharma', 'Goa', '5', '2', '15000.00', '30000.00', '2025-10-25', '2025-11-10', '2025-11-15', 'Confirmed'
'2', 'Priya Mehta', 'Manali', '6', '3', '18000.00', '54000.00', '2025-10-26', '2025-12-01', '2025-12-06', 'Pending'
'3', 'Rohan Das', 'Jaipur', '4', '1', '12000.00', '12000.00', '2025-10-27', '2025-11-20', '2025-11-24', 'Cancelled'
'4', 'Sneha Iyer', 'Kerala', '7', '2', '22000.00', '44000.00', '2025-10-28', '2025-12-10', '2025-12-17', 'Confirmed'
'5', 'Amit Sharma', 'Manali', '6', '1', '18000.00', '18000.00', '2025-10-29', '2025-12-01', '2025-12-06', 'Confirmed'*/

select 
    p.destination,
    count(b.booking_id) as total_bookings
from packages p
left join bookings b on p.package_id = b.package_id
group by p.destination
order by total_bookings desc;
/*'Manali', '2'
'Goa', '1'
'Jaipur', '1'
'Kerala', '1'*/

select 
    destination,
    start_date,
    end_date,
    datediff(end_date, start_date) as total_days_remaining
from packages
where start_date > curdate()
order by start_date;
/*'Goa', '2025-11-10', '2025-11-15', '5'
'Jaipur', '2025-11-20', '2025-11-24', '4'
'Manali', '2025-12-01', '2025-12-06', '5'
'Kerala', '2025-12-10', '2025-12-17', '7'*/

delimiter $$

create procedure insert_booking(
    in p_tourist_id int,
    in p_package_id int,
    in p_booking_date date,
    in p_num_persons int,
    in p_status varchar(30)
)
begin
    declare pkg_price decimal(10,2);
    declare tourist_exists int;
    declare package_exists int;

    select count(*) into tourist_exists from tourists where tourist_id = p_tourist_id;
    select count(*) into package_exists from packages where package_id = p_package_id;

    if tourist_exists > 0 and package_exists > 0 then
        select price_per_person into pkg_price from packages where package_id = p_package_id;
        insert into bookings (tourist_id, package_id, booking_date, num_persons, total_amount, status)
        values (p_tourist_id, p_package_id, p_booking_date, p_num_persons, (pkg_price * p_num_persons), p_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Tourist ID or Package ID!';
    end if;
end $$

delimiter ;
call insert_booking(3, 1, '2025-11-01', 2, 'Pending');

delimiter $$

create procedure update_booking_status(
    in p_booking_id int,
    in p_new_status varchar(30)
)
begin
    update bookings
    set status = p_new_status
    where booking_id = p_booking_id;
end $$

delimiter ;
call update_booking_status(2, 'Confirmed');
