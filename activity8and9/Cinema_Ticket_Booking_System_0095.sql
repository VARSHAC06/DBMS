CREATE DATABASE CinemaDB;
USE CinemaDB;
-- Table: Movies
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    movie_title VARCHAR(100),
    genre VARCHAR(50),
    duration_minutes INT,
    ticket_price DECIMAL(8,2)
);

-- Table: Shows
CREATE TABLE Shows (
    show_id INT PRIMARY KEY,
    movie_id INT,
    show_date DATE,
    show_time TIME,
    hall_number INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Table: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100)
);

-- Table: Bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    show_id INT,
    customer_id INT,
    tickets_booked INT,
    booking_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
-- Insert Movies
INSERT INTO Movies (movie_id, movie_title, genre, duration_minutes, ticket_price)
VALUES
(1, 'Inception', 'Sci-Fi', 148, 250.00),
(2, 'Avengers: Endgame', 'Action', 181, 300.00),
(3, 'The Lion King', 'Animation', 118, 200.00);

-- Insert Shows
INSERT INTO Shows (show_id, movie_id, show_date, show_time, hall_number)
VALUES
(101, 1, '2024-11-01', '18:00:00', 1),
(102, 2, '2024-11-01', '21:00:00', 2),
(103, 3, '2024-11-02', '17:00:00', 3),
(104, 1, '2024-11-02', '20:00:00', 1);

-- Insert Customers
INSERT INTO Customers (customer_id, customer_name, phone, email)
VALUES
(201, 'Ravi Sharma', '9876543210', 'ravi@example.com'),
(202, 'Priya Mehta', '9988776655', 'priya@example.com'),
(203, 'Amit Verma', '9123456789', 'amit@example.com');

-- Insert Bookings
INSERT INTO Bookings (booking_id, show_id, customer_id, tickets_booked, booking_date, total_amount)
VALUES
(301, 101, 201, 2, '2024-10-25', 500.00),
(302, 102, 202, 3, '2024-10-26', 900.00),
(303, 103, 203, 4, '2024-10-26', 800.00),
(304, 104, 201, 1, '2024-10-27', 250.00);
SELECT 
    b.booking_id,
    c.customer_name,
    c.phone,
    m.movie_title,
    m.genre,
    s.show_date,
    s.show_time,
    b.tickets_booked,
    b.total_amount
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Shows s ON b.show_id = s.show_id
JOIN Movies m ON s.movie_id = m.movie_id
ORDER BY b.booking_id;
/*'301', 'Ravi Sharma', '9876543210', 'Inception', 'Sci-Fi', '2024-11-01', '18:00:00', '2', '500.00'
'302', 'Priya Mehta', '9988776655', 'Avengers: Endgame', 'Action', '2024-11-01', '21:00:00', '3', '900.00'
'303', 'Amit Verma', '9123456789', 'The Lion King', 'Animation', '2024-11-02', '17:00:00', '4', '800.00'
'304', 'Ravi Sharma', '9876543210', 'Inception', 'Sci-Fi', '2024-11-02', '20:00:00', '1', '250.00'*/

SELECT 
    m.movie_title,
    SUM(b.tickets_booked) AS Total_Tickets_Booked,
    SUM(b.total_amount) AS Total_Collection
FROM Movies m
JOIN Shows s ON m.movie_id = s.movie_id
JOIN Bookings b ON s.show_id = b.show_id
GROUP BY m.movie_title
ORDER BY Total_Tickets_Booked DESC;
/*'The Lion King', '4', '800.00'
'Inception', '3', '750.00'
'Avengers: Endgame', '3', '900.00'*/

SELECT 
    b.booking_id,
    c.customer_name,
    b.booking_date,
    DATEDIFF(CURDATE(), b.booking_date) AS Days_Since_Booking
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id;
/*'301', 'Ravi Sharma', '2024-10-25', '366'
'304', 'Ravi Sharma', '2024-10-27', '364'
'302', 'Priya Mehta', '2024-10-26', '365'
'303', 'Amit Verma', '2024-10-26', '365'*/

SELECT 
    m.movie_title,
    AVG(m.ticket_price) AS Average_Ticket_Price
FROM Movies m
GROUP BY m.movie_title;
/*'Inception', '250.000000'
'Avengers: Endgame', '300.000000'
'The Lion King', '200.000000'*/

DELIMITER //
CREATE PROCEDURE InsertBooking(
    IN bid INT,
    IN sid INT,
    IN cid INT,
    IN tickets INT,
    IN bdate DATE
)
BEGIN
    DECLARE ticket_cost DECIMAL(8,2);
    DECLARE total DECIMAL(10,2);
    
    -- Get ticket price from movie
    SELECT m.ticket_price INTO ticket_cost
    FROM Movies m
    JOIN Shows s ON m.movie_id = s.movie_id
    WHERE s.show_id = sid;
    
    SET total = ticket_cost * tickets;
    
    -- Insert booking
    INSERT INTO Bookings (booking_id, show_id, customer_id, tickets_booked, booking_date, total_amount)
    VALUES (bid, sid, cid, tickets, bdate, total);
END //
DELIMITER ;
CALL InsertBooking(305, 103, 202, 2, '2024-10-28');
DELIMITER //
CREATE PROCEDURE UpdateBooking(
    IN bid INT,
    IN new_tickets INT
)
BEGIN
    DECLARE sid INT;
    DECLARE ticket_cost DECIMAL(8,2);
    DECLARE new_total DECIMAL(10,2);
    
    -- Get show ID for this booking
    SELECT show_id INTO sid FROM Bookings WHERE booking_id = bid;
    
    -- Get ticket price
    SELECT m.ticket_price INTO ticket_cost
    FROM Movies m
    JOIN Shows s ON m.movie_id = s.movie_id
    WHERE s.show_id = sid;
    
    SET new_total = ticket_cost * new_tickets;
    
    -- Update booking
    UPDATE Bookings
    SET tickets_booked = new_tickets,
        total_amount = new_total
    WHERE booking_id = bid;
END //
DELIMITER ;
CALL UpdateBooking(301, 4);
