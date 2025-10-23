-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Lab Experiment 02: Program 02 - Implementation of DML Commands in SQL ( INSERT , SELECT, UPDATE and DELETE )
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- STUDENT NAME: VARSHA C
-- USN: 1RUA24BCA0095
-- SECTION: A
-- -----------------------------------------------------------------------------------------------------------------------------------------
SELECT USER(), 
       @@hostname AS Host_Name, 
       VERSION() AS MySQL_Version, 
       NOW() AS Current_Date_Time;

-- Paste the Output below by execution of above command
-- 10:13:16	SELECT USER(),         @@hostname AS Host_Name,         VERSION() AS MySQL_Version,         NOW() AS Current_Date_Time LIMIT 0, 1000	1 row(s) returned	0.000 sec / 0.000 sec

create  database BCALAB003;
use BCALAB003;
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Scenario: You are managing a database for a library with two tables: Books and Members.
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Task 01: Create Tables [ Check the below mentioned Instructions:
-- Create the Books and Members tables with the specified structure.
-- Books Table and Member Table : 
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task with the Instructed Column in the session 

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(25) NOT NULL,
    Author VARCHAR(25) NOT NULL,
    PublishedYear INT,
    CopiesAvailable int, 
    TotalCopies int
);
drop table Books;
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    FirstName VARCHAR(10) NOT NULL,
    LastName VARCHAR(10) NOT NULL,
    MembershipType VARCHAR(100),
    joinDate VARCHAR(40)
);
drop table Members;

-- Paste the Output below for the given command ( DESC TableName;) 
desc Books;
/*'BookID', 'int', 'NO', 'PRI', NULL, ''
'Title', 'varchar(25)', 'NO', '', NULL, ''
'Author', 'varchar(25)', 'NO', '', NULL, ''
'PublishedYear', 'int', 'YES', '', NULL, ''
'CopiesAvailable', 'int', 'YES', '', NULL, ''
'TotalCopies', 'int', 'YES', '', NULL, ''*/


desc Members;
/*'MemberID', 'int', 'NO', 'PRI', NULL, ''
'FirstName', 'varchar(10)', 'NO', '', NULL, ''
'LastName', 'varchar(10)', 'NO', '', NULL, ''
'Email', 'varchar(25)', 'YES', 'UNI', NULL, ''
'MembershipType', 'varchar(10)', 'YES', '', NULL, ''
'joinDate', 'int', 'YES', '', NULL, ''*/

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 02: Insert a New Book
-- Instructions: Insert a book titled "1984_The Black Swan" by George Orwell (published in 1949) with 04 available copies and 10 Total copies. 
-- Populate other fields as needed.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.
Insert into Books values
(1, '1984_The Black Swan', 'George Orwell', 1949, 04, 10),
(2, '1985_The white Swan','George',1950, 05, 10),
(3, '1985_The brown Swan','Orwell',1951,  10, 20),
(4, '1985_The red Swan','George',1952, 20, 20),
(5, '1985_The pink Swan','Orwell',1953, 20 ,30);

-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).
SELECT * FROM Books;
/*'1', '1984_The Black Swan', 'George Orwell', '1949', '4', '10'
'2', '1985_The white Swan', 'George', '1950', '5', '10'
'3', '1985_The brown Swan', 'Orwell', '1951', '10', '20'
'4', '1985_The red Swan', 'George', '1952', '20', '20'
'5', '1985_The pink Swan', 'Orwell', '1953', '20', '30'*/


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 03: Add New Members
-- Instructions: Insert two members: David Lee (Platinum, joined 2024-04-15) and Emma Wilson (Silver, joined 2024-05-22).
-- Populate other fields as needed.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.
insert into Members Values
(1, 'David', 'Lee','Platinum', 'Joined 2024-04-15'),
(2, 'Emma',' Wilson', 'Silver', 'joined 2024-05-22');
-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).
SELECT * FROM Members;
/*'1', 'David', 'Lee', 'Platinum', 'Joined 2024-04-15'
'2', 'Emma', ' Wilson', 'Silver', 'joined 2024-05-22'*/

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 04: Update Book Details 
-- Instructions: The library acquired 2 additional copies of "1984_The Black Swan". Update the Books table.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.
alter table Books 
add Location VARCHAR(50);

update Books 
Set location='bangalore'


-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 05: Modify a Member's Information
-- Instructions: Update a member's membership type. Emma Wilson has upgraded her membership from 'Silver' to 'Gold'.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.








-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 06: Remove a Member
-- Instructions: Delete David Lee’s record from the Members table.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.








-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 09: Borrowing Table 
-- Instructions: Create a Borrowing table with foreign keys referencing Books and Members.
-- Subtask 1: Borrow a Book
-- Scenario:Emma Wilson (member_id = 2) borrows the book "The Catcher in the Rye" (book_id = 102) on 2024-06-01. Insert this record into the Borrowing table.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.








-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Task 10: Find the name of Borrower who book = 102 [ Advance and Optional ]
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Write the SQL Query below for above mentioned task.








-- Paste the Output below for the given command ( SELECT * FROM TABLE_NAME ).


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- Final Task 00: ER Diagram - Instructions:
-- Draw an ER diagram for the library database. Additional Upload the scanned copy of the created ER Daigram in the Google Classroom.
