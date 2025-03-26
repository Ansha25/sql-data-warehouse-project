/*
  =================================================================
  Stored procedure: Load bronze layer

  This script truncates the tables befor loading
  next it bulk inserts the data into the tables

  Usage : EXEC bronze.load_bronze;
 ========================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME;
	
BEGIN TRY
	SET @start_time = GETDATE();
	PRINT '================================================='
	PRINT 'Loading the bronze layer'
	PRINT '================================================='


	PRINT '----------------------------------------------'
	PRINT 'Loading CRM Tables'
	PRINT '----------------------------------------------'
	TRUNCATE TABLE [bronze].[crm_cust_info];
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[crm_cust_info]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'


	TRUNCATE TABLE [bronze].[crm_prd_info];
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[crm_prd_info]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'
	

	TRUNCATE TABLE [bronze].[crm_sales_details]
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[crm_sales_details]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'
	
	PRINT '----------------------------------------------'
	PRINT 'Loading ERP Tables'
	PRINT '----------------------------------------------'

	TRUNCATE TABLE [bronze].[erp_cust_az12]
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[erp_cust_az12]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'
	

	TRUNCATE TABLE [bronze].[erp_loc_a101]
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[erp_loc_a101]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'
	

	TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
	
	SET @start_time = GETDATE();
	BULK INSERT [bronze].[erp_px_cat_g1v2]
	FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\Projects\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOAD TIME : ' + CAST(DATEDIFF(SECOND, @Start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT'--------'
	SET @end_time = GETDATE();
	PRINT 'TOTAL LOAD TIME FOR BRONZE LAYER: ' + CAST(DATEDIFF(SECOND,@Start_time , @end_time) AS NVARCHAR)+ 'Seconds'
	END TRY
	BEGIN CATCH
		PRINT ' --------------------'
		PRINT 'ERROR OCCURED'
		print 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT '---------------------'
	END CATCH
	

END
