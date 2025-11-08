create database scenario8;
use scenario8;

create table guest (
    guest_id int primary key,
    guest_name varchar(50),
    city varchar(50)
);

create table room (
    room_id int primary key,
    room_type varchar(30),
    price_per_night decimal(10,2)
);

create table booking (
    booking_id int primary key,
    guest_id int,
    room_id int,
    check_in_date date,
    check_out_date date,
    total_amount decimal(10,2),
    foreign key (guest_id) references guest(guest_id),
    foreign key (room_id) references room(room_id)
);

insert into guest (guest_id, guest_name, city) values
(1, 'Aarav', 'Delhi'),
(2, 'Bhavya', 'Mumbai'),
(3, 'Chirag', 'Pune'),
(4, 'Diya', 'Chennai');

insert into room (room_id, room_type, price_per_night) values
(101, 'Single', 2500.00),
(102, 'Double', 4000.00),
(103, 'Suite', 7500.00),
(104, 'Deluxe', 6000.00);

insert into booking (booking_id, guest_id, room_id, check_in_date, check_out_date, total_amount) values
(1, 1, 101, '2025-10-01', '2025-10-03', 5000.00),
(2, 2, 102, '2025-10-02', '2025-10-05', 12000.00),
(3, 3, 103, '2025-10-05', '2025-10-06', 7500.00),
(4, 1, 104, '2025-10-07', '2025-10-09', 12000.00);

select guest.guest_name, room.room_type
from guest
inner join booking
on guest.guest_id = booking.guest_id
inner join room
on booking.room_id = room.room_id;
/*'Aarav', 'Single'
'Aarav', 'Deluxe'
'Bhavya', 'Double'
'Chirag', 'Suite'*/

select room.room_type, booking.booking_id, booking.total_amount
from room
left outer join booking
on room.room_id = booking.room_id;
/*'Single', '1', '5000.00'
'Double', '2', '12000.00'
'Suite', '3', '7500.00'
'Deluxe', '4', '12000.00'*/

select room.room_type, count(booking.booking_id) as total_bookings
from room
left join booking
on room.room_id = booking.room_id
group by room.room_type;
/*'Single', '1'
'Double', '1'
'Suite', '1'
'Deluxe', '1'*/

select max(price_per_night) as highest_room_price
from room;
/*'7500.00'*/

select sum(total_amount) as total_revenue
from booking;
/*36500.00*/