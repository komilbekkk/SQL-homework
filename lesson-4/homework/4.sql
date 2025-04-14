
--Lesson 4: Filtering and Ordering Data

--Easy-Level Tasks (10)

--1

Select top 5 * from Employees;

--2

select distinct ProductName  from Products; 

--3

select *  from Products where Price > 100;

--4

select *  from Products where ProductName like ('A%');

--5

select *  from Products order by Price asc;

--6

select * from Employees where Salary >= 60000 and DepartmentName = 'HR';

--7

select isnull(email, 'noemail@example.com') as Email from Employees; --or -- this option

select 
	EmployeeID, FirstName, LAstName, 
	DepartmentName, Salary, HireDate, Age, 
	isnull(email, 'noemail@example.com') as Email, Country 
	from Employees;

--8

select * 
	from Products 
		where Price between 50 and 100;

--9

select 
	distinct 
		ProductName, Category 
		from Products; 

--10

select 
	distinct ProductName, Category 
	from Products 
	order by ProductName desc;

--Medium-Level Tasks (10)

--11

select 
	top 10 * 
	from Products 
	order by Price desc;

--12

select 
	coalesce(FirstName, LastName) 
	As EmployeeName 
	from Employees;
	--OR-- this option for full table
select 
	EmployeeID, 
	coalesce(FirstName, LastName) As EmployeeName, 
	DepartmentName, Salary, HireDate, age, email, Country 
	from Employees;

--13

select 
	distinct Category, Price  
	from  Products;

--14

select * from Employees where Age between 30 and 40 or DepartmentName = 'Marketing';

--15

select * 
	from Employees 
		order by Salary desc
		offset 10 rows fetch next 10 rows only;

--16

select * 
	from Products 
	where Price <= 1000 and StockQuantity > 50 
	order by StockQuantity asc 

--17

select * from Products where ProductName like ('%e%');

--18

select * 
	from Employees 
	where DepartmentName in ('HR', 'IT', 'Finance');

--19

select * 
	from Customers 
	order by City asc, PostalCode desc;

--Hard-Level Tasks

--20

select top 10 * from Orders order by TotalAmount desc;

--21

select CONCAT(firstname, ' ', LastName) as Fullname from Employees;

--22

select 
	distinct Category, ProductName, Price 
	from Products 
	where Price > 50;

--23

select * 
	from Products 
	where Price < (select AVG(Price) 
	from Products)*0.10; 

--24

select * 
	from Employees 
	where Age < 30 
	and DepartmentName in ('HR', 'IT');

--25

select * 
	from Customers 
	where Email like ('%@gmail.com');

--26
select * 
	from Employees 
	where Salary > 
	all(select Salary from Employees where DepartmentName = 'Sales');

--27

select * from Orders where OrderDate > GETDATE()-180 and OrderDate < GETDATE();
--OR--
Select * from Orders where OrderDate between GETDATE() - 180 and GETDATE(); 
-- or also this option

Select * from Orders where OrderDate between Cast(GETDATE() - 180 as Date) and Cast(GETDATE() as Date); 





