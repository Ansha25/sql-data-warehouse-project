/*
================================================================================
DDL Script: Create Gold Views
================================================================================
Script Purpose:
   The script creates vies for gold layer in the data warehouse.
   Also represents the dimensions and fact tables in the star schema data model.

Usage:
  -These can be directly queried directly for analytics and reporting
================================================================================

--=======================================
--create Dimension : gold_dim_customers
--=======================================

--=======================================
--create Dimension : gold_dim_customers
--=======================================

IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key
	,ci.cst_id AS customer_id
	,ci.cst_key AS customer_number
	,ci.cst_firstname AS first_name
	,ci.cst_lastname AS last_name
	,la.cntry AS country
	,ci.cst_marital_status AS marital_status
	,CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM IS THE MASTER INFO FOR GENDER
	ELSE COALESCE(ca.gen,'n/a')
	END AS gender
	,ca.bdate AS birthdate
	,ci.cst_create_date AS create_date
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid;
GO


--=======================================
--create Dimension : gold.dim_products
--=======================================

IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

 CREATE VIEW gold.dim_products AS
 SELECT 
      ROW_NUMBER() OVER (ORDER BY prd_start_dt,prd_end_dt) AS product_key
      ,pr.[prd_id] AS product_id
	  ,pr.[prd_key] AS product_number
      ,pr.[prd_nm] AS product_name
      ,pr.[cat_id] AS category_id
	  ,pc.cat AS category
	  ,pc.subcat AS sub_category
	  ,pc.maintenance
      ,pr.[prd_cost] AS cost
      ,pr.[prd_line] AS product_line
      ,pr.[prd_start_dt] AS start_date
  FROM [DataWarehouse].[silver].[crm_prd_info] pr
  LEFT JOIN [silver].[erp_px_cat_g1v2] pc
  ON pr.cat_id = pc.id
WHERE prd_end_dt IS NULL ----ONLY Current Data, No historical data
GO


--=======================================
--create Dimension : gold.fact_sales
--=======================================

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT [sls_ord_num] AS order_number
      ,pr.product_key 
      ,cu.customer_key 
      ,[sls_order_dt] AS order_date
      ,[sls_ship_dt] AS ship_date
      ,[sls_due_dt] AS due_date
      ,[sls_sales] AS sales
      ,[sls_quantity] AS quantity
      ,[sls_price] AS price
  FROM [DataWarehouse].[silver].[crm_sales_details] s
  LEFT JOIN gold.dim_products pr
  ON s.sls_prd_key = pr.product_number
  LEFT JOIN gold.dim_customers AS cu
  ON s.sls_cust_id = cu.customer_id
