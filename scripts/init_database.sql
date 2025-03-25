/*
===================================================
Create Database and Schemas
===================================================
  Script Purpose:
  This script creates a new database name 'DataWarehouse' after checking if it already exists in the database. If exists it drops and creates a new one. Additionally 
  we create the three required schemas 'Bronze' , 'Silver' and 'Gold'.

  WARNING:
  Once You run this script the database if existing will get dropped and all the data gets erased. 
  So ensure that there is a backup existing and then go ahead and run the script

*/

USE master;
Go

--Drop and recreate the DataWarehouse database
   
IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

--Create database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--create all the required schemas as per the Medallion approach
CREATE SCHEMA bronze;
GO;
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO;
