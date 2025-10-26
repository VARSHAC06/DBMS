CREATE DATABASE LibraryDB;
USE LibraryDB;
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    join_date DATE
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    genre VARCHAR(50),
    total_copies INT,
    available_copies INT
);

CREATE TABLE IssueRecords (
    issue_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    issue_date DATE,
    return_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
INSERT INTO Members (member_id, member_name, email, phone, join_date)
VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', '9876543210', '2024-01-15'),
(2, 'Priya Mehta', 'priya@gmail.com', '9876501234', '2024-02-05'),
(3, 'Amit Kumar', 'amit@gmail.com', '9876012345', '2024-03-12');

INSERT INTO Books (book_id, title, author, genre, total_copies, available_copies)
VALUES
(101, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 5, 5),
(102, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 4, 4),
(103, 'Data Science 101', 'John Doe', 'Education', 3, 3),
(104, 'Atomic Habits', 'James Clear', 'Self-help', 6, 6);

INSERT INTO IssueRecords (issue_id, member_id, book_id, issue_date, return_date, status)
VALUES
(1001, 1, 101, '2024-06-01', '2024-06-15', 'Returned'),
(1002, 1, 102, '2024-07-05', NULL, 'Issued'),
(1003, 2, 103, '2024-06-10', '2024-06-20', 'Returned'),
(1004, 3, 104, '2024-07-01', NULL, 'Issued');

SELECT i.issue_id,
       m.member_name,
       b.title AS book_title,
       b.author,
       i.issue_date,
       i.return_date,
       i.status
FROM IssueRecords i
INNER JOIN Members m ON i.member_id = m.member_id
INNER JOIN Books b ON i.book_id = b.book_id;
/*'1001', 'Rahul Sharma', 'The Great Gatsby', 'F. Scott Fitzgerald', '2024-06-01', '2024-06-15', 'Returned'
'1002', 'Rahul Sharma', 'To Kill a Mockingbird', 'Harper Lee', '2024-07-05', NULL, 'Issued'
'1003', 'Priya Mehta', 'Data Science 101', 'John Doe', '2024-06-10', '2024-06-20', 'Returned'
'1004', 'Amit Kumar', 'Atomic Habits', 'James Clear', '2024-07-01', NULL, 'Issued'*/

SELECT m.member_name,
       COUNT(i.issue_id) AS Total_Books_Issued
FROM Members m
LEFT JOIN IssueRecords i ON m.member_id = i.member_id
GROUP BY m.member_name;
/*'Rahul Sharma', '2'
'Priya Mehta', '1'
'Amit Kumar', '1'*/

SELECT issue_id,
       DATEDIFF(return_date, issue_date) AS Days_Kept
FROM IssueRecords
WHERE return_date IS NOT NULL;
/*'1001', '14'
'1003', '10'*/

DELIMITER //
CREATE PROCEDURE UpdateBookAvailability(
    IN b_id INT,
    IN action_type VARCHAR(10)
)
BEGIN
    IF action_type = 'issue' THEN
        UPDATE Books
        SET available_copies = available_copies - 1
        WHERE book_id = b_id AND available_copies > 0;
    ELSEIF action_type = 'return' THEN
        UPDATE Books
        SET available_copies = available_copies + 1
        WHERE book_id = b_id;
    END IF;
END //
DELIMITER ;

CALL UpdateBookAvailability(102, 'issue');
CALL UpdateBookAvailability(102, 'return');
SELECT * FROM Books;
/*'101', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', '5', '5'
'102', 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', '4', '3'
'103', 'Data Science 101', 'John Doe', 'Education', '3', '3'
'104', 'Atomic Habits', 'James Clear', 'Self-help', '6', '6'*/

SELECT * FROM IssueRecords;
/*'1001', '1', '101', '2024-06-01', '2024-06-15', 'Returned'
'1002', '1', '102', '2024-07-05', NULL, 'Issued'
'1003', '2', '103', '2024-06-10', '2024-06-20', 'Returned'
'1004', '3', '104', '2024-07-01', NULL, 'Issued'*/

