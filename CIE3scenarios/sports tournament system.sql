create database sports_tournament_system;
use sports_tournament_system;

create table teams (
    team_id int primary key auto_increment,
    team_name varchar(100),
    coach_name varchar(100),
    city varchar(50)
);

create table players (
    player_id int primary key auto_increment,
    player_name varchar(100),
    role varchar(50),
    team_id int,
    foreign key (team_id) references teams(team_id)
);

create table matches (
    match_id int primary key auto_increment,
    team1_id int,
    team2_id int,
    match_date date,
    venue varchar(100),
    result varchar(100),
    foreign key (team1_id) references teams(team_id),
    foreign key (team2_id) references teams(team_id)
);

insert into teams (team_name, coach_name, city) values
('Delhi Warriors', 'Ravi Sharma', 'Delhi'),
('Mumbai Strikers', 'Priya Mehta', 'Mumbai'),
('Chennai Challengers', 'Amit Verma', 'Chennai'),
('Kolkata Titans', 'Sneha Iyer', 'Kolkata');

insert into players (player_name, role, team_id) values
('Arjun Singh', 'Batsman', 1),
('Rohit Das', 'Bowler', 1),
('Vikram Mehta', 'All-rounder', 2),
('Amit Kumar', 'Batsman', 2),
('Ravi Raj', 'Bowler', 3),
('Suresh Nair', 'All-rounder', 3),
('Karan Patel', 'Batsman', 4),
('Deepak Iyer', 'Bowler', 4);

insert into matches (team1_id, team2_id, match_date, venue, result) values
(1, 2, '2025-10-25', 'Delhi Stadium', 'Delhi Warriors Won'),
(3, 4, '2025-10-26', 'Chennai Arena', 'Kolkata Titans Won'),
(1, 3, '2025-10-28', 'Pune Ground', 'Chennai Challengers Won'),
(2, 4, '2025-10-30', 'Mumbai Dome', 'Draw'),
(1, 4, '2025-11-01', 'Kolkata Field', 'Delhi Warriors Won');

select 
    m.match_id,
    m.match_date,
    m.venue,
    m.result,
    t1.team_name as team1,
    t2.team_name as team2,
    p.player_name,
    p.role
from matches m
join teams t1 on m.team1_id = t1.team_id
join teams t2 on m.team2_id = t2.team_id
join players p on p.team_id in (t1.team_id, t2.team_id)
order by m.match_date;
/*'1', '2025-10-25', 'Delhi Stadium', 'Delhi Warriors Won', 'Delhi Warriors', 'Mumbai Strikers', 'Arjun Singh', 'Batsman'
'1', '2025-10-25', 'Delhi Stadium', 'Delhi Warriors Won', 'Delhi Warriors', 'Mumbai Strikers', 'Rohit Das', 'Bowler'
'1', '2025-10-25', 'Delhi Stadium', 'Delhi Warriors Won', 'Delhi Warriors', 'Mumbai Strikers', 'Vikram Mehta', 'All-rounder'
'1', '2025-10-25', 'Delhi Stadium', 'Delhi Warriors Won', 'Delhi Warriors', 'Mumbai Strikers', 'Amit Kumar', 'Batsman'
'2', '2025-10-26', 'Chennai Arena', 'Kolkata Titans Won', 'Chennai Challengers', 'Kolkata Titans', 'Ravi Raj', 'Bowler'
'2', '2025-10-26', 'Chennai Arena', 'Kolkata Titans Won', 'Chennai Challengers', 'Kolkata Titans', 'Suresh Nair', 'All-rounder'
'2', '2025-10-26', 'Chennai Arena', 'Kolkata Titans Won', 'Chennai Challengers', 'Kolkata Titans', 'Karan Patel', 'Batsman'
'2', '2025-10-26', 'Chennai Arena', 'Kolkata Titans Won', 'Chennai Challengers', 'Kolkata Titans', 'Deepak Iyer', 'Bowler'
'3', '2025-10-28', 'Pune Ground', 'Chennai Challengers Won', 'Delhi Warriors', 'Chennai Challengers', 'Arjun Singh', 'Batsman'
'3', '2025-10-28', 'Pune Ground', 'Chennai Challengers Won', 'Delhi Warriors', 'Chennai Challengers', 'Rohit Das', 'Bowler'
'3', '2025-10-28', 'Pune Ground', 'Chennai Challengers Won', 'Delhi Warriors', 'Chennai Challengers', 'Ravi Raj', 'Bowler'
'3', '2025-10-28', 'Pune Ground', 'Chennai Challengers Won', 'Delhi Warriors', 'Chennai Challengers', 'Suresh Nair', 'All-rounder'
'4', '2025-10-30', 'Mumbai Dome', 'Draw', 'Mumbai Strikers', 'Kolkata Titans', 'Vikram Mehta', 'All-rounder'
'4', '2025-10-30', 'Mumbai Dome', 'Draw', 'Mumbai Strikers', 'Kolkata Titans', 'Amit Kumar', 'Batsman'
'4', '2025-10-30', 'Mumbai Dome', 'Draw', 'Mumbai Strikers', 'Kolkata Titans', 'Karan Patel', 'Batsman'
'4', '2025-10-30', 'Mumbai Dome', 'Draw', 'Mumbai Strikers', 'Kolkata Titans', 'Deepak Iyer', 'Bowler'
'5', '2025-11-01', 'Kolkata Field', 'Delhi Warriors Won', 'Delhi Warriors', 'Kolkata Titans', 'Arjun Singh', 'Batsman'
'5', '2025-11-01', 'Kolkata Field', 'Delhi Warriors Won', 'Delhi Warriors', 'Kolkata Titans', 'Rohit Das', 'Bowler'
'5', '2025-11-01', 'Kolkata Field', 'Delhi Warriors Won', 'Delhi Warriors', 'Kolkata Titans', 'Karan Patel', 'Batsman'
'5', '2025-11-01', 'Kolkata Field', 'Delhi Warriors Won', 'Delhi Warriors', 'Kolkata Titans', 'Deepak Iyer', 'Bowler'*/

select 
    t.team_name,
    count(m.match_id) as total_matches
from teams t
join matches m on t.team_id in (m.team1_id, m.team2_id)
group by t.team_name
order by total_matches desc;
/*'Delhi Warriors', '3'
'Kolkata Titans', '3'
'Mumbai Strikers', '2'
'Chennai Challengers', '2'*/

delimiter $$

create procedure add_match(
    in p_team1_id int,
    in p_team2_id int,
    in p_match_date date,
    in p_venue varchar(100),
    in p_result varchar(100)
)
begin
    declare team1_exists int;
    declare team2_exists int;

    select count(*) into team1_exists from teams where team_id = p_team1_id;
    select count(*) into team2_exists from teams where team_id = p_team2_id;

    if team1_exists > 0 and team2_exists > 0 then
        insert into matches (team1_id, team2_id, match_date, venue, result)
        values (p_team1_id, p_team2_id, p_match_date, p_venue, p_result);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Team IDs!';
    end if;
end $$

delimiter ;
call add_match(2, 3, '2025-11-02', 'Bangalore Arena', 'Mumbai Strikers Won');


delimiter $$

create procedure update_match_result(
    in p_match_id int,
    in p_new_result varchar(100)
)
begin
    update matches
    set result = p_new_result
    where match_id = p_match_id;
end $$

delimiter ;
call update_match_result(4, 'Mumbai Strikers Won');
