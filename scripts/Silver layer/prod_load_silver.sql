/*
================================================================================
Stored Procedure: Load Silver layer data (Bronze > Silver)
________________________________________________________________________________
Script purpose:
	The store procedure perfoms Extract, Transform, Load (ETL), loading the 
	silver schema tables from the bronze schema.

Actions Performed: 
	Truncates silver tables.
	Load transformed and cleaned data from the bronze layer tables

Parameters:
	none

Usage Example:
	EXEC silver.load_silver;
 ===============================================================================
*/

CREATE OR ALTER  PROCEDURE silver.load_silver AS
BEGIN

	Declare @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		Print '=================================='
		Print 'Load cleaned CRM to silver layer'
		Print '=================================='

		-- TRUNCATING AND LOADING  crm_cust_info data 
		SET @batch_start_time = GETDATE()
		SET @start_time = GETDATE()
		Print 'Truncating table: Silver.crm_cust_info'
		TRUNCATE TABLE Silver.crm_cust_info
		Print 'Loading cleaned data: Silver.crm_cust_info'
		Insert into Silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select 
			cst_id,
			cst_key,
			trim(cst_firstname) cst_firstname, --Removing empty spaces
			trim(cst_lastname) cst_lastname, -- Removing empty spaces 
			case 
				when upper(trim(cst_marital_status)) = 'S' then 'Single'
				when upper(trim(cst_marital_status)) = 'M' then 'Married'
				else 'n/a'
			end cst_marital_status, -- normalising data to simple names
			case upper(trim(cst_gndr))
				when 'M' then 'Male'
				when 'F' then 'Female'
				else 'n/a'
			end cst_gndr, -- normalising data to simple names
			cast(cst_create_date as date) cst_create_date
			from (select
			*,
			ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) flagged
		from Bronze.crm_cust_info
		where cst_id is not null
		)t 
		where flagged = 1 --remove all duplicate primary key and retaining the last record
		SET @end_time = GETDATE()
		PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		Print '__________________________________________________'

		-- TRUNCATING AND LOADING  crm_prd_info data 
		SET @start_time = GETDATE()
		Print 'Truncating table: Silver.crm_prd_info'
		TRUNCATE TABLE Silver.crm_prd_info
		Print 'Loading cleaned data: Silver.crm_prd_info'
		insert into Silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') cat_id, --Derived new columns to join with other table 
			SUBSTRING(prd_key,7, len(prd_key)) prd_key, --Derived new columns to join with other table
			trim(prd_nm) prd_nm, -- removing unwanted spaces
			ISNULL(prd_cost,0) prd_cost, -- handling missing information
			case upper(trim(prd_line))
				when 'R' then 'Road'
				when 'M' then 'Mountain'
				when 'T' then 'Touring'
				when 'S' then 'Other Sales'
				else 'n/a'
			end prd_line, -- mapping code to be more descriptive
			cast(prd_start_dt as date) prd_start_dt,
			cast( cast(LEAD(prd_start_dt,1) over (partition by prd_key order by prd_start_dt) as datetime) - 1 as date) prd_end_dt -- calculating end date to make a it a date before the start date 
		from Bronze.crm_prd_info
		SET @end_time = GETDATE()
		PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		Print '__________________________________________________'

		-- TRUNCATING AND LOADING  crm_sales_details data 
		SET @start_time = GETDATE()
		Print 'Truncating table: Silver.crm_sales_details'
		TRUNCATE TABLE Silver.crm_sales_details
		Print 'Loading cleaned data: Silver.crm_sales_details'
		Insert into Silver.crm_sales_details (
		   sls_ord_num
		  ,sls_prd_key
		  ,sls_cust_id
		  ,sls_order_dt
		  ,sls_ship_dt
		  ,sls_due_dt
		  ,sls_sales
		  ,sls_quantity
		  ,sls_price
			)
		SELECT 
		   sls_ord_num
		  ,sls_prd_key
		  ,sls_cust_id
		  ,case 
			when sls_order_dt <= 0 or len(sls_order_dt) != 8 then Null
			else cast(cast(sls_order_dt as nvarchar) as date)
			end as sls_order_dt -- Removing invalid date and converting int to date 
		  ,
		  case 
			when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then Null
			else cast(cast(sls_ship_dt as nvarchar) as date)
			end as sls_ship_dt -- Removing invalid date and converting int to date 
		  ,
		  case 
			when sls_due_dt <= 0 or len(sls_due_dt) != 8 then Null
			else cast(cast(sls_due_dt as nvarchar) as date)
			end as sls_due_dt -- Removing invalid date and converting int to date 
		  ,case
			when sls_price * sls_quantity != sls_sales or sls_sales is null or sls_sales<=0 
				then abs(sls_price) * sls_quantity
			else sls_sales
			end as sls_sales -- Calculating correct sales amount
		  ,sls_quantity
		  ,abs(isnull(sls_price,sls_sales/nullif(sls_quantity,0))) as sls_price -- Calculating correct Price from sales amount
		FROM Bronze.crm_sales_details
		SET @end_time = GETDATE()
		PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		Print '__________________________________________________'

		Print '=================================='
		Print 'Load cleaned ERP to silver layer'
		Print '=================================='

		-- TRUNCATING AND LOADING  erp_cust_aZ12 data 
		SET @start_time = GETDATE()
		Print 'Truncating table: Silver.erp_cust_aZ12'
		TRUNCATE TABLE Silver.erp_cust_aZ12
		Print 'Loading cleaned data: Silver.erp_cust_aZ12'
		insert into Silver.erp_cust_aZ12
			(
			CID
			,BDATE
			,GEN
			)
		SELECT  
			case
				when CID like 'NASA%'
				then substring(CID,4,len(cid))
				else CID
			end as CID --Remove NASA to match cat_key in cust_info
			,case 
				  when [BDATE]>GETDATE() then Null
				  else BDATE
			end as bdate --Remove bdate that are in the future 
			,case 
				when UPPER(trim(gen)) in ('F', 'FEMALE') THEN  'FEMALE'
				when UPPER(trim(gen)) in ('M', 'MALE') THEN  'MALE'
				ELSE 'n/a'
			end as gen -- Cleaning and Map gen code to proper description
		 FROM [Datawarehouse].[Bronze].[erp_cust_aZ12]
		 SET @end_time = GETDATE()
		 PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		 Print '__________________________________________________'


		-- TRUNCATING AND LOADING  erp_loc_a101 data 
		 SET @start_time = GETDATE()
		 Print 'Truncating table: Silver.erp_loc_a101'
		 TRUNCATE TABLE Silver.erp_loc_a101
		 Print 'Loading cleaned data: Silver.erp_loc_a101'
		 Insert into Silver.erp_loc_a101
			(
			CID
			,CNTRY
			)
		 SELECT 
				replace([CID],'-','') as CID --removing '-' from ID to match cat_key in cust_info
			,case
			when CNTRY = 'DE' then 'Germany'
			when CNTRY in ('US','USA') then 'United States'
			when CNTRY = '' or CNTRY is null then 'n/a'
			else CNTRY
			end as CNTRY -- Cleaning and Map gen code to proper description
		 FROM [Datawarehouse].[Bronze].[erp_loc_a101]
		 SET @end_time = GETDATE()
		 PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		 Print '__________________________________________________'

		-- TRUNCATING AND LOADING  erp_px_cat_g1v2 data 
		 SET @start_time = GETDATE()
		 Print 'Truncating table: Silver.erp_px_cat_g1v2'
		 TRUNCATE TABLE Silver.erp_px_cat_g1v2
		 Print 'Loading cleaned data: Silver.erp_px_cat_g1v2'
		 insert into Silver.erp_px_cat_g1v2
			(
			ID
			,CAT
			,SUBCAT
			,MAINTENANCE
			)
		 SELECT
				[ID]
				,[CAT]
				,[SUBCAT]
				,[MAINTENANCE]
		 FROM [Datawarehouse].[Bronze].[erp_px_cat_g1v2]
		 SET @end_time = GETDATE()
		 PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds'
		 Print '__________________________________________________'

		 Print '=================================='
		 SET @batch_end_time = GETDATE()
		 Print 'Load cleaned data to silver layer completed'
		 PRINT 'Total Load duration:' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' Seconds'
		 Print '=================================='
	END TRY

	BEGIN CATCH

	 Print '=================================='
	 Print 'Truncating and Loading data error to the Silver layer'
	 Print 'Error message: ' + ERROR_MESSAGE()
	 Print 'Error message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
	 Print 'Error message: ' + CAST(ERROR_STATE() AS NVARCHAR)
	 Print '=================================='

	END CATCH

END
