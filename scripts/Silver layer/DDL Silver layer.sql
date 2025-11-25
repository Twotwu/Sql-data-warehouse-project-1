/*
================================================================================
DDL script: Create Silver Tables
________________________________________________________________________________
Script purpose:
	This script create the silver later schema and tables.
	Dropping the existing table if they already exists.
	Running this script to re-define the DDL structure of the silver tables
 ===============================================================================
*/


-- check if table cust_info exists and if so, drop it
if OBJECT_ID('silver.crm_cust_info','U') is not null 
	drop table silver.crm_cust_info;
go

-- silver table cust info 
CREATE TABLE silver.crm_cust_info
(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getdate()

);
go

-- check if table prd_info exists and if so, drop it
if OBJECT_ID('silver.crm_prd_info','U') is not null 
	drop table silver.crm_prd_info;
go

-- silver table cust info 
CREATE TABLE silver.crm_prd_info
(
	prd_id		int,
	cat_id		nvarchar(50),
	prd_key		nvarchar(50),
	prd_nm		nvarchar(50),
	prd_cost	float,
	prd_line	nvarchar(50),
	prd_start_dt date,
	prd_end_dt	date,
	dwh_create_date datetime2 default getdate()

);
go

-- check if table sales details exists and if so, drop it
if OBJECT_ID('silver.crm_sales_details','U') is not null 
	drop table silver.crm_sales_details;
go

-- silver table sales details 
CREATE TABLE silver.crm_sales_details
(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales float,
	sls_quantity int,
	sls_price float,
	dwh_create_date datetime2 default getdate()

);
go


-- check if table CUST_AZ12 exists and if so, drop it
if OBJECT_ID('silver.erp_cust_aZ12','U') is not null 
	drop table silver.erp_cust_aZ12;
go

-- silver table CUST_AZ12
CREATE TABLE silver.erp_cust_aZ12
(
	CID nvarchar(50),
	BDATE date,
	GEN nvarchar(50),
	dwh_create_date datetime2 default getdate()

);
go

-- check if table LOC_A101 exists and if so, drop it
if OBJECT_ID('silver.erp_loc_a101','U') is not null 
	drop table silver.erp_loc_a101;
go

-- silver table LOC_A101
CREATE TABLE silver.erp_loc_a101
(
	CID nvarchar(50),
	CNTRY nvarchar(50),
	dwh_create_date datetime2 default getdate()

);
go

-- check if table PX_CAT_G1V2 exists and if so, drop it
if OBJECT_ID('silver.erp_px_cat_g1V2','U') is not null 
	drop table silver.erp_px_cat_g1v2;
go

-- silver table PX_CAT_G1V2
CREATE TABLE silver.erp_px_cat_g1v2
(
	ID nvarchar(50),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(50),
	dwh_create_date datetime2 default getdate()

);
go
