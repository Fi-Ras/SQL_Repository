-- Active: 1686445526786@@127.0.0.1@3306@sakila
 -- Select all columns from the TABLES system database
 SELECT * 
 FROM INFORMATION_SCHEMA.TABLES
 -- Filter by schema
 WHERE table_schema = 'public' ;

  -- Select all columns from the COLUMNS system database
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS 
 WHERE table_name = 'actor';

-- Get the column name and data type
SELECT
 	COLUMN_NAME, 
    DATA_TYPE
-- From the system database information schema
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';

--Interval data types
SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;

-- Select the title and special features column 
SELECT 
  title, 
  special_features
FROM film;

-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[1] = 'Trailers';

-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[2] = 'Deleted Scenes';

SELECT
  title, 
  special_features 
FROM film 
-- Modify the query to use the ANY function 
WHERE 'Trailers' = ANY (special_features);

SELECT 
  title, 
  special_features 
FROM film 
-- Filter where special_features contains 'Deleted Scenes'
WHERE special_features @> ARRAY['Deleted Scenes'];
