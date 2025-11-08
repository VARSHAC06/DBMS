create database p2;
use p2;

create table books (
    book_id int primary key,
    title varchar(100),
    author varchar(50),
    genre varchar(30),
    available_copies int
);

create table members (
    member_id int primary key,
    member_name varchar(50),
    membership_date date,
    city varchar(50)
);

create table issue_records (
    issue_id int primary key,
    book_id int,
    member_id int,
    issue_date date,
    due_date date,
    return_date date,
    foreign key (book_id) references books(book_id),
    foreign key (member_id) references members(member_id)
);

insert into books (book_id, title, author, genre, available_copies) values
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 5),
(2, '1984', 'George Orwell', 'Dystopian', 3),
(3, 'The Alchemist', 'Paulo Coelho', 'Adventure', 4),
(4, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 2);

insert into members (member_id, member_name, membership_date, city) values
(101, 'Aarav', '2024-06-10', 'Delhi'),
(102, 'Bhavya', '2024-07-15', 'Mumbai'),
(103, 'Chirag', '2024-08-20', 'Pune'),
(104, 'Diya', '2024-09-25', 'Chennai');

insert into issue_records (issue_id, book_id, member_id, issue_date, due_date, return_date) values
(1, 1, 101, '2025-10-01', '2025-10-10', '2025-10-08'),
(2, 2, 102, '2025-10-03', '2025-10-12', null),
(3, 3, 103, '2025-10-04', '2025-10-13', '2025-10-10'),
(4, 1, 104, '2025-10-05', '2025-10-15', null);

select members.member_name, count(issue_records.issue_id) as total_books_issued
from members
left join issue_records
on members.member_id = issue_records.member_id
group by members.member_name;
/*'Aarav', '1'
'Bhavya', '1'
'Chirag', '1'
'Diya', '1'*/

select members.member_name, books.title, issue_records.due_date
from issue_records
inner join members on issue_records.member_id = members.member_id
inner join books on issue_records.book_id = books.book_id
where issue_records.return_date is null 
and issue_records.due_date < current_date;
/*'Bhavya', '1984', '2025-10-12'
'Diya', 'To Kill a Mockingbird', '2025-10-15'*/

delimiter //
create procedure add_issue_record (
    in p_issue_id int,
    in p_book_id int,
    in p_member_id int,
    in p_issue_date date,
    in p_due_date date
)
begin
    insert into issue_records (issue_id, book_id, member_id, issue_date, due_date, return_date)
    values (p_issue_id, p_book_id, p_member_id, p_issue_date, p_due_date, null);

    update books
    set available_copies = available_copies - 1
    where book_id = p_book_id;
end //
delimiter ;
call add_issue_record(5, 2, 101, '2025-10-20', '2025-10-30');

delimiter //
create procedure update_issue_record (
    in p_issue_id int,
    in p_return_date date
)
begin
    update issue_records
    set return_date = p_return_date
    where issue_id = p_issue_id;

    -- Increase book copies back when returned
    update books
    set available_copies = available_copies + 1
    where book_id = (select book_id from issue_records where issue_id = p_issue_id);
end //
delimiter ;
call update_issue_record(2, '2025-10-18');
