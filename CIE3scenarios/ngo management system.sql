create database ngo_management;
use ngo_management;

create table volunteers (
    volunteer_id int primary key auto_increment,
    volunteer_name varchar(100),
    age int,
    contact varchar(15),
    city varchar(50)
);
create table projects (
    project_id int primary key auto_increment,
    project_name varchar(100),
    start_date date,
    end_date date,
    location varchar(100)
);
create table assignments (
    assignment_id int primary key auto_increment,
    volunteer_id int,
    project_id int,
    assigned_date date,
    role varchar(100),
    remarks varchar(255),
    foreign key (volunteer_id) references volunteers(volunteer_id),
    foreign key (project_id) references projects(project_id)
);

insert into volunteers (volunteer_name, age, contact, city) values
('Amit Sharma', 24, '9876543210', 'Pune'),
('Priya Nair', 27, '9123456789', 'Mumbai'),
('Rohan Patel', 22, '9988776655', 'Delhi'),
('Sneha Joshi', 25, '9865321470', 'Bangalore'),
('Karan Singh', 23, '9812345678', 'Hyderabad');

insert into projects (project_name, start_date, end_date, location) values
('Clean City Drive', '2025-10-01', '2025-11-15', 'Mumbai'),
('Tree Plantation Week', '2025-11-05', '2025-11-12', 'Pune'),
('Rural Education Program', '2025-09-10', '2025-12-20', 'Nashik'),
('Women Empowerment Workshop', '2025-10-15', '2025-11-25', 'Bangalore');

insert into assignments (volunteer_id, project_id, assigned_date, role, remarks) values
(1, 1, '2025-10-02', 'Coordinator', 'Managing team activities'),
(2, 1, '2025-10-03', 'Volunteer', 'Awareness campaign'),
(3, 2, '2025-11-05', 'Helper', 'Tree planting'),
(4, 3, '2025-09-12', 'Trainer', 'Teaching support'),
(5, 4, '2025-10-16', 'Organizer', 'Workshop management');

select 
    a.assignment_id,
    v.volunteer_name,
    v.city,
    p.project_name,
    p.location,
    a.role,
    a.assigned_date,
    a.remarks
from assignments a
join volunteers v on a.volunteer_id = v.volunteer_id
join projects p on a.project_id = p.project_id
order by p.project_name, v.volunteer_name;
/*'1', 'Amit Sharma', 'Pune', 'Clean City Drive', 'Mumbai', 'Coordinator', '2025-10-02', 'Managing team activities'
'2', 'Priya Nair', 'Mumbai', 'Clean City Drive', 'Mumbai', 'Volunteer', '2025-10-03', 'Awareness campaign'
'4', 'Sneha Joshi', 'Bangalore', 'Rural Education Program', 'Nashik', 'Trainer', '2025-09-12', 'Teaching support'
'3', 'Rohan Patel', 'Delhi', 'Tree Plantation Week', 'Pune', 'Helper', '2025-11-05', 'Tree planting'
'5', 'Karan Singh', 'Hyderabad', 'Women Empowerment Workshop', 'Bangalore', 'Organizer', '2025-10-16', 'Workshop management'*/

select 
    p.project_name,
    count(a.volunteer_id) as total_volunteers
from assignments a
join projects p on a.project_id = p.project_id
group by p.project_name
order by total_volunteers desc;
/*'Clean City Drive', '2'
'Tree Plantation Week', '1'
'Rural Education Program', '1'
'Women Empowerment Workshop', '1'*/

select 
    project_name,
    datediff(end_date, start_date) as project_duration_days
from projects;
/*'Clean City Drive', '45'
'Tree Plantation Week', '7'
'Rural Education Program', '101'
'Women Empowerment Workshop', '41'*/

delimiter $$

create procedure insert_assignment(
    in p_volunteer_id int,
    in p_project_id int,
    in p_assigned_date date,
    in p_role varchar(100),
    in p_remarks varchar(255)
)
begin
    declare volunteer_exists int;
    declare project_exists int;

    select count(*) into volunteer_exists from volunteers where volunteer_id = p_volunteer_id;
    select count(*) into project_exists from projects where project_id = p_project_id;

    if volunteer_exists > 0 and project_exists > 0 then
        insert into assignments (volunteer_id, project_id, assigned_date, role, remarks)
        values (p_volunteer_id, p_project_id, p_assigned_date, p_role, p_remarks);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Volunteer ID or Project ID!';
    end if;
end $$

delimiter ;
call insert_assignment(3, 4, '2025-11-01', 'Assistant', 'Helps with event setup');

delimiter $$

create procedure update_assignment(
    in p_assignment_id int,
    in p_new_role varchar(100),
    in p_new_remarks varchar(255)
)
begin
    update assignments
    set 
        role = p_new_role,
        remarks = p_new_remarks
    where assignment_id = p_assignment_id;
end $$

delimiter ;
call update_assignment(2, 'Lead Volunteer', 'Promoted to team leader');

