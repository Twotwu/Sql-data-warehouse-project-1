/* 
===================================================
Create a database and schemas
===================================================

script purpose: 
Create a data warehouse with a schemas bronze, silver and gold. The script check the existance
of warehouse, drops and then creates a new one.

warning:
The script deletes permantently all data warehouse data and create a new empty warehouse, 
so be careful sense the are no back ups
*/

Use master;
go

if exists (select 1 from sys.databases where name = 'Datawarehouse')
begin 
	ALTER DATABASE Datawarehouse  SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE	Datawarehouse
end;
GO

-- Creating database
CREATE DATABASE Datawarehouse;
go

use Datawarehouse;
go

-- Create schemas
CREATE SCHEMA Bronze;
go

CREATE SCHEMA Silver;
go

CREATE SCHEMA Gold;
go
