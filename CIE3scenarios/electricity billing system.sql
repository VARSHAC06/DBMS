create database electricity_billing;
use electricity_billing;

create table customers (
    customer_id int primary key auto_increment,
    customer_name varchar(100),
    address varchar(200),
    contact varchar(15)
);
create table meters (
    meter_id int primary key auto_increment,
    customer_id int,
    meter_number varchar(20),
    meter_type varchar(50),
    install_date date,
    foreign key (customer_id) references customers(customer_id)
);
create table bills (
    bill_id int primary key auto_increment,
    meter_id int,
    bill_month varchar(20),
    start_date date,
    end_date date,
    units_consumed int,
    unit_rate decimal(10,2),
    total_amount decimal(10,2),
    payment_status varchar(20),
    foreign key (meter_id) references meters(meter_id)
);

insert into customers (customer_name, address, contact) values
('Amit Sharma', 'Pune', '9876543210'),
('Priya Nair', 'Mumbai', '9123456789'),
('Rohit Mehta', 'Delhi', '9988776655'),
('Sneha Joshi', 'Bangalore', '9865321470'),
('Karan Patel', 'Hyderabad', '9812345678');

insert into meters (customer_id, meter_number, meter_type, install_date) values
(1, 'MTR1001', 'Residential', '2024-05-10'),
(2, 'MTR1002', 'Commercial', '2024-06-15'),
(3, 'MTR1003', 'Residential', '2024-07-01'),
(4, 'MTR1004', 'Industrial', '2024-08-20'),
(5, 'MTR1005', 'Residential', '2024-09-05');

insert into bills (meter_id, bill_month, start_date, end_date, units_consumed, unit_rate, total_amount, payment_status) values
(1, 'October 2025', '2025-10-01', '2025-10-31', 250, 7.50, 1875.00, 'Paid'),
(2, 'October 2025', '2025-10-01', '2025-10-31', 450, 8.00, 3600.00, 'Unpaid'),
(3, 'October 2025', '2025-10-01', '2025-10-31', 300, 7.50, 2250.00, 'Paid'),
(4, 'October 2025', '2025-10-01', '2025-10-31', 800, 9.00, 7200.00, 'Paid'),
(5, 'October 2025', '2025-10-01', '2025-10-31', 200, 7.00, 1400.00, 'Unpaid');

select 
    b.bill_id,
    c.customer_name,
    c.address,
    m.meter_number,
    m.meter_type,
    b.bill_month,
    b.units_consumed,
    b.unit_rate,
    b.total_amount,
    b.payment_status
from bills b
join meters m on b.meter_id = m.meter_id
join customers c on m.customer_id = c.customer_id
order by c.customer_name;
/*'1', 'Amit Sharma', 'Pune', 'MTR1001', 'Residential', 'October 2025', '250', '7.50', '1875.00', 'Paid'
'5', 'Karan Patel', 'Hyderabad', 'MTR1005', 'Residential', 'October 2025', '200', '7.00', '1400.00', 'Unpaid'
'2', 'Priya Nair', 'Mumbai', 'MTR1002', 'Commercial', 'October 2025', '450', '8.00', '3600.00', 'Unpaid'
'3', 'Rohit Mehta', 'Delhi', 'MTR1003', 'Residential', 'October 2025', '300', '7.50', '2250.00', 'Paid'
'4', 'Sneha Joshi', 'Bangalore', 'MTR1004', 'Industrial', 'October 2025', '800', '9.00', '7200.00', 'Paid'*/

select 
    c.customer_name,
    sum(b.total_amount) as total_bill_amount
from bills b
join meters m on b.meter_id = m.meter_id
join customers c on m.customer_id = c.customer_id
group by c.customer_name
order by total_bill_amount desc;
/*'Sneha Joshi', '7200.00'
'Priya Nair', '3600.00'
'Rohit Mehta', '2250.00'
'Amit Sharma', '1875.00'
'Karan Patel', '1400.00'*/

delimiter $$

create procedure insert_bill(
    in p_meter_id int,
    in p_bill_month varchar(20),
    in p_start_date date,
    in p_end_date date,
    in p_units_consumed int,
    in p_unit_rate decimal(10,2),
    in p_payment_status varchar(20)
)
begin
    declare meter_exists int;
    declare total decimal(10,2);

    select count(*) into meter_exists from meters where meter_id = p_meter_id;
    set total = p_units_consumed * p_unit_rate;

    if meter_exists > 0 then
        insert into bills (meter_id, bill_month, start_date, end_date, units_consumed, unit_rate, total_amount, payment_status)
        values (p_meter_id, p_bill_month, p_start_date, p_end_date, p_units_consumed, p_unit_rate, total, p_payment_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Meter ID!';
    end if;
end $$

delimiter ;
call insert_bill(3, 'November 2025', '2025-11-01', '2025-11-30', 320, 7.50, 'Unpaid');

delimiter $$

create procedure update_bill(
    in p_bill_id int,
    in p_new_units int,
    in p_new_rate decimal(10,2),
    in p_new_status varchar(20)
)
begin
    declare new_total decimal(10,2);
    set new_total = p_new_units * p_new_rate;

    update bills
    set 
        units_consumed = p_new_units,
        unit_rate = p_new_rate,
        total_amount = new_total,
        payment_status = p_new_status
    where bill_id = p_bill_id;
end $$

delimiter ;
call update_bill(2, 460, 8.00, 'Paid');

select 
    bill_id,
    bill_month,
    datediff(end_date, start_date) as billing_days,
    start_date,
    end_date
from bills;
/*'1', 'October 2025', '30', '2025-10-01', '2025-10-31'
'2', 'October 2025', '30', '2025-10-01', '2025-10-31'
'3', 'October 2025', '30', '2025-10-01', '2025-10-31'
'4', 'October 2025', '30', '2025-10-01', '2025-10-31'
'5', 'October 2025', '30', '2025-10-01', '2025-10-31'
'6', 'November 2025', '29', '2025-11-01', '2025-11-30'*/

