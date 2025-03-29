/*
===================================================================================
Quality Checks
===================================================================================
Script Purpose:
    This script performs quality checks and validates the integrity, consistency,
    and accuracy of the gold layer. These checks ensure:

  - Uniqueness of surrogate keys in dimension tables.
  - Refrential integrity between fact and dimensions table.

Run these checks after loading the silver layer
=====================================================================================

--Checking Customers

SELECT cst_id, COUNT(*) FROM
(
	SELECT
*
	FROM silver.crm_cust_info ci
	INNER JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	INNER JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) > 1;


--Checking Products

SELECT prd_key,count(*) FROM
(
SELECT *
  FROM [DataWarehouse].[silver].[crm_prd_info] pr
  LEFT JOIN [silver].[erp_px_cat_g1v2] pc
  ON pr.cat_id = pc.id
WHERE prd_end_dt IS NULL ----ONLY Current Data, No historical data
)t GROUP BY prd_key
 HAVING count(*) > 1
