create database p7;
use p7;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50),
    contact_no varchar(15)
);

create table account (
    account_id int primary key,
    customer_id int,
    account_type varchar(20),
    balance decimal(12,2),
    foreign key (customer_id) references customer(customer_id)
);

create table transaction (
    trans_id int primary key,
    account_id int,
    trans_date date,
    trans_type varchar(20),
    amount decimal(10,2),
    foreign key (account_id) references account(account_id)
);

insert into customer (customer_id, customer_name, city, contact_no) values
(1, 'Aarav', 'Delhi', '9876543210'),
(2, 'Bhavya', 'Mumbai', '9988776655'),
(3, 'Chirag', 'Pune', '9123456789'),
(4, 'Diya', 'Chennai', '9090909090');

insert into account (account_id, customer_id, account_type, balance) values
(101, 1, 'Savings', 50000.00),
(102, 2, 'Current', 75000.00),
(103, 3, 'Savings', 42000.00),
(104, 4, 'Savings', 38000.00);

insert into transaction (trans_id, account_id, trans_date, trans_type, amount) values
(1, 101, '2025-01-10', 'Deposit', 10000.00),
(2, 101, '2025-01-15', 'Withdrawal', 5000.00),
(3, 102, '2025-01-18', 'Deposit', 15000.00),
(4, 103, '2025-01-19', 'Deposit', 8000.00),
(5, 104, '2025-01-20', 'Withdrawal', 3000.00),
(6, 102, '2025-01-25', 'Deposit', 10000.00);

select 
    t.trans_id,
    c.customer_name,
    a.account_type,
    t.trans_type,
    t.amount,
    t.trans_date
from transaction t
inner join account a on t.account_id = a.account_id
inner join customer c on a.customer_id = c.customer_id
where t.trans_date >= curdate() - interval 10 day
order by t.trans_date desc;

select 
    a.account_id,
    c.customer_name,
    sum(t.amount) as total_deposits
from transaction t
inner join account a on t.account_id = a.account_id
inner join customer c on a.customer_id = c.customer_id
where t.trans_type = 'Deposit'
group by a.account_id, c.customer_name;
/*'101', 'Aarav', '10000.00'
'102', 'Bhavya', '25000.00'
'103', 'Chirag', '8000.00'*/

select 
    c.customer_name,
    a.account_type,
    t.trans_type,
    t.amount,
    t.trans_date
from customer c
inner join account a on c.customer_id = a.customer_id
inner join transaction t on a.account_id = t.account_id
order by c.customer_name;
/*'Aarav', 'Savings', 'Deposit', '10000.00', '2025-01-10'
'Aarav', 'Savings', 'Withdrawal', '5000.00', '2025-01-15'
'Bhavya', 'Current', 'Deposit', '15000.00', '2025-01-18'
'Bhavya', 'Current', 'Deposit', '10000.00', '2025-01-25'
'Chirag', 'Savings', 'Deposit', '8000.00', '2025-01-19'
'Diya', 'Savings', 'Withdrawal', '3000.00', '2025-01-20'*/

delimiter //

create procedure add_transaction (
    in p_trans_id int,
    in p_account_id int,
    in p_trans_date date,
    in p_trans_type varchar(20),
    in p_amount decimal(10,2)
)
begin
    -- Insert transaction
    insert into transaction (trans_id, account_id, trans_date, trans_type, amount)
    values (p_trans_id, p_account_id, p_trans_date, p_trans_type, p_amount);

    -- Update balance based on transaction type
    if p_trans_type = 'Deposit' then
        update account
        set balance = balance + p_amount
        where account_id = p_account_id;
    elseif p_trans_type = 'Withdrawal' then
        update account
        set balance = balance - p_amount
        where account_id = p_account_id;
    end if;
end //

delimiter ;
call add_transaction(7, 103, '2025-02-01', 'Deposit', 5000.00);

delimiter //

create procedure update_transaction (
    in p_trans_id int,
    in p_new_amount decimal(10,2)
)
begin
    update transaction
    set amount = p_new_amount
    where trans_id = p_trans_id;
end //

delimiter ;
call update_transaction(2, 6000.00);
