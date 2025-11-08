CREATE DATABASE scenario1;
USE scenario1;

create table author (
    authorid int primary key,
    authorname varchar(100)
);

CREATE TABLE publisher (
    publisherid INT PRIMARY KEY,
    publishername VARCHAR(100)
);

create table book (
    bookid int primary key,
    title varchar(150),
    authorid int,
    publisherid int,
    price decimal(8,2),
    foreign key (authorid) references author(authorid),
    foreign key (publisherid) references publisher(publisherid)
);

create table member (
    memberid int primary key,
    membername varchar(100)
);

create table issue (
    issueid int primary key,
    bookid int,
    memberid int,
    issuedate date,
    returndate date,
    foreign key (bookid) references book(bookid),
    foreign key (memberid) references member(memberid)
);

insert into author values
(1, 'j.k. rowling'),
(2, 'george r.r. martin'),
(3, 'j.r.r. tolkien');

insert into publisher values
(1, 'bloomsbury'),
(2, 'bantam books'),
(3, 'harpercollins'),
(4, 'penguin random house');

insert into book values
(1, 'harry potter and the sorcerer''s stone', 1, 1, 20.00),
(2, 'a game of thrones', 2, 2, 25.00),
(3, 'the hobbit', 3, 3, 15.00);

insert into member values
(1, 'alice'),
(2, 'bob'),
(3, 'charlie');

insert into issue values
(1, 1, 1, '2025-10-01', '2025-10-10'),
(2, 2, 1, '2025-10-05', null),
(3, 3, 2, '2025-10-06', '2025-10-15');

select 
    b.title as book_title,
    a.authorname as author,
    p.publishername as publisher
from book b
inner join author a on b.authorid = a.authorid
inner join publisher p on b.publisherid = p.publisherid;

/*harry potter and the sorcerer's stone	j.k. rowling	bloomsbury
a game of thrones	george r.r. martin	bantam books
the hobbit	j.r.r. tolkien	harpercollins*/

select 
    p.publishername,
    b.title as book_title
from publisher p
left outer join book b on p.publisherid = b.publisherid;
/*bloomsbury	harry potter and the sorcerer's stone
bantam books	a game of thrones
harpercollins	the hobbit
penguin random house	*/

select 
    m.membername,
    count(i.bookid) as total_books_issued
from member m
left join issue i on m.memberid = i.memberid
group by m.membername;
/*alice	2
bob	1
charlie	0*/

select avg(price) as average_book_price from book;
/*20.000000*/

select count(bookid) as total_books_issued from issue;
/*3*/