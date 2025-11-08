create database p11;
use p11;

create table student (
    student_id int primary key,
    student_name varchar(50),
    department varchar(50),
    contact_no varchar(15)
);

create table subject (
    subject_id int primary key,
    subject_name varchar(50),
    max_marks int
);

create table result (
    result_id int primary key,
    student_id int,
    subject_id int,
    marks_obtained int,
    exam_date date,
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into student (student_id, student_name, department, contact_no) values
(1, 'Aarav Mehta', 'Computer Science', '9876543210'),
(2, 'Bhavya Patel', 'Information Technology', '9988776655'),
(3, 'Chirag Singh', 'Electronics', '9123456789'),
(4, 'Diya Sharma', 'Mechanical', '9090909090'),
(5, 'Esha Nair', 'Computer Science', '9898989898');

insert into subject (subject_id, subject_name, max_marks) values
(101, 'Database Systems', 100),
(102, 'Computer Networks', 100),
(103, 'Operating Systems', 100),
(104, 'Data Structures', 100),
(105, 'Software Engineering', 100);

insert into result (result_id, student_id, subject_id, marks_obtained, exam_date) values
(1, 1, 101, 85, '2025-01-20'),
(2, 1, 102, 90, '2025-01-22'),
(3, 2, 101, 78, '2025-01-20'),
(4, 3, 103, 88, '2025-01-23'),
(5, 4, 104, 70, '2025-01-25'),
(6, 5, 105, 95, '2025-01-26');

select 
    s.student_name,
    s.department,
    sub.subject_name,
    r.marks_obtained,
    sub.max_marks,
    r.exam_date
from result r
inner join student s on r.student_id = s.student_id
inner join subject sub on r.subject_id = sub.subject_id
order by s.student_name;
/*'Aarav Mehta', 'Computer Science', 'Database Systems', '85', '100', '2025-01-20'
'Aarav Mehta', 'Computer Science', 'Computer Networks', '90', '100', '2025-01-22'
'Bhavya Patel', 'Information Technology', 'Database Systems', '78', '100', '2025-01-20'
'Chirag Singh', 'Electronics', 'Operating Systems', '88', '100', '2025-01-23'
'Diya Sharma', 'Mechanical', 'Data Structures', '70', '100', '2025-01-25'
'Esha Nair', 'Computer Science', 'Software Engineering', '95', '100', '2025-01-26'*/

select 
    s.student_name,
    sum(r.marks_obtained) as total_marks
from result r
inner join student s on r.student_id = s.student_id
group by s.student_name;
/*'Aarav Mehta', '175'
'Bhavya Patel', '78'
'Chirag Singh', '88'
'Diya Sharma', '70'
'Esha Nair', '95'*/

select 
    sub.subject_name,
    avg(r.marks_obtained) as average_marks
from result r
inner join subject sub on r.subject_id = sub.subject_id
group by sub.subject_name;
/*'Database Systems', '81.5000'
'Computer Networks', '90.0000'
'Operating Systems', '88.0000'
'Data Structures', '70.0000'
'Software Engineering', '95.0000'*/

delimiter //
create procedure add_result (
    in p_result_id int,
    in p_student_id int,
    in p_subject_id int,
    in p_marks_obtained int,
    in p_exam_date date
)
begin
    insert into result (result_id, student_id, subject_id, marks_obtained, exam_date)
    values (p_result_id, p_student_id, p_subject_id, p_marks_obtained, p_exam_date);
end //
delimiter ;
call add_result(7, 2, 104, 82, '2025-01-28');

delimiter //
create procedure update_marks (
    in p_result_id int,
    in p_new_marks int
)
begin
    update result
    set marks_obtained = p_new_marks
    where result_id = p_result_id;
end //
delimiter ;
call update_marks(3, 85);
