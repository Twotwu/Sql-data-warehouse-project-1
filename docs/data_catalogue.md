**The Gold Layer** is for business level use and follows business assumptions. It consist of Fact table and Dimension table.

1. **Gold.dim_customers** : Contains customer demographic detials.
   
|Column Name|Data Type|Decription|
|------|------|-----|
|customer_number|INT|Surrogate key created as a unique key for each customer record|
|customer_number|INT|Unique number for each customer as unique indentifier|
|customer_id|NVARCHAR|Text customer identifier unique for each customer|
|first_name|NVARCHAR|First name for the customer|
|last_name|NVARCHAR|Surname of the customer|
|country|NVARCHAR|Country each customer belong to|
|gender|NVARCHAR|The gender for each customer|
|birth_date|DATE|Date of birth for each cusotmer 
|create_date|DATE|Date the customer record was created|

2. **Gold.dim_products** : Contain information for each product and to which Catogory it belongs to.

|Column Name|Data Type|Decription|
|------|------|-----|
|product_key|INT|Surrogate key created as an uniqie identifier for each product|
|product_number|INT|Unique number use as a product identifier|
|category_id|NVARCHAR|Text that is serves as a unique category identifier used to group products|
|product_id|NVARCHAR|Text that is serves as a unique product identifier |
|product_name|NVARCHAR|Name for the product|
|category|NVARCHAR|Name of the category used to group products|
|sub_category|NVARCHAR|Name of the sub-category to which product belong to| 
|cost|FLOAT|The cost of each product|
|product_line|NVARCHAR|Name of the product line used to group products|
|maintenance|NVARCHAR|Identifies if the product is serviceable by the business|
|start_dates|DATE|Date to at which the product was last updated|

3. **Gold.fact_sales**: Contains all the transaction record of sales.

|Column Name|Data Type|Decription|
|------|------|-----|
|order_number|NVARCHAR|Sales order number to track the all order|
|product_key|INT|Foriegn key to join product table|
|customer_key|INT|Foriegn key to join customer table|
|order_date|DATE|Date of the order was placed|
|shipping_date|DATE|Date of the product was shipped to the customer|
|due_date|DATE|Date the product must have been shipped to the customer|
|sales|FLOAT|Sales amount which equals to price multiplied by quantity|
|quantity|INT|The number of quantity of the prodcut order|
|price|FLOAT|The price of each product|
