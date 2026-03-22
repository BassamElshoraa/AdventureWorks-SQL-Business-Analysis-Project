/******************************************************************************
 Project: AdventureWorks2019 – Final Project Answers (Simplified)
 Database: AdventureWorks2019
 Purpose : Instructor Reference – Full Answer Code Zone
******************************************************************************/

USE AdventureWorks2019;
GO

------------------------------------------------------------
-- 1. Annual Sales Trend (No JOIN)
------------------------------------------------------------
SELECT
    YEAR(OrderDate) AS OrderYear,
    SUM(TotalDue) AS AnnualSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


------------------------------------------------------------
-- 2. Monthly Sales Performance (No JOIN)
------------------------------------------------------------
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(TotalDue) AS MonthlySales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;


------------------------------------------------------------
-- 3. Top 5 Customers by Total Spending (JOIN)
------------------------------------------------------------
SELECT TOP 5
    p.FirstName + ' ' + p.LastName AS CustomerName,
    SUM(h.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
    ON h.CustomerID = c.CustomerID
JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSpent DESC;


------------------------------------------------------------
-- 4. Average Order Value (AOV) (No JOIN)
------------------------------------------------------------
SELECT
    AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader;


------------------------------------------------------------
-- 5. Number of Orders per Year (No JOIN – Simplified)
------------------------------------------------------------
SELECT
    YEAR(OrderDate) AS OrderYear,
    COUNT(*) AS OrdersCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


------------------------------------------------------------
-- 6. Best-Selling Products by Quantity (JOIN)
------------------------------------------------------------
SELECT
    p.Name AS ProductName,
    SUM(d.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail d
JOIN Production.Product p
    ON d.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQuantitySold DESC;


------------------------------------------------------------
-- 7. Revenue by Product Category (JOIN)
------------------------------------------------------------
SELECT
    pc.Name AS CategoryName,
    SUM(d.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail d
JOIN Production.Product p
    ON d.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalRevenue DESC;


------------------------------------------------------------
-- 8. Products Never Sold (LEFT JOIN)
------------------------------------------------------------
SELECT
    p.Name AS ProductName
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail d
    ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;


------------------------------------------------------------
-- 9. High Quantity – Low Revenue Products (JOIN)
------------------------------------------------------------
SELECT
    p.Name AS ProductName,
    SUM(d.OrderQty) AS TotalQuantity,
    SUM(d.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail d
JOIN Production.Product p
    ON d.ProductID = p.ProductID
GROUP BY p.Name
HAVING SUM(d.OrderQty) > 100 
   AND SUM(d.LineTotal) < 10000
ORDER BY TotalQuantity DESC;


------------------------------------------------------------
-- 10. Inventory Value per Product (No JOIN)
------------------------------------------------------------
SELECT
    Name AS ProductName,
    SafetyStockLevel * StandardCost AS InventoryValue
FROM Production.Product;


------------------------------------------------------------
-- 11. Sales by Country (JOIN)
------------------------------------------------------------
SELECT
    cr.Name AS Country,
    SUM(h.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
    ON h.CustomerID = c.CustomerID
JOIN Person.Address a
    ON c.CustomerID = a.AddressID
JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;


------------------------------------------------------------
-- 12. Customers with More Than 10 Orders (JOIN)
------------------------------------------------------------
SELECT
    c.CustomerID,
    COUNT(h.SalesOrderID) AS OrdersCount
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
    ON h.CustomerID = c.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(h.SalesOrderID) > 10;


------------------------------------------------------------
-- 13. Total Sales per Salesperson (JOIN – Simplified)
------------------------------------------------------------
SELECT
    p.FirstName + ' ' + p.LastName AS SalesPerson,
    SUM(h.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesPerson sp
    ON h.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSales DESC;


------------------------------------------------------------
-- 14. Cities with High Orders but Low Revenue (JOIN)
------------------------------------------------------------
SELECT
    a.City,
    COUNT(h.SalesOrderID) AS OrdersCount,
    SUM(h.TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
    ON h.CustomerID = c.CustomerID
JOIN Person.Address a
    ON c.CustomerID = a.AddressID
GROUP BY a.City
HAVING COUNT(h.SalesOrderID) > 10
   AND SUM(h.TotalDue) < 50000;


------------------------------------------------------------
-- 15. Order Size Classification (No JOIN – CASE)
------------------------------------------------------------
SELECT
    SalesOrderID,
    TotalDue,
    CASE
        WHEN TotalDue < 1000 THEN 'Small'
        WHEN TotalDue BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'Large'
    END AS OrderSize
FROM Sales.SalesOrderHeader;
