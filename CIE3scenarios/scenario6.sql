create database scenario6;
use scenario6;

create table department (
    dept_id int primary key,
    dept_name varchar(50)
);

create table student (
    student_id int primary key,
    student_name varchar(50),
    dept_id int,
    foreign key (dept_id) references department(dept_id)
);

create table exam (
    exam_id int primary key,
    student_id int,
    subject_name varchar(50),
    marks int,
    foreign key (student_id) references student(student_id)
);

insert into department (dept_id, dept_name) values
(1, 'Computer Science'),
(2, 'Electronics'),
(3, 'Mechanical'),
(4, 'Civil');

insert into student (student_id, student_name, dept_id) values
(101, 'Aarav', 1),
(102, 'Bhavya', 1),
(103, 'Chirag', 2),
(104, 'Diya', 3),
(105, 'Eshan', 2);

insert into exam (exam_id, student_id, subject_name, marks) values
(1, 101, 'Database Systems', 85),
(2, 101, 'Operating Systems', 78),
(3, 102, 'Database Systems', 92),
(4, 102, 'Operating Systems', 88),
(5, 103, 'Circuits', 75),
(6, 104, 'Thermodynamics', 80),
(7, 105, 'Circuits', 68);

select student.student_name, department.dept_name
from student
inner join department
on student.dept_id = department.dept_id;
/*'Aarav', 'Computer Science'
'Bhavya', 'Computer Science'
'Chirag', 'Electronics'
'Eshan', 'Electronics'
'Diya', 'Mechanical'*/

select department.dept_name, student.student_name
from department
left outer join student
on department.dept_id = student.dept_id;
/*'Computer Science', 'Aarav'
'Computer Science', 'Bhavya'
'Electronics', 'Chirag'
'Electronics', 'Eshan'
'Mechanical', 'Diya'
'Civil', NULL*/

select subject_name, avg(marks) as average_marks
from exam
group by subject_name;
/*'Database Systems', '88.5000'
'Operating Systems', '83.0000'
'Circuits', '71.5000'
'Thermodynamics', '80.0000'*/

select max(marks) as highest_marks from exam;
/*'92'*/

select sum(marks) as total_marks from exam;
/*'566'*/
