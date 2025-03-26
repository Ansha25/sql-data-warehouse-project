# sql-data-warehouse-project
A Data Warehouse project utilizing SQL Server, encompassing an ETL process, data modeling, and analytics.

**What is a data warehouse?**
A Data Warehouse is a subject-oriented, integrated, time-variant, and non-volatile collection of data, designed to support management decision-making processes. 

Subject-Oriented: A data warehouse organizes data around specific subjects, such as sales or customer interactions, making it easier to analyze.
Integrated: It consolidates data from different sources, ensuring consistency by resolving any conflicts in data formats or definitions.
Time-Variant: Unlike operational systems, a data warehouse stores historical data over extended periods, allowing trend analysis and time-based insights.
Non-Volatile: Once data is stored in the warehouse, it remains stable; it cannot be deleted or altered, ensuring historical accuracy and reliability.


In this project, we have a source table containing the incoming data. This data needs to be stored in a data warehouse, which will later be utilized to derive business insights. Before the data is moved to the data warehouse, it undergoes the ETL process.

ETL, which stands for Extract, Transform, and Load, is a core process in building and maintaining a data warehouse. It enables organizations to:
Extract: Retrieve data from multiple sources.
Transform: Clean, validate, and standardize the data to ensure consistency and usability.
Load: Store the transformed data into a centralized repository for efficient analysis and informed decision-making.

![](ETL.png)



The above image illustrates the data transformation journey from its raw form to actionable business insights. We can compare this process to the operations of a restaurant:

- Every morning, a restaurant receives a fresh supply of vegetables, just like the incoming raw data we collect from various sources.
- These vegetables are cleaned, sorted, and stored in the refrigerator. Similarly, raw data is processed, validated, and organized during the ETL process before being stored securely in the data warehouse.
- When a customer places an order, the restaurant retrieves the required vegetables, prepares a dish, and serves it to the customer. Likewise, when insights are needed for business purposes, the stored data is retrieved, analyzed, and transformed into valuable information that supports decision-making.

# ETL Process

## Extraction in ETL
Extraction is the process of retrieving data from various sources to prepare it for transformation and loading.

**Extraction Methods**:  
- Pull Extractions  
- Push Extractions  

**Extraction Types**:  
- Full Extraction  
- Incremental Extraction  

**Extraction Techniques**:  
- Manual Data Extraction  
- Database Querying  
- File Parsing  
- API  
- Event-Based Streaming  
- CDC  
- Web Scraping  

## Transformation in ETL
Transformation involves cleaning, formatting, and converting raw data into a structured format. This step ensures the data aligns with the requirements of the target system for accurate analysis and usage.

**Transformation Methods**:  
- Data Enrichment  
- Data Normalization & Standardization  
- Data Integration  
- Business Rules & Logic  
- Derived Columns  
- Data Aggregations  

**Data Cleansing**:  
- Remove Duplicates  
- Data Filtering  
- Handling Missing Data  
- Outlier Detection  
- Datatype Casting  
- Handling Unwanted Spaces & Invalid Values  

## Load in ETL
Load is the process of transferring transformed data into a target system, such as a database or data warehouse. It ensures the data is available and ready for analysis or reporting.

**



















