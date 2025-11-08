create database p10;
use p10;

create table flight (
    flight_id int primary key,
    flight_number varchar(10),
    source varchar(50),
    destination varchar(50),
    departure_date date,
    available_seats int
);

create table passenger (
    passenger_id int primary key,
    passenger_name varchar(50),
    gender varchar(10),
    contact_no varchar(15)
);

create table booking (
    booking_id int primary key,
    passenger_id int,
    flight_id int,
    booking_date date,
    seat_no varchar(10),
    fare decimal(10,2),
    foreign key (passenger_id) references passenger(passenger_id),
    foreign key (flight_id) references flight(flight_id)
);

insert into flight (flight_id, flight_number, source, destination, departure_date, available_seats) values
(1, 'AI101', 'Delhi', 'Mumbai', '2025-02-10', 100),
(2, 'AI205', 'Chennai', 'Kolkata', '2025-02-12', 80),
(3, 'AI309', 'Bangalore', 'Delhi', '2025-02-15', 120),
(4, 'AI412', 'Pune', 'Hyderabad', '2025-02-18', 60),
(5, 'AI520', 'Mumbai', 'Goa', '2025-02-20', 90);

insert into passenger (passenger_id, passenger_name, gender, contact_no) values
(1, 'Aarav Mehta', 'Male', '9876543210'),
(2, 'Bhavya Patel', 'Female', '9988776655'),
(3, 'Chirag Singh', 'Male', '9123456789'),
(4, 'Diya Sharma', 'Female', '9090909090'),
(5, 'Esha Nair', 'Female', '9898989898');

insert into booking (booking_id, passenger_id, flight_id, booking_date, seat_no, fare) values
(1, 1, 1, '2025-02-01', '12A', 5500.00),
(2, 2, 1, '2025-02-02', '12B', 5500.00),
(3, 3, 2, '2025-02-05', '15C', 6200.00),
(4, 4, 3, '2025-02-06', '10D', 7000.00),
(5, 5, 5, '2025-02-07', '18A', 4500.00);

select 
    p.passenger_name,
    f.flight_number,
    f.source,
    f.destination,
    f.departure_date,
    b.seat_no,
    b.fare
from booking b
inner join passenger p on b.passenger_id = p.passenger_id
inner join flight f on b.flight_id = f.flight_id
order by f.departure_date;
/*'Aarav Mehta', 'AI101', 'Delhi', 'Mumbai', '2025-02-10', '12A', '5500.00'
'Bhavya Patel', 'AI101', 'Delhi', 'Mumbai', '2025-02-10', '12B', '5500.00'
'Chirag Singh', 'AI205', 'Chennai', 'Kolkata', '2025-02-12', '15C', '6200.00'
'Diya Sharma', 'AI309', 'Bangalore', 'Delhi', '2025-02-15', '10D', '78000.00'
'Esha Nair', 'AI520', 'Mumbai', 'Goa', '2025-02-20', '18A', '4500.00'*/

select 
    f.flight_number,
    f.source,
    f.destination,
    count(b.booking_id) as total_passengers
from flight f
left join booking b on f.flight_id = b.flight_id
group by f.flight_number, f.source, f.destination;
/*'AI101', 'Delhi', 'Mumbai', '2'
'AI205', 'Chennai', 'Kolkata', '1'
'AI309', 'Bangalore', 'Delhi', '1'
'AI412', 'Pune', 'Hyderabad', '0'
'AI520', 'Mumbai', 'Goa', '1'*/

select 
    flight_number,
    source,
    destination,
    departure_date,
    available_seats
from flight
where departure_date >= curdate()
order by departure_date;

delimiter //

create procedure add_booking (
    in p_booking_id int,
    in p_passenger_id int,
    in p_flight_id int,
    in p_booking_date date,
    in p_seat_no varchar(10),
    in p_fare decimal(10,2)
)
begin
    -- Insert booking details
    insert into booking (booking_id, passenger_id, flight_id, booking_date, seat_no, fare)
    values (p_booking_id, p_passenger_id, p_flight_id, p_booking_date, p_seat_no, p_fare);

    -- Update available seats
    update flight
    set available_seats = available_seats - 1
    where flight_id = p_flight_id;
end //

delimiter ;
call add_booking(6, 2, 3, '2025-02-08', '20B', 6900.00);

delimiter //

create procedure update_booking (
    in p_booking_id int,
    in p_new_seat_no varchar(10),
    in p_new_fare decimal(10,2)
)
begin
    update booking
    set seat_no = p_new_seat_no,
        fare = p_new_fare
    where booking_id = p_booking_id;
end //

delimiter ;
call update_booking(3, '15D', 6400.00);
