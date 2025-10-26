CREATE DATABASE FlightDB;
USE FlightDB;
-- Table: Passengers
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50)
);

-- Table: Flights
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_name VARCHAR(100),
    source_city VARCHAR(50),
    destination_city VARCHAR(50),
    departure_time DATETIME,
    arrival_time DATETIME,
    fare DECIMAL(10,2)
);

-- Table: Bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    booking_date DATE,
    seat_no VARCHAR(10),
    status VARCHAR(20),  -- Confirmed / Cancelled
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
-- Insert Passengers
INSERT INTO Passengers (passenger_id, passenger_name, gender, age, city)
VALUES
(1, 'Amit Verma', 'Male', 28, 'Delhi'),
(2, 'Priya Mehta', 'Female', 25, 'Mumbai'),
(3, 'Ravi Sharma', 'Male', 35, 'Chennai'),
(4, 'Sneha Patel', 'Female', 30, 'Bangalore'),
(5, 'Karan Singh', 'Male', 40, 'Kolkata');

-- Insert Flights
INSERT INTO Flights (flight_id, flight_name, source_city, destination_city, departure_time, arrival_time, fare)
VALUES
(101, 'IndiGo 6E101', 'Delhi', 'Mumbai', '2024-10-28 09:00:00', '2024-10-28 11:00:00', 5500.00),
(102, 'Air India AI202', 'Mumbai', 'Chennai', '2024-10-28 12:00:00', '2024-10-28 14:00:00', 6000.00),
(103, 'SpiceJet SJ303', 'Bangalore', 'Delhi', '2024-10-29 10:30:00', '2024-10-29 13:00:00', 5800.00),
(104, 'Vistara UK404', 'Kolkata', 'Bangalore', '2024-10-30 08:00:00', '2024-10-30 10:30:00', 6200.00),
(105, 'GoAir G805', 'Chennai', 'Delhi', '2024-10-30 15:00:00', '2024-10-30 17:30:00', 6500.00);

-- Insert Bookings
INSERT INTO Bookings (booking_id, passenger_id, flight_id, booking_date, seat_no, status)
VALUES
(1, 1, 101, '2024-10-15', '12A', 'Confirmed'),
(2, 2, 101, '2024-10-16', '14B', 'Confirmed'),
(3, 3, 102, '2024-10-17', '10C', 'Confirmed'),
(4, 4, 104, '2024-10-20', '8D', 'Confirmed'),
(5, 5, 103, '2024-10-22', '9A', 'Cancelled');
SELECT 
    b.booking_id,
    p.passenger_name,
    f.flight_name,
    f.source_city,
    f.destination_city,
    f.departure_time,
    f.arrival_time,
    b.seat_no,
    b.status
FROM Bookings b
INNER JOIN Passengers p ON b.passenger_id = p.passenger_id
INNER JOIN Flights f ON b.flight_id = f.flight_id
ORDER BY p.passenger_name;
/*'1', 'Amit Verma', 'IndiGo 6E101', 'Delhi', 'Mumbai', '2024-10-28 09:00:00', '2024-10-28 11:00:00', '12A', 'Confirmed'
'5', 'Karan Singh', 'SpiceJet SJ303', 'Bangalore', 'Delhi', '2024-10-29 10:30:00', '2024-10-29 13:00:00', '9A', 'Cancelled'
'2', 'Priya Mehta', 'IndiGo 6E101', 'Delhi', 'Mumbai', '2024-10-28 09:00:00', '2024-10-28 11:00:00', '14B', 'Confirmed'
'3', 'Ravi Sharma', 'Air India AI202', 'Mumbai', 'Chennai', '2024-10-28 12:00:00', '2024-10-28 14:00:00', '10C', 'Confirmed'
'4', 'Sneha Patel', 'Vistara UK404', 'Kolkata', 'Bangalore', '2024-10-30 08:00:00', '2024-10-30 10:30:00', '8D', 'Confirmed'*/

SELECT 
    f.flight_name,
    COUNT(b.passenger_id) AS Total_Passengers
FROM Flights f
LEFT JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_name
ORDER BY Total_Passengers DESC;
/*'IndiGo 6E101', '2'
'Air India AI202', '1'
'SpiceJet SJ303', '1'
'Vistara UK404', '1'
'GoAir G805', '0'*/

SELECT AVG(fare) AS Average_Fare FROM Flights;
/*'6000.000000'*/

SELECT MAX(fare) AS Max_Fare, MIN(fare) AS Min_Fare FROM Flights;
/*'6500.00', '5500.00'*/

SELECT 
    booking_id,
    passenger_id,
    YEAR(booking_date) AS Booking_Year,
    MONTH(booking_date) AS Booking_Month
FROM Bookings;
/*'1', '1', '2024', '10'
'2', '2', '2024', '10'
'3', '3', '2024', '10'
'4', '4', '2024', '10'
'5', '5', '2024', '10'*/

SELECT * 
FROM Flights
WHERE departure_time > NOW()
ORDER BY departure_time;

DELIMITER //
CREATE PROCEDURE InsertBooking(
    IN bid INT,
    IN pid INT,
    IN fid INT,
    IN bdate DATE,
    IN seat VARCHAR(10),
    IN stat VARCHAR(20)
)
BEGIN
    INSERT INTO Bookings (booking_id, passenger_id, flight_id, booking_date, seat_no, status)
    VALUES (bid, pid, fid, bdate, seat, stat);
END //
DELIMITER ;
CALL InsertBooking(6, 1, 105, '2024-10-25', '11B', 'Confirmed');
DELIMITER //
CREATE PROCEDURE UpdateBookingStatus(
    IN bid INT,
    IN new_status VARCHAR(20)
)
BEGIN
    UPDATE Bookings
    SET status = new_status
    WHERE booking_id = bid;
END //
DELIMITER ;
CALL UpdateBookingStatus(5, 'Confirmed');

SELECT b.booking_id, 
       p.passenger_name, 
       f.flight_name, 
       b.status
FROM Bookings b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Flights f ON b.flight_id = f.flight_id;
/*'1', 'Amit Verma', 'IndiGo 6E101', 'Confirmed'
'6', 'Amit Verma', 'GoAir G805', 'Confirmed'
'2', 'Priya Mehta', 'IndiGo 6E101', 'Confirmed'
'3', 'Ravi Sharma', 'Air India AI202', 'Confirmed'
'4', 'Sneha Patel', 'Vistara UK404', 'Confirmed'
'5', 'Karan Singh', 'SpiceJet SJ303', 'Confirmed'*/

SELECT * FROM Passengers;
/*'1', 'Amit Verma', 'Male', '28', 'Delhi'
'2', 'Priya Mehta', 'Female', '25', 'Mumbai'
'3', 'Ravi Sharma', 'Male', '35', 'Chennai'
'4', 'Sneha Patel', 'Female', '30', 'Bangalore'
'5', 'Karan Singh', 'Male', '40', 'Kolkata'*/

SELECT * FROM Flights;
/*'101', 'IndiGo 6E101', 'Delhi', 'Mumbai', '2024-10-28 09:00:00', '2024-10-28 11:00:00', '5500.00'
'102', 'Air India AI202', 'Mumbai', 'Chennai', '2024-10-28 12:00:00', '2024-10-28 14:00:00', '6000.00'
'103', 'SpiceJet SJ303', 'Bangalore', 'Delhi', '2024-10-29 10:30:00', '2024-10-29 13:00:00', '5800.00'
'104', 'Vistara UK404', 'Kolkata', 'Bangalore', '2024-10-30 08:00:00', '2024-10-30 10:30:00', '6200.00'
'105', 'GoAir G805', 'Chennai', 'Delhi', '2024-10-30 15:00:00', '2024-10-30 17:30:00', '6500.00'*/

SELECT * FROM Bookings;
/*'1', '1', '101', '2024-10-15', '12A', 'Confirmed'
'2', '2', '101', '2024-10-16', '14B', 'Confirmed'
'3', '3', '102', '2024-10-17', '10C', 'Confirmed'
'4', '4', '104', '2024-10-20', '8D', 'Confirmed'
'5', '5', '103', '2024-10-22', '9A', 'Confirmed'
'6', '1', '105', '2024-10-25', '11B', 'Confirmed'*/
