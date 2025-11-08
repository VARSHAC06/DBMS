create database p4;
use p4;

create table department (
    dept_id int primary key,
    dept_name varchar(50),
    location varchar(50)
);

create table employee (
    emp_id int primary key,
    emp_name varchar(50),
    dept_id int,
    job_title varchar(50),
    hire_date date,
    foreign key (dept_id) references department(dept_id)
);

create table salary (
    salary_id int primary key,
    emp_id int,
    basic_salary decimal(10,2),
    allowances decimal(10,2),
    deductions decimal(10,2),
    foreign key (emp_id) references employee(emp_id)
);

insert into department (dept_id, dept_name, location) values
(1, 'Human Resources', 'Delhi'),
(2, 'Finance', 'Mumbai'),
(3, 'IT', 'Bangalore'),
(4, 'Marketing', 'Pune');

insert into employee (emp_id, emp_name, dept_id, job_title, hire_date) values
(101, 'Aarav', 1, 'HR Manager', '2021-05-12'),
(102, 'Bhavya', 2, 'Accountant', '2022-03-20'),
(103, 'Chirag', 3, 'Software Engineer', '2021-11-01'),
(104, 'Diya', 3, 'System Analyst', '2023-01-10'),
(105, 'Eshan', 4, 'Sales Executive', '2022-07-05');

insert into salary (salary_id, emp_id, basic_salary, allowances, deductions) values
(1, 101, 50000, 8000, 2000),
(2, 102, 45000, 7000, 1500),
(3, 103, 60000, 10000, 2500),
(4, 104, 55000, 9000, 2000),
(5, 105, 40000, 6000, 1000);

select employee.emp_name, department.dept_name
from employee
inner join department
on employee.dept_id = department.dept_id;
/*'Aarav', 'Human Resources'
'Bhavya', 'Finance'
'Chirag', 'IT'
'Diya', 'IT'
'Eshan', 'Marketing'*/

select employee.emp_name,
       (basic_salary + allowances - deductions) as total_salary
from salary
inner join employee on salary.emp_id = employee.emp_id;
/*'Aarav', '56000.00'
'Bhavya', '50500.00'
'Chirag', '67500.00'
'Diya', '62000.00'
'Eshan', '45000.00'*/

select 
    sum(basic_salary + allowances - deductions) as total_salary_paid,
    avg(basic_salary + allowances - deductions) as average_salary
from salary;
/*'281000.00', '56200.000000'*/

delimiter //
create procedure add_salary (
    in p_salary_id int,
    in p_emp_id int,
    in p_basic decimal(10,2),
    in p_allowances decimal(10,2),
    in p_deductions decimal(10,2)
)
begin
    insert into salary (salary_id, emp_id, basic_salary, allowances, deductions)
    values (p_salary_id, p_emp_id, p_basic, p_allowances, p_deductions);
end //
delimiter ;
call add_salary(6, 101, 52000, 8500, 2500);

delimiter //
create procedure update_salary (
    in p_emp_id int,
    in p_basic decimal(10,2),
    in p_allowances decimal(10,2),
    in p_deductions decimal(10,2)
)
begin
    update salary
    set basic_salary = p_basic,
        allowances = p_allowances,
        deductions = p_deductions
    where emp_id = p_emp_id;
end //
delimiter ;
call update_salary(103, 63000, 11000, 3000);
