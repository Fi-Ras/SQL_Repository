-- Active: 1686445526786@@127.0.0.1@3306@european_soccer_database
USE european_soccer_database;


-- Calculate the running total of athlete medals
WITH Athlete_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'USA' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)
SELECT
  athlete,
  medals,
  sum(medals) OVER (ORDER BY athlete ASC) AS Max_Medals
FROM Athlete_Medals
ORDER BY Athlete ASC;


  -- Return the max medals earned so far per country
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('CHN', 'KOR', 'JPN')
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year, Country)
SELECT
  Year,
  Country,
  medals,
  MAX(medals) OVER (PARTITION BY Country
                ORDER BY Year ASC) AS Max_Medals
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

--Return the year, medals earned, and minimum medals earned so far.
WITH France_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'FRA'
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year)
SELECT
  Year,
  Medals,
  MIN(Medals) OVER (ORDER BY Year ASC) AS Min_Medals
FROM France_Medals
ORDER BY Year ASC;


--------------------------
--        FRAMES        --
--------------------------

-- Get the max of the current and next years'  medals
WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year)
SELECT
  Year,
  medals,
  MAX(medals) OVER (ORDER BY Year ASC
             ROWS BETWEEN current row
             AND 1 following) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;


  -- Select the athletes and the medals they've earned & Get the max of the last two and current rows' medals
WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)
SELECT
  athlete,
  medals, 
  MAX(medals) OVER (ORDER BY athlete ASC
            ROWS BETWEEN 2 preceding
            AND current row) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;


---------------------------------
--Calculate Moving Average (MA)--
---------------------------------

--- Calculate the 3-year moving average of medals earned
WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year)
SELECT
  Year, Medals,
  AVG(medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 preceding AND current row) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;


-- Calculate each country's 3-game moving total
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Year, Country)
SELECT
  Year, Country, Medals,
  SUM(Medals) OVER
    (PARTITION BY Country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 preceding AND current row) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;