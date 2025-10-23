CREATE DATABASE Schem;
Use Schem;

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Price DECIMAL(10, 2),
    PublishDate DATE
);

CREATE TABLE Customers (
    CustID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustID INT,
    BookID INT,
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Books (BookID, Title, Author, Price, PublishDate) VALUES
(101, 'The Alchemist', 'Paulo Coelho', 350.00, '2010-06-15'),
(102, 'Atomic Habits', 'James Clear', 450.00, '2018-10-16'),
(103, 'Clean Code', 'Robert Martin', 550.00, '2008-08-01'),
(104, 'Think Like a Monk', 'Jay Shetty', 400.00, '2020-09-08'),
(105, 'Python Crash Course', 'Eric Matthes', 500.00, '2019-05-10');

INSERT INTO Customers (CustID, Name, Email, JoinDate) VALUES
(201, 'Arjun Rao', 'arjun@gmail.com', '2021-02-10'),
(202, 'Priya Nair', 'priya@yahoo.com', '2020-07-25'),
(203, 'John Smith', 'john@gmail.com', '2022-01-14'),
(204, 'Maria Lopez', 'maria@outlook.com', '2019-11-30');

INSERT INTO Orders (OrderID, CustID, BookID, OrderDate, Quantity) VALUES
(301, 201, 102, '2022-03-05', 2),
(302, 202, 101, '2021-09-12', 1),
(303, 203, 105, '2022-05-20', 3),
(304, 204, 104, '2020-12-25', 1),
(305, 201, 103, '2021-11-18', 1);

SELECT UPPER(Name) AS CustomerName FROM Customers;
/*'ARJUN RAO'
'PRIYA NAIR'
'JOHN SMITH'
'MARIA LOPEZ'*/

SELECT LOWER(Name) AS CustomerName FROM Customers;
/*'arjun rao'
'priya nair'
'john smith'
'maria lopez'*/

SELECT SUBSTRING(Title, 1, 3) AS BookTitlePrefix FROM Books;
/*'The'
'Ato'
'Cle'
'Thi'
'Pyt'*/

SELECT SUBSTRING(Email, POSITION('@' IN Email) + 1) AS EmailDomain FROM Customers;
/*'gmail.com'
'yahoo.com'
'gmail.com'
'outlook.com'*/

SELECT Title, LENGTH(Title) AS TitleLength FROM Books;
/*'The Alchemist', '13'
'Atomic Habits', '13'
'Clean Code', '10'
'Think Like a Monk', '17'
'Python Crash Course', '19'*/

SELECT Title, REPLACE(Title, 'Book', 'Text') AS UpdatedTitle FROM Books;
/*'The Alchemist', 'The Alchemist'
'Atomic Habits', 'Atomic Habits'
'Clean Code', 'Clean Code'
'Think Like a Monk', 'Think Like a Monk'
'Python Crash Course', 'Python Crash Course'*/

SELECT CONCAT(Author, ' - ', Title) AS AuthorBook FROM Books;
/*'Paulo Coelho - The Alchemist'
'James Clear - Atomic Habits'
'Robert Martin - Clean Code'
'Jay Shetty - Think Like a Monk'
'Eric Matthes - Python Crash Course'*/

SELECT Title FROM Books WHERE Author LIKE '%a%';
/*'The Alchemist'
'Atomic Habits'
'Clean Code'
'Think Like a Monk'
'Python Crash Course'*/

SELECT Title, EXTRACT(YEAR FROM PublishDate) AS PublishYear FROM Books;
/*'The Alchemist', '2010'
'Atomic Habits', '2018'
'Clean Code', '2008'
'Think Like a Monk', '2020'
'Python Crash Course', '2019'*/

SELECT Name, DATE_FORMAT(JoinDate, '%M') AS JoinMonth FROM Customers;
/*'Arjun Rao', 'February'
'Priya Nair', 'July'
'John Smith', 'January'
'Maria Lopez', 'November'*/

SELECT Name FROM Customers WHERE EXTRACT(YEAR FROM JoinDate) = 2021;
/*'Arjun Rao'*/

SELECT OrderID, DAYNAME(OrderDate) AS OrderDay FROM Orders;
/*'301', 'Saturday'
'302', 'Sunday'
'303', 'Friday'
'304', 'Friday'
'305', 'Thursday'*/

SELECT Title, FLOOR(DATEDIFF(CURDATE(), PublishDate) / 365) AS BookAge FROM Books;
/*'The Alchemist', '15'
'Atomic Habits', '6'
'Clean Code', '17'
'Think Like a Monk', '5'
'Python Crash Course', '6'*/


SELECT Name, CURRENT_DATE - JoinDate AS DaysSinceJoin FROM Customers;
/*'Arjun Rao', '40707'
'Priya Nair', '50192'
'John Smith', '30803'
'Maria Lopez', '59787'*/

SELECT * FROM Orders WHERE EXTRACT(MONTH FROM OrderDate) = 12;
/*'304', '204', '104', '2020-12-25', '1'*/

SELECT COUNT(*) AS TotalBooks FROM Books;
/*'5'*/

SELECT AVG(Price) AS AvgBookPrice FROM Books;
/*'450.000000'*/

SELECT MAX(Price) AS MaxPrice, MIN(Price) AS MinPrice FROM Books;
/*'550.00', '350.00'*/

SELECT COUNT(*) AS CustomersJoinedAfter2020 FROM Customers WHERE EXTRACT(YEAR FROM JoinDate) > 2020;
/*'2'*/

SELECT SUM(Quantity) AS TotalBooksOrdered FROM Orders;
/*'8'*/

SELECT C.Name, SUM(O.Quantity) AS TotalBooksOrdered
FROM Orders O
JOIN Customers C ON O.CustID = C.CustID
GROUP BY C.Name;
/*'Arjun Rao', '3'
'Priya Nair', '1'
'John Smith', '3'
'Maria Lopez', '1'*/

SELECT B.Title, AVG(O.Quantity) AS AvgOrderQuantity
FROM Orders O
JOIN Books B ON O.BookID = B.BookID
GROUP BY B.Title;
/*'Atomic Habits', '2.0000'
'The Alchemist', '1.0000'
'Python Crash Course', '3.0000'
'Think Like a Monk', '1.0000'
'Clean Code', '1.0000'*/

SELECT B.Title, SUM(O.Quantity) AS TotalQuantityOrdered
FROM Orders O
JOIN Books B ON O.BookID = B.BookID
GROUP BY B.Title
ORDER BY TotalQuantityOrdered DESC
LIMIT 1;
/*'Python Crash Course', '3'*/

SELECT B.Title, SUM(B.Price * O.Quantity) AS TotalRevenue
FROM Orders O
JOIN Books B ON O.BookID = B.BookID
GROUP BY B.Title;
/*'Atomic Habits', '900.00'
'The Alchemist', '350.00'
'Python Crash Course', '1500.00'
'Think Like a Monk', '400.00'
'Clean Code', '550.00'*/

SELECT EXTRACT(YEAR FROM OrderDate) AS OrderYear, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY EXTRACT(YEAR FROM OrderDate)
ORDER BY OrderYear;
/*'2020', '1'
'2021', '2'
'2022', '2'*/



