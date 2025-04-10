
-- Lesson 2: DDL and DML Commands

--Basic-Level Tasks (10)
--1
create table Employees (EmpID int, name varchar(50), salary decimal(10,2))
--2
insert into Employees values (1, 'Power', 50000);
insert into Employees values (2, 'Jeck', 60000), (3, 'Ann', 55000);
--3
update Employees 
set salary = 70000
where EmpID  = 1;
--4
delete Employees 
where EmpID = 2;

--5

-- Removes specific rows (can use WHERE)
DELETE FROM TestTable WHERE id = 1;

-- Removes all rows but keeps table structure
DELETE FROM TestTable;

-- Removes all rows instantly
TRUNCATE TABLE TestTable;
-- Completely removes table structure
DROP TABLE TestTable;

/*DELETE: Erasing specific lines in a notebook

TRUNCATE: Tearing out all pages but keeping the cover

DROP: Throwing away the entire notebook*/

--6
alter table employees
alter column name varchar(100);

--7
alter table employees
add department varchar(50);

--8

alter table employees
alter column salary float
--9
create table Departments (DepartmentID int primary key, Departmentname varchar(50));
--10
truncate table employees;

--Intermediate-Level Tasks (6)

--11
insert into
Departments select top 5 * from 
Departments1;

--12

update Employees 
set department = 'Management'
where salary > 5000;

--13
truncate table Employees; --or
DELETE FROM Employees;

--14
alter table Employees
drop column department;

--15
EXEC sp_rename 'Employees', 'StaffMembers';

--16

drop table Departments


-- Advanced-Level Tasks (9)

--17

create table Products 
	(ProductID int primary key, ProductName varchar(50), 
	Category varchar(50), price decimal(10, 2), SupplierID int);

--18
alter table products
add constraint Check_Price check (price > 0);

--19
ALTER TABLE Products
ADD StockQuantity INT NOT NULL DEFAULT 50;
--20

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

--21

insert into Products (ProductID, ProductName, ProductCategory, Price, SupplierID)
values
    (1, 'Wireless Keyboard', 'Electronics', 45.99, 101),
    (2, 'Bluetooth Headphones', 'Electronics', 89.99, 102),
    (3, 'Stainless Steel Water Bottle', 'Kitchen', 24.95, 103),
    (4, 'Desk Organizer', 'Office Supplies', 19.99, 104),
    (5, 'Yoga Mat', 'Fitness', 29.50, 105);

--22

select * into Products_Backup from Products;

--23

Exec sp_rename 'products', 'Inventory';  

--24
alter table Inventory
drop constraint Check_Price;

alter table Inventory
alter column price float

alter table Inventory
add constraint Check_Price check (price > 0);

--25

alter table Inventory
add ProductCode int identity (1000, 5) not null;

