

/*

DATA CLEANING IN SQL PROJECT

--Create database [AirbnbIn]
--Import file and create table [dbo].[Airbnb_India]
--Create duplicate table [dbo].[Airbnb_IndiaWork] from raw table [dbo].[Airbnb_India] to work upon


*** Data Cleaning Steps taken:
		1) Finding duplicate values and deleting them.
		2) Standardize Data.
				-Trim Text
				-Spell Check
				-Upper/Lower case to Proper case
				-Check for NULL/Blank Values and auto populate it where applicable
		3) Remove irrelevant column(s) if any.
		4) Finally, exporting the cleaned data to use further.
*/



USE AirbnbIn

--View the improted data in the table [dbo].[Airbnb_India]
SELECT * 
FROM Airbnb_India


--create New Table [dbo].[Airbnb_IndiaWork]. Will use this table throughout the project.
--Script to create table structure (minus data) from existing table.
SELECT *
INTO Airbnb_IndiaWork
FROM Airbnb_India
WHERE 1=2
GO

--Insert data from one RAW table to newly created Table.
INSERT INTO Airbnb_IndiaWork
SELECT * 
FROM Airbnb_India

--Data Cleaning Steps taken:
-- (1) Finding duplicate values, if any; with ROW_NUMBER()
SELECT *,
	ROW_NUMBER() 
		OVER(
				PARTITION BY 
					city
				  , city_state
				  , isHostedBysuperhost
				  , location_latitude
				  , location_longitude
				  , numberOfGuests
				  , price
				  , stars
				ORDER BY city
			) AS RowNumber 
FROM Airbnb_IndiaWork
GO

--Script to see only Duplicate Rows in the Table using CTE
WITH duplicaterow_CTE AS
(
	SELECT *,
	ROW_NUMBER() 
		OVER(
				PARTITION BY 
					city
				  , city_state
				  , isHostedBysuperhost
				  , location_latitude
				  , location_longitude
				  , numberOfGuests
				  , price
				  , stars
				ORDER BY city
			) AS RowNumber 
FROM Airbnb_IndiaWork
)
SELECT *
FROM duplicaterow_CTE
WHERE RowNumber >=2
GO

--Delete duplicate rows and verify again
WITH duplicaterow_CTE AS
(
	SELECT *,
	ROW_NUMBER() 
		OVER(
				PARTITION BY 
					city
				  , city_state
				  , isHostedBysuperhost
				  , location_latitude
				  , location_longitude
				  , numberOfGuests
				  , price
				  , stars
				ORDER BY city
			) AS RowNumber 
FROM Airbnb_IndiaWork
)
DELETE
FROM duplicaterow_CTE
WHERE RowNumber > 1
GO


-- (2) Standardize Data.
--Trim data for columns, as required. 
SELECT city , TRIM(city)
FROM Airbnb_IndiaWork
GO

UPDATE Airbnb_IndiaWork
SET city = TRIM(city)


--Trimmed the trailing (.) period.
SELECT CITY, TRIM(TRAILING '.' FROM city)
FROM Airbnb_IndiaWork
WHERE city LIKE 'karj%'
GO

UPDATE Airbnb_IndiaWork 
SET city = TRIM(TRAILING '.' FROM city)
WHERE city LIKE 'karj%'
GO


--Spell Check
--check for any data and then update accordingly. I have noted few scrips here.

SELECT DISTINCT city
FROM Airbnb_IndiaWork
GO

UPDATE Airbnb_IndiaWork
SET city_state = 'Tamil Nadu'
WHERE city_state = 'TN'
GO

UPDATE Airbnb_IndiaWork
SET city_state = 'Alibaug'
WHERE city_state = 'Alibag'
GO


SELECT DISTINCT isHostedBySuperhost
FROM Airbnb_IndiaWork
GO

UPDATE Airbnb_IndiaWork
SET isHostedBySuperhost = 'FALSE'
WHERE isHostedBySuperhost = 'FAALSE'
GO


--Case cleaning
SELECT city_state
FROM Airbnb_IndiaWork
WHERE city_state ='goa'


UPDATE Airbnb_IndiaWork
SET city_state = 'Goa'
WHERE city_state = 'goa'
GO


--Check for NULL/Blank values.
SELECT * 
FROM Airbnb_IndiaWork

--We have NULL/Blank values in 'city_state' and 'stars' columns. 
--I worked on 'city_state' column only and kept 'stars' columns as it is.
SELECT city_state
FROM Airbnb_IndiaWork
WHERE city_state IS  NULL
GO

SELECT *
FROM Airbnb_IndiaWork
WHERE city_state ='' OR city_state IS NULL
GO

SELECT *
FROM Airbnb_IndiaWork
WHERE city = 'Jaipur'
--WHERE city_state ='' OR city_state IS NULL
GO

--Found 8 null values in 'city_state' column. 
--I used self join the and used it to auto-populate the values from t2 table to t1 table.
SELECT t1.city
     , t1.city_state
	 , t2.city_state
FROM Airbnb_IndiaWork t1
	JOIN Airbnb_IndiaWork t2
	ON t1.city = t2.city
WHERE t1.city_state IS NULL
	AND t2.city_state IS NOT NULL
GROUP BY t1.city
	   , t1.city_state
	   , t2.city_state
GO

--auto-populate the values from t2 table to t1 table.
UPDATE t1
SET  t1.city_state = t2.city_state
FROM Airbnb_IndiaWork t1 JOIN Airbnb_IndiaWork t2
ON t1.city = t2.city
WHERE t1.city_state IS NULL
AND	t2.city_state IS NOT NULL
GO

--Verify the NULL values. Look for the 'city' and 'city_state' column if update happened as expected.
SELECT *
FROM Airbnb_IndiaWork
WHERE city_state IS NULL
GO

SELECT city, city_state
FROM Airbnb_IndiaWork
WHERE city LIKE 'VIJ%'
   OR city = 'NASHIK'
GO


SELECT *
FROM Airbnb_IndiaWork
GO

--THE END--