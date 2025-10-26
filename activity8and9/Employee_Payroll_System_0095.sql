CREATE DATABASE PayrollDB;
USE PayrollDB;
-- Table: Departments
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

-- Table: Employees
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    gender VARCHAR(10),
    dob DATE,
    dept_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- Table: SalaryDetails
CREATE TABLE SalaryDetails (
    salary_id INT PRIMARY KEY,
    emp_id INT,
    basic_salary DECIMAL(10,2),
    hra DECIMAL(10,2),
    da DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);
-- Insert into Departments
INSERT INTO Departments (dept_id, dept_name, location)
VALUES
(1, 'HR', 'Bangalore'),
(2, 'Finance', 'Mumbai'),
(3, 'IT', 'Pune'),
(4, 'Sales', 'Delhi');

-- Insert into Employees
INSERT INTO Employees (emp_id, emp_name, gender, dob, dept_id, hire_date)
VALUES
(101, 'Asha Rao', 'Female', '1995-04-10', 1, '2020-01-15'),
(102, 'Rahul Kumar', 'Male', '1992-08-25', 2, '2018-05-20'),
(103, 'Sneha Patil', 'Female', '1996-02-12', 3, '2021-07-01'),
(104, 'Rohit Sharma', 'Male', '1990-12-05', 4, '2016-03-10'),
(105, 'Neha Singh', 'Female', '1998-06-18', 3, '2022-02-25');

-- Insert into SalaryDetails
INSERT INTO SalaryDetails (salary_id, emp_id, basic_salary, hra, da, deductions, net_salary)
VALUES
(1, 101, 30000.00, 8000.00, 5000.00, 2000.00, 41000.00),
(2, 102, 40000.00, 10000.00, 7000.00, 3000.00, 54000.00),
(3, 103, 35000.00, 9000.00, 6000.00, 2500.00, 47500.00),
(4, 104, 45000.00, 12000.00, 8000.00, 4000.00, 61000.00),
(5, 105, 28000.00, 7000.00, 4000.00, 1500.00, 37500.00);

SELECT e.emp_id,
       e.emp_name,
       e.gender,
       d.dept_name,
       d.location,
       e.hire_date
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id;
/*'101', 'Asha Rao', 'Female', 'HR', 'Bangalore', '2020-01-15'
'102', 'Rahul Kumar', 'Male', 'Finance', 'Mumbai', '2018-05-20'
'103', 'Sneha Patil', 'Female', 'IT', 'Pune', '2021-07-01'
'105', 'Neha Singh', 'Female', 'IT', 'Pune', '2022-02-25'
'104', 'Rohit Sharma', 'Male', 'Sales', 'Delhi', '2016-03-10'*/
SELECT SUM(net_salary) AS Total_Salary_Expense
FROM SalaryDetails;
/*'241000.00'*/

SELECT AVG(net_salary) AS Average_Salary
FROM SalaryDetails;
/*'48200.000000'*/

SELECT d.dept_name,
       SUM(s.net_salary) AS Total_Salary_By_Dept,
       AVG(s.net_salary) AS Avg_Salary_By_Dept
FROM Departments d
JOIN Employees e ON d.dept_id = e.dept_id
JOIN SalaryDetails s ON e.emp_id = s.emp_id
GROUP BY d.dept_name
ORDER BY Total_Salary_By_Dept DESC;
/*'IT', '85000.00', '42500.000000'
'Sales', '61000.00', '61000.000000'
'Finance', '54000.00', '54000.000000'
'HR', '41000.00', '41000.000000'*/

DELIMITER //
CREATE PROCEDURE InsertSalary(
    IN sid INT,
    IN eid INT,
    IN basic DECIMAL(10,2),
    IN hra DECIMAL(10,2),
    IN da DECIMAL(10,2),
    IN deduct DECIMAL(10,2)
)
BEGIN
    DECLARE net DECIMAL(10,2);
    SET net = basic + hra + da - deduct;

    INSERT INTO SalaryDetails (salary_id, emp_id, basic_salary, hra, da, deductions, net_salary)
    VALUES (sid, eid, basic, hra, da, deduct, net);
END //
DELIMITER ;
CALL InsertSalary(6, 101, 32000.00, 8500.00, 5200.00, 2500.00);
DELIMITER //
CREATE PROCEDURE UpdateSalary(
    IN eid INT,
    IN new_basic DECIMAL(10,2),
    IN new_hra DECIMAL(10,2),
    IN new_da DECIMAL(10,2),
    IN new_deduct DECIMAL(10,2)
)
BEGIN
    DECLARE new_net DECIMAL(10,2);
    SET new_net = new_basic + new_hra + new_da - new_deduct;

    UPDATE SalaryDetails
    SET basic_salary = new_basic,
        hra = new_hra,
        da = new_da,
        deductions = new_deduct,
        net_salary = new_net
    WHERE emp_id = eid;
END //
DELIMITER ;
CALL UpdateSalary(103, 36000.00, 9500.00, 6200.00, 2700.00);
SELECT * FROM SalaryDetails;
/*'1', '101', '30000.00', '8000.00', '5000.00', '2000.00', '41000.00'
'2', '102', '40000.00', '10000.00', '7000.00', '3000.00', '54000.00'
'3', '103', '36000.00', '9500.00', '6200.00', '2700.00', '49000.00'
'4', '104', '45000.00', '12000.00', '8000.00', '4000.00', '61000.00'
'5', '105', '28000.00', '7000.00', '4000.00', '1500.00', '37500.00'
'6', '101', '32000.00', '8500.00', '5200.00', '2500.00', '43200.00'*/

SELECT * FROM Employees;
/*'101', 'Asha Rao', 'Female', '1995-04-10', '1', '2020-01-15'
'102', 'Rahul Kumar', 'Male', '1992-08-25', '2', '2018-05-20'
'103', 'Sneha Patil', 'Female', '1996-02-12', '3', '2021-07-01'
'104', 'Rohit Sharma', 'Male', '1990-12-05', '4', '2016-03-10'
'105', 'Neha Singh', 'Female', '1998-06-18', '3', '2022-02-25'*/

SELECT * FROM Departments;
/*'1', 'HR', 'Bangalore'
'2', 'Finance', 'Mumbai'
'3', 'IT', 'Pune'
'4', 'Sales', 'Delhi'*/


