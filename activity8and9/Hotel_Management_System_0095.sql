CREATE DATABASE HotelDB;
USE HotelDB;
-- Table: Guests
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY,
    guest_name VARCHAR(100),
    gender VARCHAR(10),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- Table: Rooms
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(30),
    price_per_night DECIMAL(10,2),
    availability_status VARCHAR(20)
);

-- Table: Bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),  -- Confirmed / Cancelled
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);
-- Insert Guests
INSERT INTO Guests (guest_id, guest_name, gender, phone, city)
VALUES
(1, 'Amit Sharma', 'Male', '9876543210', 'Delhi'),
(2, 'Priya Nair', 'Female', '9988776655', 'Mumbai'),
(3, 'Ravi Kumar', 'Male', '9123456780', 'Chennai'),
(4, 'Sneha Patel', 'Female', '9234567891', 'Bangalore');

-- Insert Rooms
INSERT INTO Rooms (room_id, room_type, price_per_night, availability_status)
VALUES
(101, 'Single', 2000.00, 'Available'),
(102, 'Double', 3500.00, 'Available'),
(103, 'Suite', 6000.00, 'Available'),
(104, 'Deluxe', 4500.00, 'Available');

-- Insert Bookings
INSERT INTO Bookings (booking_id, guest_id, room_id, check_in, check_out, total_amount, status)
VALUES
(1, 1, 101, '2024-10-20', '2024-10-22', 4000.00, 'Confirmed'),
(2, 2, 103, '2024-10-21', '2024-10-24', 18000.00, 'Confirmed'),
(3, 3, 102, '2024-10-22', '2024-10-23', 3500.00, 'Cancelled'),
(4, 4, 104, '2024-10-25', '2024-10-27', 9000.00, 'Confirmed');

SELECT 
    b.booking_id,
    g.guest_name,
    r.room_type,
    r.price_per_night,
    b.check_in,
    b.check_out,
    b.total_amount,
    b.status
FROM Bookings b
INNER JOIN Guests g ON b.guest_id = g.guest_id
INNER JOIN Rooms r ON b.room_id = r.room_id
ORDER BY g.guest_name;
/*'1', 'Amit Sharma', 'Single', '2000.00', '2024-10-20', '2024-10-22', '4000.00', 'Confirmed'
'2', 'Priya Nair', 'Suite', '6000.00', '2024-10-21', '2024-10-24', '18000.00', 'Confirmed'
'3', 'Ravi Kumar', 'Double', '3500.00', '2024-10-22', '2024-10-23', '3500.00', 'Cancelled'
'4', 'Sneha Patel', 'Deluxe', '4500.00', '2024-10-25', '2024-10-27', '9000.00', 'Confirmed'*/

SELECT 
    r.room_type,
    SUM(b.total_amount) AS Total_Revenue
FROM Rooms r
JOIN Bookings b ON r.room_id = b.room_id
WHERE b.status = 'Confirmed'
GROUP BY r.room_type
ORDER BY Total_Revenue DESC;
/*'Suite', '18000.00'
'Deluxe', '9000.00'
'Single', '4000.00'*/

SELECT 
    b.booking_id,
    g.guest_name,
    r.room_type,
    DATEDIFF(b.check_out, b.check_in) AS Duration_Days,
    b.total_amount
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
JOIN Rooms r ON b.room_id = r.room_id;
/*'1', 'Amit Sharma', 'Single', '2', '4000.00'
'2', 'Priya Nair', 'Suite', '3', '18000.00'
'3', 'Ravi Kumar', 'Double', '1', '3500.00'
'4', 'Sneha Patel', 'Deluxe', '2', '9000.00'*/

DELIMITER //
CREATE PROCEDURE InsertBooking(
    IN bid INT,
    IN gid INT,
    IN rid INT,
    IN cin DATE,
    IN cout DATE,
    IN amt DECIMAL(10,2),
    IN stat VARCHAR(20)
)
BEGIN
    INSERT INTO Bookings (booking_id, guest_id, room_id, check_in, check_out, total_amount, status)
    VALUES (bid, gid, rid, cin, cout, amt, stat);
    
    -- Update room availability
    IF stat = 'Confirmed' THEN
        UPDATE Rooms SET availability_status = 'Booked' WHERE room_id = rid;
    END IF;
END //
DELIMITER ;
CALL InsertBooking(5, 2, 101, '2024-10-28', '2024-10-30', 4000.00, 'Confirmed');
DELIMITER //
CREATE PROCEDURE UpdateBookingStatus(
    IN bid INT,
    IN new_status VARCHAR(20)
)
BEGIN
    UPDATE Bookings
    SET status = new_status
    WHERE booking_id = bid;

    -- If cancelled, make room available again
    IF new_status = 'Cancelled' THEN
        UPDATE Rooms
        SET availability_status = 'Available'
        WHERE room_id = (SELECT room_id FROM Bookings WHERE booking_id = bid);
    END IF;
END //
DELIMITER ;
CALL UpdateBookingStatus(3, 'Confirmed');
SELECT * FROM Guests;
/*'1', 'Amit Sharma', 'Male', '9876543210', 'Delhi'
'2', 'Priya Nair', 'Female', '9988776655', 'Mumbai'
'3', 'Ravi Kumar', 'Male', '9123456780', 'Chennai'
'4', 'Sneha Patel', 'Female', '9234567891', 'Bangalore'*/

SELECT * FROM Rooms;
/*'101', 'Single', '2000.00', 'Booked'
'102', 'Double', '3500.00', 'Available'
'103', 'Suite', '6000.00', 'Available'
'104', 'Deluxe', '4500.00', 'Available'*/

SELECT * FROM Bookings;
/*'1', '1', '101', '2024-10-20', '2024-10-22', '4000.00', 'Confirmed'
'2', '2', '103', '2024-10-21', '2024-10-24', '18000.00', 'Confirmed'
'3', '3', '102', '2024-10-22', '2024-10-23', '3500.00', 'Confirmed'
'4', '4', '104', '2024-10-25', '2024-10-27', '9000.00', 'Confirmed'
'5', '2', '101', '2024-10-28', '2024-10-30', '4000.00', 'Confirmed'*/
