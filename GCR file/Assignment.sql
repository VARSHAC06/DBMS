Create database StudentMarkcard;
use StudentMarkcard;
Create table Student (
    reg_no INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    combination VARCHAR(10),
    marks1 INT,
    marks2 INT,
    marks3 INT
);
desc Student;
/*reg_no	int	NO	PRI		
name	varchar(50)	YES			
age	int	YES			
combination	varchar(10)	YES			
marks1	int	YES			
marks2	int	YES			
marks3	int	YES*/

INSERT INTO student VALUES
(101, 'Arjun', 18, 'PCMB', 78, 65, 80),
(102, 'Meera', 17, 'PCMC', 45, 50, 55),
(103, 'Rahul', 18, 'PCMB', 90, 88, 92),
(104, 'Sneha', 17, 'PCMC', 32, 40, 29),
(105, 'Kiran', 18, 'PCMB', 55, 60, 58),
(106, 'Divya', 17, 'PCMC', 70, 72, 68),
(107, 'Manoj', 18, 'PCMB', 25, 30, 45),
(108, 'Anita', 17, 'PCMC', 80, 85, 82),
(109, 'Ravi', 18, 'PCMB', 34, 36, 33),
(110, 'Priya', 17, 'PCMC', 60, 62, 65);	

ALTER TABLE student
ADD total INT,
ADD average DECIMAL(5,2),
ADD result VARCHAR(10);

desc Student;
/*'reg_no', 'int', 'NO', 'PRI', NULL, ''
'name', 'varchar(50)', 'YES', '', NULL, ''
'age', 'int', 'YES', '', NULL, ''
'combination', 'varchar(10)', 'YES', '', NULL, ''
'marks1', 'int', 'YES', '', NULL, ''
'marks2', 'int', 'YES', '', NULL, ''
'marks3', 'int', 'YES', '', NULL, ''
'total', 'int', 'YES', '', NULL, ''
'average', 'decimal(5,2)', 'YES', '', NULL, ''
'result', 'varchar(10)', 'YES', '', NULL, ''*/

UPDATE student
SET total = marks1 + marks2 + marks3;

UPDATE student
SET average = total / 3;

UPDATE student
SET result = 'Pass'
WHERE marks1 >= 35 AND marks2 >= 35 AND marks3 >= 35;

UPDATE student
SET result = 'Fail'
WHERE marks1 < 35 OR marks2 < 35 OR marks3 < 35;

SELECT * FROM Student;
/*101	Arjun	18	PCMB	78	65	80	223	74.33	Pass
102	Meera	17	PCMC	45	50	55	150	50.00	Pass
103	Rahul	18	PCMB	90	88	92	270	90.00	Pass
104	Sneha	17	PCMC	32	40	29	101	33.67	Fail
105	Kiran	18	PCMB	55	60	58	173	57.67	Pass
106	Divya	17	PCMC	70	72	68	210	70.00	Pass
107	Manoj	18	PCMB	25	30	45	100	33.33	Fail
108	Anita	17	PCMC	80	85	82	247	82.33	Pass
109	Ravi	18	PCMB	34	36	33	103	34.33	Fail
110	Priya	17	PCMC	60	62	65	187	62.33	Pass*/
									



