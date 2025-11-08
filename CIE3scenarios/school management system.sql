create database p3;
use p3; 

create table class (
    class_id int primary key,
    class_name varchar(50),
    teacher_name varchar(50)
);

create table student (
    student_id int primary key,
    student_name varchar(50),
    class_id int,
    age int,
    city varchar(50),
    foreign key (class_id) references class(class_id)
);

create table marks (
    mark_id int primary key,
    student_id int,
    subject varchar(50),
    marks int,
    foreign key (student_id) references student(student_id)
);

insert into class (class_id, class_name, teacher_name) values
(1, 'Class 10-A', 'Mr. Sharma'),
(2, 'Class 10-B', 'Mrs. Nair'),
(3, 'Class 9-A', 'Mr. Mehta');

insert into student (student_id, student_name, class_id, age, city) values
(101, 'Aarav', 1, 15, 'Delhi'),
(102, 'Bhavya', 1, 16, 'Mumbai'),
(103, 'Chirag', 2, 15, 'Pune'),
(104, 'Diya', 2, 15, 'Chennai'),
(105, 'Eshan', 3, 14, 'Delhi');

insert into marks (mark_id, student_id, subject, marks) values
(1, 101, 'Math', 88),
(2, 101, 'Science', 92),
(3, 102, 'Math', 79),
(4, 102, 'Science', 85),
(5, 103, 'Math', 90),
(6, 103, 'Science', 87),
(7, 104, 'Math', 76),
(8, 104, 'Science', 82),
(9, 105, 'Math', 84),
(10, 105, 'Science', 80);

select class.class_name, avg(marks.marks) as average_marks
from marks
inner join student on marks.student_id = student.student_id
inner join class on student.class_id = class.class_id
group by class.class_name;
/*'Class 10-A', '86.0000'
'Class 10-B', '83.7500'
'Class 9-A', '82.0000'*/

select student.student_name, avg(marks.marks) as average_marks
from marks
inner join student on marks.student_id = student.student_id
group by student.student_name
order by average_marks desc
limit 3;
/*'Aarav', '90.0000'
'Chirag', '88.5000'
'Bhavya', '82.0000'*/

delimiter //
create procedure add_marks (
    in p_mark_id int,
    in p_student_id int,
    in p_subject varchar(50),
    in p_marks int
)
begin
    insert into marks (mark_id, student_id, subject, marks)
    values (p_mark_id, p_student_id, p_subject, p_marks);
end //
delimiter ;
call add_marks(11, 101, 'English', 89);

delimiter //
create procedure update_marks (
    in p_student_id int,
    in p_subject varchar(50),
    in p_new_marks int
)
begin
    update marks
    set marks = p_new_marks
    where student_id = p_student_id and subject = p_subject;
end //
delimiter ;
call update_marks(102, 'Science', 90);
