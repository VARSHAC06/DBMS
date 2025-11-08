create database recruitment_management_system;
use recruitment_management_system;

create table applicants (
    applicant_id int primary key auto_increment,
    applicant_name varchar(100),
    email varchar(100),
    phone varchar(15)
);
create table jobs (
    job_id int primary key auto_increment,
    job_title varchar(100),
    department varchar(50),
    location varchar(50),
    salary decimal(10,2)
);
create table applications (
    application_id int primary key auto_increment,
    applicant_id int,
    job_id int,
    application_date date,
    status varchar(30),
    foreign key (applicant_id) references applicants(applicant_id),
    foreign key (job_id) references jobs(job_id)
);

insert into applicants (applicant_name, email, phone) values
('Amit Sharma', 'amit@gmail.com', '9876543210'),
('Priya Mehta', 'priya@gmail.com', '9123456789'),
('Rohan Das', 'rohan@gmail.com', '9988776655'),
('Sneha Iyer', 'sneha@gmail.com', '9865321470');

insert into jobs (job_title, department, location, salary) values
('Software Engineer', 'IT', 'Pune', 60000.00),
('HR Executive', 'HR', 'Mumbai', 40000.00),
('Marketing Manager', 'Marketing', 'Delhi', 55000.00),
('Data Analyst', 'IT', 'Bangalore', 50000.00);

insert into applications (applicant_id, job_id, application_date, status) values
(1, 1, '2025-10-25', 'Under Review'),
(2, 2, '2025-10-26', 'Interview Scheduled'),
(3, 3, '2025-10-26', 'Rejected'),
(4, 4, '2025-10-27', 'Under Review'),
(1, 3, '2025-10-28', 'Selected');

select 
    a.application_id,
    ap.applicant_name,
    ap.email,
    j.job_title,
    j.department,
    j.location,
    a.application_date,
    a.status
from applications a
join applicants ap on a.applicant_id = ap.applicant_id
join jobs j on a.job_id = j.job_id
order by a.application_date;
/*'1', 'Amit Sharma', 'amit@gmail.com', 'Software Engineer', 'IT', 'Pune', '2025-10-25', 'Under Review'
'2', 'Priya Mehta', 'priya@gmail.com', 'HR Executive', 'HR', 'Mumbai', '2025-10-26', 'Interview Scheduled'
'3', 'Rohan Das', 'rohan@gmail.com', 'Marketing Manager', 'Marketing', 'Delhi', '2025-10-26', 'Rejected'
'4', 'Sneha Iyer', 'sneha@gmail.com', 'Data Analyst', 'IT', 'Bangalore', '2025-10-27', 'Under Review'
'5', 'Amit Sharma', 'amit@gmail.com', 'Marketing Manager', 'Marketing', 'Delhi', '2025-10-28', 'Selected'*/

select 
    j.job_title,
    count(a.application_id) as total_applications
from jobs j
left join applications a on j.job_id = a.job_id
group by j.job_title
order by total_applications desc;
/*'Marketing Manager', '2'
'Software Engineer', '1'
'HR Executive', '1'
'Data Analyst', '1'*/

delimiter $$

create procedure insert_application(
    in p_applicant_id int,
    in p_job_id int,
    in p_application_date date,
    in p_status varchar(30)
)
begin
    declare applicant_exists int;
    declare job_exists int;

    select count(*) into applicant_exists from applicants where applicant_id = p_applicant_id;
    select count(*) into job_exists from jobs where job_id = p_job_id;

    if applicant_exists > 0 and job_exists > 0 then
        insert into applications (applicant_id, job_id, application_date, status)
        values (p_applicant_id, p_job_id, p_application_date, p_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Applicant ID or Job ID!';
    end if;
end $$

delimiter ;
call insert_application(2, 4, '2025-11-01', 'Under Review');


delimiter $$

create procedure update_application_status(
    in p_application_id int,
    in p_new_status varchar(30)
)
begin
    update applications
    set status = p_new_status
    where application_id = p_application_id;
end $$

delimiter ;
call update_application_status(3, 'Interview Scheduled');

