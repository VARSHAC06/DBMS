create database p1;
use p1;

create table doctor (
    doctor_id int primary key,
    doctor_name varchar(50),
    specialization varchar(50)
);

create table patient (
    patient_id int primary key,
    patient_name varchar(50),
    age int,
    gender varchar(10),
    city varchar(50)
);

create table appointment (
    appointment_id int primary key,
    patient_id int,
    doctor_id int,
    appointment_date date,
    purpose varchar(100),
    foreign key (patient_id) references patient(patient_id),
    foreign key (doctor_id) references doctor(doctor_id)
);

insert into doctor (doctor_id, doctor_name, specialization) values
(1, 'Dr. Mehta', 'Cardiologist'),
(2, 'Dr. Sharma', 'Dermatologist'),
(3, 'Dr. Patel', 'Orthopedic'),
(4, 'Dr. Nair', 'Pediatrician');

insert into patient (patient_id, patient_name, age, gender, city) values
(101, 'Aarav', 35, 'Male', 'Delhi'),
(102, 'Bhavya', 28, 'Female', 'Mumbai'),
(103, 'Chirag', 45, 'Male', 'Pune'),
(104, 'Diya', 15, 'Female', 'Chennai'),
(105, 'Eshan', 55, 'Male', 'Delhi');

insert into appointment (appointment_id, patient_id, doctor_id, appointment_date, purpose) values
(1, 101, 1, '2025-10-01', 'Heart Checkup'),
(2, 102, 2, '2025-10-02', 'Skin Allergy'),
(3, 103, 1, '2025-10-03', 'ECG Follow-up'),
(4, 104, 4, '2025-10-04', 'Fever'),
(5, 105, 3, '2025-10-05', 'Knee Pain');

select doctor.doctor_name, count(appointment.patient_id) as total_patients
from doctor
left join appointment
on doctor.doctor_id = appointment.doctor_id
group by doctor.doctor_name;
/*'Dr. Mehta', '2'
'Dr. Sharma', '1'
'Dr. Patel', '1'
'Dr. Nair', '1'*/

SELECT 
    appointment.appointment_date,
    patient.patient_name,
    doctor.doctor_name,
    appointment.purpose
FROM
    appointment
        INNER JOIN
    patient ON appointment.patient_id = patient.patient_id
        INNER JOIN
    doctor ON appointment.doctor_id = doctor.doctor_id
ORDER BY appointment.appointment_date;
/*'2025-10-01', 'Aarav', 'Dr. Mehta', 'Heart Checkup'
'2025-10-02', 'Bhavya', 'Dr. Sharma', 'Skin Allergy'
'2025-10-03', 'Chirag', 'Dr. Mehta', 'ECG Follow-up'
'2025-10-04', 'Diya', 'Dr. Nair', 'Fever'
'2025-10-05', 'Eshan', 'Dr. Patel', 'Knee Pain'*/
delimiter //

create procedure add_appointment (
    in p_appointment_id int,
    in p_patient_id int,
    in p_doctor_id int,
    in p_appointment_date date,
    in p_purpose varchar(100)
)
begin
    insert into appointment (appointment_id, patient_id, doctor_id, appointment_date, purpose)
    values (p_appointment_id, p_patient_id, p_doctor_id, p_appointment_date, p_purpose);
end //

delimiter ;
call add_appointment(6, 102, 3, '2025-10-06', 'Back Pain');

delimiter //

create procedure update_appointment (
    in p_appointment_id int,
    in p_new_date date,
    in p_new_purpose varchar(100)
)
begin
    update appointment
    set appointment_date = p_new_date,
        purpose = p_new_purpose
    where appointment_id = p_appointment_id;
end //

delimiter ;
call update_appointment(2, '2025-10-07', 'Skin Treatment');
