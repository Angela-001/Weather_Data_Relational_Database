# Weather Data Relational Database
## Overview

Designed and implemented a normalized relational database in MySQL to manage and analyze historical weather data collected from NOAA weather stations across South Carolina, Georgia, and Florida. 
The project demonstrates database design, SQL querying, data preparation, normalization, and performance evaluation using over 200,000 weather observations per measurement type.

## Technologies
- MySQL
- SQL
- Python
- NOAA Climate Data
- Sequel Ace

## Skills Demonstrated
- Relational Database Design
- Database Normalization
- SQL Joins
- Aggregate Queries
- Nested Queries
- Data Cleaning
- Performance Analysis
- ETL

## Project Workflow

1. Collected historical weather data from NOAA.
2. Cleaned and prepared the data using Python.
3. Designed a normalized relational database schema.
4. Imported weather station, county, temperature, precipitation, and pressure data into MySQL.
5. Wrote SQL queries to analyze precipitation trends, weather patterns, and hurricane-season conditions.
6. Evaluated query performance across different query types.

## Database Tables

- **County** – Stores county identifiers and names.
- **Station** – Stores weather station information and county relationships.
- **Temperature** – Daily temperature observations.
- **Precipitation** – Daily precipitation measurements.
- **Pressure** – Daily atmospheric pressure measurements.

## Example Analyses

- Monthly precipitation totals for South Carolina
- Yearly precipitation trend comparison across South Carolina, Georgia, and Florida
- Hurricane-season precipitation and pressure analysis
- Query performance comparison

## Repository Contents

- `README.md` — Project overview and documentation
- `weather_database_queries.sql` — SQL database setup, table creation, cleaning, and analytical queries

## Challenges & Solutions

## Challenges & Solutions

### Large Dataset Performance

The original NOAA datasets contained more than 200,000 weather observations per measurement type. To improve development efficiency, the working dataset was reduced to a representative five-year subset while preserving the database design for larger datasets.

### Missing Data

Historical NOAA data contained missing observations. Python preprocessing was used to prepare the datasets prior to importing them into MySQL, enabling more reliable SQL analysis.
