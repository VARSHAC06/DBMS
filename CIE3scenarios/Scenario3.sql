create database scenario3;
use scenario3;
create table student (
    studentid int primary key,
    studentname varchar(100)
);

create table course (
    courseid int primary key,
    coursename varchar(100),
    coursefee decimal(8,2)
);

create table enrollment (
    enrollid int primary key,
    studentid int,
    courseid int,
    foreign key (studentid) references student(studentid),
    foreign key (courseid) references course(courseid)
);

insert into student values
(1, 'alice'),
(2, 'bob'),
(3, 'charlie'),
(4, 'david');

insert into course values
(1, 'database systems', 500.00),
(2, 'computer networks', 600.00),
(3, 'data structures', 550.00),
(4, 'operating systems', 650.00); 

insert into enrollment values
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 1, 3);

select 
    s.studentname,
    c.coursename
from enrollment e
inner join student s on e.studentid = s.studentid
inner join course c on e.courseid = c.courseid;
/*alice	database systems
bob	database systems
charlie	computer networks
alice	data structures*/
select 
    c.coursename,
    s.studentname
from course c
left outer join enrollment e on c.courseid = e.courseid
left outer join student s on e.studentid = s.studentid;
/*database systems	alice
database systems	bob
computer networks	charlie
data structures	alice
operating systems*/	
select 
    c.coursename,
    count(e.studentid) as total_students_enrolled
from course c
left join enrollment e on c.courseid = e.courseid
group by c.coursename;
/*database systems	2
computer networks	1
data structures	1
operating systems	0*/
select avg(coursefee) as average_course_fee from course;
/*575.000000*/
select count(studentid) as total_students_enrolled from enrollment;
/*4*/
