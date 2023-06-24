/*In This script w need to Import "SAKILA" databases from this link :
 https://dev.mysql.com/doc/index-other.html

To import database in mysql we need to click on:

*Server 
    -> *Data Import 
        -> *Cocher la deuxième case "Import from Self-Contained File"
            -> *Préciser le shéma de la base sql
*/

/*Now Let us see the data bases*/
SHOW DATABASES;


/*Use sakila database*/
USE sakila;


/*Show all the tables of the database*/
SHOW TABLES;


/*Choose the film table and show it*/
SELECT * FROM film;


/*Show the dimensions of the table (Data shape)*/
SELECT (SELECT COUNT(*) FROM film) AS "Rows Number",
       (SELECT COUNT(*) FROM information_schema.`COLUMNS` WHERE TABLE_NAME = 'film') AS "Columns Number ";


/*Describe the table and see the content of its columns*/
--1st Methode: 
DESC film;
--2nd Methode: 
SHOW COLUMNS FROM film;


/*Show the unique Values Of movies_Rating*/
SELECT DISTINCT
    (rental_rate) AS "Unique Rates Number",
    (rating) AS "Unique Rates character"
FROM film
ORDER BY rental_rate;


/*Calculate the total duration of all movies*/
SELECT SUM(length) AS "Total Duration"
FROM film;


/*Calculate the total duration of all movies*/
SELECT SUM(replacement_cost) AS "Movies Cost"
FROM film;

/*"SUM" is used to calculate the total sum of numeric values
"COUNT" is used to count rows or non-null values in a column.*/


/*Show the first 5 most expensive movies and count the total of most expensive movies*/
SELECT 
    title
FROM film
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film)
LIMIT 5;

SELECT 
    COUNT(title) AS "Number of the most expensive movies"
FROM film
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film);


/*Show the first 5 most expensive movies and count the total of most expensive movies*/
SELECT 
    title AS 'The most expensive movies are :'
FROM film
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film)
LIMIT 5;

SELECT 
    COUNT(title) AS "Number of the most expensive movies"
FROM film
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film);


/*Show the first 5 cheapest movies and count the total of cheapest movies*/
SELECT 
    title AS 'The cheapest movies are :'
FROM film
WHERE replacement_cost = (SELECT MIN(replacement_cost) FROM film)
LIMIT 5;

SELECT 
    COUNT(title) AS "Number of cheapest movies"
FROM film
WHERE replacement_cost = (SELECT MIN(replacement_cost) FROM film);


/*Classify Movies By duration*/
SELECT title , description,
    CASE 
        WHEN length =  (SELECT MIN(length) FROM film) THEN  'SHORT MOVIE'
        WHEN length =  (SELECT MAX(length) FROM film) THEN  'LONG MOVIE'
        ELSE  'MEDIUM MOVIE'
    END AS "Movies Classification"
FROM film
ORDER BY length;


/*Show lowest, highest and the average of rental duration*/
SELECT 
    MIN(rental_duration) AS 'Lowest Rental Duration',
    MAX(rental_duration) AS 'Highest Rental Duration',
    AVG(rental_duration) AS 'Average Rental Duration'
FROM film; 

/*The average price of rental duration is (4.9850), round this result to 2 then to 0 decimal places*/
SELECT 
    AVG(rental_duration) AS 'Average Rental Duration',
    ROUND(AVG(rental_duration), 2) AS 'Rounded Average Rental',
    ROUND(AVG(rental_duration), 0) AS 'Rounded Average Rental'
FROM film; 


/*Count the number of films and rank them by rating*/
/*GROUP BY is a clause used to arrange identical data into groups
The GROUP BY statement comes after any WHERE statements, but before ORDER BY or LIMIT.*/
SELECT 
    rating,
    COUNT(*) AS 'Number of Movies' 
FROM film
GROUP BY rating
ORDER BY COUNT(*);

/*We can also GROUPE BY using numbers of COLUMNS, For instance :
Column number 1 = 'rating'
Column number 2 = 'rental_rate' etc...*/
SELECT 
    rating,
    rental_rate,
    COUNT(title) AS 'Number of movies'
FROM film
GROUP BY 1,2
ORDER BY 2,3;

/*Use the previous code and keep only number of movies Higher than 60

NB : 
WHERE ==> When we want to limit the results of a query based on values of the individual rows .
HAVING => When we want to limit the results of a query based on an aggregate property.

HAVING statement always comes after GROUP BY, but before ORDER BY and LIMIT.*/
SELECT 
    rating,
    rental_rate,
    COUNT(title) AS 'Number of movies'
FROM film
GROUP BY 1,2
HAVING COUNT(title) > 60
ORDER BY 2,3;