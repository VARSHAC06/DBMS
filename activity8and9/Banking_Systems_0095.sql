CREATE DATABASE BankDB;
USE BankDB;
-- Table: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    address VARCHAR(150),
    phone VARCHAR(15),
    email VARCHAR(100)
);

-- Table: Accounts
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(12,2),
    open_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table: Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),   -- Deposit / Withdrawal
    amount DECIMAL(10,2),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);
-- Insert Customers
INSERT INTO Customers (customer_id, customer_name, address, phone, email)
VALUES
(1, 'Amit Sharma', 'Delhi', '9876543210', 'amit@example.com'),
(2, 'Priya Nair', 'Mumbai', '9988776655', 'priya@example.com'),
(3, 'Ravi Kumar', 'Chennai', '9123456780', 'ravi@example.com');

-- Insert Accounts
INSERT INTO Accounts (account_id, customer_id, account_type, balance, open_date)
VALUES
(101, 1, 'Savings', 15000.00, '2022-05-10'),
(102, 2, 'Current', 50000.00, '2023-01-15'),
(103, 3, 'Savings', 25000.00, '2021-12-20');

-- Insert Transactions
INSERT INTO Transactions (transaction_id, account_id, transaction_date, transaction_type, amount)
VALUES
(1001, 101, '2024-06-10', 'Deposit', 5000.00),
(1002, 101, '2024-07-05', 'Withdrawal', 2000.00),
(1003, 102, '2024-08-15', 'Deposit', 10000.00),
(1004, 103, '2024-09-10', 'Deposit', 4000.00),
(1005, 103, '2024-09-20', 'Withdrawal', 1500.00),
(1006, 102, '2024-10-10', 'Withdrawal', 3000.00);

SELECT c.customer_id,
       c.customer_name,
       a.account_id,
       a.account_type,
       t.transaction_id,
       t.transaction_date,
       t.transaction_type,
       t.amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
ORDER BY c.customer_name, t.transaction_date;
/*'1', 'Amit Sharma', '101', 'Savings', '1001', '2024-06-10', 'Deposit', '5000.00'
'1', 'Amit Sharma', '101', 'Savings', '1002', '2024-07-05', 'Withdrawal', '2000.00'
'2', 'Priya Nair', '102', 'Current', '1003', '2024-08-15', 'Deposit', '10000.00'
'2', 'Priya Nair', '102', 'Current', '1006', '2024-10-10', 'Withdrawal', '3000.00'
'3', 'Ravi Kumar', '103', 'Savings', '1004', '2024-09-10', 'Deposit', '4000.00'
'3', 'Ravi Kumar', '103', 'Savings', '1005', '2024-09-20', 'Withdrawal', '1500.00'*/

SELECT a.account_id,
       c.customer_name,
       SUM(t.amount) AS Total_Transaction_Amount
FROM Accounts a
JOIN Customers c ON a.customer_id = c.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, c.customer_name;
/*'101', 'Amit Sharma', '7000.00'
'102', 'Priya Nair', '13000.00'
'103', 'Ravi Kumar', '5500.00'*/

SELECT 
    MAX(amount) AS Highest_Transaction,
    MIN(amount) AS Lowest_Transaction
FROM Transactions;
/*'10000.00', '1500.00'*/

SELECT *
FROM Transactions
WHERE MONTH(transaction_date) = MONTH(CURDATE())
  AND YEAR(transaction_date) = YEAR(CURDATE());

DELIMITER //
CREATE PROCEDURE InsertTransaction(
    IN tid INT,
    IN accid INT,
    IN tdate DATE,
    IN ttype VARCHAR(20),
    IN amt DECIMAL(10,2)
)
BEGIN
    INSERT INTO Transactions (transaction_id, account_id, transaction_date, transaction_type, amount)
    VALUES (tid, accid, tdate, ttype, amt);

    -- Update account balance
    IF ttype = 'Deposit' THEN
        UPDATE Accounts SET balance = balance + amt WHERE account_id = accid;
    ELSEIF ttype = 'Withdrawal' THEN
        UPDATE Accounts SET balance = balance - amt WHERE account_id = accid;
    END IF;
END //
DELIMITER ;
CALL InsertTransaction(1007, 101, '2024-10-25', 'Deposit', 3000.00);
DELIMITER //
CREATE PROCEDURE UpdateTransaction(
    IN tid INT,
    IN new_type VARCHAR(20),
    IN new_amount DECIMAL(10,2)
)
BEGIN
    UPDATE Transactions
    SET transaction_type = new_type,
        amount = new_amount
    WHERE transaction_id = tid;
END //
DELIMITER ;
CALL UpdateTransaction(1002, 'Withdrawal', 2500.00);
SELECT * FROM Customers;
/*'1', 'Amit Sharma', 'Delhi', '9876543210', 'amit@example.com'
'2', 'Priya Nair', 'Mumbai', '9988776655', 'priya@example.com'
'3', 'Ravi Kumar', 'Chennai', '9123456780', 'ravi@example.com'*/

SELECT * FROM Accounts;
/*'101', '1', 'Savings', '18000.00', '2022-05-10'
'102', '2', 'Current', '50000.00', '2023-01-15'
'103', '3', 'Savings', '25000.00', '2021-12-20'*/

SELECT * FROM Transactions;
/*'1001', '101', '2024-06-10', 'Deposit', '5000.00'
'1002', '101', '2024-07-05', 'Withdrawal', '2500.00'
'1003', '102', '2024-08-15', 'Deposit', '10000.00'
'1004', '103', '2024-09-10', 'Deposit', '4000.00'
'1005', '103', '2024-09-20', 'Withdrawal', '1500.00'
'1006', '102', '2024-10-10', 'Withdrawal', '3000.00'
'1007', '101', '2024-10-25', 'Deposit', '3000.00'*/
