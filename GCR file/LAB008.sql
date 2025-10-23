-- Lab Experiment 08: Implementation of Procedure ( insert, update and delete)
-- STUDENT NAME: Varsha C
-- USN: 1RUA24BCA0095
-- SECTION: A

SELECT USER(), 
       @@hostname AS Host_Name, 
       VERSION() AS MySQL_Version, 
       NOW() AS Current_Date_Time;
-- OUTPUT : [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
-- 05:55:22	SELECT USER(),         @@hostname AS Host_Name,         VERSION() AS MySQL_Version,         NOW() AS Current_Date_Time LIMIT 0, 1000	1 row(s) returned	0.000 sec / 0.000 sec

-- Scenario: Employee Management System
-- CREATE AND LOAD THE database DBLab008
-- Write your SQL query below Codespace:
Create database DBLab008;
use DBLab008;

-- Task 1: Create the Employee Table
-- Create a table to store information about Employee.
-- Include the following columns:
 --   empid INT PRIMARY KEY,
   -- empname VARCHAR(50),
   -- age INT,
   -- salary DECIMAL(10,2),
   -- designation VARCHAR(30),
   -- address VARCHAR(100),
   -- date_of_join DATE
-- Write your SQL query below Codespace:
Create Table Employee (
Empid int PRIMARY KEY,
Empname VARCHAR(50),
Age int,
Salary DECIMAL(10,2),
Designation VARCHAR(30),
Address VARCHAR(100),
date_of_join DATE);

-- DESCRIBE THE SCHEMA -- [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
DESC Employee;
-- OUTPUT : Disclaimer - This code is not the part of the SQL Code
-- 06:11:07	Create Table Employee ( Empid int PRIMARY KEY, Empname VARCHAR(50), Age int, Salary DECIMAL(10,2), Designation VARCHAR(30), Address VARCHAR(100), date_of_join DATE)	0 row(s) affected	0.016 sec
/*'Empid', 'int', 'NO', 'PRI', NULL, ''
'Empname', 'varchar(50)', 'YES', '', NULL, ''
'Age', 'int', 'YES', '', NULL, ''
'Salary', 'decimal(10,2)', 'YES', '', NULL, ''
'Designation', 'varchar(30)', 'YES', '', NULL, ''
'Address', 'varchar(100)', 'YES', '', NULL, ''
'date_of_join', 'date', 'YES', '', NULL, ''*/

-- insert 10 records to the table 
-- Write your SQL query below Codespace:
insert into Employee VALUES 
(101, 'Ram', 28, 30000.00, 'Manager', 'Mangalore', '2018-06-01'),
(102, 'Raj', 34, 22000.00, 'Clerk', 'Bangalore', '2019-09-15'),
(103, 'Seetha', 45, 40000.00, 'Manager', 'Mumbai', '2010-03-12'),
(104, 'Riya', 29, 18000.00, 'Intern', 'Bangalore', '2021-01-20'),
(105, 'Rema', 40, 25000.00, 'Senior Clerk', 'Chennai', '2015-07-30'),
(106, 'Amit', 38, 35000.00, 'Manager', 'Bangalore', '2016-11-05'),
(107, 'Saru', 55, 27000.00, 'Clerk', 'Delhi', '2008-04-18'),
(108, 'Hema', 23, 19000.00, 'Intern', 'Bangalore', '2023-02-25'),
(109, 'Romeo', 31, 21000.00, 'Clerk', 'Mysore', '2017-08-10'),
(110, 'Julias', 50, 45000.00, 'Manager', 'Bangalore', '2012-12-01');

Select *from Employee;
-- COPYPASTE OF THE OUTPUT in CSV Format and terminate with ;
/*'101', 'Ram', '28', '30000.00', 'Manager', 'Mangalore', '2018-06-01'
'102', 'Raj', '34', '22000.00', 'Clerk', 'Bangalore', '2019-09-15'
'103', 'Seetha', '45', '40000.00', 'Manager', 'Mumbai', '2010-03-12'
'104', 'Riya', '29', '18000.00', 'Intern', 'Bangalore', '2021-01-20'
'105', 'Rema', '40', '25000.00', 'Senior Clerk', 'Chennai', '2015-07-30'
'106', 'Amit', '38', '35000.00', 'Manager', 'Bangalore', '2016-11-05'
'107', 'Saru', '55', '27000.00', 'Clerk', 'Delhi', '2008-04-18'
'108', 'Hema', '23', '19000.00', 'Intern', 'Bangalore', '2023-02-25'
'109', 'Romeo', '31', '21000.00', 'Clerk', 'Mysore', '2017-08-10'
'110', 'Julias', '50', '45000.00', 'Manager', 'Bangalore', '2012-12-01'*/

-- perform the following procedures on the employee database and copy paste the output in the space provided
-- A. Insert Procedure
-- Create the InsertEmployee procedure
DELIMITER $$

CREATE PROCEDURE InsertEmployee(
    IN p_empid INT,
    IN p_empname VARCHAR(50),
    IN p_age INT,
    IN p_salary DECIMAL(10,2),
    IN p_designation VARCHAR(30),
    IN p_address VARCHAR(100),
    IN p_date_of_join DATE
)
BEGIN
    IF p_age BETWEEN 18 AND 60 THEN
        INSERT INTO Employee (empid, empname, age, salary, designation, address, date_of_join)
        VALUES (p_empid, p_empname, p_age, p_salary, p_designation, p_address, p_date_of_join);
    ELSE
        SELECT 'Invalid age, employee not added.' AS Message;
    END IF;
END$$

DELIMITER ;


-- 1. Write a stored procedure named InsertEmployee to insert a new employee record into the Employee table with all fields as input parameters.
-- 2. Modify the insert procedure to ensure the employee’s age must be between 18 and 60.
      -- If not, display a message: "Invalid age, employee not added."
-- 3. Create a procedure that inserts a new employee record.
          -- If the salary is not provided, assign a default salary of 20000.
          -- Create the InsertEmployeeWithDefaultSalary procedure
DELIMITER $$

CREATE PROCEDURE InsertEmployeeWithDefaultSalary(
    IN p_empid INT,
    IN p_empname VARCHAR(50),
    IN p_age INT,
    IN p_designation VARCHAR(30),
    IN p_address VARCHAR(100),
    IN p_date_of_join DATE
)
BEGIN
    IF p_age BETWEEN 18 AND 60 THEN
        INSERT INTO Employee (empid, empname, age, salary, designation, address, date_of_join)
        VALUES (p_empid, p_empname, p_age, 20000.00, p_designation, p_address, p_date_of_join);
    ELSE
        SELECT 'Invalid age, employee not added.' AS Message;
    END IF;
END$$

DELIMITER ;

-- 4. Write a procedure that inserts three new employee records in a single procedure using multiple INSERT statements.
-- Create the InsertMultipleEmployees procedure
DELIMITER $$

CREATE PROCEDURE InsertMultipleEmployees()
BEGIN
    INSERT INTO Employee VALUES
    (111, 'Ivy Green', 26, 24000.00, 'Developer', '808 Willow St, City', '2022-01-10'),
    (112, 'Jack White', 33, 29000.00, 'Designer', '909 Maplewood Dr, City', '2021-11-20'),
    (113, 'Kathy Black', 29, 27000.00, 'Manager', '1010 Oakwood Ave, City', '2020-05-15');
END$$

DELIMITER ;

-- B.  Update Procedure
/*
Update Salary:
Write a stored procedure named UpdateSalary to update an employee’s salary based on their empid.*/

DELIMITER $$

CREATE PROCEDURE UpdateSalary(
    IN p_empid INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE Employee
    SET salary = p_new_salary
    WHERE empid = p_empid;
END$$

DELIMITER ;

/* Increment Salary by Percentage:
Create a procedure to increase the salary by 10% for all employees whose designation = 'Manager'.*/

DELIMITER $$

CREATE PROCEDURE IncreaseManagerSalary()
BEGIN
    UPDATE Employee
    SET salary = salary * 1.10
    WHERE designation = 'Manager';
END$$

DELIMITER ;

/* Update Designation:
Write a procedure to update the designation of an employee by empid.
Example: Promote an employee from 'Clerk' to 'Senior Clerk'.*/
-- Create the UpdateDesignation procedure
DELIMITER $$

CREATE PROCEDURE UpdateDesignation(
    IN p_empid INT,
    IN p_new_designation VARCHAR(30)
)
BEGIN
    UPDATE Employee
    SET designation = p_new_designation
    WHERE empid = p_empid;
END$$

DELIMITER ;

/* Update Address:
Write a procedure to update the address of an employee when empid is given as input.*/

DELIMITER $$

CREATE PROCEDURE UpdateAddress(
   
::contentReference[oaicite:0]{index=0} 
 

/*Conditional Update (Age Check):
Create a procedure that updates salary only if the employee’s age > 40; otherwise, print "Not eligible for salary update."

*/
-- C. Delete Procedure
/*
Delete by empid:
Write a stored procedure named DeleteEmployee to delete an employee record using their empid.

Delete by Designation:
Create a procedure that deletes all employees belonging to a specific designation (e.g., 'Intern').

Delete Based on Salary Range:
Write a procedure to delete employees whose salary is less than ₹15000.

Delete by Joining Year:
Write a procedure to delete employees who joined before the year 2015.
*/
-- End of Lab Experiment 
-- Upload the Completed worksheet in the google classroom with file name USN _ LabExperiment01
