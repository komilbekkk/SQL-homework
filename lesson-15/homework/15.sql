

--SQL Homework Tasks: CTEs and Derived Tables

--Easy Tasks

--1

with Numbers as (
	select 65 as Number
	union all
	select number+1 from Numbers where number  < 90)
select * from Numbers;

--2

with Numbers as (
	select 1 as Number
	union all
	select Number*2 from Numbers where Number < 100)
select * from Numbers;

-- or unlimited version

with Numbers as (
	select 1 as Number
	union all
	select Number*2 from Numbers)
select * from Numbers; 

--3

Select 
	E.EmployeeID, 
	e.DepartmentID, 
	e.FirstName, 
	e.Lastname, 
	e.Salary, 
	Total_sales.Total_sales
	from Employees E join 
	(select EmployeeID, max(SalesAmount) As Total_Sales  
	from Sales group by EmployeeID) as Total_sales 
on e.EmployeeID = Total_sales.EmployeeID;

--4

With AVG_salary as 
	(select EmployeeID, FirstName, LastName, 
	AVG(salary) as 'AVG_Salary' 
	from Employees 
	group by EmployeeID, firstName, lastname)
select * from AVG_salary; 

--5


select 
	p.ProductID, 
	p.CategoryID, 
	p.ProductName, 
	p.Price, 
	M_SalesAmout.Highest_sales 
	from Products P 
	join (select ProductID, MAX(SalesAmount) Highest_sales  
	from Sales 
	group by ProductID) as M_SalesAmout 
	on  p.ProductID = M_SalesAmout.ProductID;

--6

select 
		e.EmployeeID,
		concat(e.FirstName, ' ', e.LastName) As Name  
		from Employees E 
		join (select EmployeeID, COUNT(EmployeeID) as Sales 
		from Sales 
		group by EmployeeID) As S 
		on e.EmployeeID = s.EmployeeID and s.Sales > 5

--7

With HighSales as (
	Select * from Sales 
	where SalesAmount > 500)
	Select 
	p1.SalesID, 
	p1.ProductID, 
	p.ProductName, 
	p.Price, 
	p1.SalesAmount 
	from HighSales p1 
	join Products P 
	on p1.ProductID = P.ProductID; 

--8

With Salary As (
	select AVG(salary) AVG_salary 
	from Employees)
select 
	e.EmployeeID, 
	e.DepartmentID, 
	e.FirstName, 
	e.LastName, 
	e.Salary 
from Employees E 
	join Salary S 
on e.Salary > s.AVG_salary;

--9

With Total as (
	select 
		ProductID, 
		SUM(SalesAmount) SalesAmount 
	from Sales 
	group by ProductID)
	select 
		p.ProductID, 
		p.ProductName, 
		Cast(t.SalesAmount/p.Price as decimal(10,2)) As 'Total number of products', 
		p.Price, 
		t.SalesAmount 
	from Total T 
		join Products P 
		on t.ProductID = p.ProductID;

--10

With NoSales as (
	select * from Employees)
	Select 
		e.EmployeeID, 
		e.DepartmentID, 
		e.FirstName, 
		e.LastName 
	from NoSales  E 
		left join Sales S 
	on e.EmployeeID = s.EmployeeID 
	where SalesID is null;

--or this option

With EMP as 
	(Select * from Employees 
	where EmployeeID  not in 
	(select EmployeeID 
	from Sales 
	where EmployeeID is not null)) 
select * 
	from EMP;

--Medium Tasks

--1

DECLARE @n INT = 5;

WITH FactorialCTE AS (
    SELECT 1 AS Num, 1 AS Factorial
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM FactorialCTE
    WHERE Num + 1 <= @n
)
SELECT * FROM FactorialCTE;

--2

DECLARE @n INT = 10;  

WITH Fibonacci AS (
    SELECT 0 AS Position, 0 AS Value
    UNION ALL
    SELECT 1 AS Position, 1 AS Value
    UNION ALL
    SELECT Position + 1, 
           (SELECT Value FROM Fibonacci WHERE Position = F.Position - 1) +
           (SELECT Value FROM Fibonacci WHERE Position = F.Position - 2)
    FROM Fibonacci F
    WHERE Position + 1 < @n
)
SELECT * FROM Fibonacci
ORDER BY Position;

--3

DECLARE @inputString VARCHAR(100) = 'HELLO';

WITH CharSplitter AS (
    SELECT 
        1 AS Position,
        SUBSTRING(@inputString, 1, 1) AS Character
    UNION ALL
    SELECT 
        Position + 1,
        SUBSTRING(@inputString, Position + 1, 1)
    FROM CharSplitter
    WHERE Position + 1 <= LEN(@inputString)
)
SELECT * FROM CharSplitter;


--4

With SalesA As
		 (select EmployeeID, SUM(salesAmount) as Sum_Sales 
		 from Sales 
		 group by EmployeeID)
	select 
			e.EmployeeID, 
			e.DepartmentID, 
			e.FirstName, 
			e.LastName, 
			s.Sum_Sales, 
		case 
		when Sum_Sales < 6500 then 'Low'
		when Sum_Sales < 8000 then 'Medium'
		else 'High' 
		end as Ranking
		from SalesA S
		join Employees E on s.EmployeeID = e.EmployeeID;

		-- or these options

With SalesA As
		 (select EmployeeID, SUM(salesAmount) as Sum_Sales 
		 from Sales 
		 group by EmployeeID)
	select 
			e.EmployeeID, 
			e.DepartmentID, 
			e.FirstName, 
			e.LastName, 
			s.Sum_Sales, 
		RANK() over (Order by s.Sum_Sales desc) as Ranking
		from SalesA S
		join Employees E on s.EmployeeID = e.EmployeeID;

	--or--

With SalesA As
		 (select EmployeeID, SUM(salesAmount) as Sum_Sales 
		 from Sales 
		 group by EmployeeID)
	select 
			e.EmployeeID, 
			e.DepartmentID, 
			e.FirstName, 
			e.LastName, 
			s.Sum_Sales, 
		DENSE_RANK() over (Order by s.Sum_Sales desc) as Ranking
		from SalesA S
		join Employees E on s.EmployeeID = e.EmployeeID;

--5

Select 
	top 5 
		e.EmployeeID, 
		e.DepartmentID, 
		e.FirstName, 
		e.LastName, 
		e.Salary, 
		orders.Total_Orders 
	from (Select EmployeeID, COUNT(EmployeeID) 
	as Total_Orders  
	from Sales 
	group by EmployeeID) as Orders 
	join Employees E 
	on orders.EmployeeID = e.EmployeeID  
	order by Total_Orders desc;

--6

With A as (
	select SUM(SalesAmount) SUM_SalesAmount_January 
	from Sales 
	where SaleDate like '2025-01-%'), 
	B as (
	select SUM(SalesAmount) SUM_SalesAmount_February 
	from Sales 
	where SaleDate like '2025-02-%')
select 
		B.SUM_SalesAmount_February, 
		A.SUM_SalesAmount_January, 
		B.SUM_SalesAmount_February - A.SUM_SalesAmount_January 
		AS Sales_Difference from A cross join B;

--7

select
	p.CategoryID, 
	SUM(T_sales.Total) as Total_Sales 
from Products P 
join (
	select ProductID, 
		SUM(salesAmount) as Total 
	from Sales 
	group by ProductID) 
	as T_sales on p.ProductID = T_sales.ProductID 
	group by p.CategoryID order by Total_Sales desc;

--8

With T as (
	select 
		ProductID, 
		SUM(SalesAmount) as Total_sales 
		from (
	select *
	from Sales 
	where YEAR(SaleDate) = 2025 ) As Sales1 
	group by ProductID)
select 
		p.CategoryID, 
		p.ProductID, 
		p.ProductName, 
		p.Price, 
		t.Total_sales, 
		RANK() over (order by t.Total_sales desc) as Ranking
		from T join Products P 
		on t.ProductID = p.ProductID;

--or

With T as (
	select 
		ProductID, 
		SUM(SalesAmount) as Total_sales 
		from (
	select *
	from Sales 
	where YEAR(SaleDate) = 2025 ) As Sales1 
	group by ProductID)
select 
		p.CategoryID, 
		p.ProductID, 
		p.ProductName, 
		p.Price, 
		t.Total_sales, 
		DENSE_RANK() over (order by t.Total_sales desc) as Ranking
		from T join Products P 
		on t.ProductID = p.ProductID;

--9

(Sales, Employees). select * from (
		select 
			EmployeeID, 
			Datepart(quarter, SaleDate) as Q, 
			SUM(SalesAmount) Sales_Amount 
		from Sales 
		where YEAR(SaleDate) = 2025 
		group by EmployeeID, Datepart(quarter, SaleDate)
		having SUM(SalesAmount) > 5000) as CBA 
		join Employees e 
		on e.EmployeeID = CBA.EmployeeID;

		--or

WITH QuarterlySales AS (
    SELECT 
        EmployeeID,
        DATEPART(QUARTER, SaleDate) AS Quarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE YEAR(SaleDate) = 2025
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
),
QualifiedEmployees AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS QualifiedQuarters
    FROM QuarterlySales
    WHERE TotalSales > 5000
    GROUP BY EmployeeID
    HAVING COUNT(*) = 1  -- All 4 quarters
)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID
FROM QualifiedEmployees q
JOIN Employees e ON e.EmployeeID = q.EmployeeID;

--10

select top 3
		e.EmployeeID, 
		E.DepartmentID, 
		e.FirstName, 
		e.LastName, 
		e.Salary, 
		a.Total_sales 
	from (
	select EmployeeID, 
		SUM(salesAmount) Total_sales 
	from Sales 
	where SaleDate like '2025-01-%' 
	group by EmployeeID) as A join Employees E 
	on e.EmployeeID = A.EmployeeID order by a.Total_sales desc;

	--or this option if you mean MARCH but in the sales table: the last sales records in February. That is why I choose January first.

select top 3
		e.EmployeeID, 
		E.DepartmentID, 
		e.FirstName, 
		e.LastName, 
		e.Salary, 
		a.Total_sales 
	from (
	select EmployeeID, 
		SUM(salesAmount) Total_sales 
	from Sales 
	where SaleDate between '2025-03-01' and '2025-03-31' 
	group by EmployeeID) as A join Employees E 
	on e.EmployeeID = A.EmployeeID order by a.Total_sales desc;

-- Difficult Tasks
--1

DECLARE @n INT = 5;

WITH Numbers AS (
    SELECT 1 AS Num, CAST('1' AS VARCHAR(MAX)) AS Sequence
    UNION ALL
    SELECT Num + 1, Sequence + CAST(Num + 1 AS VARCHAR)
    FROM Numbers
    WHERE Num + 1 <= @n
)
SELECT Sequence
FROM Numbers;


--2

Select 
	top 
		1 E.DepartmentID, 
		e.EmployeeID, 
		e.FirstName, 
		e.LastName, 
		e.Salary, 
		S.SUM_Sales 
	from 
		(select EmployeeID, SUM(SalesAmount)  as SUM_Sales 
		from Sales 
		where saledate between '2024-10-01' and '2025-03-31' 
		group by EmployeeID) as S join Employees e 
		on e.EmployeeID = S.EmployeeID 
		order by S.SUM_Sales desc;

--3

WITH RECURSIVE RunningTotal AS (
    -- Base case: first row
    SELECT 
        id,
        StepNumber,
        Count,
        GREATEST(0, LEAST(10, Count)) AS RunningSum
    FROM Numbers
    WHERE id = 1
    
    UNION ALL
    
    -- Recursive case: subsequent rows
    SELECT 
        n.id,
        n.StepNumber,
        n.Count,
        GREATEST(0, LEAST(10, rt.RunningSum + n.Count)) AS RunningSum
    FROM Numbers n
    JOIN RunningTotal rt ON n.id = rt.id + 1
)

SELECT 
    id,
    StepNumber,
    Count,
    RunningSum
FROM RunningTotal
ORDER BY id;
--4

SELECT 
    A.ScheduleID,
    A.StartTime,
    A.EndTime,
    A.ActivityName
FROM Activity A

UNION

SELECT 
    S.ScheduleID,
    CASE 
        WHEN MIN(A.StartTime) > S.StartTime THEN S.StartTime 
        ELSE NULL 
    END AS StartTime,
    MIN(A.StartTime) AS EndTime,
    'Work' AS ActivityName
FROM Schedule S
LEFT JOIN Activity A ON S.ScheduleID = A.ScheduleID
GROUP BY S.ScheduleID, S.StartTime

UNION

SELECT 
    S.ScheduleID,
    MAX(A.EndTime) AS StartTime,
    CASE 
        WHEN MAX(A.EndTime) < S.EndTime THEN S.EndTime 
        ELSE NULL 
    END AS EndTime,
    'Work' AS ActivityName
FROM Schedule S
LEFT JOIN Activity A ON S.ScheduleID = A.ScheduleID
GROUP BY S.ScheduleID, S.EndTime

ORDER BY ScheduleID, StartTime;



--5

With Total as (
		select 
			E.EmployeeID, 
			E.DepartmentID, 
			D.DepartmentName, 
			E.FirstName, 
			E.LastName, 
			E.Salary, 
			S.SalesID, 
			S.SalesAmount, 
			S.SaleDate, 
			P.ProductID, 
			P.ProductName, 
			P.Price, 
			P.CategoryID
		from Employees E join Sales S 
		on E.EmployeeID = s.EmployeeID join Products P 
		on s.ProductID = P.ProductID join Departments D 
		on E.DepartmentID = D.DepartmentID)
		select DepartmentName, ProductName, SUM(salesAmount) as Total_sales from Total group by DepartmentName, ProductName

-- or this option with derived table

With Total as (
		select 
			E.EmployeeID, 
			E.DepartmentID, 
			D.DepartmentName, 
			E.FirstName, 
			E.LastName, 
			E.Salary, 
			S.SalesID, 
			S.SalesAmount, 
			S.SaleDate, 
			P.ProductID, 
			P.ProductName, 
			P.Price, 
			P.CategoryID
		from Employees E join Sales S 
		on E.EmployeeID = s.EmployeeID join Products P 
		on s.ProductID = P.ProductID join Departments D 
		on E.DepartmentID = D.DepartmentID)
		select 
			T.DepartmentName, 
			T.ProductName, 
			SUM(T.SalesAmount) as Total_sales 
		from (select DepartmentName, ProductName, SalesAmount from Total) as T 
		group by DepartmentName, ProductName;

