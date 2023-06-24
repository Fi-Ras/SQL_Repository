/*In This script w need to Import "WORLD" databases from this link :
 https://dev.mysql.com/doc/index-other.html

To import database in mysql we need to click on:

*Server 
    -> *Data Import 
        -> *Cocher la deuxième case "Import from Self-Contained File"
            -> *Préciser le shéma de la base sql
*/

/*Now Let us see the data bases*/
SHOW DATABASES;


/*Use world database*/
USE world;


/*Show the tables of the database*/
SHOW tables ;


/*Show country table*/
SELECT * 
FROM country;


/*Show the Shape of the table*/
SELECT (SELECT COUNT(*) FROM country) AS  "Row Numbers",
       (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_NAME = 'Country') AS "Columns Numbers";


/*Describe the table and see the content of its columns*/
--Methode 1
DESCRIBE country;
--Methode 2
SHOW COLUMNS FROM country;

/*Show and count the Regions & the Unique Regions*/
SELECT Region 
FROM Country;

SELECT COUNT (Region) AS "Unique Region"
FROM country;

--We can use DISTINCT to Show & Count
SELECT DISTINCT Region 
FROM Country;

SELECT COUNT (DISTINCT Region) AS "Unique Region"
FROM country;


/*Show the Unique Regions ascending order & descending order */
--Ascending order
SELECT DISTINCT * 
FROM Country
ORDER BY Region;
--Descending order
SELECT DISTINCT * 
FROM Country
ORDER BY Region DESC;


/*Select the Code Alias Code Pays, 
             Name Alias Nom Pays, 
             Continent, 
             Population and 
             GNP Alias Produits National Brut*/
SELECT 
   Code As 'Code de Pays', 
   Name AS 'Nom de Pays',
   Continent,
   Population,
   GNP AS 'Produits National Brut'
FROM country;

/*Show only 3 the first 3 lines*/
SELECT 
   Code As 'Code de Pays', 
   Name AS 'Nom de Pays',
   Continent,
   Population,
   GNP AS 'Produits National Brut'
FROM country
LIMIT 3 ;

/*Show only 3 the last 3 lines*/
-------------------------------
--Methode 1 LIMIT N(total rows)-N(number of last lines that we look for)
/*STEP1 : Count the total number of rows*/
SELECT COUNT (*) FROM country;
/*STEP2 : use the total number of rows to susbsract from the rest*/
SELECT 
   Code As 'Code de Pays', 
   Name AS 'Nom de Pays',
   Continent,
   Population,
   GNP AS 'Produits National Brut'
FROM country
LIMIT 236,3;

/*Show only 3 the last 3 lines/
------------------------------
Methode 2 Using ORDER BY .... DESC to inverse the order of the ROWS
then we use LIMIT*/
SELECT 
   Code As 'Code de Pays', 
   Name AS 'Nom de Pays',
   Continent,
   Population,
   GNP AS 'Produits National Brut'
FROM country
ORDER BY Name DESC
LIMIT 3;


/*Show and count countries where life expectancy is lower than 50*/
SELECT 
   Code As 'Code de Pays', 
   Name AS 'Nom de Pays',
   Continent,
   Population,
   GNP AS 'Produits National Brut'
FROM country
WHERE LifeExpectancy < 50;

SELECT COUNT (*) AS "Countries with LifeExpectancy < 50"
FROM country
WHERE LifeExpectancy < 50;


/*Show and count Countries where there names starts with T*/
SELECT * 
FROM Country
WHERE Name LIKE "T%";

SELECT COUNT(*) AS "N° Countries with names strat by T"
FROM Country
WHERE Name LIKE "T%";


/*Show and count Countries where there names ends with T*/
SELECT * 
FROM Country
WHERE Name LIKE "%T";

SELECT COUNT(*) AS "N° Countries with names end by T"
FROM Country
WHERE Name LIKE "%T";


/*Show and count Countries where there names contain t*/
SELECT * 
FROM Country
WHERE Name LIKE "%t%";

SELECT COUNT(*) AS "N° Countries with names contain T"
FROM Country
WHERE Name LIKE "%t%";


/*Show and count Countries where the independance year is Empty*/
SELECT * 
FROM Country
WHERE IndepYear IS NULL;

SELECT COUNT(*) AS "N° Countries with empthy IY"
FROM Country
WHERE IndepYear IS NULL;


/*Show and count Countries where the GNPOld year is not Empty*/
SELECT * 
FROM Country
WHERE GNPOLD IS NOT NULL;

SELECT COUNT(*) AS "N° Countries with GNPOLG"
FROM Country
WHERE GNPOLD IS NOT NULL;

/*Show and count Countries where the independance year is between 1940 and 1960*/
SELECT * 
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960;

SELECT COUNT(*) AS "N° Countries with IY btw 40s and 60s"
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960;


/*Combine multiple conditions
->First uing : <AND>
With AND, both conditions must be true for the row to be included in the result.

1-Show and count Countries where the independance year is between 1940 and 1960
and where the name of the country starts with T*/
SELECT * 
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960
AND
Name Like 'T%';

SELECT COUNT(*) AS "N° Countries with IY btw 40s and 60s starts with T"
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960
AND
Name Like 'T%';


/*Combine multiple conditions
->First uing : <OR>
With OR, if any of the conditions are true, then the row is added to the result.

1-Show and count Countries where the independance year is between 1940 and 1960
or where the name of the country starts with T*/
SELECT * 
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960
OR
Name Like 'T%';

SELECT COUNT(*) AS "N° Countries with IY btw 40s and 60s starts with T"
FROM Country
WHERE IndepYear BETWEEN 1940 AND 1960
OR
Name Like 'T%';

/*SQL’s way of handling if-then logic cases

Each WHEN tests a condition and the following 
THEN gives us the string if the condition is true.
The ELSE gives us the string if all the above conditions are false.

The CASE statement must end with END.*/

SELECT Name,
 CASE
  WHEN Continent = 'Europ' OR Continent = 'North America'
  THEN 'Probably developed country'
  
  WHEN Continent = 'Asia' OR Continent = 'Africa'
  THEN 'Probably undeveloped country'
  
  ELSE 'Undetermined'
 END AS 'Country classification'
FROM Country;