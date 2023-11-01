"""
In this file some scripts dont work on MySQL, they only work on PostgreSQL.

I tried to find similar scripts that work on MySQL. But it is not the case for all the scripts.
"""

-- Active: 1686445526786@@127.0.0.1@3306@european_soccer_database
USE european_soccer_database;


-----------------------
--PostgreSQL's Script--
-----------------------
-- Create the correct extension to enable CROSSTAB & Fill in the correct column names for the pivoted table
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
  SELECT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year IN (2008, 2012)
    AND Medal = 'Gold'
    AND Event = 'Pole Vault'
  ORDER By Gender ASC, Year ASC;
$$) AS ct (Gender VARCHAR,
           "2008" VARCHAR,
           "2012" VARCHAR)
ORDER BY Gender ASC;

-----------------------
--MySQL's Script--
-----------------------
SELECT Gender,
       MAX(CASE WHEN Year = 2008 THEN Country ELSE NULL END) AS "2008",
       MAX(CASE WHEN Year = 2012 THEN Country ELSE NULL END) AS "2012"
FROM Summer_Medals
WHERE Year IN (2008, 2012)
      AND Medal = 'Gold'
      AND Event = 'Pole Vault'
GROUP BY Gender
ORDER BY Gender ASC;


-- Count the gold medals per country and year
SELECT
  Country,
  Year,
  Count (*) AS Awards
FROM Summer_Medals
WHERE
  Country IN ('FRA', 'GBR', 'GER')
  AND Year IN (2004, 2008, 2012)
  AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC;


-----------------------
--PostgreSQL's Script--
-----------------------
WITH Country_Awards AS (
  SELECT
    Country,
    Year,
    COUNT(*) AS Awards
  FROM Summer_Medals
  WHERE
    Country IN ('FRA', 'GBR', 'GER')
    AND Year IN (2004, 2008, 2012)
    AND Medal = 'Gold'
  GROUP BY Country, Year)
SELECT
  Country,
  Year,
  -- Rank by gold medals earned per year
  Rank() OVER( PARTITION BY Year) :: INTEGER AS rank
FROM Country_Awards
ORDER BY Country ASC, Year ASC;



-----------------------
--PostgreSQL's Script--
-----------------------
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)
  SELECT
    Country,
    Year,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)
Order by Country ASC;


-----------------------
--PostgreSQL's Script--
-----------------------
-- Count the gold medals per country and gender
SELECT
  Country,
  Gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
-- Generate Country-level subtotals
GROUP BY Country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;

-----------------------
--MySQL's Script--
-----------------------
SELECT
  Country,
  Gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY Country, Gender WITH ROLLUP
ORDER BY Country ASC, Gender ASC;




-----------------------
--PostgreSQL's Script--
-----------------------
-- Count the medals per gender and medal type
SELECT
  gender,
  medal,
  Count(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(gender, medal)
ORDER BY Gender ASC, Medal ASC;

-----------------------
--MySQL's Script--
-----------------------
-- Count the medals per gender and medal type
-- Query for gender and medal subtotals
SELECT gender, medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE Year = 2012 AND Country = 'RUS'
GROUP BY gender, medal
UNION ALL
-- Query for gender subtotals
SELECT gender, NULL, COUNT(*) AS Awards
FROM Summer_Medals
WHERE Year = 2012 AND Country = 'RUS'
GROUP BY gender
UNION ALL
-- Query for medal subtotals
SELECT NULL, medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE Year = 2012 AND Country = 'RUS'
GROUP BY medal


SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY Country, Gender WITH ROLLUP
ORDER BY Country ASC, Gender ASC;


WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country)
  SELECT
    Country,
    -- Rank countries by the medals awarded
    Rank() OVER(ORDER BY Medals DESC) AS Ranked
  FROM Country_Medals
  ORDER BY Ranked ASC;


-----------------------
--PostgreSQL's Script--
-----------------------
  WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country),
  Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Ranked
  FROM Country_Medals
  ORDER BY Ranked ASC)
-- Compress the countries column
SELECT STRING_AGG(Country, ', ')
FROM Country_Ranks
-- Select only the top three ranks
WHERE Ranked <= 3;

-----------------------
--MySQL's Script--
-----------------------
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country
),
Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Ranked
  FROM Country_Medals
)
SELECT GROUP_CONCAT(Country) AS TopCountries
FROM Country_Ranks
WHERE Ranked <= 3;