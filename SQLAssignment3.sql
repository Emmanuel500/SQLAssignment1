--Using Northwind Database
Use Northwind
Go

-- 1) List all cities that have both Employees and Customers.
SELECT DISTINCT City
FROM Customers
WHERE City IN (SELECT City FROM Employees)

-- 2) List all cities that have Customers but no Employee.
--	a.Use sub-query
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (SELECT City FROM Employees)

--	b.Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c FULL JOIN Employees e ON e.City = c.City
WHERE e.EmployeeID IS NULL

-- 3) List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) AS [Total order quantities]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

-- 4) List all Customer Cities and total products ordered by that city.
SELECT c.City, COUNT(o.OrderID) AS [Total Orders]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.City

-- 5) List all Customer Cities that have at least two customers.~
--	a. Use union
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(*) >= 2
UNION
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(*) >= 2

--	b. Use sub-query and no union
SELECT DISTINCT City
FROM Customers
WHERE City IN (
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(*) >= 2
)

-- 6) List all Customer Cities that have ordered at least two different kinds of products.~
SELECT c.City
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON p.ProductID = od.ProductID
GROUP BY c.City
HAVING COUNT(p.ProductName) >= 2

-- 7) List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity

-- 8) List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 p.ProductName, AVG(p.UnitPrice) AS [Average Price], (
	SELECT TOP 1 c.City
	FROM Customers c JOIN Orders o2 ON c.CustomerID = o2.CustomerID JOIN [Order Details] od2 ON o2.OrderID = od2.OrderID JOIN Products p2 ON p2.ProductID = od2.ProductID
	WHERE p.ProductName = p2.ProductName
	GROUP BY c.City, p2.ProductName
	ORDER BY SUM(od.Quantity) DESC
	) AS [Top Customer City to order most quantity]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY SUM(od.Quantity) DESC

-- 9) List all cities that have never ordered something but we have employees there.
--	a. Use sub-query
SELECT City
FROM Employees
WHERE City NOT IN (SELECT ShipCity FROM Orders)

--	b. Do not use sub-query
SELECT DISTINCT e.City
FROM Employees e LEFT JOIN Orders o ON e.City = o.ShipCity
WHERE o.ShipCity IS NULL

-- 10) List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total
--	   quantity of products ordered from. (tip: join  sub-query)
SELECT DISTINCT e.EmployeeID, (
	SELECT TOP 1 o2.ShipCity
	FROM Employees e2 JOIN Orders o2 ON e2.EmployeeID = o2.EmployeeID
	WHERE e.EmployeeID = e2.EmployeeID
	GROUP BY e2.EmployeeID, o2.ShipCity
	ORDER BY COUNT(o2.OrderID) DESC
	) AS [Most Sold City], (
	SELECT TOP 1 o3.ShipCity
	FROM Employees e3 JOIN Orders o3 ON e3.EmployeeID = o3.EmployeeID JOIN [Order Details] od3 ON o3.OrderID = od3.OrderID
	WHERE e.EmployeeID = e3.EmployeeID
	GROUP BY e3.EmployeeID, o3.ShipCity
	ORDER BY SUM(od3.Quantity) DESC
	) AS [Most Total Quantity City]
FROM Employees e
ORDER By e.EmployeeID

-- 11) How do you remove the duplicates record of a table?
--		Answer: Use DISTINCT, GROUP BY, Common Table Expressions (CTE), or RANK