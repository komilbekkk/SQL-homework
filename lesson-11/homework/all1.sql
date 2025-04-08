
--Lesson 11 Homework Tasks

-- Easy-Level Tasks (7)

--1
select OrderID, CONCAT(firstname, ' ', lastname) As CostumerName, OrderDate 
	from Customers c join Orders o on 
		c.CustomerID = o.CustomerID 
			where year(OrderDate) > 2022 
				order by OrderDate;
--2
Select 
	name EmployeeName, DepartmentName  
		from Employees e join Departments d 
			on e.DepartmentID = d.DepartmentID 
				where DepartmentName = 'sales' or 
					DepartmentName = 'marketing' order by EmployeeName;

--3
select   
	d.DepartmentName,
    e.Name AS TopEmployeeName,
	e.Salary AS MaxSalary 
	from Employees e join Departments d on  
	e.DepartmentID  = d.DepartmentID join 
	(select DepartmentID, max(salary) As MAXSALARY 
	from Employees group by DepartmentID) as Max_Salary on 
	e.DepartmentID = Max_Salary.DepartmentID and 
	e.Salary = Max_Salary.MAXSALARY order by MaxSalary desc;

--4
select 
	CONCAT(c.firstname, ' ', c.LastName) as CustomerName, 
	o.OrderID, o.OrderDate 
	from Customers c join Orders o on 
	c.CustomerID = o.CustomerID 
	where year(OrderDate) = 2023 and lower(Country) = 'usa'

--5
select
	CONCAT(c.firstname, ' ', LastName)As CustomerName, 
	count(o.orderID) As TotalOrders 
	from Customers c join Orders o on 
	c.CustomerID  = o.CustomerID 
	group by c.FirstName, c.LastName 
	order by TotalOrders desc;

--6
select 
	p.ProductName, s.SupplierName 
	from Products p join Suppliers s 
	on p.SupplierID = s.SupplierID 
	where SupplierName in ('Gadget Supplies', 'Clothing Mart');

--7
select 
	CONCAT(firstname, ' ', lastname) as CustomerName,
	o.MostRecentOrderDate, o.OrderID 
	from Customers c 
	left join (select o1.CustomerID, o1.OrderDate AS MostRecentOrderDate, o1.OrderID
    FROM Orders o1 
	join (select CustomerID, max(OrderDate) as MaxDate
    from Orders
    group by CustomerID) o2 
	on o1.CustomerID = o2.CustomerID AND o1.OrderDate = o2.MaxDate) o 
	on c.CustomerID = o.CustomerID;

	-- Medium-Level Tasks (7)

--8
select 
    CONCAT(c.FirstName, ' ', c.LastName) as CustomerName,
    o.OrderID,
    o.TotalAmount as OrderTotal
from Customers c
JOIN Orders o on c.CustomerID = o.CustomerID
where o.TotalAmount > 500
order by o.TotalAmount desc;

--9
select 
	Productname, SaleDate, SaleAmount 
	from Products p join Sales s 
	on p.ProductID = s.ProductID 
	where year(s.SaleDate )= 2022 
	or s.SaleAmount > 400;


--10
select 
	p.ProductName, t.TotalSalesAmount 
	from Products p join (select productID, 
	sum(saleAmount) as TotalSalesAmount 
	from Sales group by ProductID) t 
	on p.productID = t.ProductID;
	
--11
select
	e.Name as EmployeeName, d.DepartmentName, 
	Salary from		
	Employees e join Departments d
	on e.DepartmentID = d.DepartmentID 
	where DepartmentName = 'Human Resources' and Salary > 50000;

--13
select 
	p.ProductName, s.SaleDate, p.StockQuantity  
	from Products p join sales s 
	on p.productID = s.productID 
	where year(saleDate) = 2023 and stockQuantity > 50;

--14
select
	e.Name as EmployeeName, d.DepartmentName, 
	e.HireDate from		
	Employees e join Departments d
	on e.DepartmentID = d.DepartmentID 
	where DepartmentName = 'Sales' or year(HireDate) > 2020;

-- Hard-Level Tasks (7)
--15
select * 
	from Customers c join Orders o 
	on c.CustomerID = o.CustomerID 
	where c.Country = lower('usa') 
	and c.Address like '[0-9][0-9][0-9][0-9]%'

--16
select p.ProductName, p.Category, s.SaleAmount 
	from Products p join Sales s 
	on p.ProductID = s.ProductID 
	where p.Category = 'Electronics' 
	or s.SaleAmount > 350;

--18
select 
	CONCAT(firstname, ' ', LastName) as CustomerName, c.City, o.OrderID, TotalAmount 
	from Customers c join Orders o 
	on c.CustomerID = o.CustomerID 
	where c.City = ('Los Angeles') and o.TotalAmount > 300


--19
select
	e.Name as EmployeeName, d.DepartmentName from		
	Employees e join Departments d
	on e.DepartmentID = d.DepartmentID 
	where d.DepartmentName in ('Human Resources', 'Finance') 
	or (lower(e.Name) like '%a%a%a%a%'  
        or lower(e.Name) like '%e%e%e%e%'  
        or lower(e.Name) like '%i%i%i%i%'  
        or lower(e.Name) like '%o%o%o%o%'  
        or lower(e.Name) like '%u%u%u%u%')


--20
select p.ProductName, s.SaleAmount as QuantitySold, p.Price
	from Products p join Sales s 
	on p.ProductID = s.ProductID 
	where s.SaleAmount > 100 
	and p.Price  > 500;

--21
select 
	e.Name as EmployeeName, d.DepartmentName, e.Salary 
	from Employees e join Departments d 
	on e.DepartmentID = d.DepartmentID 
	where DepartmentName in ('Sales', 'Marketing') 
	and Salary > 60000



