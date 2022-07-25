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


--8  return OrderId, CustomerId, and Shipcountry for the orders where shipcountry is either france or Belgium
select OrderID, CustomerID, ShipCountry from Orders
where ShipCountry in ('france', 'Belgium')

--or
select OrderID, CustomerID, ShipCountry from Orders
where ShipCountry ='france' 
or ShipCountry='Belgium'

--9return all orders fromany latin american country. brazil , mexico , argentina venenzuela

select OrderID, CustomerID, ShipCountry from Orders
where ShipCountry in ('Brazil','Mexico', 'Argentina','Venezuela')

--10 return firstname, lastname, title birthdate order results by birthdate oldest employee first
select FirstName,LastName, Title,BirthDate from Employees 
order by BirthDate 

--11  return the above query but show only the date portion  of the birthdate field
select FirstName,LastName, Title, cast(birthdate as date)  from Employees 
order by BirthDate 
--or
select FirstName,LastName, Title, convert(date,birthdate)  from Employees 
order by BirthDate 

--12 return firstname and lastname columns from the employees table then create a new columns fullname 
select FirstName,LastName, (firstname+' '+Lastname) as FullName from Employees
--or 
select FirstName,LastName, CONCAT(FirstName,' ', LastName) as FullName from Employees

--13in orderdetaisl show orderid,productid,unitprice and quantity , create a new field totalprice (unitprice * quantity) . order by orderid and product id 
select OrderID,ProductID,UnitPrice,Quantity,(unitprice *quantity) as totalPrice from [Order Details]
order by OrderID, ProductID


--14 show the total number of customers that we have in customers table. show only one value. 

select count(CustomerID) from Customers


--15 show the date of the first order ever made in the orders table

select  Min( OrderDate) from Orders
--or 
select top 1 OrderDate from orders

--16 list of countries where the northwind company has customers
select distinct Country from Customers
--or
select Country from Customers
group by Country

--17 list of all the different values in the customers table for contacttitles. also include a count for each contact title. 
select ContactTitle,count(CustomerID)as totalContactTitle  from customers
group by ContactTitle
order by totalContactTitle desc

--18 show for each product the asssociated supplier . show product id, product name  and companyname of the supplier. sort by product id
--using both tables
select ProductID,ProductName,s.CompanyName from Suppliers s
join products p
on s.SupplierID = p.SupplierID
order by productId


--19show list of orders , include shipper that was used, show order id, orderdate(date only) and company name of the shipper, sort by orderId.
--show  only rows where orderid less than 10300
select OrderID,CONVERT(date,OrderDate) as orderDate, s.CompanyName from Orders o
join Shippers s 
on o.ShipVia = s.ShipperID
where o.OrderID < 10300
order by OrderID


--20 total number of products in each category . sort the results by the total number of products in desc order.
select c.CategoryName , count(p.ProductID) as TotalProducts from Products p
join Categories c
on p.CategoryID = c.CategoryID
group by CategoryName
order by TotalProducts desc


--21 total number of customers per country and city
select country, city, count(CustomerID) as TotalCustomer from customers
group by country,City 
order by TotalCustomer desc


--22 show units in stock and reorderlevel, where unitesinstock is less than reorderlevel,ignoring the fields units on order and discontinued.
--order results by product id
select ProductID,ProductName,UnitsInStock,ReorderLevel from Products
where UnitsInStock < ReorderLevel
order by ProductID



--23 incorporate fields units in stock, units on order, reorderLevel,discontinued into calculuation. define products that need reordering 
--by saying units in stock plus units on order are lass than or equal to reorder level
-- discontinued flag musl be false 
select ProductID,ProductName,UnitsInStock,ReorderLevel from Products
where (UnitsInStock + UnitsOnOrder) <= ReorderLevel
and Discontinued = 0;



--24 A list of customers sorted by region alphabetically. customers with no region . to be at the end . within the same region companies should be sorted by cusdtomer id
select  CustomerID,CompanyName,Region from customers 
order by case 
when region is null then 1 
else 0
end, Region,
CustomerID


--25 Height freight charges -return three ship countries with the higest average freight overall in descending order by average freight
select top 3 ShipCountry, avg(freight) as AverageFreight from orders
group by ShipCountry
order by AverageFreight desc


--26 continue on 25 but with only orders from the year 1998 , the book uses 2015 but i downloaded an older version of the Northwind database
select top 3 ShipCountry, avg(freight) as AverageFreight from orders
where DATEPART(year, convert( date,OrderDate))= '1998'
group by ShipCountry
order by AverageFreight desc

--27 find the order id that is not included in the problem (wrong) answer , per the book material

select * from orders 
order by OrderDate desc
