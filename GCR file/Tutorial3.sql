create database schooldb;
use schooldb;

create table student (
    studentid int primary key,
    firstname varchar(50),
    lastname varchar(50),
    dob date,
    class varchar(20),
    marks int,
    city varchar(50)
);

create table teacher (
    teacherid int primary key,
    firstname varchar(50),
    lastname varchar(50),
    subject varchar(50),
    hiredate date,
    salary decimal(10,2)
);

create table course (
    courseid int primary key,
    coursename varchar(100),
    credits int
);

create table enroll (
    enrollid int primary key,
    studentid int,
    courseid int,
    grade varchar(5),
    foreign key (studentid) references student(studentid),
    foreign key (courseid) references course(courseid)
);

insert into student values (1,'ravi','kumar','2006-01-15','10th',85,'delhi');
insert into student values (2,'sneha','sharma','2007-03-20','9th',72,'mumbai');
insert into student values (3,'arjun','verma','2006-01-10','10th',95,'kolkata');

insert into teacher values (1,'amit','singh','maths','2015-06-10',45250);
insert into teacher values (2,'priya','nair','science','2018-09-15',38900);

insert into course values (1,'mathematics',4);
insert into course values (2,'science',3);
insert into course values (3,'history',2);

insert into enroll values (1,1,1,'a');
insert into enroll values (2,2,2,'b');
insert into enroll values (3,3,3,'a');

select * from student;
/*'1', 'ravi', 'kumar', '2006-01-15', '10th', '85', 'delhi'
'2', 'sneha', 'sharma', '2007-03-20', '9th', '72', 'mumbai'
'3', 'arjun', 'verma', '2006-01-10', '10th', '95', 'kolkata'*/

select coursename, right(coursename, 3) as lastthreechars from course;
/*'mathematics', 'ics'
'science', 'nce'
'history', 'ory'*/

select concat(firstname, ' ', lastname) as fullname from teacher;
/*'amit singh'
'priya nair'*/

select firstname, lastname, length(firstname) + length(lastname) as namelength 
from student;
/*'ravi', 'kumar', '9'
'sneha', 'sharma', '11'
'arjun', 'verma', '10'*/

update course 
set coursename = replace(coursename, 'maths', 'mathematics');

select abs(max(marks) - min(marks)) as difference from student;
/*'23'*/

select firstname, lastname, round(salary, -3) as roundedsalary from teacher;
/*'amit', 'singh', '45000'
'priya', 'nair', '39000'*/

select coursename, sqrt(credits) as creditroot from course;
/*'mathematics', '2'
'science', '1.7320508075688772'
'history', '1.4142135623730951'*/


select firstname, marks, ceil(marks) as ceilmarks, floor(marks) as floormarks 
from student;
/*'ravi', '85', '85', '85'
'sneha', '72', '72', '72'
'arjun', '95', '95', '95'*/

select firstname, marks, mod(marks, 5) as modulus from student;
/*'ravi', '85', '0'
'sneha', '72', '2'
'arjun', '95', '0'*/

select now() as currentdatetime;
/*'2025-09-10 06:33:01'*/

select firstname, lastname, year(hiredate) as year, month(hiredate) as month 
from teacher;
/*'amit', 'singh', 2015, '6'
'priya', 'nair', 2018, '9'*/

select * from student 
where month(dob) = 1;
/*'1', 'ravi', 'kumar', '2006-01-15', '10th', '85', 'delhi'
'3', 'arjun', 'verma', '2006-01-10', '10th', '95', 'kolkata'*/

select firstname, datediff(curdate(), hiredate) as daysworked 
from teacher;
/*'amit', '3745'
'priya', '2552'*/

select count(*) as totalstudents from student;
/*'3'*/

select avg(salary) as averagesalary from teacher;
/*'42075.000000'*/

select max(marks) as highestmarks, min(marks) as lowestmarks from student;
/*'95', '72'*/







