CREATE DATABASE SchoolDB;
USE SchoolDB;
-- Table: Classes
CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50),
    section VARCHAR(10),
    class_teacher VARCHAR(100)
);

-- Table: Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    gender VARCHAR(10),
    dob DATE,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Table: Marks
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject VARCHAR(50),
    marks_obtained INT,
    total_marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);
-- Insert into Classes
INSERT INTO Classes (class_id, class_name, section, class_teacher)
VALUES
(1, 'Grade 10', 'A', 'Mrs. Sharma'),
(2, 'Grade 10', 'B', 'Mr. Verma'),
(3, 'Grade 9', 'A', 'Mrs. Reddy');

-- Insert into Students
INSERT INTO Students (student_id, student_name, gender, dob, class_id)
VALUES
(101, 'Asha Rao', 'Female', '2008-04-12', 1),
(102, 'Rahul Kumar', 'Male', '2008-09-20', 1),
(103, 'Sneha Patil', 'Female', '2009-01-15', 2),
(104, 'Rohit Sharma', 'Male', '2009-05-10', 3),
(105, 'Neha Singh', 'Female', '2008-12-30', 2);

-- Insert into Marks
INSERT INTO Marks (mark_id, student_id, subject, marks_obtained, total_marks)
VALUES
(1, 101, 'Math', 88, 100),
(2, 101, 'Science', 92, 100),
(3, 102, 'Math', 76, 100),
(4, 102, 'Science', 81, 100),
(5, 103, 'Math', 85, 100),
(6, 103, 'Science', 89, 100),
(7, 104, 'Math', 90, 100),
(8, 104, 'Science', 93, 100),
(9, 105, 'Math', 70, 100),
(10, 105, 'Science', 78, 100);

SELECT s.student_id,
       s.student_name,
       c.class_name,
       c.section,
       m.subject,
       m.marks_obtained,
       m.total_marks
FROM Students s
INNER JOIN Classes c ON s.class_id = c.class_id
INNER JOIN Marks m ON s.student_id = m.student_id
ORDER BY c.class_name, s.student_name, m.subject;
/*'101', 'Asha Rao', 'Grade 10', 'A', 'Math', '88', '100'
'101', 'Asha Rao', 'Grade 10', 'A', 'Science', '92', '100'
'105', 'Neha Singh', 'Grade 10', 'B', 'Math', '70', '100'
'105', 'Neha Singh', 'Grade 10', 'B', 'Science', '78', '100'
'102', 'Rahul Kumar', 'Grade 10', 'A', 'Math', '76', '100'
'102', 'Rahul Kumar', 'Grade 10', 'A', 'Science', '81', '100'
'103', 'Sneha Patil', 'Grade 10', 'B', 'Math', '85', '100'
'103', 'Sneha Patil', 'Grade 10', 'B', 'Science', '89', '100'
'104', 'Rohit Sharma', 'Grade 9', 'A', 'Math', '90', '100'
'104', 'Rohit Sharma', 'Grade 9', 'A', 'Science', '93', '100'*/

SELECT c.class_name,
       AVG(m.marks_obtained) AS Average_Marks
FROM Classes c
JOIN Students s ON c.class_id = s.class_id
JOIN Marks m ON s.student_id = m.student_id
GROUP BY c.class_name
ORDER BY Average_Marks DESC;
/*'Grade 9', '91.5000'
'Grade 10', '82.3750'*/

SELECT m.subject,
       s.student_name,
       m.marks_obtained
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
WHERE m.marks_obtained = (
    SELECT MAX(m2.marks_obtained)
    FROM Marks m2
    WHERE m2.subject = m.subject
);
/*'Math', 'Rohit Sharma', '90'
'Science', 'Rohit Sharma', '93'*/

DELIMITER //
CREATE PROCEDURE InsertStudent(
    IN sid INT,
    IN sname VARCHAR(100),
    IN gender VARCHAR(10),
    IN dob DATE,
    IN classid INT
)
BEGIN
    INSERT INTO Students (student_id, student_name, gender, dob, class_id)
    VALUES (sid, sname, gender, dob, classid);
END //
DELIMITER ;
CALL InsertStudent(106, 'Kiran Das', 'Male', '2009-03-10', 3);
DELIMITER //
CREATE PROCEDURE UpdateMarks(
    IN sid INT,
    IN subject_name VARCHAR(50),
    IN new_marks INT
)
BEGIN
    UPDATE Marks
    SET marks_obtained = new_marks
    WHERE student_id = sid AND subject = subject_name;
END //
DELIMITER ;
CALL UpdateMarks(102, 'Math', 82);
SELECT * FROM Students;
/*'101', 'Asha Rao', 'Female', '2008-04-12', '1'
'102', 'Rahul Kumar', 'Male', '2008-09-20', '1'
'103', 'Sneha Patil', 'Female', '2009-01-15', '2'
'104', 'Rohit Sharma', 'Male', '2009-05-10', '3'
'105', 'Neha Singh', 'Female', '2008-12-30', '2'
'106', 'Kiran Das', 'Male', '2009-03-10', '3'*/

SELECT * FROM Classes;
/*'1', 'Grade 10', 'A', 'Mrs. Sharma'
'2', 'Grade 10', 'B', 'Mr. Verma'
'3', 'Grade 9', 'A', 'Mrs. Reddy'*/

SELECT * FROM Marks;
/*'1', '101', 'Math', '88', '100'
'2', '101', 'Science', '92', '100'
'3', '102', 'Math', '82', '100'
'4', '102', 'Science', '81', '100'
'5', '103', 'Math', '85', '100'
'6', '103', 'Science', '89', '100'
'7', '104', 'Math', '90', '100'
'8', '104', 'Science', '93', '100'
'9', '105', 'Math', '70', '100'
'10', '105', 'Science', '78', '100'*/
