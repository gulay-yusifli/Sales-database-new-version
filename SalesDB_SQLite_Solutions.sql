-- =====================================================================
-- SQL & Relational Database Design - Student Assignment 
-- DBMS: SQLite 3
-- Sections: Setup | B01-B10 | Scenarios 1-6
-- Note: modification tasks run inside BEGIN ... ROLLBACK, so the clean
--       reference data is never changed.
-- =====================================================================

PRAGMA foreign_keys = ON;

-- =====================================================================
-- PART 0. DATABASE SETUP (tables)
-- =====================================================================
DROP VIEW  IF EXISTS QualifyingSales;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Country    VARCHAR(50),
    Score      INTEGER
);

CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    Product   VARCHAR(100),
    Category  VARCHAR(50),
    Price     DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Department VARCHAR(50),
    BirthDate  DATE,
    Gender     VARCHAR(10),
    Salary     DECIMAL(10,2),
    ManagerID  INTEGER NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID       INTEGER PRIMARY KEY,
    ProductID     INTEGER,
    CustomerID    INTEGER,
    SalesPersonID INTEGER,
    OrderDate     DATE,
    ShipDate      DATE NULL,
    OrderStatus   VARCHAR(30),
    ShipAddress   VARCHAR(150) NULL,
    BillAddress   VARCHAR(150) NULL,
    Quantity      INTEGER,
    Sales         DECIMAL(10,2),
    CreationTime  DATETIME,
    FOREIGN KEY (ProductID)     REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID)    REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);

-- =====================================================================
-- PART 0. REFERENCE DATA (inserts)
-- =====================================================================
INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score) VALUES
(1, 'Ayla',  'Karimova', 'Azerbaijan', 720),
(2, 'John',  'Miller',   'USA',        450),
(3, 'Emma',  'Schmidt',  'Germany',    860),
(4, 'Sara',  'Martin',   'France',     280),
(5, 'Lukas', 'Weber',    'Germany',    550),
(6, 'Noah',  'Adams',    'USA',        610),
(7, 'Lea',   'Fischer',  'Germany',    680),
(8, 'Sofia', 'Rossi',    'Italy',      700),
(9, 'Ali',   'Hasanov',  'Azerbaijan', 330);

INSERT INTO Products (ProductID, Product, Category, Price) VALUES
(101, 'Wireless Mouse', 'Electronics', 55.00),
(102, 'Office Chair',   'Furniture',   230.00),
(103, 'Laptop',         'Electronics', 850.00),
(104, 'Notebook',       'Stationery',  12.00),
(105, 'Smart Phone',    'Electronics', 420.00),
(106, 'Standing Desk',  'Furniture',   380.00),
(107, 'USB Hub',        'Electronics', 45.00),
(108, 'Desk Lamp',      'Furniture',   65.00);

-- Manager (12) is inserted first because of the self-referencing FK
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(12, 'Maya',  'Brown', 'Sales',   '1990-07-09', 'Female', 2400.00, NULL),
(11, 'David', 'Lee',   'Sales',   '1987-05-14', 'Male',   2200.00, 12),
(13, 'Alex',  'Green', 'Support', '1994-11-21', 'Male',   1900.00, 12),
(14, 'Omar',  'Ali',   'Sales',   '1995-02-17', 'Male',   2100.00, 12),
(15, 'Nina',  'Stone', 'Sales',   '1998-08-03', 'Female', 2000.00, 12);

-- Orders: core + shipping details combined (CreationTime = OrderDate + 10:00:00)
INSERT INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered', '10 Nizami St, Baku',     '10 Nizami St, Baku',     2,  110.00, '2026-10-04 10:00:00'),
(202, 103, 3, 12, '2026-10-08', '2026-10-18', 'Shipped',   '22 Oak St, Berlin',      '22 Oak St, Berlin',      1,  850.00, '2026-10-08 10:00:00'),
(203, 102, 2, 11, '2026-10-12', NULL,         'Pending',   NULL,                     '45 Main St, New York',   1,  230.00, '2026-10-12 10:00:00'),
(204, 105, 5, 12, '2026-10-15', '2026-10-19', 'Delivered', '16 Park Rd, Munich',     '16 Park Rd, Munich',     1,  420.00, '2026-10-15 10:00:00'),
(205, 103, 3, 12, '2026-10-20', '2026-10-22', 'Delivered', '22 Oak St, Berlin',      '22 Oak St, Berlin',      8, 6800.00, '2026-10-20 10:00:00'),
(206, 105, 2, 11, '2026-10-21', '2026-10-23', 'Delivered', '45 Main St, New York',   '9 Pine St, Boston',      3, 1260.00, '2026-10-21 10:00:00'),
(207, 102, 6, 14, '2026-10-22', '2026-10-24', 'Delivered', '31 Oak St, Boston',      '31 Oak St, Boston',      4,  920.00, '2026-10-22 10:00:00'),
(208, 101, 4, 11, '2026-10-23', NULL,         'Pending',   NULL,                     '8 Rue Lyon, Paris',      2,  110.00, '2026-10-23 10:00:00'),
(209, 106, 1, 14, '2026-10-24', '2026-10-27', 'Delivered', '10 Nizami St, Baku',     '10 Nizami St, Baku',     2,  760.00, '2026-10-24 10:00:00'),
(210, 103, 6, 14, '2026-10-25', NULL,         'Cancelled', '31 Oak St, Boston',      '31 Oak St, Boston',      2, 1700.00, '2026-10-25 10:00:00'),
(211, 104, 5, 11, '2026-10-26', '2026-10-28', 'Delivered', '16 Park Rd, Munich',     '16 Park Rd, Munich',    10,  120.00, '2026-10-26 10:00:00'),
(212, 105, 3, 12, '2026-10-27', NULL,         'Pending',   NULL,                     '22 Oak St, Berlin',      2,  840.00, '2026-10-27 10:00:00'),
(213, 107, 2, 11, '2026-10-28', '2026-10-30', 'Shipped',   '45 Main St, New York',   '45 Main St, New York',   3,  135.00, '2026-10-28 10:00:00'),
(214, 103, 8, 14, '2026-10-29', '2026-11-01', 'Delivered', '18 Via Roma, Milan',     '18 Via Roma, Milan',     1,  850.00, '2026-10-29 10:00:00'),
(215, 106, 5, 12, '2026-10-30', NULL,         'Pending',   '16 Park Rd, Munich',     '16 Park Rd, Munich',     1,  380.00, '2026-10-30 10:00:00'),
(216, 101, 1, 11, '2026-11-02', '2026-11-04', 'Delivered', '10 Nizami St, Baku',     '10 Nizami St, Baku',     1,   55.00, '2026-11-02 10:00:00'),
(217, 102, 7, 14, '2026-11-03', '2026-11-05', 'Shipped',   '9 River St, Berlin',     '9 River St, Berlin',     1,  230.00, '2026-11-03 10:00:00'),
(218, 105, 6, 14, '2026-11-04', NULL,         'Pending',   '31 Oak St, Boston',      NULL,                     1,  420.00, '2026-11-04 10:00:00'),
(219, 103, 3, 12, '2026-11-05', '2026-11-06', 'Shipped',   '22 Oak St, Berlin',      '22 Oak St, Berlin',      1,  850.00, '2026-11-05 10:00:00'),
(220, 104, 2, 11, '2026-11-06', '2026-11-07', 'Delivered', '45 Main St, New York',   '45 Main St, New York',   5,   60.00, '2026-11-06 10:00:00'),
(221, 107, 6, 14, '2026-10-28', NULL,         'Shipped',   '31 Oak St, Boston',      '31 Oak St, Boston',      1,   45.00, '2026-10-28 10:00:00'),
(222, 102, 4, 11, '2026-10-31', '2026-10-30', 'Shipped',   '8 Rue Lyon, Paris',      '8 Rue Lyon, Paris',      1,  230.00, '2026-10-31 10:00:00'),
(223, 102, 2, 11, '2026-10-29', '2026-10-31', 'Delivered', '45 Main St, New York',   '45 Main St, New York',   1,  230.00, '2026-10-29 10:00:00'),
(224, 101, 3, 12, '2026-11-02', NULL,         'Pending',   '22 Oak St, Berlin',      '22 Oak St, Berlin',      2,  110.00, '2026-11-02 10:00:00');

-- Qualifying sale (Scenarios 4 and 6): Shipped/Delivered, ShipDate not NULL, ShipDate >= OrderDate
CREATE VIEW QualifyingSales AS
SELECT *
FROM Orders
WHERE OrderStatus IN ('Shipped', 'Delivered')
  AND ShipDate IS NOT NULL
  AND ShipDate >= OrderDate;

-- Sanity check: expected 9 / 8 / 5 / 24
SELECT (SELECT COUNT(*) FROM Customers) AS Customers,
       (SELECT COUNT(*) FROM Products)  AS Products,
       (SELECT COUNT(*) FROM Employees) AS Employees,
       (SELECT COUNT(*) FROM Orders)    AS Orders;


-- =====================================================================
-- PART I. BASIC SQL (B01-B10)
-- =====================================================================

-- B01. Explore a table
SELECT * FROM Customers;
SELECT FirstName, LastName, Country FROM Customers;

-- B02. Customers from Germany
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';

-- B03. Score >= 300 and Germany or France
SELECT CustomerID, FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300 AND Country IN ('Germany', 'France');

-- B04. Products sorted by price, most expensive first
SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;

-- B05. Price between 50 and 300 (inclusive)
SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;

-- B06. Product name contains "Phone"
SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';

-- B07. Distinct categories, alphabetical
SELECT DISTINCT Category
FROM Products
ORDER BY Category;

-- B08. Orders with customer names
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID;

-- B09. Order count and total Sales per status
SELECT OrderStatus,
       COUNT(*)   AS OrderCount,
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;

-- B10. Safe data change (practice copy = transaction that is rolled back)
BEGIN;
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (900, 'Practice Item', 'Electronics', 10.00);

UPDATE Products SET Price = 15.00 WHERE ProductID = 900;
SELECT * FROM Products WHERE ProductID = 900;            -- verify the change

DELETE FROM Products WHERE ProductID = 900;
SELECT COUNT(*) AS ProductsLeft FROM Products;           -- back to 8
ROLLBACK;
-- Explanation: without WHERE, UPDATE/DELETE would affect EVERY row of the table.
-- WHERE restricts the change to the intended row(s) only (here ProductID = 900).


-- =====================================================================
-- SCENARIO 1. CUSTOMER LOYALTY AND SALES ANALYSIS
-- =====================================================================

-- 1.1 High-score customers
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;

-- 1.2 Target countries with Score >= 300
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA') AND Score >= 300;

-- 1.3 Purchase history
SELECT c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderID, o.OrderDate, o.Sales
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate, o.OrderID;

-- 1.4 Customers who never ordered (LEFT JOIN + IS NULL)
SELECT c.CustomerID, c.FirstName, c.LastName, c.Country
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;

-- 1.5 Total spending per customer (grouped by ID)
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSales DESC, c.CustomerID;

-- 1.6 Loyalty threshold: total Sales > 1000
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > 1000
ORDER BY TotalSales DESC, c.CustomerID;

-- 1.7 Top-five customers (SQLite uses LIMIT)
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC, c.CustomerID
LIMIT 5;
-- Explanation: a customer with NO orders has no row in Orders at all (found with LEFT JOIN ... IS NULL).
-- A customer whose orders merely fail a campaign filter (e.g. total <= 1000) still has orders
-- and is simply excluded by HAVING/WHERE - they are not "inactive".


-- =====================================================================
-- SCENARIO 2. ORDER AND DELIVERY INVESTIGATION
-- =====================================================================

-- 2.1 October orders
SELECT OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY OrderDate, OrderID;

-- 2.2 Pending queue, oldest first
SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate, OrderID;

-- 2.3 Late shipments (> 7 days)
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, o.ShipDate
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE julianday(o.ShipDate) - julianday(o.OrderDate) > 7;

-- 2.4 Customers affected by delayed orders
SELECT DISTINCT c.CustomerID, c.FirstName || ' ' || c.LastName AS CustomerName, c.Country
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE julianday(o.ShipDate) - julianday(o.OrderDate) > 7;

-- 2.5 - 2.7 Modifications in a practice copy (transaction, rolled back at the end)
BEGIN;

-- 2.5 Ensure OrderID 105 exists, then set status and ship date
INSERT OR IGNORE INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (105, 101, 1, 11, '2026-11-01', NULL, 'Pending', 'Test Address', 'Test Address', 1, 55.00, '2026-11-01 10:00:00');
SELECT * FROM Orders WHERE OrderID = 105;                -- preview
UPDATE Orders SET OrderStatus = 'Shipped', ShipDate = '2026-11-05' WHERE OrderID = 105;
SELECT * FROM Orders WHERE OrderID = 105;                -- verify

-- 2.6 Ensure OrderID 110 exists, then set ShipAddress
INSERT OR IGNORE INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (110, 101, 1, 11, '2026-11-01', NULL, 'Pending', NULL, 'Test Address', 1, 55.00, '2026-11-01 10:00:00');
SELECT * FROM Orders WHERE OrderID = 110;
UPDATE Orders SET ShipAddress = '45 Main Street, Baku' WHERE OrderID = 110;
SELECT * FROM Orders WHERE OrderID = 110;

-- 2.7 Temporary test record 999 - delete only this row
INSERT OR IGNORE INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (999, 101, 1, 11, '2026-11-01', NULL, 'Pending', 'Temp', 'Temp', 1, 55.00, '2026-11-01 10:00:00');
SELECT * FROM Orders WHERE OrderID = 999;
DELETE FROM Orders WHERE OrderID = 999;
SELECT COUNT(*) AS Remaining999 FROM Orders WHERE OrderID = 999;   -- 0

ROLLBACK;   -- restores the clean reference dataset (24 orders)

-- 2.8 Status distribution
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- 2.9 Unshipped records (ShipDate IS NULL) - keep the status
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, o.OrderStatus
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.ShipDate IS NULL
ORDER BY o.OrderDate, o.OrderID;


-- =====================================================================
-- SCENARIO 3. PRODUCTS AND EMPLOYEE PERFORMANCE
-- =====================================================================

-- 3.1 Affordable products
SELECT Product, Category, Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;

-- 3.2 Premium electronics
SELECT *
FROM Products
WHERE Category = 'Electronics' AND Price > 500;

-- 3.3 Product sales
SELECT p.Product, p.Category, o.Quantity, o.Sales
FROM Products p
INNER JOIN Orders o ON o.ProductID = p.ProductID;

-- 3.4 Best-selling products (top five by total Quantity)
SELECT p.ProductID, p.Product, SUM(o.Quantity) AS TotalQuantity
FROM Products p
INNER JOIN Orders o ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.Product
ORDER BY TotalQuantity DESC, p.ProductID
LIMIT 5;

-- 3.5 Unsold products
SELECT p.ProductID, p.Product, p.Category, p.Price
FROM Products p
LEFT JOIN Orders o ON o.ProductID = p.ProductID
WHERE o.OrderID IS NULL;

-- 3.6 Employee performance
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees e
INNER JOIN Orders o ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department;

-- 3.7 Top-performing staff (> 5000)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees e
INNER JOIN Orders o ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
HAVING SUM(o.Sales) > 5000
ORDER BY TotalSales DESC;

-- 3.8 - 3.10 Modifications (practice copy; rolled back)
BEGIN;

-- 3.8 New product
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75);

-- 3.9 Price correction
UPDATE Products SET Price = 90 WHERE ProductID = 501;
SELECT * FROM Products WHERE ProductID = 501;

-- 3.10 Add inventory column
ALTER TABLE Products ADD COLUMN StockQuantity INTEGER;
SELECT * FROM Products WHERE ProductID = 501;

ROLLBACK;

-- 3.11 Combined directory (UNION removes duplicate name combinations)
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;

-- 3.12 Category performance (Sales > 2000)
SELECT p.Category,
       SUM(o.Quantity) AS TotalQuantity,
       SUM(o.Sales)    AS TotalSales
FROM Products p
INNER JOIN Orders o ON o.ProductID = p.ProductID
GROUP BY p.Category
HAVING SUM(o.Sales) > 2000
ORDER BY TotalSales DESC;


-- =====================================================================
-- SCENARIO 4. TARGETED CAMPAIGN PLANNING
-- (qualifying October sales, target countries: Germany, France, USA)
-- =====================================================================

-- 4.1 Campaign sales register
SELECT o.OrderID, o.OrderDate, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, p.Category,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Quantity, o.Sales
FROM QualifyingSales o
INNER JOIN Customers c ON c.CustomerID  = o.CustomerID
INNER JOIN Products  p ON p.ProductID   = o.ProductID
INNER JOIN Employees e ON e.EmployeeID  = o.SalesPersonID
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY c.Country, o.OrderDate, o.OrderID;

-- 4.2 Priority electronics orders
SELECT o.OrderID, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, c.Score, p.Product, o.Sales
FROM QualifyingSales o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND p.Category = 'Electronics'
  AND (c.Score >= 500 OR o.Sales >= 1000)
ORDER BY o.OrderID;

-- 4.3 Affordable products to promote (catalogue search, no order filter)
SELECT ProductID, Product, Category, Price
FROM Products
WHERE Category = 'Electronics'
  AND Price BETWEEN 40 AND 100
  AND (Product LIKE '%Wireless%' OR Product LIKE '%USB%')
ORDER BY Price, ProductID;

-- 4.4 Unique recipient list
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName, c.Country, c.Score
FROM QualifyingSales o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND c.Score >= 500
  AND p.Category = 'Electronics'
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY c.CustomerID;

-- 4.5 High-value accounts (>= 2 orders AND total >= 1000)
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       COUNT(o.OrderID) AS OrderCount,
       SUM(o.Quantity)  AS TotalQuantity,
       SUM(o.Sales)     AS TotalSales
FROM QualifyingSales o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 2 AND SUM(o.Sales) >= 1000
ORDER BY TotalSales DESC, c.CustomerID;

-- 4.6 Country-category demand (total Sales > 500)
SELECT c.Country, p.Category,
       COUNT(o.OrderID) AS OrderCount,
       SUM(o.Quantity)  AS TotalQuantity,
       SUM(o.Sales)     AS TotalSales
FROM QualifyingSales o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY c.Country, p.Category
HAVING SUM(o.Sales) > 500
ORDER BY c.Country, TotalSales DESC;

-- 4.7 Customers without eligible activity (LEFT JOIN; period/status conditions inside ON)
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, c.Score
FROM Customers c
LEFT JOIN QualifyingSales o
       ON o.CustomerID = c.CustomerID
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE c.Country IN ('Germany', 'France', 'USA')
  AND o.OrderID IS NULL
ORDER BY c.CustomerID;

-- 4.8 Cross-category buyers (INTERSECT)
WITH elec AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Electronics'
),
furn AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Furniture'
)
SELECT CustomerID FROM elec
INTERSECT
SELECT CustomerID FROM furn
ORDER BY CustomerID;

-- 4.9 Combined audiences (UNION)
WITH elec AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Electronics'
),
furn AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Furniture'
)
SELECT CustomerID FROM elec
UNION
SELECT CustomerID FROM furn
ORDER BY CustomerID;

-- 4.10 Furniture cross-sell list (EXCEPT)
WITH elec AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Electronics'
),
furn AS (
    SELECT DISTINCT o.CustomerID
    FROM QualifyingSales o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products  p ON p.ProductID  = o.ProductID
    WHERE c.Country IN ('Germany', 'France', 'USA')
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
      AND p.Category = 'Furniture'
)
SELECT CustomerID FROM elec
EXCEPT
SELECT CustomerID FROM furn
ORDER BY CustomerID;


-- =====================================================================
-- SCENARIO 5. FULFILMENT EXCEPTION DESK
-- Snapshot date: 2026-11-07 (raw operational data, no qualifying-sale filter)
-- =====================================================================

-- 5.1 Pending work queue
SELECT o.OrderID, o.OrderDate,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Quantity, o.Sales,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.ShipAddress
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
INNER JOIN Employees e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.OrderDate <= '2026-11-07'
ORDER BY o.OrderDate, o.OrderID;

-- 5.2 Overdue pending shipments (older than 7 days: OrderDate < 2026-10-31)
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, p.Product,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Sales
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
INNER JOIN Employees e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
  AND o.OrderDate < '2026-10-31'
ORDER BY o.OrderDate, o.OrderID;

-- 5.3 Missing delivery addresses (NULL or empty string)
SELECT o.OrderID, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.ShipAddress
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Employees e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.OrderDate <= '2026-11-07'
  AND (o.ShipAddress IS NULL OR TRIM(o.ShipAddress) = '')
ORDER BY o.OrderID;

-- 5.4 Different billing address (non-cancelled, both present)
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.ShipAddress, o.BillAddress, o.OrderStatus
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus <> 'Cancelled'
  AND o.OrderDate <= '2026-11-07'
  AND o.ShipAddress IS NOT NULL AND TRIM(o.ShipAddress) <> ''
  AND o.BillAddress IS NOT NULL AND TRIM(o.BillAddress) <> ''
  AND o.ShipAddress <> o.BillAddress
ORDER BY o.OrderID;

-- 5.5 Inconsistent shipment records
SELECT o.OrderID, o.OrderStatus, o.OrderDate, o.ShipDate,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Employees e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderDate <= '2026-11-07'
  AND ( o.ShipDate < o.OrderDate
        OR (o.OrderStatus IN ('Shipped', 'Delivered') AND o.ShipDate IS NULL) )
ORDER BY o.OrderID;

-- 5.6 Late dispatch (> 7 days, non-cancelled, valid ShipDate)
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       p.Product, o.OrderDate, o.ShipDate,
       CAST(julianday(o.ShipDate) - julianday(o.OrderDate) AS INTEGER) AS DaysToShip
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus <> 'Cancelled'
  AND o.OrderDate <= '2026-11-07'
  AND o.ShipDate IS NOT NULL
  AND o.ShipDate >= o.OrderDate
  AND julianday(o.ShipDate) - julianday(o.OrderDate) > 7
ORDER BY DaysToShip DESC, o.OrderID;

-- 5.7 Pending workload per Sales employee (zeros kept)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(o.OrderID)         AS PendingOrderCount,
       COALESCE(SUM(o.Sales), 0) AS PendingSales
FROM Employees e
LEFT JOIN Orders o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus = 'Pending'
      AND o.ShipDate IS NULL
      AND o.OrderDate <= '2026-11-07'
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;

-- 5.8 Customers needing one combined follow-up (>= 2 pending orders)
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       COUNT(o.OrderID) AS PendingOrderCount,
       SUM(o.Sales)     AS PendingSales
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
  AND o.OrderDate <= '2026-11-07'
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 2
ORDER BY c.CustomerID;

-- 5.9 Priority support list
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Sales, o.OrderStatus, o.OrderDate, o.ShipDate
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus <> 'Cancelled'
  AND o.OrderDate <= '2026-11-07'
  AND c.Country IN ('Germany', 'USA')
  AND o.Sales >= 500
  AND ( (o.OrderStatus = 'Pending' AND o.ShipDate IS NULL)
        OR (o.ShipDate IS NOT NULL
            AND o.ShipDate >= o.OrderDate
            AND julianday(o.ShipDate) - julianday(o.OrderDate) > 7) )
ORDER BY o.OrderID;

-- 5.10 Ready-to-dispatch checklist
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Quantity, o.ShipAddress,
       e.FirstName || ' ' || e.LastName AS EmployeeName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
INNER JOIN Products  p ON p.ProductID  = o.ProductID
INNER JOIN Employees e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
  AND o.OrderDate <= '2026-11-07'
  AND o.ShipAddress IS NOT NULL AND TRIM(o.ShipAddress) <> ''
ORDER BY c.Country, o.OrderDate, o.OrderID;


-- =====================================================================
-- SCENARIO 6. SALES TEAM REVIEW AND RETENTION
-- October: 2026-10-01..2026-10-31 | November snapshot: 2026-11-01..2026-11-07
-- =====================================================================

-- 6.1 Reporting lines (self join, keep employees without a manager)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department, e.ManagerID,
       m.FirstName || ' ' || m.LastName AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON m.EmployeeID = e.ManagerID
ORDER BY e.EmployeeID;

-- 6.2 Fair October scorecard (all Sales employees)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(q.OrderID)           AS OrderCount,
       COALESCE(SUM(q.Quantity), 0) AS TotalQuantity,
       COALESCE(SUM(q.Sales), 0)    AS TotalSales
FROM Employees e
LEFT JOIN QualifyingSales q
       ON q.SalesPersonID = e.EmployeeID
      AND q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSales DESC, e.EmployeeID;

-- 6.3 Direct-report team summary (manager's own sales excluded)
SELECT m.EmployeeID AS ManagerID,
       m.FirstName || ' ' || m.LastName AS ManagerName,
       COUNT(DISTINCT s.EmployeeID)     AS DirectSalesStaffCount,
       COUNT(q.OrderID)                 AS TeamOrderCount,
       COALESCE(SUM(q.Sales), 0)        AS TeamSales
FROM Employees m
INNER JOIN Employees s
        ON s.ManagerID = m.EmployeeID
       AND s.Department = 'Sales'
LEFT JOIN QualifyingSales q
       ON q.SalesPersonID = s.EmployeeID
      AND q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY m.EmployeeID, m.FirstName, m.LastName
ORDER BY m.EmployeeID;

-- 6.4 Staff meeting the monthly target
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(q.OrderID) AS OrderCount,
       SUM(q.Sales)     AS TotalSales
FROM Employees e
INNER JOIN QualifyingSales q ON q.SalesPersonID = e.EmployeeID
WHERE e.Department = 'Sales'
  AND q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(q.OrderID) >= 2 AND SUM(q.Sales) >= 1000
ORDER BY TotalSales DESC, e.EmployeeID;

-- 6.5 Customer and country coverage (zeros kept)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(DISTINCT c.CustomerID) AS DistinctCustomers,
       COUNT(DISTINCT c.Country)    AS DistinctCountries
FROM Employees e
LEFT JOIN QualifyingSales q
       ON q.SalesPersonID = e.EmployeeID
      AND q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
LEFT JOIN Customers c ON c.CustomerID = q.CustomerID
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;

-- 6.6 Sales staff without qualifying October sales
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department
FROM Employees e
LEFT JOIN QualifyingSales q
       ON q.SalesPersonID = e.EmployeeID
      AND q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE e.Department = 'Sales'
  AND q.OrderID IS NULL
ORDER BY e.EmployeeID;

-- 6.7 Returning customers (October AND November snapshot)
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
INTERSECT
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY CustomerID;

-- 6.8 Not yet returning: no return by 2026-11-07 (not permanent inactivity)
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
EXCEPT
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY CustomerID;

-- 6.9 New to the comparison period (not necessarily first-time buyers overall)
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
EXCEPT
SELECT CustomerID FROM QualifyingSales
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY CustomerID;

-- 6.10 Two-period sales register (UNION ALL)
SELECT 'October 2026' AS PeriodLabel, q.OrderID, q.OrderDate, q.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       q.Sales
FROM QualifyingSales q
JOIN Customers c ON c.CustomerID = q.CustomerID
JOIN Employees e ON e.EmployeeID = q.SalesPersonID
WHERE q.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
UNION ALL
SELECT 'November 01-07', q.OrderID, q.OrderDate, q.CustomerID,
       c.FirstName || ' ' || c.LastName,
       e.FirstName || ' ' || e.LastName,
       q.Sales
FROM QualifyingSales q
JOIN Customers c ON c.CustomerID = q.CustomerID
JOIN Employees e ON e.EmployeeID = q.SalesPersonID
WHERE q.OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY OrderDate, OrderID;
