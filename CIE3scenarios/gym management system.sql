create database gym_management;
use gym_management;

create table members (
    member_id int primary key auto_increment,
    member_name varchar(50),
    age int,
    gender varchar(10),
    contact varchar(15)
);

create table trainers (
    trainer_id int primary key auto_increment,
    trainer_name varchar(50),
    specialization varchar(50),
    contact varchar(15)
);

create table sessions (
    session_id int primary key auto_increment,
    member_id int,
    trainer_id int,
    session_date date,
    session_type varchar(50),
    duration_minutes int,
    foreign key (member_id) references members(member_id),
    foreign key (trainer_id) references trainers(trainer_id)
);


insert into members (member_name, age, gender, contact) values
('Amit Sharma', 28, 'Male', '9876543210'),
('Priya Mehta', 25, 'Female', '9123456789'),
('Rohan Das', 30, 'Male', '9988776655'),
('Sneha Iyer', 27, 'Female', '9765432189');

insert into trainers (trainer_name, specialization, contact) values
('Rahul Singh', 'Strength Training', '9823456712'),
('Kavita Rao', 'Yoga', '9734567812'),
('Arjun Patil', 'Cardio & HIIT', '9876501234');

insert into sessions (member_id, trainer_id, session_date, session_type, duration_minutes) values
(1, 1, '2025-10-30', 'Weight Training', 60),
(2, 2, '2025-10-31', 'Yoga', 45),
(3, 3, '2025-11-01', 'HIIT', 50),
(1, 1, '2025-11-02', 'Strength', 55),
(4, 2, '2025-11-02', 'Meditation', 40);

select 
    s.session_id,
    m.member_name,
    t.trainer_name,
    t.specialization,
    s.session_type,
    s.session_date,
    s.duration_minutes
from sessions s
join members m on s.member_id = m.member_id
join trainers t on s.trainer_id = t.trainer_id
order by s.session_date;
/*'1', 'Amit Sharma', 'Rahul Singh', 'Strength Training', 'Weight Training', '2025-10-30', '60'
'2', 'Priya Mehta', 'Kavita Rao', 'Yoga', 'Yoga', '2025-10-31', '45'
'3', 'Rohan Das', 'Arjun Patil', 'Cardio & HIIT', 'HIIT', '2025-11-01', '50'
'4', 'Amit Sharma', 'Rahul Singh', 'Strength Training', 'Strength', '2025-11-02', '55'
'5', 'Sneha Iyer', 'Kavita Rao', 'Yoga', 'Meditation', '2025-11-02', '40'*/


select 
    t.trainer_name,
    t.specialization,
    count(s.session_id) as total_sessions
from trainers t
left join sessions s on t.trainer_id = s.trainer_id
group by t.trainer_name, t.specialization
order by total_sessions desc;
/*'Rahul Singh', 'Strength Training', '2'
'Kavita Rao', 'Yoga', '2'
'Arjun Patil', 'Cardio & HIIT', '1'*/

delimiter $$

create procedure insert_session(
    in p_member_id int,
    in p_trainer_id int,
    in p_session_date date,
    in p_session_type varchar(50),
    in p_duration_minutes int
)
begin
    declare member_exists int;
    declare trainer_exists int;

    select count(*) into member_exists from members where member_id = p_member_id;
    select count(*) into trainer_exists from trainers where trainer_id = p_trainer_id;

    if member_exists > 0 and trainer_exists > 0 then
        insert into sessions (member_id, trainer_id, session_date, session_type, duration_minutes)
        values (p_member_id, p_trainer_id, p_session_date, p_session_type, p_duration_minutes);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Member ID or Trainer ID!';
    end if;
end $$

delimiter ;
call insert_session(2, 3, '2025-11-03', 'Cardio', 60);


delimiter $$

create procedure update_session(
    in p_session_id int,
    in p_new_trainer_id int,
    in p_new_session_type varchar(50),
    in p_new_duration int
)
begin
    declare trainer_exists int;

    select count(*) into trainer_exists from trainers where trainer_id = p_new_trainer_id;

    if trainer_exists > 0 then
        update sessions
        set trainer_id = p_new_trainer_id,
            session_type = p_new_session_type,
            duration_minutes = p_new_duration
        where session_id = p_session_id;
    else
        signal sqlstate '45000'
        set message_text = 'Trainer not found!';
    end if;
end $$

delimiter ;

call update_session(3, 1, 'Power Training', 70);

