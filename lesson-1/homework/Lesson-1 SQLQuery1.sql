/* 

Data – Raw facts, figures, or information that can be processed or stored for use. 
Example: Names, numbers, or dates.

Database – A structured collection of data that allows for storage, retrieval, and management efficiently. 
Example: A customer database in a retail store.

Relational Database – A type of database that organizes data into tables with rows (records) and columns (attributes), using relationships between them. 
Example: SQL Server, MySQL, and PostgreSQL.

Table – A collection of data arranged in rows and columns within a relational database. Each row represents a record, and each column represents a specific attribute. 
Example: A "Students" table with columns for StudentID, Name, and Age.



Five Key Features of SQL Server:

Data Security – Supports encryption, authentication, and role-based access to protect data.

Scalability – Handles large amounts of data efficiently and can be used in both small applications and enterprise-level systems.

Backup and Recovery – Provides automated and manual backup options to prevent data loss.

High Performance – Optimized for fast query execution, indexing, and caching to improve efficiency.

Integration with BI & AI – Supports Business Intelligence (BI) tools like Power BI and AI-driven analytics.

Authentication Modes in SQL Server

Windows Authentication – Uses Windows credentials (Active Directory) to connect securely to SQL Server without requiring a separate SQL login.

SQL Server Authentication – Requires a username and password created within SQL Server, independent of Windows credentials.





CREATE DATABASE SchoolDB

USE SchoolDB 

CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT)

INSERT INTO Students values (1, 'Rose', 20), (2, 'Jeck', 20) , (3, 'Ann', 21)

select * from students

/* 
SQL is a language. Structured Quary Language. SQL is used to interact with databases in SQL Server and other DBMSs;

SQL SERVER is software which allow us to use database management system that stores and processes data;

SSMS is just a tool (like a control panel) to manage SQL Server more easily.
*/


/* 

DQL (Data Query Language). It includes only the SELECT statement.

SELECT * FROM Students;
SELECT Name, Age FROM Students WHERE Age > 20;

DML (Data Manipulation Language). Includes INSERT, UPDATE, and DELETE.

INSERT INTO Students (StudentID, Name, Age) VALUES (1, 'Rose', 20);

UPDATE Students SET Age = 21 WHERE Name = 'Rose';

DDL (Data Definition Language). Includes CREATE, ALTER, DROP, and TRUNCATE.

CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT);

ALTER TABLE Students ADD Email VARCHAR(100);

DROP TABLE Students;

TRUNCATE TABLE Students;

DCL (Data Control Language).It includes GRANT and REVOKE.

GRANT SELECT, INSERT ON Students TO user1;

REVOKE INSERT ON Students FROM user1;

TCL (Transaction Control Language)

BEGIN TRANSACTION;
UPDATE Students SET Age = 22 WHERE Name = 'Ann';
ROLLBACK; -- Undo the update

BEGIN TRANSACTION;
UPDATE Students SET Age = 23 WHERE Name = 'Ann';
SAVEPOINT Save1; -- Save this point
DELETE FROM Students WHERE Age < 20;
ROLLBACK TO Save1; -- Undo deletion but keep the update


BACKUP DATABASE SchoolDB  
TO DISK = 'C:\Backup\SchoolDB.bak'  
WITH FORMAT, MEDIANAME = 'SQLServerBackup', NAME = 'Full Backup of SchoolDB';


RESTORE DATABASE SchoolDB  
FROM DISK = 'C:\Backup\SchoolDB.bak'  
WITH REPLACE, RECOVERY;


