create database online_course_platform;
use online_course_platform;

create table instructors (
    instructor_id int primary key auto_increment,
    instructor_name varchar(50),
    email varchar(100),
    specialization varchar(100)
);


create table courses (
    course_id int primary key auto_increment,
    course_name varchar(100),
    category varchar(50),
    instructor_id int,
    duration_weeks int,
    foreign key (instructor_id) references instructors(instructor_id)
);

create table enrollments (
    enroll_id int primary key auto_increment,
    course_id int,
    student_name varchar(50),
    student_email varchar(100),
    enroll_date date,
    foreign key (course_id) references courses(course_id)
);


insert into instructors (instructor_name, email, specialization) values
('Dr. Neha Sharma', 'neha.sharma@example.com', 'Data Science'),
('Prof. Arjun Rao', 'arjun.rao@example.com', 'Web Development'),
('Ms. Kavita Das', 'kavita.das@example.com', 'Graphic Design');

insert into courses (course_name, category, instructor_id, duration_weeks) values
('Python for Beginners', 'Programming', 1, 8),
('Advanced Machine Learning', 'AI/ML', 1, 10),
('Full Stack Web Development', 'Web Development', 2, 12),
('UI/UX Design Fundamentals', 'Design', 3, 6);

insert into enrollments (course_id, student_name, student_email, enroll_date) values
(1, 'Amit Patel', 'amit.patel@example.com', '2025-10-20'),
(1, 'Riya Mehta', 'riya.mehta@example.com', '2025-10-21'),
(2, 'Rohan Das', 'rohan.das@example.com', '2025-10-22'),
(3, 'Sneha Iyer', 'sneha.iyer@example.com', '2025-10-23'),
(3, 'Tanya Gupta', 'tanya.gupta@example.com', '2025-10-24'),
(4, 'Vikas Jain', 'vikas.jain@example.com', '2025-10-25');

select 
    i.instructor_name,
    c.course_name,
    c.category,
    c.duration_weeks
from courses c
join instructors i on c.instructor_id = i.instructor_id
order by i.instructor_name;
/*'Dr. Neha Sharma', 'Python for Beginners', 'Programming', '8'
'Dr. Neha Sharma', 'Advanced Machine Learning', 'AI/ML', '10'
'Ms. Kavita Das', 'UI/UX Design Fundamentals', 'Design', '6'
'Prof. Arjun Rao', 'Full Stack Web Development', 'Web Development', '12'*/

select 
    c.course_name,
    i.instructor_name,
    count(e.enroll_id) as total_students
from courses c
join instructors i on c.instructor_id = i.instructor_id
left join enrollments e on c.course_id = e.course_id
group by c.course_name, i.instructor_name
order by total_students desc;
/*'Python for Beginners', 'Dr. Neha Sharma', '2'
'Full Stack Web Development', 'Prof. Arjun Rao', '2'
'Advanced Machine Learning', 'Dr. Neha Sharma', '1'
'UI/UX Design Fundamentals', 'Ms. Kavita Das', '1'*/

delimiter $$

create procedure add_enrollment(
    in p_course_id int,
    in p_student_name varchar(50),
    in p_student_email varchar(100),
    in p_enroll_date date
)
begin
    declare course_exists int;

    select count(*) into course_exists from courses where course_id = p_course_id;

    if course_exists > 0 then
        insert into enrollments (course_id, student_name, student_email, enroll_date)
        values (p_course_id, p_student_name, p_student_email, p_enroll_date);
    else
        signal sqlstate '45000'
        set message_text = 'Course not found!';
    end if;
end $$

delimiter ;
call add_enrollment(2, 'Meera Joshi', 'meera.joshi@example.com', '2025-10-28');


delimiter $$

create procedure update_enrollment(
    in p_enroll_id int,
    in p_new_course_id int,
    in p_new_enroll_date date
)
begin
    declare course_exists int;

    select count(*) into course_exists from courses where course_id = p_new_course_id;

    if course_exists > 0 then
        update enrollments
        set course_id = p_new_course_id,
            enroll_date = p_new_enroll_date
        where enroll_id = p_enroll_id;
    else
        signal sqlstate '45000'
        set message_text = 'Invalid course ID!';
    end if;
end $$

delimiter ;
call update_enrollment(3, 1, '2025-10-30');