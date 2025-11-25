/*
================================================================================
DDL script: Create Gold Views
________________________________________________________________________________
Script purpose:
	
	This script create the gold layer schema and views.
	This layer applies all the business rules.
	Dropping the existing view if they already exists.
	Running this script to re-define the DDL structure of the gold views

Usage:
	The views can be used for analytics and reporting.

 ===============================================================================
*/

-- check if View dim_customers and if so, drop it
if OBJECT_ID('Gold.dim_customers','V') is not null 
	drop table Gold.dim_customers;
go

-- create View for dim_customers and import records from Silver tables 
CREATE VIEW Gold.dim_customers as
select 
ROW_NUMBER() OVER (ORDER BY ci.cst_id) as customer_key, --creating a surrogate key
ci.cst_id as customer_number,
ci.cst_key as customer_id,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
l.CNTRY as country,
CASE WHEN ci.cst_gndr = 'n/a' then ISNULL(c.GEN,'n/a')
	WHEN c.GEN is null then ci.cst_gndr
	else ci.cst_gndr
END as gender, -- Integrating gender columns from crm_cust_info and erp_cust_aZ12 (master table) to handle missing values
ci.cst_marital_status as marital_status,
c.BDATE as birth_date,
ci.cst_create_date as create_date
from Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_aZ12 c
ON ci.cst_key = c.CID
LEFT JOIN Silver.erp_loc_a101 l
ON ci.cst_key = l.CID;

go

-- check if View dim_products and if so, drop it
if OBJECT_ID('Gold.dim_products','V') is not null 
	drop table Gold.dim_products;
go

-- create View for dim_products and import records from Silver tables 
CREATE VIEW Gold.dim_products AS
SELECT 
ROW_NUMBER() OVER (ORDER BY prd_key) as product_key, --creating a surrogate key
p.prd_id as product_number,
p.cat_id as category_id, 
p.prd_key as product_id,
p.prd_nm as product_name,
ISNULL(px.CAT,'n/a') as category, --n/a missing values
ISNULL(px.SUBCAT,'n/a') as sub_category,--n/a missing values
p.prd_cost as cost,
p.prd_line product_line,
ISNULL(px.MAINTENANCE,'n/a') as maintenance,--n/a missing values
p.prd_start_dt as start_dates
FROM Silver.crm_prd_info p
LEFT JOIN Silver.erp_px_cat_g1v2 px
ON p.cat_id = px.ID
WHERE p.prd_end_dt IS NULL -- selecting the most recent version of the product

go

-- check if View fact_sales and if so, drop it
if OBJECT_ID('Gold.fact_sales','V') is not null 
	drop table Gold.fact_sales;
go

-- create View for dim_products and import records from Silver tables 
CREATE VIEW Gold.fact_sales AS 
SELECT 
s.sls_ord_num AS order_number,
p.product_key,
c.customer_key,
s.sls_order_dt AS order_date,
s.sls_ship_dt AS shipping_date,
s.sls_due_dt AS due_date,
s.sls_sales AS sales,
s.sls_quantity AS quantity,
s.sls_price AS price
FROM Silver.crm_sales_details s
LEFT JOIN Gold.dim_customers c
ON s.sls_cust_id = c.customer_number
LEFT JOIN Gold.dim_products p
ON s.sls_prd_key = p.product_id

