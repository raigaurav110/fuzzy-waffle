show databases;
create database Warehouse_Management_System;
use Warehouse_Management_System;

create table Products (
    ProductID VARCHAR(15) PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(30),
    Price DECIMAL(10,2),
    Perishable BOOLEAN
);
 
create table Warehouse (
    WarehouseID VARCHAR(10) PRIMARY KEY,
    Location VARCHAR(50),
    Capacity INT,
    CurrentUtilization INT
);


ALTER TABLE warehouse ADD COLUMN LeadTimeDays INT;

CREATE TABLE Inventory (
    InventoryID VARCHAR(10) PRIMARY KEY,
    WarehouseID VARCHAR(10),
    ProductID VARCHAR(15),
    Quantity INT,
    ReorderLevel INT,
    SafetyStock INT,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    CustomerID VARCHAR(10),
    ProductID VARCHAR(15),
    Quantity INT,
    OrderDate date,
    DeliveryZone varchar(5),
    Status varchar(15)
);

CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    Contact VARCHAR(15),
    Address varchar(100),
    DeliveryZone varchar(5)
);


CREATE TABLE Supplier (
    SupplierID VARCHAR(10) PRIMARY KEY,
    SupplierName VARCHAR(50),
    Contact VARCHAR(15),
    LeadTimeDays int
);

CREATE TABLE Replenishments (
    ReplenishmentID VARCHAR(20) PRIMARY KEY, 
    ProductID VARCHAR(15),                   
    WarehouseID VARCHAR(10),                 
    Quantity INT,                            
    ReplenishmentDate DATE,                  
    SupplierID VARCHAR(10),                  
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)   
);

show tables;

SELECT ProductID, Quantity, ReorderLevel
FROM Inventory
WHERE Quantity <= ReorderLevel;

SELECT WarehouseID, (CurrentUtilization * 100.0 / Capacity) AS UtilizationPercentage
FROM Warehouse;

SELECT Status, COUNT(*) AS OrderCount
FROM Orders
GROUP BY Status;

SELECT 
    i.InventoryID,
    p.ProductName,
    w.Location AS WarehouseLocation,
    i.Quantity AS CurrentStock,
    i.ReorderLevel,
    i.SafetyStock,
    (i.ReorderLevel + i.SafetyStock - i.Quantity) AS ReplenishmentQuantity
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
JOIN Warehouse w ON i.WarehouseID = w.WarehouseID
WHERE i.Quantity <= i.ReorderLevel + i.SafetyStock;

SELECT 
    p.ProductName,
    w.Location AS WarehouseLocation,
    i.Quantity AS CurrentStock,
    i.SafetyStock,
    (CURRENT_DATE + INTERVAL w.LeadTimeDays DAY) AS ExpectedRestockingDate
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
JOIN Warehouse w ON i.WarehouseID = w.WarehouseID
WHERE i.Quantity <= i.ReorderLevel + i.SafetyStock;


