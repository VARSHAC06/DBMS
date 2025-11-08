create database scenario7;
use scenario7;

create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50)
);

create table account (
    account_id int primary key,
    customer_id int,
    account_type varchar(20),
    balance decimal(10,2),
    foreign key (customer_id) references customer(customer_id)
);

create table transaction (
    transaction_id int primary key,
    account_id int,
    transaction_type varchar(20),
    amount decimal(10,2),
    foreign key (account_id) references account(account_id)
);

insert into customer (customer_id, customer_name, city) values
(1, 'Aarav', 'Delhi'),
(2, 'Bhavya', 'Mumbai'),
(3, 'Chirag', 'Pune'),
(4, 'Diya', 'Chennai');

insert into account (account_id, customer_id, account_type, balance) values
(101, 1, 'Savings', 45000.00),
(102, 2, 'Current', 78000.00),
(103, 3, 'Savings', 52000.00),
(104, 4, 'Savings', 60000.00);

insert into transaction (transaction_id, account_id, transaction_type, amount) values
(1, 101, 'Deposit', 10000.00),
(2, 101, 'Withdrawal', 5000.00),
(3, 102, 'Deposit', 20000.00),
(4, 103, 'Deposit', 15000.00),
(5, 104, 'Withdrawal', 8000.00);

select customer.customer_name, account.balance
from customer
inner join account
on customer.customer_id = account.customer_id;
/*'Aarav', '45000.00'
'Bhavya', '78000.00'
'Chirag', '52000.00'
'Diya', '60000.00'*/

select account.account_id, account.account_type, transaction.transaction_type, transaction.amount
from account
left outer join transaction
on account.account_id = transaction.account_id;
/*'101', 'Savings', 'Deposit', '10000.00'
'101', 'Savings', 'Withdrawal', '5000.00'
'102', 'Current', 'Deposit', '20000.00'
'103', 'Savings', 'Deposit', '15000.00'
'104', 'Savings', 'Withdrawal', '8000.00'*/

select account_id, sum(amount) as total_transaction_amount
from transaction
group by account_id;
/*'101', '15000.00'
'102', '20000.00'
'103', '15000.00'
'104', '8000.00'*/

select max(balance) as highest_balance
from account;
/*'78000.00'*/

select sum(amount) as total_deposit_amount
from transaction
where transaction_type = 'Deposit';
/*'45000.00'*/
