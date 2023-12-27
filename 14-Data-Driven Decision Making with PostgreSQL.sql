-- Active: 1702405895474@@127.0.0.1@5432@postgres

-- Create <Movies_data> Database
DROP DATABASE IF EXISTS Movies_data;
CREATE DATABASE Movies_data;

CONNECT Movies_data;

-- Create tables and insert data
DROP TABLE IF EXISTS "movies";
CREATE TABLE movies
(
    movie_id INT PRIMARY KEY,
    title TEXT,
    genre TEXT,
    runtime INT,
    year_of_release INT,
    renting_price numeric
);

COPY movies
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/3eebf2a145b76fee37357bcd55ac54577c03c805/movies_181127_2.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

SELECT * FROM movies;



DROP TABLE IF EXISTS "actors";
CREATE TABLE actors
(
    actor_id integer PRIMARY KEY,
    name character varying,
    year_of_birth integer,
    nationality character varying,
    gender character varying
);

COPY actors
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/c67f20fa317e8229eed7586cda8bfce5fc177444/actors_181127_2.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

SELECT * FROM actors;


DROP TABLE IF EXISTS "actsin";
CREATE TABLE actsin
(
    actsin_id integer PRIMARY KEY,
    movie_id integer,
    actor_id integer
);

COPY actsin
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/6efc08575effcc9327c82fea18aaf22dfd61cc27/actsin_181127_2.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

SELECT * FROM actsin;

DROP TABLE IF EXISTS "customers";
CREATE TABLE customers
(
	customer_id integer PRIMARY KEY,
    name character varying,
    country character varying,
    gender character varying,
    date_of_birth date,
    date_account_start date
);

COPY customers
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/4b1767d8e638ab26e62d98517fef297d72260992/customers_181127_2.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

SELECT * FROM customers;


DROP TABLE IF EXISTS "renting";
CREATE TABLE renting
(
    renting_id integer PRIMARY KEY,
    customer_id integer NOT NULL,
    movie_id integer NOT NULL,
    rating integer,
    date_renting date
);

COPY renting
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/d36ed7719976092a9b3387c8a2ac077914c9e1d2/renting_181127_2.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

SELECT * FROM renting;


------------------------------------------------------------
--business intelligence for a online movie rental database--
------------------------------------------------------------

-- Select all From table renting
SELECT *  
FROM renting;       

-- Select all columns needed to compute the average rating per movie
SELECT movie_id,  
       rating
FROM renting;

-- Movies rented on October 9th, 2018
SELECT *
FROM renting
WHERE date_renting = '2018-10-09'; 

-- from beginning April 2018 to end August 2018
-- Order by recency in decreasing order
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY date_renting DESC; 

-- Select All genres except drama
SELECT *
FROM movies
where genre <> 'Drama';

-- Select all movies with the given titles
SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter');

-- Order the movies by increasing renting price
SELECT *
FROM movies
ORDER BY renting_price DESC ;


-- Select from table renting all movie rentals from 2018
-- Filter only those records which have a movie rating
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' 
AND rating IS NOT NULL;

-- Count the number of customers born in the 80s
SELECT Count(*)
FROM customers
WHERE date_of_birth between '1980-01-01' and '1989-12-31';

--Count the number of customers from Germany
SELECT count(*) 
FROM customers
WHERE country='Germany' ;

--Count the number of countries where MovieNow has customers.
SELECT COUNT( DISTINCT country)  
FROM customers
WHERE country IS NOT NULL;


SELECT min(rating) min_rating, -- Calculate the minimum rating and use alias min_rating
	   max(rating) max_rating, -- Calculate the maximum rating and use alias max_rating
	   avg(rating) avg_rating, -- Calculate the average rating and use alias avg_rating
	   COUNT(rating) number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
WHERE movie_id=25; -- Select all records of the movie with ID 25


-- Select all records of movie rentals since January 1st 2019
SELECT *  
FROM renting
WHERE date_renting >= '2019-01-01';


SELECT 
	COUNT(*), -- Count the total number of rented movies
	AVG(rating) -- Add the average rating
FROM renting
WHERE date_renting >= '2019-01-01';


SELECT 
	COUNT(*) AS number_renting, -- Give it the column name number_renting
	AVG(rating) AS average_rating -- Give it the column name average_rating
FROM renting
WHERE date_renting >= '2019-01-01';

-- Add the total number of ratings here
SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    COUNT(rating) AS number_ratings 
FROM renting
WHERE date_renting >= '2019-01-01';


-------------------------------------------
--Decision Making with simple SQL queries--
-------------------------------------------
-- For each country report the earliest date when an account was created
SELECT country, 
	MIN(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account;

-- Calculate average rating per movie
SELECT movie_id, 
       AVG(rating)    
FROM renting
GROUP BY movie_id;


SELECT movie_id, 
       AVG(rating) AS avg_rating, -- Use as alias avg_rating
       COUNT(rating) AS number_rating,                -- Add column for number of ratings with alias number_rating
       COUNT(*) AS number_renting                 -- Add column for number of movie rentals with alias number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating desc; -- Order by average rating in decreasing order


SELECT customer_id, -- Report the customer_id
      AVG(rating),  -- Report the average rating per customer
      COUNT(rating),  -- Report the number of ratings per customer
      COUNT(*)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY AVG(rating); -- Order by the average rating in ascending order

-- Join renting with customers
SELECT * 
FROM renting as r
LEFT JOIN customers as c
ON c.customer_id = r.customer_id
WHERE c.country = 'Belgium'; -- Select only records from customers coming from Belgium

SELECT AVG(rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';

-- Choose the correct join statment
SELECT *
FROM renting AS r
LEFT JOIN movies AS m 
ON r.movie_id = m.movie_id;


SELECT 
	SUM(m.renting_price), -- Get the revenue from movie rentals
	COUNT(*), -- Count the number of rentals
	COUNT( DISTINCT customer_id)  -- Count the number of customers
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;


SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' ;


SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin as ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;


SELECT m.title, -- Use a join to get the movie title and price for each movie rental
       m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;


SELECT rm.title, -- Report the income from movie rentals for each movie 
       SUM(rm.renting_price) AS income_movie
FROM
       (SELECT m.title, 
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
GROUP BY rm.title
ORDER BY income_movie DESC; -- Order the result by decreasing income


SELECT a.gender, -- Report for male and female actors from the USA 
       MIN(a.year_of_birth), -- The year of birth of the oldest actor
       MAX(a.year_of_birth) -- The year of birth of the youngest actor
FROM
   ( SELECT  * -- Use a subsequen SELECT to get all information about actors from the USA
   FROM actors
   WHERE nationality = 'USA' ) AS a -- Give the table the name a
GROUP BY gender;


SELECT *
FROM renting AS r
LEFT JOIN customers AS c   -- Add customer information
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m   -- Add movie information
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'; -- Select customers born in the 70s


SELECT m.title, 
COUNT(*), -- Report number of views per movie
AVG(rating) -- Report the average rating per movie
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title;


SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1 -- Remove movies with only one rental
ORDER BY COUNT DESC; -- Order with highest rating first


SELECT *
FROM renting as r 
LEFT JOIN customers AS c -- Augment table renting with information about customers 
ON r.customer_id = c.customer_id
LEFT JOIN actsin AS ai -- Augment the table renting with the table actsin
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a  -- Augment table renting with information about actors
ON a.actor_id = ai.actor_id;


SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
GROUP BY a.name, c.gender -- For each actor, separately for male and female customers
HAVING AVG(r.rating) IS NOT NULL 
AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY avg_rating DESC, number_views DESC;


SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
WHERE c.country = 'Spain'  -- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 
ORDER BY avg_rating DESC, number_views DESC;



SELECT *
FROM renting AS r -- Augment the table renting with information about customers
LEFT JOIN customers AS c
ON  r.customer_id = c.customer_id
LEFT JOIN movies AS m -- Augment the table renting with information about movies
ON  r.movie_id = m.movie_id
WHERE r.date_renting BETWEEN '2019-01-01' AND '2019-12-31'; -- Select only records about rentals since the beginning of 2019


SELECT 
	c.country,                      -- For each country report
	COUNT(*) AS number_renting,   -- The number of movie rentals
	AVG(r.rating) AS average_rating,  -- The average rating
	SUM(m.renting_price) AS revenue  -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY c.country;


---------------------------------------------------------
--Data Driven Decision Making with advanced SQL queries--
---------------------------------------------------------

--Select all movie IDs which have more than 5 views
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING COUNT(*) > 5;


-- Select movie IDs from the inner query
SELECT *
FROM movies
WHERE movie_id IN  
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5);


-- Select all customers with more than 10 movie rentals
SELECT *
FROM customers
WHERE customer_id IN            
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING COUNT(*)> 10);


-- Calculate the total average rating
SELECT AVG(rating) 
FROM renting;

-- Select movie IDs and calculate the average rating of movies with rating above average
SELECT movie_id, -- Select movie IDs and calculate the average rating 
       AVG(rating)
FROM renting
GROUP BY movie_id
HAVING AVG(rating) >         -- Of movies with rating above average
	(SELECT AVG(rating)
	FROM renting);


-- Report the movie titles of all movies with average rating higher than the total average
SELECT title 
FROM movies 
WHERE movie_id in
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));


-- Count movie rentals of customer 45
SELECT COUNT(*)
FROM renting
WHERE customer_id = 45;


-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 > 
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);


-- Calculate the minimum rating of customer with ID 7
SELECT min(rating)
FROM renting AS r
WHERE r.customer_id = 7;


-- Select all customers with a minimum rating smaller than 4
SELECT *
FROM customers 	AS c
WHERE 4 >  
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);


-- Select all movies with more than 5 ratings
SELECT *
FROM movies AS m
WHERE 5 < 
	(SELECT count(rating)
	FROM renting AS r
	WHERE m.movie_id = r.movie_id);


-- Select all movies with an average rating higher than 8
SELECT *
FROM movies AS m
WHERE 8 < 
	(SELECT AVG(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);


-- Select all records of movie rentals from customer with ID 115
SELECT *
FROM renting AS r
WHERE r.customer_id = 115;


-- Exclude those with null ratings
SELECT *
FROM renting
WHERE rating IS NOT NULL 
AND customer_id = 115;


-- Select all records of movie rentals from the customer with ID 1, excluding null ratings
SELECT *
FROM renting
WHERE rating IS NOT NULL
AND customer_id = 1; 

-- Select all customers with at least one rating
SELECT *
FROM customers AS c 
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);


-- Select the records from the table `actsin` of all actors who play in a Comedy
SELECT *  
FROM actsin AS ai
LEFT JOIN movies AS m
ON ai.movie_id = m.movie_id
WHERE m.genre = 'Comedy';


-- Make a table of the records of actors who play in a Comedy and select only the actor with ID 1
SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id = 1;


-- Create a list of all actors who play in a Comedy. Use the first letter of the table as an alias
SELECT *
FROM actors AS a 
WHERE EXISTS
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id);


-- Report the nationality and the number of actors for each nationality
SELECT a.nationality, COUNT(*)
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;


-- Report the name, nationality and the year of birth of all actors who are not from the USA
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA';


-- Report the name, nationality and the year of birth of all actors who were born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


-- Select all actors who are not from the USA and "all actors" who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION 
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


-- Select all actors who are not from the USA and "who are also" born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT 
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


-- Select the IDs of all dramas
SELECT movie_id 
FROM movies
WHERE genre = 'Drama';


-- Select the IDs of all movies with average rating higher than 9
SELECT movie_id 
FROM renting
GROUP BY movie_id
HAVING AVG(rating) > 9;


-- Select the IDs of all dramas with average rating higher than 9
SELECT movie_id
FROM movies
WHERE genre = 'Drama'
INTERSECT  
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;


-- Select all movies of genre drama with average rating higher than 9
SELECT *
FROM movies
WHERE movie_id IN 
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);


-----------------------------------------------------
--Data Driven Decision Making with OLAP SQL queries--
-----------------------------------------------------

-- Extract information of a pivot table of gender and country for the number of customers
SELECT COUNT(*), 
	   gender,
	   country
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;


-- List the number of movies for different genres and the year of release on all aggregation levels
SELECT COUNT(*),
       genre,
       year_of_release
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;


-- Augment the records of movie rentals with information about movies and customers
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;


-- Calculate the average rating for each country
SELECT 
	c.country,
    AVG(r.rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY country;


-- Calculate the average rating for all aggregation levels of country and genre
SELECT 
	country, 
	genre, 
	AVG(r.rating) AS avg_rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE(country,genre);


-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
-- Order the result by country and gender
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender;


-- Augment the renting records with information about movies and customers
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;


-- Calculate the average ratings and the number of ratings for each country and each genre
-- Aggregate for each country and each genre
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating), 
	COUNT(*)  
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY (country, genre) 
ORDER BY c.country, m.genre;


-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP (c.country, m.genre)
ORDER BY c.country, m.genre;


-- Count the number of actors in the table actors from each country, the number of male and female actors and the total number of actors
SELECT 
	nationality, 
    gender, 
    COUNT(*) 
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); 


-- Select the columns country, gender, and rating and use the correct join to combine the table renting with customer
SELECT 
	country, 
    gender,
    rating
FROM renting AS r
LEFT JOIN customers AS c 
ON r.customer_id = c.customer_id;


-- Use GROUP BY to calculate the average rating over country and gender. Order the table by country and gender
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating) 
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY (country,gender) 
ORDER BY country,gender;


-- Group by country and gender with GROUPING SETS
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY GROUPING SETS ((country, gender));


-- Report all info from a Pivot table for country and gender
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());


-- Augment the records of movie rentals with information about movies
SELECT *
FROM renting AS r
LEFT JOIN movies AS m 
ON r.movie_id = m.movie_id;



-- Select records of movies with at least 4 ratings, starting from 2018-04-01
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN (
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND date_renting >= '2018-04-01';


SELECT m.genre, -- For each genre, calculate:
	   AVG(r.rating) AS avg_rating, -- The average rating and use the alias avg_rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings and use the alias n_rating
	   COUNT(*) AS n_rentals,     -- The number of movie rentals and use the alias n_rentals
	   COUNT(DISTINCT m.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY m.genre;


-- Order the table by decreasing average rating
SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; 


-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN actsin AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id;


SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY (nationality,gender); -- Report results for each combination of the actors' nationality and gender


-- Provide results for all aggregation levels represented in a pivot table
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE(nationality,gender); 