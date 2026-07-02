/* 
CREATE DATABASE MeteorologicalData;
USE MeteorologicalData;


-- ------------------------------------------------------------------
CREATE TABLE org_county(
    countyName VARCHAR(25),
    countyID VARCHAR(8)
);

SELECT * FROM org_county;

CREATE TABLE County AS
SELECT DISTINCT countyId, countyName
FROM org_county;

SELECT * FROM County;

-- ------------------------------------------------------------------

-- Station table
CREATE TABLE Station (
    stationID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    countyId VARCHAR(15) NOT NULL
);



CREATE TABLE stations AS
SELECT DISTINCT(stationName), countyId
FROM Station;


SELECT * FROM stations;
-- ------------------------------------------------------------------


-- Temperature table  
CREATE TABLE Temperature (
    tempID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    tempValue VARCHAR(15) NOT NULL
);


SELECT * FROM Temperature;
-- ------------------------------------------------------------------


-- Precipitation table  
CREATE TABLE Precipitation (
    precipID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    precipValue VARCHAR(15) NOT NULL
);

SELECT * FROM Precipitation;



-- ------------------------------------------------------------------


-- Pressure table  
CREATE TABLE Pressure (
    pressID INT AUTO_INCREMENT PRIMARY KEY,
    stationName VARCHAR(15) NOT NULL,
    recordDate VARCHAR(15) NOT NULL,
    pressValue VARCHAR(15) NOT NULL
);

SELECT * FROM Pressure;





-- --------------------------------------------------------
-- --------------------------------------------------------


UPDATE Precipitation
SET recordDate = STR_TO_DATE(recordDate, '%m/%d/%Y');
ALTER TABLE Precipitation
MODIFY COLUMN recordDate DATE;

-- getting the monthly total precip across all stations in SC

SELECT YEAR(recordDate) AS p_year, MONTH(recordDate) AS p_month, SUM(precipValue) AS total_precipitation
FROM Precipitation
WHERE stationName LIKE 'USW%'  -- stations that start with 'USW' correspond to SC
GROUP BY 
    p_year, p_month 
ORDER BY 
    p_year, p_month;

-- --------------------------------------
-- see the trend over multiple years for sc.


CREATE TABLE MonthlySC AS
SELECT 
    YEAR(recordDate) AS p_year, 
    SUM(precipValue) AS total_precipitation
FROM 
    Precipitation
WHERE 
    stationName LIKE 'USW%'  -- stations that start with 'USW' correspond to SC
GROUP BY 
    p_year
ORDER BY 
    total_precipitation DESC;  -- order by total precipitation from highest to lowest


-- --------------------------------------
-- see the trend over multiple years for ga.
CREATE TABLE MonthlyGA AS
SELECT 
    YEAR(recordDate) AS p_year, 
    SUM(precipValue) AS total_precipitation
FROM 
    Precipitation
WHERE 
    stationName LIKE 'USR0000G%'  -- stations that start with 'USR0000G' correspond to GA
GROUP BY 
    p_year
ORDER BY 
    total_precipitation DESC;  -- order by total precipitation from highest to lowest


-- --------------------------------------
-- see the trend over multiple years for fl.
CREATE TABLE MonthlyFL AS
SELECT 
    YEAR(recordDate) AS p_year, 
    SUM(precipValue) AS total_precipitation
FROM 
    Precipitation
WHERE 
    stationName LIKE 'USR0000F%'  -- stations that start with 'USR0000F' correspond to FL
GROUP BY 
    p_year
ORDER BY 
    total_precipitation DESC;  -- order by total precipitation from highest to lowest
    
    

-- --------------------------------------
-- subquery; Join to track trend across states  
   
SELECT 
    p_year,
    SC_precipitation, 
    GA_precipitation, 
    FL_precipitation
FROM 
    (
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
    ) AS StatesTrend;




-- hurricane season 
-- change to date type
UPDATE Pressure
SET recordDate = STR_TO_DATE(recordDate, '%m/%d/%Y');
ALTER TABLE Pressure
MODIFY COLUMN recordDate DATE;

-- change to date type
UPDATE Precipitation
SET recordDate = STR_TO_DATE(recordDate, '%m/%d/%Y');
ALTER TABLE Precipitation
MODIFY COLUMN recordDate DATE;


-- filter to get precip and pressure values for hurricane season
SELECT 
    Pressure.recordDate, 
    Pressure.pressValue,
    Precipitation.precipValue
FROM 
    Pressure
JOIN 
    Precipitation 
    ON Precipitation.recordDate = Pressure.recordDate 
    AND Precipitation.stationName = Pressure.stationName  
WHERE 
    MONTH(Pressure.recordDate) BETWEEN 6 AND 11  -- Filter for months between June and November
ORDER BY 
    Precipitation.precipValue DESC;  -- Order by precip value */
