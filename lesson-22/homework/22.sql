use Lesson_22_HW

--1

select *, SUM(total_amount) over (partition by customer_id order by sale_id) as Running_Total from sales_data;

--2

select *, COUNT(sale_id) over (partition by product_category) as Total_orders from sales_data;

--3

With MAX_price as (
select *, ROW_NUMBER() over (partition by product_category order by unit_price desc) Max_unit_price from sales_data
)
select * from MAX_price where Max_unit_price = 1;

--or this option

select distinct s.product_category, s.product_name, s.unit_price  
		from sales_data s join (
			select product_category, MAX(unit_price) as Max_price 
			from sales_data 
			group by product_category) as s2 
			on s.product_category = s2.product_category 
			and s.unit_price =s2.Max_price; 

--4
With MIN_price as (
select *, ROW_NUMBER() over (partition by product_category order by unit_price) Min_unit_price from sales_data
)
select * from MIN_price where Min_unit_price = 1;

--or this option

select * 
		from sales_data s join (
			select product_category, MIN(unit_price) as Min_price 
			from sales_data 
			group by product_category) as s2 
			on s.product_category = s2.product_category 
			and s.unit_price =s2.Min_price;

			--or

	select product_category, MIN(unit_price) as MIN_unit_price from sales_data group by product_category;

--5

select *, 
		CAST(ROUND(AVG(total_amount) 
		over (
		order by order_date 
		rows between 1 preceding and 1 following), 2) as decimal(10,2)) as M_avg 
		from sales_data;

--6

select *, SUM(total_amount) over (partition by region) as Total_re from sales_data;

--or

Select region, SUM(total_amount) Total_re from sales_data group by region;

--7


with Total1 as (
	select distinct customer_id, customer_name, SUM(total_amount) over (partition by customer_id) as Total from sales_data
)
	select *, ROW_NUMBER() over (order by Total desc) as Ranking from Total1;


--8

select *, 
		coalesce(LAG(total_amount) 
		over (partition by customer_id 
		order by order_date)  - total_amount, 0) as Difference 
		from sales_data;

--9

With Top_expensive_p as (
select *, ROW_NUMBER() over (partition by product_category order by unit_price desc) as Ranking from sales_data
)
select * from Top_expensive_p where Ranking <= 3;

--10

select *, SUM(total_amount) over (partition by region order by order_date) Runing_total from sales_data;

--11

select *, SUM(total_amount) over (partition by product_category order by order_date, sale_id) Runing_total from sales_data;

--12



--13

select coalesce(SUM(value) over (order by value rows between unbounded preceding  and 1 preceding), 0) Sum_previous from OneColumn

--14



--15

Select 
		customer_id, 
		customer_name 
		from sales_data 
		group by customer_id, customer_name 
		having  count(distinct product_category) > 1 

--16

with Above_avg as (
select *, AVG(total_amount) over (partition by region) AVG_a, SUM(total_amount) over (partition by customer_id) Sum_a from sales_data
)
select distinct customer_id, customer_name from Above_avg where Sum_a > AVG_a;

--17

With Ranking1 as (
select *, SUM(total_amount) over (partition by customer_id, region) as Total_spending from sales_data
)
select *, DENSE_RANK() over (partition by region order by total_spending desc) as Ranking from Ranking1;

--18

select *, SUM(total_amount) over (partition by customer_id order by order_date) Runing_total from sales_data;

--19



