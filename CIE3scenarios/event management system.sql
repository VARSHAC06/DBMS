create database event_management;
use event_management;

create table events (
    event_id int primary key auto_increment,
    event_name varchar(100),
    event_date date,
    location varchar(100),
    description varchar(200)
);

create table participants (
    participant_id int primary key auto_increment,
    participant_name varchar(50),
    email varchar(100),
    contact varchar(15)
);

create table registrations (
    reg_id int primary key auto_increment,
    event_id int,
    participant_id int,
    reg_date date,
    foreign key (event_id) references events(event_id),
    foreign key (participant_id) references participants(participant_id)
);


insert into events (event_name, event_date, location, description) values
('Tech Summit 2025', '2025-11-05', 'Pune', 'A conference on emerging technologies.'),
('Art Expo 2025', '2025-11-10', 'Mumbai', 'An exhibition for modern art.'),
('Startup Meet 2025', '2025-12-01', 'Bangalore', 'Networking event for entrepreneurs.'),
('Health & Fitness Fair', '2025-10-20', 'Delhi', 'A fair promoting health and fitness.');

insert into participants (participant_name, email, contact) values
('Amit Sharma', 'amit.sharma@example.com', '9876543210'),
('Priya Mehta', 'priya.mehta@example.com', '9123456789'),
('Rohan Das', 'rohan.das@example.com', '9988776655'),
('Sneha Iyer', 'sneha.iyer@example.com', '9765432189');

insert into registrations (event_id, participant_id, reg_date) values
(1, 1, '2025-10-25'),
(1, 2, '2025-10-26'),
(2, 3, '2025-10-28'),
(3, 4, '2025-10-29');

select 
    e.event_name,
    e.event_date,
    p.participant_name,
    p.email,
    p.contact
from registrations r
join events e on r.event_id = e.event_id
join participants p on r.participant_id = p.participant_id
order by e.event_date;
/*'Tech Summit 2025', '2025-11-05', 'Amit Sharma', 'amit.sharma@example.com', '9876543210'
'Tech Summit 2025', '2025-11-05', 'Priya Mehta', 'priya.mehta@example.com', '9123456789'
'Art Expo 2025', '2025-11-10', 'Rohan Das', 'rohan.das@example.com', '9988776655'
'Startup Meet 2025', '2025-12-01', 'Sneha Iyer', 'sneha.iyer@example.com', '9765432189'*/

select 
    event_name,
    event_date,
    location,
    description
from events
where event_date > curdate()
order by event_date;
/*'Tech Summit 2025', '2025-11-05', 'Pune', 'A conference on emerging technologies.'
'Art Expo 2025', '2025-11-10', 'Mumbai', 'An exhibition for modern art.'
'Startup Meet 2025', '2025-12-01', 'Bangalore', 'Networking event for entrepreneurs.'*/

delimiter $$

create procedure register_participant(
    in p_event_id int,
    in p_participant_id int,
    in p_reg_date date
)
begin
    declare event_exists int;
    declare participant_exists int;

    select count(*) into event_exists from events where event_id = p_event_id;
    select count(*) into participant_exists from participants where participant_id = p_participant_id;

    if event_exists > 0 and participant_exists > 0 then
        insert into registrations (event_id, participant_id, reg_date)
        values (p_event_id, p_participant_id, p_reg_date);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Event ID or Participant ID!';
    end if;
end $$

delimiter ;
call register_participant(2, 1, '2025-11-01');


delimiter $$

create procedure update_registration(
    in p_reg_id int,
    in p_new_event_id int,
    in p_new_reg_date date
)
begin
    declare event_exists int;

    select count(*) into event_exists from events where event_id = p_new_event_id;

    if event_exists > 0 then
        update registrations
        set event_id = p_new_event_id,
            reg_date = p_new_reg_date
        where reg_id = p_reg_id;
    else
        signal sqlstate '45000'
        set message_text = 'Event not found!';
    end if;
end $$

delimiter ;
call update_registration(3, 1, '2025-11-02');

