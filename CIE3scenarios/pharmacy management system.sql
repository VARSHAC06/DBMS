create database p12;
use p12;

create table medicine (
    medicine_id int primary key,
    medicine_name varchar(50),
    supplier_id int,
    price_per_unit decimal(10,2),
    stock_quantity int
);

create table supplier (
    supplier_id int primary key,
    supplier_name varchar(50),
    contact_no varchar(15),
    city varchar(50)
);

create table sales (
    sale_id int primary key,
    medicine_id int,
    quantity_sold int,
    sale_date date,
    total_amount decimal(10,2),
    foreign key (medicine_id) references medicine(medicine_id)
);

insert into supplier (supplier_id, supplier_name, contact_no, city) values
(1, 'Medilife Pharma', '9876543210', 'Mumbai'),
(2, 'HealthPlus Distributors', '9123456789', 'Delhi'),
(3, 'CureWell Medicines', '9988776655', 'Chennai'),
(4, 'LifeCare Supplies', '9090909090', 'Bangalore'),
(5, 'PharmaNation', '9898989898', 'Pune');

insert into medicine (medicine_id, medicine_name, supplier_id, price_per_unit, stock_quantity) values
(101, 'Paracetamol', 1, 2.50, 500),
(102, 'Amoxicillin', 2, 5.00, 300),
(103, 'Cetirizine', 3, 3.00, 400),
(104, 'Cough Syrup', 4, 6.50, 250),
(105, 'Pain Relief Gel', 5, 8.00, 200);

insert into sales (sale_id, medicine_id, quantity_sold, sale_date, total_amount) values
(1, 101, 50, '2025-01-10', 125.00),
(2, 102, 30, '2025-01-12', 150.00),
(3, 103, 40, '2025-01-14', 120.00),
(4, 104, 20, '2025-01-15', 130.00),
(5, 105, 10, '2025-01-18', 80.00);

select 
    m.medicine_name,
    s.supplier_name,
    sa.quantity_sold,
    sa.sale_date,
    sa.total_amount
from sales sa
inner join medicine m on sa.medicine_id = m.medicine_id
inner join supplier s on m.supplier_id = s.supplier_id
order by sa.sale_date;
/*'Paracetamol', 'Medilife Pharma', '50', '2025-01-10', '125.00'
'Amoxicillin', 'HealthPlus Distributors', '30', '2025-01-12', '150.00'
'Cetirizine', 'CureWell Medicines', '40', '2025-01-14', '120.00'
'Cough Syrup', 'LifeCare Supplies', '20', '2025-01-15', '130.00'
'Pain Relief Gel', 'PharmaNation', '10', '2025-01-18', '80.00'*/

select 
    m.medicine_name,
    sum(sa.total_amount) as total_sales
from sales sa
inner join medicine m on sa.medicine_id = m.medicine_id
group by m.medicine_name;
/*'Paracetamol', '125.00'
'Amoxicillin', '150.00'
'Cetirizine', '120.00'
'Cough Syrup', '130.00'
'Pain Relief Gel', '80.00'*/

select 
    m.medicine_name,
    m.stock_quantity as current_stock
from medicine m;
/*'Paracetamol', '500'
'Amoxicillin', '300'
'Cetirizine', '400'
'Cough Syrup', '250'
'Pain Relief Gel', '200'*/

delimiter //

create procedure add_sale (
    in p_sale_id int,
    in p_medicine_id int,
    in p_quantity_sold int,
    in p_sale_date date
)
begin
    declare p_price decimal(10,2);
    declare p_total decimal(10,2);

    select price_per_unit into p_price from medicine where medicine_id = p_medicine_id;

    set p_total = p_price * p_quantity_sold;

    insert into sales (sale_id, medicine_id, quantity_sold, sale_date, total_amount)
    values (p_sale_id, p_medicine_id, p_quantity_sold, p_sale_date, p_total);

    -- Update stock after sale
    update medicine
    set stock_quantity = stock_quantity - p_quantity_sold
    where medicine_id = p_medicine_id;
end //
delimiter ;
