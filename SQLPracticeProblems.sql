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


--26 continue on 25 but with only orders from the year 2015 , you might have to download a .bak file of northwind 2016
select top 3 ShipCountry, avg(freight) as AverageFreight from orders
where DATEPART(year, convert( date,OrderDate))= '2015'
group by ShipCountry
order by AverageFreight desc

--27 find the order id that is not included in the problem (wrong) answer , per the book material 
-- this is wrong  because although the between is inclusive like [2,4] it excludes the 
-- orders made later than the beginning of 12/31/2022
select top 3 shipcountry , averagefreight = avg(freight) from orders
where 
	OrderDate between '1/1/2015' and 
	'12/31/2015'
	group by ShipCountry
	order by averagefreight desc;

select * from Orders
order by OrderDate


--28 three ship countries with the heightest average freight charges in the last year from the date with the newest order
select top 3 ShipCountry, avg(freight) as AverageFreight from orders
where OrderDate >= dateadd(yy,-1,(select max(orderdate) from orders))
	group by ShipCountry
	order by averagefreight desc;

--29 example in the book we just had to join tables to show specific fields from each table. 

select e.EmployeeID,e.LastName, od.OrderID,ProductName, Quantity from OrderDetails od
join Orders o 
on od.OrderID = o.OrderID
join products p
on p.ProductId =od.ProductID
join Employees e on e.EmployeeID = o.EmployeeID
order by o.OrderID, p.ProductID

--30 show customers who have never placed an order
select c.CustomerID,o.CustomerID from Customers c
left join Orders o
on o.CustomerID = c.CustomerID
where o.CustomerID is null

--31 return customers who have never placed an order with margaret peacock employee id 4
select c.CustomerID,o.CustomerID from customers c
left join orders o 
on o.CustomerID = c.CustomerID      -- you can add an extra clause in the join 
and o.EmployeeID = 4
where 
o.CustomerID is null

select customerid from customers
where 
CustomerID not in (select CustomerID from 
Orders where EmployeeID = 4)

--32 select all customers with at least 1 order with total value 10,000 or more .
--only considering the orders made in the year 2016
select c.CustomerID, c.CompanyName,o.OrderID,   sum(Quantity*UnitPrice) as ammount from Customers c
join orders o 
on c.CustomerID = o.CustomerID
join OrderDetails od 
on od.OrderID = o.OrderID
where OrderDate>='20160101'
and orderdate < '20170101'
group by 
c.CustomerID,c.CompanyName,o.OrderID 
having sum(Quantity*unitPrice) > 10000
order by ammount desc



--33 select all customers who have orders totaling 15,000 or more in 2016
select  c.customerId,c.CompanyName,sum(quantity * unitPrice) as ammount from customers c
join orders o 
on c.CustomerID =o.CustomerID
join OrderDetails od on 
od.OrderID =o.OrderID
where OrderDate>='20160101'
and orderdate < '20170101'
group by 
c.CustomerID,c.CompanyName
having sum(quantity * unitPrice) > 15000
order by ammount desc


--34 same as 33 but use the discount when calculating high value  customers. order by total ammount with includes the discount book has error. answer is for 10000, book says to calculate value based on probelm 33 which sets value at 15000
select  c.customerId,c.CompanyName,sum(quantity * unitPrice) as totalsWithoutDiscount, sum(quantity * unitPrice*(1-Discount)) as totalsWithDiscounts from customers c
join orders o 
on c.CustomerID =o.CustomerID
join OrderDetails od on 
od.OrderID =o.OrderID
where OrderDate>='20160101'
and orderdate < '20170101'
group by 
c.CustomerID,c.CompanyName
having sum(Quantity * UnitPrice*(1-discount)) > 10000
order by totalsWithDiscounts desc

--35 show all orders made on the last day ofthe month . order by employee id and order id an error in the book shows 26 rows
select EmployeeID,OrderID, OrderDate from Orders
where OrderDate = EOMONTH(OrderDate)
order by EmployeeID,OrderID

select * from Orders
where orderdate= DATEADD(month,1+DATEDIFF(month,0,OrderDate),-1)


--36 orders that have lots of individual line items. show the 10 orders with the most line items in order of total line items
select top 10 o.OrderID, count(od.OrderID) total from Orders o
join OrderDetails od 
on od.OrderID = o.OrderID
group by o.OrderID
order by total desc


--37 random set of 2% of all orders , newId() function creates a new unique identifier for the data , because it is called each time you run the query it creates a new identifier and orders it based on that 
select top 2 percent OrderID from Orders
order by NEWID()

--38show all orderIds with line items that match 60 or more 

select orderid, Quantity from OrderDetails
where Quantity >= 60
group by orderid,Quantity
having count(orderid) >1


--39 based on the previous question , show the details of the order, for orders that match the above criteria	
--using a normal subquery in the the where clause to  pickout only the orderids 
select * from orderdetails 
where OrderID in (select orderid from OrderDetails
where Quantity >= 60
group by orderid,Quantity
having count(orderid) >1)



--same idea but using the with function of the CTE "common table expression" which creates a variable containing the subquery you want to search from.
-- works as a subquery except that a subquery can only return one value because it is matching to orderid . here we can store both values in the subquery inside the cte and just retrive the value we want. 

with orderIds as(select orderid,Quantity from OrderDetails
where Quantity >= 60
group by orderid,Quantity
having count(orderid) >1)

select * from OrderDetails
where OrderID in ( select OrderID from orderIds)


--40 - same problem as before using a derived table. 
select o.OrderID,o.ProductID,o.UnitPrice,o.Quantity,o.Discount from OrderDetails o
join 
(select distinct orderid
from OrderDetails 
where quantity >=60
group by OrderID,Quantity
having count(*) >1) as PPO --potential problem orders
on ppo.OrderID = o.OrderID
order by OrderID,ProductID


--41 which orders are late 
select OrderID,OrderDate,RequiredDate,ShippedDate from orders
where ShippedDate >= RequiredDate

--42which salespeople have the most orders arriving late , i was off by a little bit but corrected it by changing the shippedDate > requireddate to shippedDate >=Required date. althought it might be an error because some 
--orders might get to the recipient within the same daY ?

select  e.EmployeeID,e.LastName, count(*)TotalLateOrders from Employees e
join (  select * from orders where ShippedDate>= RequiredDate) lateOrders
on e.EmployeeID = lateOrders.EmployeeID
group by e.EmployeeID,LastName
order by TotalLateOrders desc

--43 the total number of sales for each person must be compared to the total number of late orders 
with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders =late.lateOrders from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID


--44 there was a value missing because there is one employee that is not  included in the list because he doesnt have any late orders

with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders =late.lateOrders from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
left join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID

--45 now that we found the employee who did not have any late orders  we need to replace the value null for the value 0 in our database. it can be done 2 ways  using isnull function and using a case statement
with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders =
case 
	when late.LateOrders 
	is null 
	then 0 
	else late.LateOrders
	end
from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
left join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID

with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders = isnull( late.lateOrders,0 )from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
left join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID

--46 now we want to get a percentage of late orders over total orders. used the convert to decimal to convert both values to a decimal before dividing. then wrapped that in an is null to make sure that i return a 0 if null 
with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders = isnull( late.lateOrders,0 ), percentage= isnull((convert(decimal, late.LateOrders)/total.totalOrders),0)  from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
left join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID

--47 now we want the percentage but we want to truncate the the decimal places to 2 places. 
with CTE_totalOrders as(
select employeeId , count(*)totalOrders from orders
group by EmployeeID),
CTE_lateOrders as( select employeeId, count(*)LateOrders from Orders
where ShippedDate > = RequiredDate 
group by EmployeeID)
select e.EmployeeID,e.LastName,AllOrders=total.totalorders,lateorders = isnull( late.lateOrders,0 ), percentage= cast( isnull((convert(decimal(5,2), late.LateOrders)/total.totalOrders),0) as decimal(3,2) ) from Employees e
join CTE_totalOrders total
on total.EmployeeID = e.EmployeeID
left join CTE_lateOrders late
on late.EmployeeID= e.EmployeeID;

--48  categorize customers in to groups , based on how much they ordered in 2016. Then, depending on which group the customer is in, hew will target the customer with different sales material
-- then grouping from 0 to 1000, 1000 to 5000, 5000 to 10000, and over 10000
select c.CustomerID,c.CompanyName,totalorderammount=SUM(quantity * unitprice), customerGroup=
case
when Sum(quantity* Unitprice)  between 0 and 1000 then 'low'
when Sum(quantity* Unitprice)  between 1001 and 5000 then 'low'
when Sum(quantity* Unitprice)  between 5001 and 10000 then 'low'
when Sum(quantity* Unitprice) >10000 then 'low'
end
from customers c
join orders o
on o.CustomerID= c.CustomerID
join OrderDetails od
on od.OrderID = o.OrderID
where 
OrderDate > = '20160101'
and 
OrderDate < '20170101'
group by c.CustomerId,c.CompanyName;



--49 there was a field if you used the between keyword again that would be null . 
-- didnt implement that keyword in my previous attempt and so i dont have to fix any null values .. i used the >= 
--operators. went back to use the between operator to see the error and verify that the user with id of maisd was present in my results. 
with cte_valueCustomers as (
select c.CustomerID,c.CompanyName,TotalOrderAmmount= sum(quantity * unitprice) from customers c
	join Orders o
	on c.CustomerID = o.CustomerID
	join OrderDetails od
	on od.OrderID = o.OrderID
	where
	OrderDate >= '20160101'
	and OrderDate < '20170101'
	group by 
	c.CustomerID,c.CompanyName
	)
	select CustomerID,CompanyName,TotalOrderAmmount,case 
	when TotalOrderAmmount >=0
	and TotalOrderAmmount <1000
	then 'low'
	when TotalOrderAmmount >=1000
	and TotalOrderAmmount <5000
	then 'medium'
	when TotalOrderAmmount >=5000
	and TotalOrderAmmount<=10000
	then 'high'
	when TotalOrderAmmount >10000
	then 'very high'
	end as customeGroup 
	from cte_valueCustomers ;
	
--50 count how many customers are in each group 
-- we can use the previous cte and make a new one to count the percenttages.. 
-- the old one will take care of the group names, and the number by giving me acoutnt. 
-- took a while because i wanted to use the previous case option alias but you cant do that. so had to first give the count(employeeid) then 
-- give it 
-- might be easier to create a temp table


with orders2016 as(
select c.CustomerID, c.CompanyName,totalOrderAmmount=(Quantity * UnitPrice) from Customers c
join orders o
on c.CustomerID = o.CustomerID
join OrderDetails od
on o.OrderID = od.OrderID
	where
	OrderDate >= '20160101'
	and OrderDate < '20170101'
	group by 
		c.CustomerID,
		c.CompanyName
),customerGrouping as ( --calling another common table expression within my primary cte
	select CustomerID,CompanyName,totalOrderAmmount,customerGroup=  
	case 
	when totalOrderAmmount >=0 and totalOrderAmmount <1000 then 'low'
	when totalOrderAmmount >=1000 and totalOrderAmmount <5000 then 'medium'
	when totalOrderAmmount >=5000 and totalOrderAmmount <10000 then 'high'
	when totalOrderAmmount >=10000 then 'very high'
	end
	from  orders2016 
	)
	select from customerGrouping
		