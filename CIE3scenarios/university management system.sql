create database p6;
use p6;

create table student (
    student_id int primary key,
    student_name varchar(50),
    age int,
    city varchar(50)
);

create table course (
    course_id int primary key,
    course_name varchar(50),
    duration varchar(20)
);

create table enrollment (
    enroll_id int primary key,
    student_id int,
    course_id int,
    enrollment_date date,
    foreign key (student_id) references student(student_id),
    foreign key (course_id) references course(course_id)
);

insert into student (student_id, student_name, age, city) values
(101, 'Aarav', 20, 'Delhi'),
(102, 'Bhavya', 21, 'Mumbai'),
(103, 'Chirag', 22, 'Pune'),
(104, 'Diya', 19, 'Chennai'),
(105, 'Eshan', 20, 'Kolkata');

insert into course (course_id, course_name, duration) values
(201, 'Computer Science', '3 Years'),
(202, 'Electronics', '3 Years'),
(203, 'Mechanical Engineering', '4 Years'),
(204, 'Civil Engineering', '4 Years');

insert into enrollment (enroll_id, student_id, course_id, enrollment_date) values
(1, 101, 201, '2024-07-01'),
(2, 102, 201, '2024-07-03'),
(3, 103, 202, '2024-07-05'),
(4, 104, 203, '2024-07-06'),
(5, 105, 204, '2024-07-07');

select 
    course.course_name,
    student.student_name,
    enrollment.enrollment_date
from enrollment
inner join student on enrollment.student_id = student.student_id
inner join course on enrollment.course_id = course.course_id
order by course.course_name;
/*'Civil Engineering', 'Eshan', '2024-07-07'
'Computer Science', 'Aarav', '2024-07-01'
'Computer Science', 'Bhavya', '2024-07-03'
'Electronics', 'Chirag', '2024-07-05'
'Mechanical Engineering', 'Diya', '2024-07-06'*/

select 
    course.course_name,
    student.student_name
from course
left outer join enrollment on course.course_id = enrollment.course_id
left outer join student on enrollment.student_id = student.student_id
order by course.course_name;
/*'Civil Engineering', 'Eshan'
'Computer Science', 'Aarav'
'Computer Science', 'Bhavya'
'Electronics', 'Chirag'
'Mechanical Engineering', 'Diya'*/

select 
    course.course_name,
    count(enrollment.student_id) as total_students
from course
left join enrollment on course.course_id = enrollment.course_id
group by course.course_name;
/*'Computer Science', '2'
'Electronics', '1'
'Mechanical Engineering', '1'
'Civil Engineering', '1'*/


