create database manufacturing_company;
use manufacturing_company;

create table products (
    product_id int primary key auto_increment,
    product_name varchar(100),
    category varchar(50),
    unit_price decimal(10,2)
);
create table workers (
    worker_id int primary key auto_increment,
    worker_name varchar(100),
    department varchar(50),
    contact varchar(15)
);
create table production_records (
    record_id int primary key auto_increment,
    worker_id int,
    product_id int,
    production_date date,
    quantity int,
    remarks varchar(255),
    foreign key (worker_id) references workers(worker_id),
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, category, unit_price) values
('Steel Rod', 'Raw Material', 500.00),
('Copper Wire', 'Electrical', 800.00),
('Plastic Pipe', 'Plumbing', 300.00),
('Aluminium Sheet', 'Construction', 700.00);

insert into workers (worker_name, department, contact) values
('Amit Sharma', 'Assembly', '9876543210'),
('Priya Mehta', 'Welding', '9123456789'),
('Rohan Das', 'Packaging', '9988776655'),
('Sneha Iyer', 'Quality Control', '9865321470');

insert into production_records (worker_id, product_id, production_date, quantity, remarks) values
(1, 1, '2025-10-25', 120, 'Day Shift'),
(2, 2, '2025-10-25', 80, 'Night Shift'),
(3, 3, '2025-10-26', 150, 'Day Shift'),
(4, 4, '2025-10-26', 60, 'Inspection done'),
(1, 2, '2025-10-27', 100, 'Extra Hours');

select 
    pr.record_id,
    w.worker_name,
    w.department,
    p.product_name,
    p.category,
    pr.production_date,
    pr.quantity,
    (pr.quantity * p.unit_price) as total_value,
    pr.remarks
from production_records pr
join workers w on pr.worker_id = w.worker_id
join products p on pr.product_id = p.product_id
order by pr.production_date;
/*'1', 'Amit Sharma', 'Assembly', 'Steel Rod', 'Raw Material', '2025-10-25', '120', '60000.00', 'Day Shift'
'2', 'Priya Mehta', 'Welding', 'Copper Wire', 'Electrical', '2025-10-25', '80', '64000.00', 'Night Shift'
'3', 'Rohan Das', 'Packaging', 'Plastic Pipe', 'Plumbing', '2025-10-26', '150', '45000.00', 'Day Shift'
'4', 'Sneha Iyer', 'Quality Control', 'Aluminium Sheet', 'Construction', '2025-10-26', '60', '42000.00', 'Inspection done'
'5', 'Amit Sharma', 'Assembly', 'Copper Wire', 'Electrical', '2025-10-27', '100', '80000.00', 'Extra Hours'*/

select 
    p.product_name,
    sum(pr.quantity) as total_quantity_produced,
    sum(pr.quantity * p.unit_price) as total_value_produced
from products p
left join production_records pr on p.product_id = pr.product_id
group by p.product_name
order by total_quantity_produced desc;
/*'Copper Wire', '180', '144000.00'
'Plastic Pipe', '150', '45000.00'
'Steel Rod', '120', '60000.00'
'Aluminium Sheet', '60', '42000.00'*/

delimiter $$

create procedure insert_production_record(
    in p_worker_id int,
    in p_product_id int,
    in p_production_date date,
    in p_quantity int,
    in p_remarks varchar(255)
)
begin
    declare worker_exists int;
    declare product_exists int;

    select count(*) into worker_exists from workers where worker_id = p_worker_id;
    select count(*) into product_exists from products where product_id = p_product_id;

    if worker_exists > 0 and product_exists > 0 then
        insert into production_records (worker_id, product_id, production_date, quantity, remarks)
        values (p_worker_id, p_product_id, p_production_date, p_quantity, p_remarks);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Worker ID or Product ID!';
    end if;
end $$

delimiter ;
call insert_production_record(2, 3, '2025-11-01', 200, 'Overtime shift');

delimiter $$

create procedure update_production_record(
    in p_record_id int,
    in p_new_quantity int,
    in p_new_remarks varchar(255)
)
begin
    update production_records
    set 
        quantity = p_new_quantity,
        remarks = p_new_remarks
    where record_id = p_record_id;
end $$

delimiter ;
call update_production_record(3, 180, 'Updated after QC review');

