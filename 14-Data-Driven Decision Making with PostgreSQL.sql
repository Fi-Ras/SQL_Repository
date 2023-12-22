-- Create <Movies_data> Database
DROP DATABASE IF EXISTS Movies_data;
CREATE DATABASE Movies_data;

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

