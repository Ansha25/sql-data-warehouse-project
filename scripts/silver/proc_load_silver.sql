/*
  =================================================================
  Stored procedure: Load bronze layer

This script begins by truncating the existing tables to clear any previous data. 
It then inserts data from the bronze tables, performing the necessary data cleaning and transformations.

  Usage : EXEC silver.load_silver;
 ========================================================================
*/



CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	SET @batch_start_time = GETDATE()
	BEGIN TRY

	SET @start_time = GETDATE();
	PRINT '===TRUNCATING DATA FROM: [silver].[crm_cust_info]'
	TRUNCATE TABLE [silver].[crm_cust_info]
	PRINT '===INSERTIING DATA INTO: [silver].[crm_cust_info]'

	INSERT INTO [silver].[crm_cust_info](
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
	)
	SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
				ELSE 'n/a'
			END AS cst_marital_status,
			CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
				ELSE 'n/a'
			END as cst_gndr,
			cst_create_date
			FROM (SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_last
	FROM [bronze].[crm_cust_info]  WHERE cst_id is not null) t
	WHERE flag_last = 1
	SELECT count(*) FROM [silver].[crm_cust_info];
	SET @end_time = GETDATE()
	PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Seconds'


	PRINT '========================================================================'

	PRINT '===TRUNCATING DATA FROM: [silver].[crm_prd_info]'
	TRUNCATE TABLE [silver].[crm_prd_info]
	PRINT '===INSERTIING DATA INTO: [silver].[crm_prd_info]'

	SET @start_time = GETDATE();
	INSERT INTO [silver].[crm_prd_info]
			([prd_id]
			,[cat_id]
			,[prd_key]
			,[prd_nm]
			,[prd_cost]
			,[prd_line]
			,[prd_start_dt]
			,[prd_end_dt]
	)
	SELECT 
	[prd_id]
		  ,REPLACE(SUBSTRING([prd_key],1,5),'-','_') AS cat_id 
		  ,SUBSTRING([prd_key],7,LEN([prd_key])) AS prd_key
		  ,[prd_nm]
		  ,ISNULL([prd_cost],0) AS [prd_cost]
		  ,CASE UPPER(TRIM([prd_line]))
				WHEN  'M' THEN 'Mountain'
				WHEN  'R' THEN 'Road' 
				WHEN  'S' THEN 'Other Sales'
				WHEN  'T' THEN 'Touring'
				ELSE 'n/a'
			END as [prd_line]
		  ,CAST([prd_start_dt] AS DATE)
		  ,CAST(LEAD([prd_start_dt]) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
	  FROM [DataWarehouse].[bronze].[crm_prd_info];
	  SELECT count(*) FROM [silver].[crm_prd_info];
	  SET @end_time = GETDATE()
	 PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + 'Seconds'

	PRINT '========================================================================'

	PRINT '===TRUNCATING DATA FROM: [silver].[crm_sales_details]'
	TRUNCATE TABLE [silver].[crm_sales_details]
	PRINT '===INSERTIING DATA INTO: [silver].[crm_sales_details]'

	SET @start_time = GETDATE();
	INSERT INTO [silver].[crm_sales_details](
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
	)
	SELECT  [sls_ord_num]
		  ,[sls_prd_key]
		  ,[sls_cust_id]
		  ,CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
			END AS sls_order_dt
		  ,CASE WHEN [sls_ship_dt] = 0 OR LEN([sls_ship_dt]) != 8 THEN NULL
				ELSE CAST(CAST([sls_ship_dt] AS VARCHAR)AS DATE)
			END AS sls_ship_dt
		  ,CASE WHEN [sls_due_dt] = 0 OR LEN([sls_due_dt]) != 8 THEN NULL
				ELSE CAST(CAST([sls_due_dt] AS VARCHAR)AS DATE)
			END AS [sls_due_dt]
		  ,CASE WHEN [sls_sales] IS NULL OR [sls_sales] <= 0  OR [sls_sales] != sls_quantity * ABS(sls_price)
				THEN [sls_quantity] * ABS([sls_price])
		   ELSE [sls_sales]
		   END AS [sls_sales]
		  ,[sls_quantity]
		  ,CASE WHEN [sls_price] IS NULL OR [sls_sales] <= 0 
				 THEN [sls_sales]/NULLIF([sls_quantity],0)
			ELSE [sls_price]
			END AS [sls_price]
	  FROM [bronze].[crm_sales_details];
	  SELECT count(*) FROM [silver].[crm_sales_details];
	  SET @end_time = GETDATE()
	PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + 'Seconds'

	PRINT '========================================================================'

	PRINT '===TRUNCATING DATA FROM: [silver].[erp_cust_az12]'
	TRUNCATE TABLE [silver].[erp_cust_az12]
	PRINT '===INSERTIING DATA INTO: [silver].[erp_cust_az12]'

	SET @start_time = GETDATE();
	INSERT INTO [silver].[erp_cust_az12](
			 [cid]
			,[bdate]
			,[gen]
	)
	SELECT 
		  CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
				ELSE cid
			END AS cid
		 ,CASE WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
		END AS bdate
		 ,CASE 
			   WHEN  UPPER(TRIM(gen)) IN('F','FEMALE') THEN 'Female'
			   WHEN UPPER(TRIM(gen)) IN('M','MALE') THEN 'Male'
			   ELSE gen
			END AS gen
	  FROM [bronze].[erp_cust_az12]
	  SELECT count(*) FROM [silver].[erp_cust_az12];
	  SET @end_time = GETDATE()
	PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + 'Seconds'

	PRINT '========================================================================'

	PRINT '===TRUNCATING DATA FROM: [silver].[erp_loc_a101]'
	TRUNCATE TABLE [silver].[erp_loc_a101]
	PRINT '===INSERTIING DATA INTO: [silver].[erp_loc_a101]'

	SET @start_time = GETDATE();
	INSERT INTO [silver].[erp_loc_a101](
			 [cid]
			,[cntry]
	)
	SELECT  REPLACE([cid],'-','')
		  ,CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry
	  FROM [DataWarehouse].[bronze].[erp_loc_a101]
	  SELECT count(*) FROM [silver].[erp_loc_a101];
	  SET @end_time = GETDATE()
	PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + 'Seconds'

	PRINT '========================================================================'

	PRINT '===TRUNCATING DATA FROM: [silver].[erp_px_cat_g1v2]'
	TRUNCATE TABLE [silver].[erp_px_cat_g1v2]
	PRINT '===INSERTIING DATA INTO: [silver].[erp_px_cat_g1v2]('

	SET @start_time = GETDATE();
	INSERT INTO [silver].[erp_px_cat_g1v2](
			 [id]
			,[cat]
			,[subcat]
			,[maintenance]
	)
	SELECT  [id]
		  ,[cat]
		  ,[subcat]
		  ,[maINTenance]
	  FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]
	  SELECT count(*) FROM [silver].[erp_px_cat_g1v2];
	  SET @end_time = GETDATE()
	PRINT 'LOAD TIME:' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + 'Seconds'

	  END TRY

	  BEGIN CATCH
		PRINT ' --------------------'
		PRINT 'ERROR OCCURED'
		print 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT '---------------------'
	END CATCH

	SET @batch_end_time = GETDATE()
	PRINT 'TOTAL LOAD TIME:' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time)AS NVARCHAR) + 'Seconds'

END
