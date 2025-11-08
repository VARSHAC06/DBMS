create database donation_management;
use donation_management;

create table donors (
    donor_id int primary key auto_increment,
    donor_name varchar(100),
    email varchar(100),
    contact varchar(15)
);
create table campaigns (
    campaign_id int primary key auto_increment,
    campaign_name varchar(100),
    start_date date,
    end_date date,
    goal_amount decimal(12,2)
);
create table donations (
    donation_id int primary key auto_increment,
    donor_id int,
    campaign_id int,
    donation_date date,
    amount decimal(10,2),
    payment_method varchar(30),
    remarks varchar(255),
    foreign key (donor_id) references donors(donor_id),
    foreign key (campaign_id) references campaigns(campaign_id)
);

insert into donors (donor_name, email, contact) values
('Amit Sharma', 'amit@example.com', '9876543210'),
('Priya Nair', 'priya@example.com', '9123456789'),
('Rohan Patel', 'rohan@example.com', '9988776655'),
('Sneha Joshi', 'sneha@example.com', '9865321470');

insert into campaigns (campaign_name, start_date, end_date, goal_amount) values
('Food for All', '2025-10-01', '2025-12-31', 100000.00),
('Clean Water Drive', '2025-09-15', '2025-11-30', 75000.00),
('Education for Every Child', '2025-08-01', '2025-12-15', 120000.00);

insert into donations (donor_id, campaign_id, donation_date, amount, payment_method, remarks) values
(1, 1, '2025-10-10', 5000.00, 'UPI', 'First-time donor'),
(2, 1, '2025-10-12', 3000.00, 'Card', 'Repeat donor'),
(3, 2, '2025-09-20', 2500.00, 'Cash', 'Offline donation'),
(4, 3, '2025-10-15', 7000.00, 'UPI', 'Scholarship support'),
(1, 3, '2025-10-20', 4500.00, 'Card', 'Second donation');

select 
    d.donation_id,
    dn.donor_name,
    dn.email,
    c.campaign_name,
    c.goal_amount,
    d.amount,
    d.payment_method,
    d.donation_date,
    d.remarks
from donations d
join donors dn on d.donor_id = dn.donor_id
join campaigns c on d.campaign_id = c.campaign_id
order by d.donation_date;
/*'3', 'Rohan Patel', 'rohan@example.com', 'Clean Water Drive', '75000.00', '2500.00', 'Cash', '2025-09-20', 'Offline donation'
'1', 'Amit Sharma', 'amit@example.com', 'Food for All', '100000.00', '5000.00', 'UPI', '2025-10-10', 'First-time donor'
'2', 'Priya Nair', 'priya@example.com', 'Food for All', '100000.00', '3000.00', 'Card', '2025-10-12', 'Repeat donor'
'4', 'Sneha Joshi', 'sneha@example.com', 'Education for Every Child', '120000.00', '7000.00', 'UPI', '2025-10-15', 'Scholarship support'
'5', 'Amit Sharma', 'amit@example.com', 'Education for Every Child', '120000.00', '4500.00', 'Card', '2025-10-20', 'Second donation'*/

select 
    c.campaign_name,
    sum(d.amount) as total_donations,
    count(d.donation_id) as total_donors
from donations d
join campaigns c on d.campaign_id = c.campaign_id
group by c.campaign_name
order by total_donations desc;
/*'Education for Every Child', '11500.00', '2'
'Food for All', '8000.00', '2'
'Clean Water Drive', '2500.00', '1'*/

delimiter $$

create procedure insert_donation(
    in p_donor_id int,
    in p_campaign_id int,
    in p_donation_date date,
    in p_amount decimal(10,2),
    in p_payment_method varchar(30),
    in p_remarks varchar(255)
)
begin
    declare donor_exists int;
    declare campaign_exists int;

    select count(*) into donor_exists from donors where donor_id = p_donor_id;
    select count(*) into campaign_exists from campaigns where campaign_id = p_campaign_id;

    if donor_exists > 0 and campaign_exists > 0 then
        insert into donations (donor_id, campaign_id, donation_date, amount, payment_method, remarks)
        values (p_donor_id, p_campaign_id, p_donation_date, p_amount, p_payment_method, p_remarks);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Donor ID or Campaign ID!';
    end if;
end $$

delimiter ;
call insert_donation(2, 2, '2025-11-01', 4000.00, 'UPI', 'Post-event donation');


delimiter $$

create procedure update_donation(
    in p_donation_id int,
    in p_new_amount decimal(10,2),
    in p_new_remarks varchar(255)
)
begin
    update donations
    set 
        amount = p_new_amount,
        remarks = p_new_remarks
    where donation_id = p_donation_id;
end $$

delimiter ;
call update_donation(3, 3000.00, 'Adjusted donation after correction');
