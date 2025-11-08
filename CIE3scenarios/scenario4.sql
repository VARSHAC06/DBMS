create database scenario4;
use scenario4;
create table customer (
    custid int primary key,
    custname varchar(100)
);

create table orders (
    orderid int primary key,
    custid int,
    orderdate date,
    totalamount decimal(10,2),
    foreign key (custid) references customer(custid)
);

insert into customer values
(1, 'alice'),
(2, 'bob'),
(3, 'charlie'),
(4, 'david');

insert into orders values
(1, 1, '2025-10-01', 250.00),
(2, 1, '2025-10-05', 300.00),
(3, 2, '2025-10-03', 150.00),
(4, 3, '2025-10-07', 400.00);

select 
    c.custname,
    o.orderdate
from customer c
inner join orders o on c.custid = o.custid;
/*alice	2025-10-01
alice	2025-10-05
bob	2025-10-03
charlie	2025-10-07*/
select 
    c.custname,
    o.orderdate
from customer c
left outer join orders o on c.custid = o.custid;
/*alice	2025-10-01
alice	2025-10-05
bob	2025-10-03
charlie	2025-10-07
david	*/
select 
    c.custname,
    sum(o.totalamount) as total_sales
from customer c
left join orders o on c.custid = o.custid
group by c.custname;
/*alice	550.00
bob	150.00
charlie	400.00
david	*/
select max(totalamount) as maximum_order_amount from orders;
/*400.00*/
select avg(totalamount) as average_order_amount from orders;
/*275.000000*/
