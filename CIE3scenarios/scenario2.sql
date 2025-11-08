create database scenario2;
use scenario2;

create table department (
    deptid int primary key,
    deptname varchar(100)
);

create table employee (
    empid int primary key,
    empname varchar(100),
    deptid int,
    salary decimal(10,2),
    foreign key (deptid) references department(deptid)
);

insert into department values
(1, 'hr'),
(2, 'finance'),
(3, 'it'),
(4, 'marketing');  

insert into employee values
(1, 'alice', 1, 50000.00),
(2, 'bob', 2, 60000.00),
(3, 'charlie', 3, 70000.00),
(4, 'david', 1, 55000.00),
(5, 'emma', 2, 62000.00);

select 
    e.empname,
    d.deptname
from employee e
inner join department d on e.deptid = d.deptid;
/*alice	hr
david	hr
bob	finance
emma	finance
charlie	it*/

select 
    d.deptname,
    e.empname
from employee e
right outer join department d on e.deptid = d.deptid;
/*hr	alice
hr	david
finance	bob
finance	emma
it	charlie
marketing*/

select 
    d.deptname,
    avg(e.salary) as average_salary
from employee e
inner join department d on e.deptid = d.deptid
group by d.deptname;
/*hr	52500.000000
finance	61000.000000
it	70000.000000*/

select max(salary) as maximum_salary from employee;
/*70000.00*/

select sum(salary) as total_salary_expenditure from employee;
/*297000.00*/