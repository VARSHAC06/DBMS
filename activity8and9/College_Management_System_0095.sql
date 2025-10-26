-- Scenario: College Management System
-- This database manages details of Students, Courses, and their Enrollments.
-- Create Database and Tables
-- Create Database
CREATE DATABASE CollegeDB;
USE CollegeDB;

-- Table: Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    gender VARCHAR(10),
    dob DATE,
    city VARCHAR(30)
);

-- Table: Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    duration INT, -- in months
    fee DECIMAL(10,2)
);

-- Table: Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
-- Insert Sample Records
-- Insert into Students
INSERT INTO Students VALUES
(1, 'Asha Rao', 'Female', '2003-04-12', 'Bangalore'),
(2, 'Rahul Kumar', 'Male', '2002-10-05', 'Mysore'),
(3, 'Sneha Patil', 'Female', '2003-07-22', 'Mangalore'),
(4, 'Rohit Sharma', 'Male', '2001-12-11', 'Hubli'),
(5, 'Neha Singh', 'Female', '2002-01-25', 'Udupi');

-- Insert into Courses
INSERT INTO Courses VALUES
(101, 'Computer Science', 6, 25000.00),
(102, 'Data Analytics', 4, 20000.00),
(103, 'Web Development', 3, 18000.00),
(104, 'AI and ML', 5, 30000.00),
(105, 'Cyber Security', 6, 28000.00);

-- Insert into Enrollments
INSERT INTO Enrollments VALUES
(1, 1, 101, '2024-06-10', 'A'),
(2, 2, 103, '2024-07-01', 'B'),
(3, 3, 104, '2024-06-15', 'A'),
(4, 4, 102, '2024-05-20', 'C'),
(5, 5, 105, '2024-07-05', 'B');

 -- Aggregate Functions
-- Total number of students
SELECT COUNT(*) AS Total_Students FROM Students;
/*'5'*/

-- Average course fee
SELECT AVG(fee) AS Avg_Fee FROM Courses;
/*'24200.000000'*/

-- Maximum and Minimum fee
SELECT MAX(fee) AS Max_Fee, MIN(fee) AS Min_Fee FROM Courses;
/*'30000.00', '18000.00'*/

-- Date Functions
-- List of enrollments with year and month of enrollment
SELECT enrollment_id, 
       student_id, 
       YEAR(enrollment_date) AS Year, 
       MONTH(enrollment_date) AS Month
FROM Enrollments;
/*'1', '1', '2024', '6'
'2', '2', '2024', '7'
'3', '3', '2024', '6'
'4', '4', '2024', '5'
'5', '5', '2024', '7'*/

-- Students older than 21 years (as of 2025)
SELECT student_name, dob, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS Age
FROM Students
WHERE TIMESTAMPDIFF(YEAR, dob, CURDATE()) > 21;
/*'Asha Rao', '2003-04-12', '22'
'Rahul Kumar', '2002-10-05', '23'
'Sneha Patil', '2003-07-22', '22'
'Rohit Sharma', '2001-12-11', '23'
'Neha Singh', '2002-01-25', '23'*/

-- INNER JOIN
SELECT s.student_name, c.course_name, e.grade
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id;
/*'Asha Rao', 'Computer Science', 'A'
'Rahul Kumar', 'Web Development', 'B'
'Sneha Patil', 'AI and ML', 'A'
'Rohit Sharma', 'Data Analytics', 'C'
'Neha Singh', 'Cyber Security', 'B'*/


-- LEFT OUTER JOIN
-- List all students and their enrollment (if any)
SELECT s.student_name, e.course_id, e.grade
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id;
/*'Asha Rao', '101', 'A'
'Rahul Kumar', '103', 'B'
'Sneha Patil', '104', 'A'
'Rohit Sharma', '102', 'C'
'Neha Singh', '105', 'B'*/

-- RIGHT OUTER JOIN
-- List all courses with enrolled students (if any)
SELECT c.course_name, e.student_id, e.grade
FROM Courses c
RIGHT JOIN Enrollments e ON c.course_id = e.course_id;
/*'Computer Science', '1', 'A'
'Web Development', '2', 'B'
'AI and ML', '3', 'A'
'Data Analytics', '4', 'C'
'Cyber Security', '5', 'B'*/

-- GROUP BY and ORDER BY
-- Number of students enrolled per course
SELECT c.course_name, COUNT(e.student_id) AS Total_Students
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY Total_Students DESC;
/*'Computer Science', '1'
'Data Analytics', '1'
'Web Development', '1'
'AI and ML', '1'
'Cyber Security', '1'*/

-- Courses ordered by fee
SELECT * FROM Courses
ORDER BY fee DESC;
/*'104', 'AI and ML', '5', '30000.00'
'105', 'Cyber Security', '6', '28000.00'
'101', 'Computer Science', '6', '25000.00'
'102', 'Data Analytics', '4', '20000.00'
'103', 'Web Development', '3', '18000.00'*/

Stored Procedures
-- Procedure to Insert a New Student
DELIMITER //
CREATE PROCEDURE InsertStudent(
    IN sid INT,
    IN sname VARCHAR(50),
    IN gender VARCHAR(10),
    IN dob DATE,
    IN city VARCHAR(30)
)
BEGIN
    INSERT INTO Students VALUES (sid, sname, gender, dob, city);
END //
DELIMITER ;
/*'104', 'AI and ML', '5', '30000.00'
'105', 'Cyber Security', '6', '28000.00'
'101', 'Computer Science', '6', '25000.00'
'102', 'Data Analytics', '4', '20000.00'
'103', 'Web Development', '3', '18000.00'*/

-- Example Call
CALL InsertStudent(6, 'Kiran Das', 'Male', '2003-02-18', 'Belgaum');

INSERT INTO Students VALUES(6, 'Kiran Das', 'Male', '2003-02-18', 'Belgaum');
INSERT INTO Courses VALUES(106, 'Computer Science', 6, 25000.00);
SELECT enrollment_id FROM Enrollments;
INSERT INTO Enrollments VALUES(6, 6, 106, '2024-06-10', 'A');

🔹 Procedure to Update Course Fee
DELIMITER //
CREATE PROCEDURE UpdateCourseFee(
    IN cid INT,
    IN new_fee DECIMAL(10,2)
)
BEGIN
    UPDATE Courses SET fee = new_fee WHERE course_id = cid;
END //
DELIMITER ;

-- Example Call
CALL UpdateCourseFee(103, 19000.00);
