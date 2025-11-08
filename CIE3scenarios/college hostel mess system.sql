create database hostel_mess;
use hostel_mess;

create table students (
    student_id int primary key auto_increment,
    student_name varchar(100),
    department varchar(50),
    contact varchar(15)
);
create table meals (
    meal_id int primary key auto_increment,
    meal_date date,
    meal_type varchar(20),
    cost_per_meal decimal(10,2)
);
create table payments (
    payment_id int primary key auto_increment,
    student_id int,
    meal_id int,
    quantity int,
    payment_date date,
    total_amount decimal(10,2),
    payment_status varchar(20),
    foreign key (student_id) references students(student_id),
    foreign key (meal_id) references meals(meal_id)
);

insert into students (student_name, department, contact) values
('Amit Sharma', 'Computer Science', '9876543210'),
('Priya Nair', 'Mechanical', '9123456789'),
('Rohan Patel', 'Electrical', '9988776655'),
('Sneha Joshi', 'Civil', '9865321470'),
('Karan Singh', 'Electronics', '9812345678');

insert into meals (meal_date, meal_type, cost_per_meal) values
('2025-10-30', 'Breakfast', 40.00),
('2025-10-30', 'Lunch', 70.00),
('2025-10-30', 'Dinner', 80.00),
('2025-10-31', 'Lunch', 75.00),
('2025-10-31', 'Dinner', 85.00);

insert into payments (student_id, meal_id, quantity, payment_date, total_amount, payment_status) values
(1, 1, 1, '2025-10-30', 40.00, 'Paid'),
(2, 2, 1, '2025-10-30', 70.00, 'Paid'),
(3, 3, 1, '2025-10-30', 80.00, 'Unpaid'),
(4, 4, 1, '2025-10-31', 75.00, 'Paid'),
(5, 5, 1, '2025-10-31', 85.00, 'Unpaid');

select 
    p.payment_id,
    s.student_name,
    s.department,
    m.meal_date,
    m.meal_type,
    m.cost_per_meal,
    p.quantity,
    p.total_amount,
    p.payment_status
from payments p
join students s on p.student_id = s.student_id
join meals m on p.meal_id = m.meal_id
order by m.meal_date, s.student_name;
/*'1', 'Amit Sharma', 'Computer Science', '2025-10-30', 'Breakfast', '40.00', '1', '40.00', 'Paid'
'2', 'Priya Nair', 'Mechanical', '2025-10-30', 'Lunch', '70.00', '1', '70.00', 'Paid'
'3', 'Rohan Patel', 'Electrical', '2025-10-30', 'Dinner', '80.00', '1', '80.00', 'Unpaid'
'5', 'Karan Singh', 'Electronics', '2025-10-31', 'Dinner', '85.00', '1', '85.00', 'Unpaid'
'4', 'Sneha Joshi', 'Civil', '2025-10-31', 'Lunch', '75.00', '1', '75.00', 'Paid'*/

select 
    s.student_name,
    sum(p.total_amount) as total_meal_cost
from payments p
join students s on p.student_id = s.student_id
group by s.student_name
order by total_meal_cost desc;
/*'Karan Singh', '85.00'
'Rohan Patel', '80.00'
'Sneha Joshi', '75.00'
'Priya Nair', '70.00'
'Amit Sharma', '40.00'*/

delimiter $$

create procedure insert_payment(
    in p_student_id int,
    in p_meal_id int,
    in p_quantity int,
    in p_payment_date date,
    in p_payment_status varchar(20)
)
begin
    declare student_exists int;
    declare meal_exists int;
    declare cost decimal(10,2);
    declare total decimal(10,2);

    select count(*) into student_exists from students where student_id = p_student_id;
    select count(*) into meal_exists from meals where meal_id = p_meal_id;

    if student_exists > 0 and meal_exists > 0 then
        select cost_per_meal into cost from meals where meal_id = p_meal_id;
        set total = cost * p_quantity;
        insert into payments (student_id, meal_id, quantity, payment_date, total_amount, payment_status)
        values (p_student_id, p_meal_id, p_quantity, p_payment_date, total, p_payment_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Student ID or Meal ID!';
    end if;
end $$

delimiter ;
call insert_payment(2, 3, 1, '2025-10-31', 'Paid');

delimiter $$

create procedure update_payment(
    in p_payment_id int,
    in p_new_quantity int,
    in p_new_status varchar(20)
)
begin
    declare meal_id_val int;
    declare meal_cost decimal(10,2);
    declare new_total decimal(10,2);

    select meal_id into meal_id_val from payments where payment_id = p_payment_id;
    select cost_per_meal into meal_cost from meals where meal_id = meal_id_val;

    set new_total = meal_cost * p_new_quantity;

    update payments
    set 
        quantity = p_new_quantity,
        total_amount = new_total,
        payment_status = p_new_status
    where payment_id = p_payment_id;
end $$

delimiter ;
call update_payment(3, 2, 'Paid');
