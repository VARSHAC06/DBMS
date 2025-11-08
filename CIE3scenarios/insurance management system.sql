create database insurance_management;
use insurance_management;

create table customers (
    cust_id int primary key auto_increment,
    cust_name varchar(100),
    contact varchar(15),
    city varchar(50)
);

create table policies (
    policy_id int primary key auto_increment,
    policy_name varchar(100),
    policy_type varchar(50),
    premium_amount decimal(10,2),
    coverage_amount decimal(10,2)
);

create table claims (
    claim_id int primary key auto_increment,
    cust_id int,
    policy_id int,
    claim_date date,
    claim_amount decimal(10,2),
    claim_status varchar(20),
    foreign key (cust_id) references customers(cust_id),
    foreign key (policy_id) references policies(policy_id)
);

insert into customers (cust_name, contact, city) values
('Amit Sharma', '9876543210', 'Pune'),
('Priya Mehta', '9123456789', 'Mumbai'),
('Rohan Das', '9988776655', 'Delhi'),
('Sneha Iyer', '9865321470', 'Chennai');

insert into policies (policy_name, policy_type, premium_amount, coverage_amount) values
('Health Plus', 'Health', 12000.00, 500000.00),
('Life Secure', 'Life', 15000.00, 1000000.00),
('Auto Protect', 'Vehicle', 8000.00, 300000.00),
('Home Shield', 'Property', 10000.00, 600000.00);

insert into claims (cust_id, policy_id, claim_date, claim_amount, claim_status) values
(1, 1, '2025-10-25', 25000.00, 'Approved'),
(2, 2, '2025-10-27', 50000.00, 'Pending'),
(3, 3, '2025-10-28', 15000.00, 'Rejected'),
(1, 1, '2025-11-01', 20000.00, 'Approved'),
(4, 4, '2025-11-02', 10000.00, 'Pending');

select 
    c.claim_id,
    cu.cust_name,
    p.policy_name,
    p.policy_type,
    c.claim_date,
    c.claim_amount,
    c.claim_status
from claims c
join customers cu on c.cust_id = cu.cust_id
join policies p on c.policy_id = p.policy_id
order by c.claim_date;
/*'1', 'Amit Sharma', 'Health Plus', 'Health', '2025-10-25', '25000.00', 'Approved'
'2', 'Priya Mehta', 'Life Secure', 'Life', '2025-10-27', '50000.00', 'Pending'
'3', 'Rohan Das', 'Auto Protect', 'Vehicle', '2025-10-28', '15000.00', 'Rejected'
'4', 'Amit Sharma', 'Health Plus', 'Health', '2025-11-01', '20000.00', 'Approved'
'5', 'Sneha Iyer', 'Home Shield', 'Property', '2025-11-02', '10000.00', 'Pending'*/

select 
    p.policy_name,
    p.policy_type,
    count(c.claim_id) as total_claims,
    sum(c.claim_amount) as total_claim_amount
from claims c
join policies p on c.policy_id = p.policy_id
group by p.policy_name, p.policy_type
order by total_claims desc;
/*'Health Plus', 'Health', '2', '45000.00'
'Life Secure', 'Life', '1', '50000.00'
'Auto Protect', 'Vehicle', '1', '15000.00'
'Home Shield', 'Property', '1', '10000.00'*/

select 
    claim_id,
    claim_date,
    cust_id,
    policy_id,
    claim_amount
from claims
where claim_date >= date_sub(curdate(), interval 7 day);
/*'1', '2025-10-25', '1', '1', '25000.00'
'2', '2025-10-27', '2', '2', '50000.00'
'3', '2025-10-28', '3', '3', '15000.00'
'4', '2025-11-01', '1', '1', '20000.00'
'5', '2025-11-02', '4', '4', '10000.00'*/

delimiter $$

create procedure insert_claim(
    in p_cust_id int,
    in p_policy_id int,
    in p_claim_date date,
    in p_claim_amount decimal(10,2),
    in p_claim_status varchar(20)
)
begin
    declare cust_exists int;
    declare policy_exists int;

    select count(*) into cust_exists from customers where cust_id = p_cust_id;
    select count(*) into policy_exists from policies where policy_id = p_policy_id;

    if cust_exists > 0 and policy_exists > 0 then
        insert into claims (cust_id, policy_id, claim_date, claim_amount, claim_status)
        values (p_cust_id, p_policy_id, p_claim_date, p_claim_amount, p_claim_status);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Customer ID or Policy ID!';
    end if;
end $$

delimiter ;
call insert_claim(2, 2, '2025-11-03', 40000.00, 'Pending');

delimiter $$

create procedure update_claim(
    in p_claim_id int,
    in p_new_amount decimal(10,2),
    in p_new_status varchar(20)
)
begin
    update claims
    set claim_amount = p_new_amount,
        claim_status = p_new_status
    where claim_id = p_claim_id;
end $$

delimiter ;
call update_claim(2, 55000.00, 'Approved');

