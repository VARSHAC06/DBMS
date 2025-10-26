CREATE DATABASE HospitalDB;
USE HospitalDB;
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15),
    city VARCHAR(30)
);
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50),
    gender VARCHAR(10),
    dob DATE,
    city VARCHAR(30)
);
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    diagnosis VARCHAR(100),
    fee DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
INSERT INTO Doctors (doctor_name, specialization, phone, city) VALUES
('Dr. Meera Nair', 'Cardiology', '9876543210', 'Bangalore'),
('Dr. Arjun Patel', 'Orthopedics', '9123456780', 'Mysore'),
('Dr. Sneha Deshmukh', 'Dermatology', '9898989898', 'Mangalore'),
('Dr. Rohit Iyer', 'Pediatrics', '9000012345', 'Hubli'),
('Dr. Nisha Rao', 'Neurology', '9112233445', 'Udupi');
INSERT INTO Patients (patient_name, gender, dob, city) VALUES
('Asha Reddy', 'Female', '1998-04-12', 'Bangalore'),
('Rahul Verma', 'Male', '2001-07-23', 'Mysore'),
('Sneha Gowda', 'Female', '1995-11-02', 'Mangalore'),
('Karan Shah', 'Male', '2000-05-14', 'Hubli'),
('Neha Singh', 'Female', '1999-08-09', 'Udupi');
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
(1, 1, '2025-05-20', 'High Blood Pressure', 500.00),
(2, 2, '2025-06-10', 'Fracture Checkup', 700.00),
(3, 3, '2025-06-18', 'Skin Allergy', 400.00),
(4, 4, '2025-07-02', 'Flu Symptoms', 300.00),
(5, 5, '2025-07-10', 'Migraine', 600.00);
SELECT a.appointment_id, 
       p.patient_name, 
       d.doctor_name, 
       d.specialization, 
       a.appointment_date, 
       a.diagnosis, 
       a.fee
FROM Appointments a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id;
/*'1', 'Asha Reddy', 'Dr. Meera Nair', 'Cardiology', '2025-05-20', 'High Blood Pressure', '500.00'
'2', 'Rahul Verma', 'Dr. Arjun Patel', 'Orthopedics', '2025-06-10', 'Fracture Checkup', '700.00'
'3', 'Sneha Gowda', 'Dr. Sneha Deshmukh', 'Dermatology', '2025-06-18', 'Skin Allergy', '400.00'
'4', 'Karan Shah', 'Dr. Rohit Iyer', 'Pediatrics', '2025-07-02', 'Flu Symptoms', '300.00'
'5', 'Neha Singh', 'Dr. Nisha Rao', 'Neurology', '2025-07-10', 'Migraine', '600.00'*/
SELECT p.patient_name, a.appointment_date, d.doctor_name
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id;
/*'Asha Reddy', '2025-05-20', 'Dr. Meera Nair'
'Rahul Verma', '2025-06-10', 'Dr. Arjun Patel'
'Sneha Gowda', '2025-06-18', 'Dr. Sneha Deshmukh'
'Karan Shah', '2025-07-02', 'Dr. Rohit Iyer'
'Neha Singh', '2025-07-10', 'Dr. Nisha Rao'*/
SELECT d.doctor_name, COUNT(a.patient_id) AS Total_Patients
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY Total_Patients DESC;
/*'Dr. Meera Nair', '1'
'Dr. Arjun Patel', '1'
'Dr. Sneha Deshmukh', '1'
'Dr. Rohit Iyer', '1'
'Dr. Nisha Rao', '1'*/
SELECT AVG(fee) AS Avg_Fee FROM Appointments;
/*'500.000000'*/
SELECT MAX(fee) AS Max_Fee, MIN(fee) AS Min_Fee FROM Appointments;
/*'700.00', '300.00'*/

DELIMITER //
CREATE PROCEDURE InsertAppointment(
    IN pid INT,
    IN did INT,
    IN adate DATE,
    IN diag VARCHAR(100),
    IN afee DECIMAL(10,2)
)
BEGIN
    INSERT INTO Appointments (patient_id, doctor_id, appointment_date, diagnosis, fee)
    VALUES (pid, did, adate, diag, afee);
END //
DELIMITER ;

CALL InsertAppointment(1, 3, '2025-08-05', 'Acne Treatment', 450.00);
DELIMITER //
CREATE PROCEDURE UpdateAppointmentFee(
    IN aid INT,
    IN new_fee DECIMAL(10,2)
)
BEGIN
    UPDATE Appointments
    SET fee = new_fee
    WHERE appointment_id = aid;
END //
DELIMITER ;
CALL UpdateAppointmentFee(3, 500.00);



