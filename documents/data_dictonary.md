# Data Dictonary for Gold Layer

## Overview

The gold layer represents a business-centric data model designed to support analytical and reporting use cases. 
It is structured with dimension tables and fact tables, providing a comprehensive and meaningful view of the data for decision-making and insights.

### 1.gold_dim_customers
 - Purpose: Stores customers details with demographic and geographic data
 - Columns:

| Column Name          | Data Type    | Description                                                                      |
|----------------------|------------- |----------------------------------------------------------------------------------|
| customer_key         | INT          | Surrogate key uniquely identifying each customer record in the dimension table.  |
| customer_id          | INT          | Unique numerical identifier assigned to each customer.                           |
| customer_number      | NVARCHAR(50) | Alphanumeric number representing the customer, used for tracking and referencing.|
| first_name           | NVARCHAR(50) | First name of the customer.                                                      |
| last_name            | NVARCHAR(50) | Last name of the customer.                                                       |
| country              | NVARCHAR(50) | Country of the customer.                                                         |
| marital_status       | NVARCHAR(50) | Marital status of the customer.(Married/single)                                  |
| gender               | NVARCHAR(50) | Gender of the customer.(Male/Female)                                             |
| birthdate            | DATE         | Birth date of the customer.(YYYY-MM-DD)                                          |
| create_date          | DATE         | The date when customer record is created.(YYYY-MM-DD)                            |

### 2.gold_dim_products
 - Purpose: Stores product details, including categories, subcategories, and product line.
 - Columns:

| Column Name          | Data Type    | Description                                                                      |
|----------------------|------------- |----------------------------------------------------------------------------------|
| product_key          | INT          | Surrogate key uniquely identifying each product record in the dimension table.   |
| product_id           | INT          | Unique numerical identifier assigned to each product.                            |
| product_number       | NVARCHAR(50) | Alphanumeric number representing the product, used for tracking and refrencing.  |
| product_name         | NVARCHAR(50) | Name of the product.                                                             |
| category_id          | NVARCHAR(50) | Alphanumeric number representing Category number of the product.                 |
| category             | NVARCHAR(50) | Category name of the product.                                                    |
| sub_category         | NVARCHAR(50) | Sub category of the product.                                                     |
| maintainence         | NVARCHAR(50) | Required Maintainence.(Yes/No)                                                   |
| cost                 | INT          | Cost of the product.                                                             |
| product_line         | NVARCHAR(50) | Product line to which the product belongs.(Road, Mountain)                       |
| start_date           | DATE         | The date when the product became available.(YYYY-MM-DD)                          |

### 3.gold_fact_sales
 - Purpose: Stores transactional sales data.
 - Columns:

| Column Name          | Data Type    | Description                                                                      |
|----------------------|------------- |----------------------------------------------------------------------------------|
| order_number         | NVARCHAR(50) | A unique alphanumeric identifier for each sales order.                           |
| product_key          | INT          | Surrogate key linking product dimension table.                                   |
| customer_key         | INT          | Surrogate key linking customer dimension table.                                  |
| order_date           | DATE         | The date when the order was placed.                                              |
| ship_date            | DATE         | The date when order was shipped.                                                 |
| due_date             | DATE         | The date when the payment for the order was due.                                 |
| sales                | INT          | The total value of the sale for the line item,in whole currency unit.            |
| quantity             | INT          | The number of units of the product ordered for the line item.                    |
| price                | INT          | The price per unit of the product for the line item,in whole currency units.     |





