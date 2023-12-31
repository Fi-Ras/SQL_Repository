-- To use the Script we need to use the "Summer olympics Dataset" 
--(belwo you can store the csv file in a DB to use this script)

-- Active: 1686445526786@@127.0.0.1@3306@european_soccer_database
USE european_soccer_database;

-- Assign numbers to each row
SELECT
  *,
  Row_Number() OVER() AS Row_N
FROM Summer_Medals
ORDER BY Row_N ASC;


-- Assign numbers to each year
SELECT
  Year,
  Row_Number() OVER() AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;


-- Assign the lowest numbers to the most recent years
SELECT
  Year,
  ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;


  -- Count the number of medals each athlete has earned
SELECT
  athlete,
  Count(*) AS Medals
FROM Summer_Medals
GROUP BY Athlete
ORDER BY Medals DESC;



WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)
SELECT
  -- Number each athlete by how many medals they've earned
  athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;


-- Return each year's champions' countries
SELECT
  year,
  Country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';


-- Return each year's champions' countries
WITH Weightlifting_Gold AS (
  SELECT
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')
SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion) OVER
    (ORDER BY Champion ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;


WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')
SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country) OVER (PARTITION BY gender
            ORDER BY gender ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;


WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold')
SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(Country) OVER (PARTITION BY gender, event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;