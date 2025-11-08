
create database cinema_booking;
use cinema_booking;

create table movies (
    movie_id int primary key auto_increment,
    title varchar(100),
    genre varchar(50),
    duration int, -- in minutes
    ticket_price decimal(10,2)
);

create table shows (
    show_id int primary key auto_increment,
    movie_id int,
    show_date date,
    show_time time,
    total_seats int,
    available_seats int,
    foreign key (movie_id) references movies(movie_id)
);

create table bookings (
    booking_id int primary key auto_increment,
    show_id int,
    customer_name varchar(50),
    tickets_booked int,
    booking_date date,
  foreign key (show_id) references shows(show_id)
);

insert into movies (title, genre, duration, ticket_price) values
('Inception', 'Sci-Fi', 148, 250.00),
('Avengers: Endgame', 'Action', 181, 300.00),
('Frozen II', 'Animation', 103, 200.00),
('The Batman', 'Action', 176, 280.00);

insert into shows (movie_id, show_date, show_time, total_seats, available_seats) values
(1, '2025-11-01', '18:00:00', 100, 100),
(2, '2025-11-01', '21:00:00', 120, 120),
(3, '2025-11-02', '17:00:00', 80, 80),
(4, '2025-11-02', '20:30:00', 90, 90);

insert into bookings (show_id, customer_name, tickets_booked, booking_date) values
(1, 'Amit Kumar', 3, '2025-10-30'),
(2, 'Priya Sharma', 5, '2025-10-30'),
(3, 'Rohan Mehta', 2, '2025-10-31');

select 
    m.movie_id,
    m.title,
    sum(b.tickets_booked) as total_tickets_sold,
    sum(b.tickets_booked * m.ticket_price) as total_revenue
from movies m
join shows s on m.movie_id = s.movie_id
join bookings b on s.show_id = b.show_id
group by m.movie_id, m.title;
/*'1', 'Inception', '3', '750.00'
'2', 'Avengers: Endgame', '5', '1500.00'
'3', 'Frozen II', '2', '400.00'*/

select m.title, s.show_date, s.show_time
from shows s
join movies m on s.movie_id = m.movie_id
where s.show_date = curdate();
/*'Inception', '2025-11-01', '18:00:00'
'Avengers: Endgame', '2025-11-01', '21:00:00'*/

select m.title, s.show_date, s.show_time
from shows s
join movies m on s.movie_id = m.movie_id
where s.show_date between curdate() and date_add(curdate(), interval 3 day);
/*'Inception', '2025-11-01', '18:00:00'
'Avengers: Endgame', '2025-11-01', '21:00:00'
'Frozen II', '2025-11-02', '17:00:00'
'The Batman', '2025-11-02', '20:30:00'*/

delimiter $$

create procedure insert_booking(
    in p_show_id int,
    in p_customer_name varchar(50),
    in p_tickets int,
    in p_booking_date date
)
begin
    declare available int;

    -- check available seats
    select available_seats into available from shows where show_id = p_show_id;

    if available >= p_tickets then
        -- insert booking
        insert into bookings (show_id, customer_name, tickets_booked, booking_date)
        values (p_show_id, p_customer_name, p_tickets, p_booking_date);

        -- update available seats
        update shows
        set available_seats = available_seats - p_tickets
        where show_id = p_show_id;

    else
        signal sqlstate '45000'
        set message_text = 'Not enough seats available!';
    end if;
end $$

delimiter ;
call insert_booking(2, 'Neha Verma', 4, '2025-10-31');
delimiter $$

create procedure update_booking(
    in p_booking_id int,
    in p_new_tickets int
)
begin
    declare old_tickets int;
    declare show_ref int;
    declare available int;

    -- fetch existing booking details
    select tickets_booked, show_id into old_tickets, show_ref
    from bookings
    where booking_id = p_booking_id;

    -- get available seats
    select available_seats into available from shows where show_id = show_ref;

    -- if increasing tickets, check seat availability
    if p_new_tickets > old_tickets and available < (p_new_tickets - old_tickets) then
        signal sqlstate '45000'
        set message_text = 'Not enough seats available for update!';
    else
        -- update booking record
        update bookings
        set tickets_booked = p_new_tickets
        where booking_id = p_booking_id;

        -- adjust seat count
        update shows
        set available_seats = available_seats + (old_tickets - p_new_tickets)
        where show_id = show_ref;
    end if;
end $$

delimiter ;
call update_booking(1, 5);

