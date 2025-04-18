--Lesson 5: Aliases, Unions, and Conditional columns

--Easy-Level Tasks

--1

select ProductName as Name from Products ;

--2

select * from Customers as Client;

--3

select productname from Products union select productname from Products_Discounted;

--4

select productname from Products intersect select productname from Products_Discounted;

--5

select distinct CONCAT(FirstName, ' ', LastName) as 'Customer name', Country  from Customers; -- or-- this option
select distinct firstname, lastname, Country from Customers;

--6

select *, case when price > 1000 then 'High' else 'Low' end as Indicator from Products; 

--7

select *, IIF(StockQuantity  > 100, 'Yes', 'No') as Indicator from Products_Discounted;

--Medium-Level Tasks
--8

select ProductName  from Products 
union 
select ProductName  from OutOfStock; 

--9

select * from Products 
except 
select * from Products_Discounted; -- or this for full difference (symmetric difference) — meaning rows that are in either table but not in both

select * from Products 
except 
select * from Products_Discounted
union
select * from Products_Discounted
except 
select * from Products;

--10

select *, IIF(price > 1000, 'Expensive', 'Affordable') as Indicator from Products; 

--11

select * from employees where age < 25 or salary > 60000;

--12

update employees
	set salary = salary *1.1
	where departmentName = 'HR' or employeeID = 5;

--13

select * from products
	intersect 
select * from Products_Discounted;

--14

select *, 
	case 
		when saleAmount = 500 then 'Top Tier'
		when saleAmount > 1 and saleamount <= 3 then 'Mid Tier' 
		else 'Low Tier'
		end as Indicator 
		from Sales; 


--15

select CustomerID  from Orders 
	except
	select CustomerID  from Invoices;

--16

select *, 
	case 
		when Quantity = 1 then 0.03
		when Quantity > 1 and Quantity <=3 then 0.05
		else 0.07 end as Discount
		from Orders 
