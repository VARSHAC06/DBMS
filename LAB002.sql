-- Lab Experiment 01: Implementation of DDL Commands in SQL for the given scenarios
-- STUDENT NAME: VARSHA C
-- USN: 1RUA24BCA0095
-- SECTION: A

SELECT USER(), 
       @@hostname AS Host_Name, 
       VERSION() AS MySQL_Version, 
       NOW() AS Current_Date_Time;
-- OUTPUT : [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
-- 'root@localhost', 'RVU-PC-008', '8.4.6', '2025-08-25 11:27:29'

-- Scenario: College Student Management System

-- CREATE AND LOAD THE database
-- Write your SQL query below Codespace:

create database BCALAB002;
 USE BCALAB002;
 
-- Task 1: Create the Tables under this system (min 5 tables)
  -- Table 01: Departments ( DepartmentID, DepartmentName, HOD,ContactEmail,PhoneNumber,Location )
  -- Table 02: Course (CourseID, CourseName,Credits,DepartmentID,Duration,Fee )
  -- Table 03: Students (StudentID,FirstName,LastName,Email,DateOfBirth,CourseID)
  -- Table 04: Faculty FacultyID,FacultyName,DepartmentID,Qualification,Email,PhoneNumber)
  -- Table 05: Enrollments (  EnrollmentID,StudentID,CourseID,Semester,Year,Grade)
-- Specify the Key (Primary and Foreign) for each table while creating

-- Write your SQL query below Codespace:

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    HOD VARCHAR(50),
    ContactEmail VARCHAR(50),
    PhoneNumber VARCHAR(15),
    Location VARCHAR(50));
    
    CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT,
    DepartmentID INT,
    Duration VARCHAR(20),
    Fee DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    DateOfBirth DATE,
    CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(50),
    DepartmentID INT,
    Qualification VARCHAR(50),
    Email VARCHAR(50),
    PhoneNumber VARCHAR(15),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(10),
    Year INT,
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);


-- [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
-- OUTPUT : Disclaimer - This code is not the part of the SQL Code
/*'DepartmentID', 'int', 'NO', 'PRI', NULL, ''
'DepartmentName', 'varchar(50)', 'YES', '', NULL, ''
'HOD', 'varchar(50)', 'YES', '', NULL, ''
'ContactEmail', 'varchar(50)', 'YES', '', NULL, ''
'PhoneNumber', 'varchar(15)', 'YES', '', NULL, ''
'Location', 'varchar(50)', 'YES', '', NULL, ''

'CourseName', 'varchar(50)', 'YES', '', NULL, ''
'Credits', 'int', 'YES', '', NULL, ''
'DepartmentID', 'int', 'YES', 'MUL', NULL, ''
'Duration', 'varchar(20)', 'YES', '', NULL, ''
'Fee', 'decimal(10,2)', 'YES', '', NULL, ''

'StudentID', 'int', 'NO', 'PRI', NULL, ''
'FirstName', 'varchar(50)', 'YES', '', NULL, ''
'LastName', 'varchar(50)', 'YES', '', NULL, ''
'Email', 'varchar(50)', 'YES', '', NULL, ''
'DateOfBirth', 'date', 'YES', '', NULL, ''
'CourseID', 'int', 'YES', 'MUL', NULL, ''

'FacultyID', 'int', 'NO', 'PRI', NULL, ''
'FacultyName', 'varchar(50)', 'YES', '', NULL, ''
'DepartmentID', 'int', 'YES', 'MUL', NULL, ''
'Qualification', 'varchar(50)', 'YES', '', NULL, ''
'Email', 'varchar(50)', 'YES', '', NULL, ''
'PhoneNumber', 'varchar(15)', 'YES', '', NULL, ''

'EnrollmentID', 'int', 'NO', 'PRI', NULL, ''
'StudentID', 'int', 'YES', 'MUL', NULL, ''
'CourseID', 'int', 'YES', 'MUL', NULL, ''
'Semester', 'varchar(10)', 'YES', '', NULL, ''
'Year', 'int', 'YES', '', NULL, ''
'Grade', 'char(2)', 'YES', '', NULL, ''*/



--  describe the structure of each table and copy paste the Output 
DESC Departments;
DESC Course;
DESC Students;
DESC Faculty;
DESC Enrollments;

-- Perform the following operations on the each of the tables
-- 01: add 2 new columns for each table
ALTER TABLE Departments ADD Budget DECIMAL(15,2);
ALTER TABLE Departments ADD Faculty VARCHAR(20);
DESC Departments;

ALTER TABLE Course ADD TotalStudents int;
ALTER TABLE Course ADD Courselevel VARCHAR(30);
DESC Course;

ALTER TABLE Students ADD ContactNumber INT ;
ALTER TABLE Students ADD Gender CHAR(1);
DESC Students; 

ALTER TABLE Faculty ADD Address VARCHAR(50);
ALTER TABLE Faculty ADD ExperienceYears INT;
DESC Faculty;

ALTER TABLE Enrollments ADD EnrollmentStatus VARCHAR(20);
ALTER TABLE Enrollments ADD Remarks VARCHAR(100);
DESC Enrollments;

-- 02: Modify the existing column from each table
ALTER TABLE Course MODIFY CourseName VARCHAR(100);
ALTER TABLE Departments MODIFY Location VARCHAR(80);
ALTER TABLE Students MODIFY FirstName VARCHAR(80);
ALTER TABLE Faculty MODIFY Address VARCHAR(80);
ALTER TABLE Enrollments MODIFY Remarks VARCHAR(128);

-- 03 change the datatypes
-- 04: Rename a column
ALTER TABLE Departments RENAME COLUMN HOD TO HeadOfDepartment;
ALTER TABLE Course RENAME COLUMN Credits TO CreditHours;
ALTER TABLE Students RENAME COLUMN DateOfBirth TO DOB;
ALTER TABLE Faculty RENAME COLUMN Qualification TO Degree;
ALTER TABLE Enrollments RENAME COLUMN Semester TO Term;

-- 05: Drop a column
ALTER TABLE Departments DROP COLUMN PhoneNumber;
ALTER TABLE Course DROP COLUMN Duration;
ALTER TABLE Students DROP COLUMN Email;
ALTER TABLE Faculty DROP COLUMN ExperienceYears;
ALTER TABLE Enrollments DROP COLUMN REMARK;

-- 06: Rename the table
ALTER TABLE Departments RENAME TO Dept;
ALTER TABLE Course RENAME TO Courses;
ALTER TABLE Students RENAME TO StudentRecords;
ALTER TABLE Faculty RENAME TO Teachers;
ALTER TABLE Enrollments RENAME TO StudentEnrollments;

-- 07: describe the structure of the new table
DESCRIBE Dept;
DESCRIBE Courses;
DESCRIBE StudentRecords;
DESCRIBE Teachers;
DESCRIBE StudentEnrollments;


/*  Additional set of questions 
--1 Add a new column Address (VARCHAR(100)) to the Students table.
ALTER TABLE StudentRecords ADD Address VARCHAR(100);

--2 Add a column Gender (CHAR(1)) to the Students table.
ALTER TABLE StudentRecords ADD Gender CHAR(1);

--3 Add a column JoiningDate (DATE) to the Faculty table.
ALTER TABLE Teachers ADD JoiningDate DATE;

--4 Modify the column CourseName in the Courses table to increase its size from VARCHAR(50) to VARCHAR(100).
ALTER TABLE Courses MODIFY CourseName VARCHAR(100);

--5 Modify the column Location in the Departments table to VARCHAR(80)
ALTER TABLE Dept MODIFY Location VARCHAR(80);

--6 Rename the column Qualification in the Faculty table to Degree.
ALTER TABLE Teachers RENAME COLUMN Qualification TO Degree;

--7 Rename the table Faculty to Teachers.
ALTER TABLE Teachers RENAME TO Teachers;

--8 Drop the column PhoneNumber from the Departments table.
ALTER TABLE Dept DROP COLUMN PhoneNumber;

--9 Drop the column Email from the Students table.
ALTER TABLE StudentRecords DROP COLUMN Email;

--10 Drop the column Duration from the Courses table.
ALTER TABLE Courses DROP COLUMN Duration;
*/

SHOW TABLES; -- Before dropping the table

-- Drop the 'Courses' and 'Enrollments' tables from the database.
-- Write your SQL query below Codespace:

DROP TABLE Courses;
DROP TABLE StudentEnrollments;



SHOW TABLES; -- After dropping the table Enrollement and Course
-- 12:47:24	DROP TABLE Courses	0 row(s) affected	0.016 sec
-- 12:51:26	DROP TABLE StudentEnrollments	0 row(s) affected	0.015 sec


-- Note: Perform the specified operations on all the 5 tables in the system
-- End of Lab Experiment 01
-- Upload the Completed worksheet in the google classroom with file name USN _ LabScenario01