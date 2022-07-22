--1. return all fields from shippers
select * from Shippers

--2. return categoryName and description
select CategoryName,[description] from Categories


--3 return firstname lastname hiredate of all employees with title of sales rep
select FirstName,LastName,HireDate from Employees 
where Title like '%Sales Representative%'
--or 
select Firstname,LastName, HireDate from Employees
where Title= Trim('Sales Representative')

--4 same as 3 but also are in the united states
select Firstname,LastName,HireDate from Employees
where Title like '%Sales Representative%'
and Country in ('United States', 'USA')

--5 return all orders replaced by a specific employee. employee id is 5 steven buchanan
select OrderID,OrderDate from Orders o
join Employees e 
on e.EmployeeID = o.EmployeeID
where e.EmployeeID=5;

--6 return supplierId, ContactName, ContactTitle where contactTitle is NOt Marketing manager
select SupplierID,ContactName,ContactTitle from Suppliers
where Not ContactTitle = 'Marketing Manager'

--or 
select SupplierID,ContactName,ContactTitle from Suppliers
where ContactTitle Not in('Marketing Manager') 


--7 return ProductID and ProductName for those products where the ProductName includes the string "queso"
select ProductID, ProductName from Products
where ProductName like '%queso%'


--8 