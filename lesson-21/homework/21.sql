/*
			Questions
Write a query to assign a row number to each sale based on the SaleDate.
Write a query to rank products based on the total quantity sold (use DENSE_RANK())
Write a query to identify the top sale for each customer based on the SaleAmount.
Write a query to display each sale's amount along with the next sale amount in the order of SaleDate using the LEAD() function
Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate using the LAG() function
Write a query to rank each sale amount within each product category.
Write a query to identify sales amounts that are greater than the previous sale's amount
Write a query to calculate the difference in sale amount from the previous sale for every product
Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
Write a query to calculate the difference in sale amount from the very first sale of that product.
Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
Write a query to calculate a "closing balance" for sales amounts which adds the current sale amount to a running total of previous sales.
Write a query to calculate the moving average of sales amounts over the last 3 sales.
Write a query to show the difference between each sale amount and the average sale amount.
Find Employees Who Have the Same Salary Rank
Identify the Top 2 Highest Salaries in Each Department
Find the Lowest-Paid Employee in Each Department
Calculate the Running Total of Salaries in Each Department
Find the Total Salary of Each Department Without GROUP BY
Calculate the Average Salary in Each Department Without GROUP BY
Find the Difference Between an Employee’s Salary and Their Department’s Average
Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
Find the Sum of Salaries for the Last 3 Hired Employees*/

-- Lesson 21 WINDOW FUNCTIONS

--1

select *, ROW_NUMBER() over (order by saleDate) as Ranking from ProductSales;

--2

select *, DENSE_RANK() over (order by Quantity desc) as Ranking from ProductSales;

--3

With Top_Amount as (
		select *, ROW_NUMBER() 
		over (partition by customerID 
		order by quantity desc) as Ranking 
		from ProductSales
)
select * from top_Amount where Ranking = 1;

--4

select *, LEAD(SaleAmount) over (order by saleDate) as Ranking  from ProductSales;

--5

select *, LAG(SaleAmount) over (order by saleDate) as Ranking  from ProductSales;

--6
--There is no catagory column on the table that's why I use ProductName column.

select *, RANK() over (partition by productName order by Quantity desc) as Ranking from ProductSales; 

--7

With Ranking1 as (
select *, LAG(SaleAmount, 1, 0) over (order by SaleDate) as Ranking from ProductSales
)
select * from Ranking1 where SaleAmount > Ranking;

 --or with null. It does not show first day saleAmount

With Ranking1 as (
select *, LAG(SaleAmount) over (order by SaleDate) as Ranking from ProductSales
)
select * from Ranking1 where SaleAmount > Ranking;

--8

select *, (SaleAmount - (LAG(SaleAmount) over (order by saleDate))) as Difference from ProductSales;

--9

Select *, 
		CAST((SaleAmount - LEAD(SaleAmount) 
		over (order by saleDate))/(SaleAmount/100) as decimal(10,2)) as PercentageDifference 
		from ProductSales;

--10

	select *, 
		coalesce(Cast(SaleAmount / LAG(SaleAmount) 
		over (partition by ProductName 
		order by saleDate) as decimal(10,2)), 0) as ratio 
		from ProductSales;


--11

select *, 
		SaleAmount - FIRST_VALUE(SaleAmount) 
		over (partition by productName 
		order by SaleDate) as Difference 
		from ProductSales;

--12

With CTE as (
		select *, 
				case when saleAmount > LAG(saleAmount, 1, SaleAmount) 
				over (partition by productName 
				order by saledate) then 1 else 0 end as Ranking 
				from ProductSales 
)
select ProductName from CTE group by ProductName having SUM(Ranking) = COUNT(*) -1;

--13

select *, 
		coalesce(SUM(SaleAmount) 
		over (partition by productname 
		order by Saledate), 0) as Running_total 
		from ProductSales;

--14

select *, 
		COALESCE(CAST(ROUND(AVG(SaleAmount) 
		over (order by SaleDate 
		rows  between 2 preceding and current row), 2) as decimal(10,2)), 0) as M_avg 
		from ProductSales

		--or this option for M_AVG by ProductName

select *, 
		COALESCE(CAST(ROUND(AVG(SaleAmount) 
		over (partition by ProductName order by SaleDate 
		rows  between 2 preceding and current row), 2) as decimal(10,2)), 0) as M_avg 
		from ProductSales

--15

select *, CAST(ROUND(SaleAmount - AVG(SaleAmount) over(), 2) as decimal(10,2)) as Difference_AVG_S_amount from ProductSales;

-- or this option for AVG by ProductName

select *, 
		CAST(ROUND(SaleAmount - AVG(SaleAmount) 
		over(partition by productname), 2) as decimal(10,2)) as Difference_AVG_S_amount 
		from ProductSales;


--16

With CTE as (
select *, DENSE_RANK() over (order by salary) as Ranking from Employees1
)
Select * from CTE 
			where Ranking in (
					select Ranking 
					from CTE 
					group by Ranking 
					having COUNT(Ranking) > 1)

--17

With Top_salary as (
	select *, ROW_NUMBER() over (partition by department order by salary desc) as Ranking from Employees1
)
	Select * from Top_salary where Ranking <= 2;
--or this this option if there is ties

With Top_salary as (
	select *, DENSE_RANK() over (partition by department order by salary desc) as Ranking from Employees1
)
	Select * from Top_salary where Ranking <= 2;

--18

With Lowest_salary as(
	select *, DENSE_RANK() over (partition by department order by salary) Ranking from Employees1
)
	Select * from Lowest_salary where Ranking = 1;

	--or this option

With Lowest_salary as(
	select *, DENSE_RANK() over (partition by department order by salary) Ranking from Employees1
)
	Select * from Lowest_salary where Ranking = 1;

--19

select *, SUM(salary) over (partition by department order by EmployeeID) RunningTotal from Employees1

--20
select *, SUM(salary) over (partition by department) RunningTotal from Employees1;

--21

select *, CAST(Round(AVG(salary) over (partition by department), 2) as decimal(10,2)) as AVG_salary from Employees1 

--22

select *, 
		Salary - CAST(Round(AVG(salary) 
		over (partition by department), 2) as decimal(10,2)) as Difference_AVG_salary 
		from Employees1;

--23

select *, 
		CAST(ROUND(AVG(salary) 
		over (
		order by employeeID 
		rows between 1 preceding and 1 following), 2) as decimal(10,2)) 
		from Employees1;

--24

With Last_emp as (
	Select *, ROW_NUMBER() over (order by HireDate desc) Ranking from Employees1
)
	select EmployeeID, Name, SUM(salary) over () as SUM_salary  from Last_emp where Ranking <= 3;

--or

With Last_emp as (
	Select *, ROW_NUMBER() over (order by HireDate desc) Ranking from Employees1
)
	select SUM(salary) as SUM_salary  from Last_emp where Ranking <= 3;
