create database p8;
use p8;

create table guest (
    guest_id int primary key,
    guest_name varchar(50),
    city varchar(50),
    contact_no varchar(15)
);

create table room (
    room_id int primary key,
    room_type varchar(30),
    price_per_night decimal(10,2),
    availability_status varchar(20)
);

create table booking (
    booking_id int primary key,
    guest_id int,
    room_id int,
    check_in date,
    check_out date,
    total_amount decimal(10,2),
    foreign key (guest_id) references guest(guest_id),
    foreign key (room_id) references room(room_id)
);

insert into guest (guest_id, guest_name, city, contact_no) values
(1, 'Aarav Mehta', 'Delhi', '9876543210'),
(2, 'Bhavya Patel', 'Mumbai', '9988776655'),
(3, 'Chirag Singh', 'Pune', '9123456789'),
(4, 'Diya Sharma', 'Chennai', '9090909090'),
(5, 'Esha Nair', 'Kolkata', '9898989898');

insert into room (room_id, room_type, price_per_night, availability_status) values
(101, 'Single Deluxe', 2500.00, 'Available'),
(102, 'Double Deluxe', 4000.00, 'Available'),
(103, 'Suite', 7000.00, 'Available'),
(104, 'Family Room', 5500.00, 'Available'),
(105, 'Executive Suite', 9000.00, 'Available');

insert into booking (booking_id, guest_id, room_id, check_in, check_out, total_amount) values
(1, 1, 101, '2025-01-10', '2025-01-12', 5000.00),
(2, 2, 102, '2025-01-15', '2025-01-18', 12000.00),
(3, 3, 103, '2025-01-20', '2025-01-21', 7000.00),
(4, 4, 104, '2025-01-25', '2025-01-28', 16500.00),
(5, 5, 102, '2025-01-30', '2025-02-01', 8000.00);

select 
    r.room_id,
    r.room_type,
    count(b.booking_id) as total_bookings
from room r
left join booking b on r.room_id = b.room_id
group by r.room_id, r.room_type;
/*'101', 'Single Deluxe', '1'
'102', 'Double Deluxe', '2'
'103', 'Suite', '1'
'104', 'Family Room', '1'
'105', 'Executive Suite', '0'*/

select 
    g.guest_name,
    r.room_type,
    b.check_in,
    b.check_out,
    b.total_amount
from booking b
inner join guest g on b.guest_id = g.guest_id
inner join room r on b.room_id = r.room_id
order by g.guest_name;
/*'Aarav Mehta', 'Single Deluxe', '2025-01-10', '2025-01-12', '5000.00'
'Bhavya Patel', 'Double Deluxe', '2025-01-15', '2025-01-18', '12000.00'
'Chirag Singh', 'Suite', '2025-01-20', '2025-01-21', '7000.00'
'Diya Sharma', 'Family Room', '2025-01-25', '2025-01-28', '16500.00'
'Esha Nair', 'Double Deluxe', '2025-01-30', '2025-02-01', '8000.00'*/

delimiter //

create procedure add_booking (
    in p_booking_id int,
    in p_guest_id int,
    in p_room_id int,
    in p_check_in date,
    in p_check_out date,
    in p_total_amount decimal(10,2)
)
begin
    -- Insert booking details
    insert into booking (booking_id, guest_id, room_id, check_in, check_out, total_amount)
    values (p_booking_id, p_guest_id, p_room_id, p_check_in, p_check_out, p_total_amount);
    
    -- Update room status
    update room
    set availability_status = 'Booked'
    where room_id = p_room_id;
end //

delimiter ;
call add_booking(6, 2, 105, '2025-02-05', '2025-02-07', 18000.00);

delimiter //

create procedure update_booking (
    in p_booking_id int,
    in p_new_check_in date,
    in p_new_check_out date,
    in p_new_total decimal(10,2)
)
begin
    update booking
    set check_in = p_new_check_in,
        check_out = p_new_check_out,
        total_amount = p_new_total
    where booking_id = p_booking_id;
end //

delimiter ;
call update_booking(3, '2025-02-10', '2025-02-12', 14000.00);
