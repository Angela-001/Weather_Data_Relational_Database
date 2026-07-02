-- ============================================================
-- Weather Data Relational Database
-- Database setup, table creation, data cleaning, and analysis
-- ============================================================


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE MeteorologicalData;
USE MeteorologicalData;


-- ============================================================
-- 2. TABLE CREATION
-- ============================================================

-- Raw county table
CREATE TABLE org_county (
    countyName VARCHAR(25),
    countyID VARCHAR(8)
);

-- Normalized county table
CREATE TABLE County AS
SELECT DISTINCT
    countyID,
    countyName
FROM org_county;


-- Station table
CREATE TABLE Station (
    stationID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    countyID VARCHAR(15) NOT NULL
);

-- Temperature table
CREATE TABLE Temperature (
    tempID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    tempValue VARCHAR(15) NOT NULL
);

-- Precipitation table
CREATE TABLE Precipitation (
    precipID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    precipValue VARCHAR(15) NOT NULL
);

-- Pressure table
CREATE TABLE Pressure (
    pressID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    pressValue VARCHAR(15) NOT NULL
);


-- ============================================================
-- 3. DATA CLEANING
-- ============================================================

-- Convert precipitation date values from text to DATE format
UPDATE Precipitation
SET recordDate = STR_TO_DATE(recordDate, '%m/%d/%Y');

ALTER TABLE Precipitation
MODIFY COLUMN recordDate DATE;

-- Convert pressure date values from text to DATE format
UPDATE Pressure
SET recordDate = STR_TO_DATE(recordDate, '%m/%d/%Y');

ALTER TABLE Pressure
MODIFY COLUMN recordDate DATE;


-- ============================================================
-- 4. ANALYTICAL QUERIES
-- ============================================================

-- Query 1: View pressure records
SELECT *
FROM Pressure;


-- Query 2: Monthly precipitation totals for South Carolina
SELECT
    YEAR(recordDate) AS p_year,
    MONTH(recordDate) AS p_month,
    SUM(CAST(precipValue AS DECIMAL(10,2))) AS total_precipitation
FROM Precipitation
WHERE stationName LIKE 'USW%'
GROUP BY
    p_year,
    p_month
ORDER BY
    p_year,
    p_month;


-- Query 3A: Yearly precipitation totals for South Carolina
CREATE TABLE MonthlySC AS
SELECT
    YEAR(recordDate) AS p_year,
    SUM(CAST(precipValue AS DECIMAL(10,2))) AS total_precipitation
FROM Precipitation
WHERE stationName LIKE 'USW%'
GROUP BY p_year;


-- Query 3B: Yearly precipitation totals for Georgia
CREATE TABLE MonthlyGA AS
SELECT
    YEAR(recordDate) AS p_year,
    SUM(CAST(precipValue AS DECIMAL(10,2))) AS total_precipitation
FROM Precipitation
WHERE stationName LIKE 'USR0000G%'
GROUP BY p_year;


-- Query 3C: Yearly precipitation totals for Florida
CREATE TABLE MonthlyFL AS
SELECT
    YEAR(recordDate) AS p_year,
    SUM(CAST(precipValue AS DECIMAL(10,2))) AS total_precipitation
FROM Precipitation
WHERE stationName LIKE 'USR0000F%'
GROUP BY p_year;


-- Query 3D: Compare yearly precipitation trends across SC, GA, and FL
SELECT
    MonthlySC.p_year,
    MonthlySC.total_precipitation AS SC_precipitation,
    MonthlyGA.total_precipitation AS GA_precipitation,
    MonthlyFL.total_precipitation AS FL_precipitation
FROM MonthlySC
JOIN MonthlyGA
    ON MonthlySC.p_year = MonthlyGA.p_year
JOIN MonthlyFL
    ON MonthlySC.p_year = MonthlyFL.p_year
ORDER BY MonthlySC.p_year;


-- Query 4: Hurricane-season precipitation and pressure analysis
SELECT
    Pressure.recordDate,
    Pressure.pressValue,
    Precipitation.precipValue
FROM Pressure
JOIN Precipitation
    ON Precipitation.recordDate = Pressure.recordDate
    AND Precipitation.stationName = Pressure.stationName
WHERE MONTH(Pressure.recordDate) BETWEEN 6 AND 11
ORDER BY CAST(Precipitation.precipValue AS DECIMAL(10,2)) DESC;
