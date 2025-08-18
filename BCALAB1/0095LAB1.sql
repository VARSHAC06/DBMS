-- Lab Experiment 01: Implementation of DDL Commands in SQL
-- STUDENT NAME: VARSHA C
-- USN: 1RUA24BCA0095
-- SECTION: A

SELECT USER(), 
       @@hostname AS Host_Name, 
       VERSION() AS MySQL_Version, 
       NOW() AS Current_Date_Time;
-- OUTPUT : [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
-- 'root@localhost', 'RVU-PC-008', '8.4.6', '2025-08-18 06:03:03'

-- Scenario: University Course Management System
-- CREATE AND LOAD THE database DBLab001
-- Write your SQL query below Codespace:

 create database BCALAB001;
 USE BCALAB001;
 
-- Task 1: Create the Students Table
-- Create a table to store information about students.
-- Include the following columns:
-- 1. StudentID (Primary Key)
-- 2. FirstName
-- 3. LastName
-- 4. Email (Unique Constraint)
-- 5. DateOfBirth

-- Write your SQL query below Codespace:

create table student
(studentId varchar(20) Primary Key, 
FirstName varchar(30),
LastName varchar(10),
email varchar(20) unique,
DOB date);

-- [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]
-- OUTPUT : Disclaimer - This code is not the part of the SQL Code
/*'studentId', 'varchar(20)', 'NO', 'PRI', NULL, ''
'FirstName', 'varchar(30)', 'YES', '', NULL, ''
'LastName', 'varchar(10)', 'YES', '', NULL, ''
'email', 'varchar(20)', 'YES', 'UNI', NULL, ''
'DOB', 'date', 'YES', '', NULL, ''*/


-- Alter the table and 2 new columns
alter table student add(gender varchar(10), age int);
desc student;

-- Modify a column data type
alter table student modify LastName varchar(15);
desc student;

-- Rename a column
alter table student
rename column LastName to SurName;
desc student;

-- Drop a column
alter table student 
drop column surname;
desc student;

-- Rename the table
alter table student
rename to Employ;





-- Task 2: Create the Courses Table
-- Create a table to store information about courses.
-- Include the following columns:
-- - CourseID (Primary Key)
-- - CourseName
-- - Credits

-- Write your SQL query below Codespace:
create table Courses 
(coursesId varchar(10),
coursename varchar(30),
credits int );


DESC Courses; -- [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]

-- OUTPUT :
/*'coursesId', 'varchar(10)', 'YES', '', NULL, ''
'coursename', 'varchar(30)', 'YES', '', NULL, ''
'credits', 'int', 'YES', '', NULL, ''*/

-- Alter the table and 2 new columns
alter table Courses add(coursefaculty  varchar(20), coursebranch varchar(10));
desc Courses ;

-- Modify a column data type
alter table Courses modify coursebranch varchar(20);

-- Rename a column
alter table Courses rename column  coursefaculty to faculty;

-- Drop a column
alter table Courses drop faculty;

-- Rename the table
alter table Courses rename to CoursesDetails;



-- Task 3: Create the Enrollments Table
-- Create a table to store course enrollment information.
-- Include the following columns:
-- - EnrollmentID (Primary Key)
-- - StudentID (Foreign Key referencing Students table)
-- - CourseID (Foreign Key referencing Courses table)
-- - EnrollmentDate

-- Write your SQL query below Codespace:
 create table enrolloments
 (enrollmentId varchar(30) primary key ,
 studentId varchar(10), 
 courseId varchar(10) ,
 Foreign Key (StudentId) referencing student(S,
 Foreign Key referencing courses table,
 enrollmentdate date );
 
DESC ENROLLMENTS; -- [ [ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ] ]
-- OUTPUT :

-- Alter the table and 2 new columns
-- Modify a column data type
-- Rename a column
-- Drop a column
-- Rename the table

-- Task 4: Alter the Students Table
-- Add a column 'PhoneNumber' to store student contact numbers.

-- Write your SQL query below Codespace:

DESC STUDENTS; -- [[ COPYPASTE OF THE OUTPUT in CSV Format and terminate with ; ]]

-- Task 5: Modify the Courses Table
-- Change the data type of the 'Credits' column to DECIMAL.
-- Write your SQL query below Codespace:

-- Task 6: Drop Tables

SHOW TABLES; -- Before dropping the table

-- Drop the 'Courses' and 'Enrollments' tables from the database.
-- Write your SQL query below Codespace:

SHOW TABLES; -- After dropping the table Enrollement and Course

-- End of Lab Experiment 01
-- Upload the Completed worksheet in the google classroom with file name USN _ LabExperiment01
