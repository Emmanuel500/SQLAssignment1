--Useing AdventureWorks2019 Database
USE AdventureWorks2019
Go

--1) How many products can you find in the Production.Product table?
SELECT Count(*) AS [Number of Products]
FROM Production.Product

--2) Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory.
--	 The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT Count(*) AS [Number of Products]
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--3) How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, Count(*) AS [CountedProducts]
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

-- 4) How many products that do not have a product subcategory.
SELECT Count(*) AS [CountedProductsWithOutSub]
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

-- 5) Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS [Sum of Products Quantity]
FROM Production.ProductInventory
GROUP BY ProductID

-- 6) Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit
--	  the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

-- 7) Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and
--	  LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100

-- 8) Write the query to list the average quantity for products where column LocationID has the value of 10 from the table
--	  Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

-- 9) Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

-- 10) Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in
--     the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

-- 11) List the members (rows) and average list price in the Production.Product table. This should be grouped independently
--	   over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color != 'N/A' AND Class != 'N/A'
GROUP BY Color, Class

-- 12) Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables.
--	  Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s ON (c.CountryRegionCode = s.CountryRegionCode)

-- 13) Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables
--	   and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s ON (c.CountryRegionCode = s.CountryRegionCode)
WHERE c.Name = 'Germany' OR c.Name = 'Canada'

--Useing Northwind Database
USE Northwind
Go

-- 14) List all Products that has been sold at least once in last 25 years.
SELECT p.ProductID, p.ProductName, o.OrderDate
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997'

-- 15) List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalQuantity
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

-- 16) List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalQuantity
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997'
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

-- 17) List all city names and number of customers in that city.     
SELECT City, COUNT(*) AS NumberOfCustomers
FROM Customers
GROUP BY City

-- 18) List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(*) AS NumberOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(*) > 2

-- 19) List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1/1/98'

-- 20) List the names of all customers with most recent order dates
SELECT c.ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (
					SELECT MAX(OrderDate)
					FROM Orders
					)

-- 21) Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(od.ProductID) AS ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName

-- 22) Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.ProductID) AS ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID) > 100

-- 23) List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT s.CompanyName AS [Supplier Company Name], o.ShipName AS [Shipping Company Name]
FROM Suppliers s JOIN Products p ON s.SupplierID = p.SupplierID JOIN [Order Details] od ON od.ProductID = p.ProductID JOIN Orders o ON o.OrderID = od.OrderID

-- 24) Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON od.OrderID = o.OrderID

-- 25) Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' + e1.LastName AS [Employeer 1], e2.FirstName + ' ' + e2.LastName AS [Employeer 2]
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID != e2.EmployeeID

-- 26) Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName + ' ' + m.LastName AS [Managers]
FROM Employees m JOIN Employees e ON e.ReportsTO = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(*) > 2

-- 27) Display the customers and suppliers by city. The results should have the following columns
SELECT ISNULL(s.City, c.City) AS City, ISNULL(s.CompanyName, c.CompanyName), ISNULL(s.ContactName, c.ContactName),
	   ISNULL((SELECT 'Supplier' WHERE s.City IS NOT NULL), 'Customer') AS Type
FROM Suppliers s FULL JOIN Customers c ON c.CompanyName = s.CompanyName
ORDER BY City