create database hostel_management;
use hostel_management;

create table students (
    student_id int primary key auto_increment,
    student_name varchar(100),
    gender varchar(10),
    contact varchar(15)
);
create table rooms (
    room_id int primary key auto_increment,
    room_number varchar(10),
    room_type varchar(50),
    rent_amount decimal(10,2)
);
create table rent_payments (
    payment_id int primary key auto_increment,
    student_id int,
    room_id int,
    payment_date date,
    amount_paid decimal(10,2),
    payment_mode varchar(20),
    remarks varchar(255),
    foreign key (student_id) references students(student_id),
    foreign key (room_id) references rooms(room_id)
);


insert into students (student_name, gender, contact) values
('Aarav Singh', 'Male', '9876543210'),
('Priya Sharma', 'Female', '9123456789'),
('Rohit Mehta', 'Male', '9988776655'),
('Sneha Nair', 'Female', '9865321470');

insert into rooms (room_number, room_type, rent_amount) values
('A101', 'Single', 6000.00),
('A102', 'Double', 4000.00),
('B201', 'Triple', 3000.00),
('C301', 'Single', 6500.00);

insert into rent_payments (student_id, room_id, payment_date, amount_paid, payment_mode, remarks) values
(1, 1, '2025-10-01', 6000.00, 'UPI', 'Paid on time'),
(2, 2, '2025-10-03', 4000.00, 'Cash', 'Paid late'),
(3, 3, '2025-10-05', 3000.00, 'Card', 'Paid on time'),
(4, 4, '2025-10-06', 6500.00, 'UPI', 'Advance payment'),
(1, 1, '2025-11-01', 6000.00, 'UPI', 'Paid for November');

select 
    rp.payment_id,
    s.student_name,
    s.gender,
    r.room_number,
    r.room_type,
    rp.payment_date,
    rp.amount_paid,
    rp.payment_mode,
    rp.remarks
from rent_payments rp
join students s on rp.student_id = s.student_id
join rooms r on rp.room_id = r.room_id
order by rp.payment_date;
/*'1', 'Aarav Singh', 'Male', 'A101', 'Single', '2025-10-01', '6000.00', 'UPI', 'Paid on time'
'2', 'Priya Sharma', 'Female', 'A102', 'Double', '2025-10-03', '4000.00', 'Cash', 'Paid late'
'3', 'Rohit Mehta', 'Male', 'B201', 'Triple', '2025-10-05', '3000.00', 'Card', 'Paid on time'
'4', 'Sneha Nair', 'Female', 'C301', 'Single', '2025-10-06', '6500.00', 'UPI', 'Advance payment'
'5', 'Aarav Singh', 'Male', 'A101', 'Single', '2025-11-01', '6000.00', 'UPI', 'Paid for November'*/

select 
    date_format(payment_date, '%Y-%m') as month_year,
    sum(amount_paid) as total_rent_collected
from rent_payments
group by month_year
order by month_year;
/*'2025-10', '19500.00'
'2025-11', '6000.00'*/

delimiter $$

create procedure insert_rent_payment(
    in p_student_id int,
    in p_room_id int,
    in p_payment_date date,
    in p_amount_paid decimal(10,2),
    in p_payment_mode varchar(20),
    in p_remarks varchar(255)
)
begin
    declare student_exists int;
    declare room_exists int;

    select count(*) into student_exists from students where student_id = p_student_id;
    select count(*) into room_exists from rooms where room_id = p_room_id;

    if student_exists > 0 and room_exists > 0 then
        insert into rent_payments (student_id, room_id, payment_date, amount_paid, payment_mode, remarks)
        values (p_student_id, p_room_id, p_payment_date, p_amount_paid, p_payment_mode, p_remarks);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Student ID or Room ID!';
    end if;
end $$

delimiter ;
call insert_rent_payment(2, 2, '2025-11-03', 4000.00, 'UPI', 'Paid for November');


delimiter $$

create procedure update_rent_payment(
    in p_payment_id int,
    in p_new_amount decimal(10,2),
    in p_new_remarks varchar(255)
)
begin
    update rent_payments
    set 
        amount_paid = p_new_amount,
        remarks = p_new_remarks
    where payment_id = p_payment_id;
end $$

delimiter ;
call update_rent_payment(3, 3200.00, 'Adjusted after late fee');