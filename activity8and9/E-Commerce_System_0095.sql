CREATE DATABASE OnlineShopDB;
USE OnlineShopDB;
-- Table: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- Table: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

-- Table: Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insert into Customers
INSERT INTO Customers (customer_id, customer_name, email, phone, city)
VALUES
(1, 'Asha Rao', 'asha@gmail.com', '9876543210', 'Bangalore'),
(2, 'Rahul Kumar', 'rahul@gmail.com', '9876501234', 'Mumbai'),
(3, 'Sneha Patil', 'sneha@gmail.com', '9876012345', 'Pune'),
(4, 'Rohit Sharma', 'rohit@gmail.com', '9876123450', 'Delhi'),
(5, 'Neha Singh', 'neha@gmail.com', '9876234567', 'Chennai');

-- Insert into Products
INSERT INTO Products (product_id, product_name, category, price, stock)
VALUES
(101, 'Laptop', 'Electronics', 55000.00, 20),
(102, 'Smartphone', 'Electronics', 25000.00, 50),
(103, 'Headphones', 'Accessories', 2000.00, 100),
(104, 'Shoes', 'Fashion', 3000.00, 60),
(105, 'Backpack', 'Travel', 1500.00, 40);

-- Insert into Orders
INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity, total_amount)
VALUES
(1001, 1, 101, '2024-07-05', 1, 55000.00),
(1002, 2, 103, '2024-07-10', 2, 4000.00),
(1003, 3, 102, '2024-08-01', 1, 25000.00),
(1004, 4, 104, '2024-08-15', 3, 9000.00),
(1005, 5, 103, '2024-09-05', 5, 10000.00);

SELECT o.order_id,
       c.customer_name,
       p.product_name,
       p.category,
       o.order_date,
       o.quantity,
       o.total_amount
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Products p ON o.product_id = p.product_id;
/*'1001', 'Asha Rao', 'Laptop', 'Electronics', '2024-07-05', '1', '55000.00'
'1002', 'Rahul Kumar', 'Headphones', 'Accessories', '2024-07-10', '2', '4000.00'
'1003', 'Sneha Patil', 'Smartphone', 'Electronics', '2024-08-01', '1', '25000.00'
'1004', 'Rohit Sharma', 'Shoes', 'Fashion', '2024-08-15', '3', '9000.00'
'1005', 'Neha Singh', 'Headphones', 'Accessories', '2024-09-05', '5', '10000.00'*/

SELECT p.product_name,
       SUM(o.total_amount) AS Total_Sales
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY Total_Sales DESC;
/*'Laptop', '55000.00'
'Smartphone', '25000.00'
'Headphones', '14000.00'
'Shoes', '9000.00'*/

SELECT p.product_name,
       SUM(o.quantity) AS Total_Quantity_Sold
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;
/*'Headphones', '7'*/

SELECT MONTH(order_date) AS Order_Month,
       COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY MONTH(order_date)
ORDER BY Order_Month;
/*'7', '2'
'8', '2'
'9', '1'*/

DELIMITER //
CREATE PROCEDURE UpdateProductStock(
    IN p_id INT,
    IN qty_sold INT
)
BEGIN
    UPDATE Products
    SET stock = stock - qty_sold
    WHERE product_id = p_id AND stock >= qty_sold;
END //
DELIMITER ;
CALL UpdateProductStock(103, 2);

SELECT * FROM Products;
/*'101', 'Laptop', 'Electronics', '55000.00', '20'
'102', 'Smartphone', 'Electronics', '25000.00', '50'
'103', 'Headphones', 'Accessories', '2000.00', '98'
'104', 'Shoes', 'Fashion', '3000.00', '60'
'105', 'Backpack', 'Travel', '1500.00', '40'*/
