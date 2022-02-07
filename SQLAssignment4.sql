--Using Northwind Database
Use Northwind
Go

--1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_perez
AS
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS [Total Ordered Quantity]
FROM Products p JOIN [Order Details]  od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName

--2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_perez
@id int
AS
BEGIN
SELECT SUM(od.Quantity) AS [Total Ordered Quantity]
FROM Products p JOIN [Order Details]  od ON p.ProductID = od.ProductID
WHERE p.ProductID = @id
END

--3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered
--   most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_perez
@pname varchar(40) out 
AS
BEGIN
SELECT TOP 5 o.ShipCity, SUM(od.Quantity) AS [Total Ordered Quantity]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON od.OrderID = o.OrderID
WHERE p.ProductName = @pname
GROUP BY o.ShipCity
ORDER BY SUM(od.Quantity) DESC
END

--4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}.
--   People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}.
--   Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all
--   people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_perez(
CityId int PRIMARY KEY,
CName varchar(20) NOT NULL
)
CREATE TABLE people_perez(
PeopleId int PRIMARY KEY,
PName varchar(30) NOT NULL,
CityId int foreign key references city_perez(CityId) on delete set null
)

INSERT INTO city_perez VALUES(1, 'Seattle')
INSERT INTO city_perez VALUES(2, 'Green Bay')
INSERT INTO people_perez VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_perez VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_perez VALUES(3, 'Jody Nelson', 2)

DELETE FROM city_perez
WHERE CName = 'Seattle'

INSERT INTO city_perez VALUES(3, 'Madison')
UPDATE people_perez
SET CityId = 3
WHERE CityId IS NULL

CREATE VIEW Packers_perez
AS
SELECT p.PeopleId, p.PName
FROM people_perez p JOIN city_perez c ON p.CityId = c.CityId
Where c.CName = 'Green Bay'
-- Test
Select *
FROM city_perez
Select *
FROM people_perez
Select *
FROM Packers_perez
-- DROP
DROP TABLE people_perez
DROP TABLE city_perez
DROP VIEW Packers_perez

--5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name”
--   and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_perez
AS
BEGIN
CREATE TABLE birthday_employees_perez (
EmployeeID int PRIMARY KEY,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
BirthDate date NOT NULL
)
INSERT INTO birthday_employees_perez
SELECT EmployeeID, FirstName, LastName, BirthDate
FROM Employees
WHERE Month(BirthDate) = Month('2020/2/1')
END

EXEC sp_birthday_employees_perez
SELECT *
FROM birthday_employees_perez

DROP TABLE dbo.birthday_employees_perez

--6. How do you make sure two tables have the same data?
--Answer: If the two tables have the same size of records and the union of them returns the same size of records, then both table have the same data
SELECT * FROM table_test1
UNION
SELECT * FROM table_test2
SELECT COUNT(*) FROM table_test1
SELECT COUNT(*) FROM table_test2