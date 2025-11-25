**The Gold Layer** is for business level use and follows business assumptions. It consist of Fact table and Dimension table. These tables purpose is for analysis and reporting.

1. **Gold.dim_customers** : Contains customer demographic detials.
   
|Column Name|Data Type|Decription|
|------|------|-----|
|customer_number|INT|Surrogate key created as a unique key for each customer record|
|customer_number|INT|Unique number for each customer as unique indentifier e.g 11000|
|customer_id|NVARCHAR|Text customer identifier unique for each customer e.g AW00011000|
|first_name|NVARCHAR|First name for the customer|
|last_name|NVARCHAR|Surname of the customer|
|country|NVARCHAR|Country each customer belong to e.g Australia|
|gender|NVARCHAR|The gender for each customer e.g Male, Female, n/a|
|marital_status|NVARCHAR|States where in customer is married or not e.g Married, Single|
|birth_date|DATE|Date of birth for each cusotmer e.g 1971-10-06|
|create_date|DATE|Date the customer record was created as YYYY-MM_DD|

2. **Gold.dim_products** : Contain information for each product and to which Catogory it belongs to.

|Column Name|Data Type|Decription|
|------|------|-----|
|product_key|INT|Surrogate key created as an uniqie identifier for each product|
|product_number|INT|Unique number use as a product identifier e.g 601|
|category_id|NVARCHAR|Text that is serves as a unique category identifier used to group products e.g CO_BB|
|product_id|NVARCHAR|Text that is serves as a unique product identifier e.g BB-7421 |
|product_name|NVARCHAR|Name for the product|
|category|NVARCHAR|Name of the category used to group products e.g Components,Bikes, n/a|
|sub_category|NVARCHAR|Name of the sub-category to which product belong to e.g Bottles and Cages, Mountain Bikes| 
|cost|FLOAT|The cost of each product|
|product_line|NVARCHAR|Name of the product line used to group products e.g Mountain, Road, n/a|
|maintenance|NVARCHAR|Identifies if the product is serviceable by the business e.g yes, no|
|start_dates|DATE|Date to at which the product was last updated as YYYY-MM_DD|

3. **Gold.fact_sales**: Contains all the transaction record of sales.

|Column Name|Data Type|Decription|
|------|------|-----|
|order_number|NVARCHAR|Sales order number to track the all order e.g SO63321|
|product_key|INT|Foriegn key to join product table|
|customer_key|INT|Foriegn key to join customer table|
|order_date|DATE|Date of the order was placed as YYYY-MM_DD e.g 2013-07-31|
|shipping_date|DATE|Date of the product was shipped to the customer as YYYY-MM_DD e.g 2013-08-07 |
|due_date|DATE|Date the product must have been shipped to the customeras YYYY-MM_DD e.g 2013-08-12|
|sales|FLOAT|Sales amount which equals to price multiplied by quantity|
|quantity|INT|The number of quantity of the prodcut order|
|price|FLOAT|The price of each product|
