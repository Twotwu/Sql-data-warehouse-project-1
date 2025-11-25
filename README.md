# Data Warehouse and Analytics Project
Building a SQL warehouse with SQL server, which will include ETL processes, data modeling and analytics. This project demostrate what I have learn in my ambitious journey to becoming a data, devop and AI engineer in pursuit of mastering the usage of data.
#
# Project Overview
This Project involves: 

1. **Data Architechure**: Using the Medallion Architecture of using **Bronze, Silver** and **Gold** layers to design and build a modern data warehouse.
2. **ETL Pipelines**: Extract, Transform and Load data from source into the Warehouse and creating Power BI report.
3. **Data Modelling**:Develop and optimise a fact and dimension tables in the **Gold** layer.
4. **Analytics & Reporting**: Design and build a Power BI report for actionable insights

This repository showcase my skills in SQL development, Data architect, Data engineering, ETL Pipeline development, Data modeling and Power BI data analytics.

#
#Tools used:
1. Datasets: CSV files.
2. SQL Server Express: Hosting my own SQL daatabase.
3. SQL Server Management Studio (SSMS): Managing and interacting with datasets.
4. GIT Repository: Management of versions of my code.
5. DrawIO: Design data architecture, models, flows and diagrams.

#
# Project Requirements
**Build a Data Warehouse (Data Engineering) and Power BI Reports (Data Analytics)**

**Objective:**
Develop a data warehouse using SQL from two sources systems, ERP and CRM, provided as CSV files to enable analytics and reporting for informed decision-making.

- **Data Source**: Import data from two sources systems, ERP and CRM, provided as CSV files
- **Data Cleaning**: Clean and impove the quality issues
- **Integration**: Combine sources into single, friendly data model to use for analysis.
- **Scope**: Only the latest dataset required, current data only.
- **Documentation**: Clear documentation of data model to support stakeholders.

#
# BI: Analytics and Reporting
**Objective**:

-Customer Behaviour

<img width="1267" height="705" alt="image" src="https://github.com/user-attachments/assets/17be6109-c1bf-4cf3-829a-b0541bb89236" />

**Insights to empower stakeholders for stragetic decisions**
#
# Data Architecture
The data architeture for this project follows Medallion Architure of using **Bronze, Silver** and **Gold** layers

<img width="1026" height="791" alt="Data Architecture drawio" src="https://github.com/user-attachments/assets/214b549c-22bd-4f3f-a537-423f483fd1e4" />

- **Bronze Layer**: Ingest raw dats without any clean or transformations in to SQL Server Database.
- **Silver Layer**: data cleaning, transformation, standardisation, normalization and loading it to Silver tables preparing the data for analysis.
- **Gold Layer**: Load business-ready data, using a star schema model ready for analysis and reporting

#
# About Me
I am Kevin Zola Shembe a Data Analyst, I have a mission to becoming a Data, devop and AI Engineer to manipulate and data end to end.
