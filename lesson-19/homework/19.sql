
--Lesson-19: Subqueries and Exists

--Level 1: Basic Subqueries

--1. Find Employees with Minimum Salary

select * from employees where salary = (select MIN(salary) from employees);

--2. Find Products Above Average Price

Select * from products where price > (select AVG(price) from products);

--Level 2: Nested Subqueries with Conditions

--3. Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. 
--Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)

Select *, ( 
		select d.department_name 
		from departments d 
		where d.id = e.department_id) Department_Name 
		from employees e 
		where e.department_id = 1;

--4

select * from customers where customer_id not in (Select customer_id from orders);

--5

select * 
		from products p2 
		where price = (
		Select MAX(price) 
		from products p1 
		where p1.category_id = p2.category_id ) 
		order by price desc;

--6

select * 
		from employees e1 
		where department_id = (
		Select top 1 department_id 
		from (
		select e2.department_id, AVG(salary) Avg_salary 
		from employees e2 
		group by e2.department_id) as dep_avg 
		order by Avg_salary desc);

		--or

	select * 
		from employees e1 
		where exists (select 1 from (
		Select top 1 department_id 
		from (
		select e2.department_id, AVG(salary) Avg_salary 
		from employees e2 
		group by e2.department_id) as dep_avg 
		order by Avg_salary desc) as top_1 
		where e1.department_id = top_1.department_id);

--7

select * 
		from employees e1
		where salary > (
		select AVG_salary 
		from (
		select department_id, AVG(salary) AVG_salary 
		from employees e2 
		group by e2.department_id) as AVG_dep 
		where AVG_dep.department_id = e1.department_id);

--8

select * 
		from students s 
		where s.student_id in (
		select g.student_id 
		from grades g 
		where g.grade = (
		select max_grade 
		from (
		select g2.course_id, MAX(grade) max_grade 
		from grades g2 
		group by g2.course_id) as max_g 
		where g.course_id = max_g.course_id));

		--or--

select * 
	from students s 
	where exists (
    select 1
    from grades g
    where g.student_id = s.student_id
    and g.grade = (
    select MAX(g2.grade)
    from grades g2
    where g2.course_id = g.course_id));

--9

select * 
		from products p1 
		where price = (
			select MIN(price) 
			from ( 
				select distinct top 3 p2.price 
				from products p2 
				where p2.category_id = p1.category_id 
				order by price desc) as Top_price);


--10
select * 
		from employees e 
		where salary > (
			select AVG(salary) 
			from employees) and salary < (
				select MAX(salary) 
				from employees e2 
				where e2.department_id = e.department_id);
