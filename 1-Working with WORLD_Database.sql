/* In this script, we need to import the "WORLD" database from this link:
https://dev.mysql.com/doc/index-other.html

To import a database in MySQL, we need to follow these steps:

Click on:
Server
-> * Data Import
-> * Check the second box "Import from Self-Contained File"
-> * Specify the schema of the SQL database
*/
/* Now let us see the databases */
SHOW DATABASES;

/* Use the world database */
USE world;

/* Show the tables of the database */
SHOW TABLES;

/* Show the country table */
SELECT *
FROM country;

/* Show the shape of the table /
SELECT
(SELECT COUNT() FROM country) AS "Row Numbers",
(SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_NAME = 'country') AS "Column Numbers";

/* Describe the table and see the content of its columns */
-- Method 1
DESCRIBE country;
-- Method 2
SHOW COLUMNS FROM country;

/* Show and count the regions & the unique regions */
SELECT Region
FROM country;

SELECT COUNT(DISTINCT Region) AS "Unique Region"
FROM country;

/* Show the unique regions in ascending order & descending order */
-- Ascending order
SELECT DISTINCT *
FROM country
ORDER BY Region;
-- Descending order
SELECT DISTINCT *
FROM country
ORDER BY Region DESC;

/* Select the Code (alias Code Pays), Name (alias Nom Pays), Continent, Population, and GNP (alias Produits National Brut) */
SELECT
Code AS 'Code de Pays',
Name AS 'Nom de Pays',
Continent,
Population,
GNP AS 'Produits National Brut'
FROM country;

/* Show only the first 3 lines */
SELECT
Code AS 'Code de Pays',
Name AS 'Nom de Pays',
Continent,
Population,
GNP AS 'Produits National Brut'
FROM country
LIMIT 3;

/* Show only the last 3 lines */
-- Method 1: LIMIT N (total rows) - N (number of last lines that we're looking for)
/* Step 1: Count the total number of rows /
SELECT COUNT() FROM country;
/* Step 2: Use the total number of rows to subtract from the rest */
SELECT
Code AS 'Code de Pays',
Name AS 'Nom de Pays',
Continent,
Population,
GNP AS 'Produits National Brut'
FROM country
LIMIT 236, 3;

/* Show only the last 3 lines */
-- Method 2: Using ORDER BY...DESC to reverse the order of the rows, then we use LIMIT
SELECT
Code AS 'Code de Pays',
Name AS 'Nom de Pays',
Continent,
Population,
GNP AS 'Produits National Brut'
FROM country
ORDER BY Name DESC
LIMIT 3;

/* Show and count countries where life expectancy is lower than 50 */
SELECT
Code AS 'Code de Pays',
Name AS 'Nom de Pays',
Continent,
Population,
GNP AS 'Produits National Brut'
FROM country
WHERE LifeExpectancy < 50;

SELECT COUNT(*) AS "Countries with Life Expectancy < 50"
FROM country
WHERE LifeExpectancy < 50;

/* Show and count countries where their names start with 'T' */
SELECT *
FROM country
WHERE Name LIKE 'T%';

SELECT COUNT(*) AS "Number of Countries with names starting with T"
FROM country
WHERE Name LIKE 'T%';

/* Show and count countries where their names end with 'T' */
SELECT *
FROM country
WHERE Name LIKE '%T';

SELECT COUNT(*) AS "Number of Countries with names ending with T"
FROM country
WHERE Name LIKE '%T';

/* Show and count countries where their names contain 't' */
SELECT *
FROM country
WHERE Name LIKE '%t%';

SELECT COUNT(*) AS "Number of Countries with names containing T"
FROM country
WHERE Name LIKE '%t%';

/* Show and count countries where the independence year is empty */
SELECT *
FROM country
WHERE IndepYear IS NULL;

SELECT COUNT(*) AS "Number of Countries with empty Independence Year"
FROM country
WHERE IndepYear IS NULL;

/* Show and count countries where the GNPOld year is not empty */
SELECT *
FROM country
WHERE GNPOLD IS NOT NULL;

SELECT COUNT(*) AS "Number of Countries with GNPOld"
FROM country
WHERE GNPOLD IS NOT NULL;

/* Show and count countries where the independence year is between 1940 and 1960 */
SELECT *
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960;

SELECT COUNT(*) AS "Number of Countries with Independence Year between the 1940s and 1960s"
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960;

/* Combine multiple conditions using <AND>
With AND, both conditions must be true for the row to be included in the result */

-- 1. Show and count countries where the independence year is between 1940 and 1960
-- and where the name of the country starts with 'T'
SELECT *
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960
AND
Name LIKE 'T%';

SELECT COUNT(*) AS "Number of Countries with Independence Year between the 1940s and 1960s starting with T"
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960
AND
Name LIKE 'T%';

/* Combine multiple conditions using <OR>
With OR, if any of the conditions are true, then the row is added to the result */

-- 1. Show and count countries where the independence year is between 1940 and 1960
-- or where the name of the country starts with 'T'
SELECT *
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960
OR
Name LIKE 'T%';

SELECT COUNT(*) AS "Number of Countries with Independence Year between the 1940s and 1960s or starting with T"
FROM country
WHERE IndepYear BETWEEN 1940 AND 1960
OR
Name LIKE 'T%';

/* SQL's way of handling if-then logic cases
Each WHEN tests a condition and the following THEN gives us the string if the condition is true.
The ELSE gives us the string if all the above conditions are false.
The CASE statement must end with END. */

SELECT Name,
CASE
WHEN Continent = 'Europe' OR Continent = 'North America'
THEN 'Probably developed country'

WHEN Continent = 'Asia' OR Continent = 'Africa'
THEN 'Probably undeveloped country'

ELSE 'Undetermined'
END AS 'Country Classification'
FROM country;