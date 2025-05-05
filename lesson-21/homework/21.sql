
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


