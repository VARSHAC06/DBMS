CREATE DATABASE InventoryDB;
USE InventoryDB;
-- Table: Suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- Table: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

-- Table: SupplyOrders
CREATE TABLE SupplyOrders (
    order_id INT PRIMARY KEY,
    supplier_id INT,
    product_id INT,
    order_date DATE,
    quantity_supplied INT,
    total_cost DECIMAL(12,2),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insert Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_person, phone, city)
VALUES
(1, 'FreshMart Pvt Ltd', 'Ravi Kumar', '9876543210', 'Delhi'),
(2, 'Global Supplies', 'Priya Sharma', '9988776655', 'Mumbai'),
(3, 'EcoTrade Ltd', 'Amit Verma', '9123456789', 'Bangalore');

-- Insert Products
INSERT INTO Products (product_id, product_name, category, unit_price, stock_quantity)
VALUES
(101, 'Rice Bag 25kg', 'Grocery', 1200.00, 80),
(102, 'Cooking Oil 5L', 'Grocery', 700.00, 50),
(103, 'LED Bulb 10W', 'Electronics', 150.00, 200),
(104, 'Notebook A4', 'Stationery', 50.00, 300);

-- Insert Supply Orders
INSERT INTO SupplyOrders (order_id, supplier_id, product_id, order_date, quantity_supplied, total_cost)
VALUES
(1, 1, 101, '2024-10-20', 40, 48000.00),
(2, 2, 103, '2024-10-21', 100, 15000.00),
(3, 1, 102, '2024-10-22', 30, 21000.00),
(4, 3, 104, '2024-10-23', 150, 7500.00),
(5, 2, 101, '2024-10-24', 20, 24000.00);

SELECT 
    so.order_id,
    s.supplier_name,
    p.product_name,
    p.category,
    so.quantity_supplied,
    so.total_cost,
    so.order_date
FROM SupplyOrders so
INNER JOIN Suppliers s ON so.supplier_id = s.supplier_id
INNER JOIN Products p ON so.product_id = p.product_id
ORDER BY s.supplier_name;
/*'4', 'EcoTrade Ltd', 'Notebook A4', 'Stationery', '150', '7500.00', '2024-10-23'
'1', 'FreshMart Pvt Ltd', 'Rice Bag 25kg', 'Grocery', '40', '48000.00', '2024-10-20'
'3', 'FreshMart Pvt Ltd', 'Cooking Oil 5L', 'Grocery', '30', '21000.00', '2024-10-22'
'2', 'Global Supplies', 'LED Bulb 10W', 'Electronics', '100', '15000.00', '2024-10-21'
'5', 'Global Supplies', 'Rice Bag 25kg', 'Grocery', '20', '24000.00', '2024-10-24'*/

SELECT 
    s.supplier_name,
    SUM(so.quantity_supplied) AS Total_Quantity_Supplied,
    SUM(so.total_cost) AS Total_Cost
FROM Suppliers s
JOIN SupplyOrders so ON s.supplier_id = so.supplier_id
GROUP BY s.supplier_name
ORDER BY Total_Quantity_Supplied DESC;
/*'EcoTrade Ltd', '150', '7500.00'
'Global Supplies', '120', '39000.00'
'FreshMart Pvt Ltd', '70', '69000.00'*/

SELECT 
    so.order_id,
    s.supplier_name,
    YEAR(so.order_date) AS Supply_Year,
    MONTH(so.order_date) AS Supply_Month,
    so.total_cost
FROM SupplyOrders so
JOIN Suppliers s ON so.supplier_id = s.supplier_id;
/*'1', 'FreshMart Pvt Ltd', '2024', '10', '48000.00'
'3', 'FreshMart Pvt Ltd', '2024', '10', '21000.00'
'2', 'Global Supplies', '2024', '10', '15000.00'
'5', 'Global Supplies', '2024', '10', '24000.00'
'4', 'EcoTrade Ltd', '2024', '10', '7500.00'*/

SELECT AVG(total_cost) AS Average_Order_Value FROM SupplyOrders;
/*'23100.000000'*/

DELIMITER //
CREATE PROCEDURE InsertSupplyOrder(
    IN oid INT,
    IN sid INT,
    IN pid INT,
    IN odate DATE,
    IN qty INT,
    IN cost DECIMAL(12,2)
)
BEGIN
    INSERT INTO SupplyOrders (order_id, supplier_id, product_id, order_date, quantity_supplied, total_cost)
    VALUES (oid, sid, pid, odate, qty, cost);
    
    -- Update product stock
    UPDATE Products
    SET stock_quantity = stock_quantity + qty
    WHERE product_id = pid;
END //
DELIMITER ;
CALL InsertSupplyOrder(6, 3, 102, '2024-10-25', 20, 14000.00);
DELIMITER //
CREATE PROCEDURE UpdateSupplyOrder(
    IN oid INT,
    IN new_qty INT,
    IN new_cost DECIMAL(12,2)
)
BEGIN
    UPDATE SupplyOrders
    SET quantity_supplied = new_qty,
        total_cost = new_cost
    WHERE order_id = oid;
END //
DELIMITER ;
CALL UpdateSupplyOrder(2, 120, 18000.00);
