-- Active: 1686445526786@@127.0.0.1@3306@sakila
use Sakila;

SELECT * from customer;


-- Concatenate the first_name and last_name and email 
SELECT first_name || ' ' || last_name || ' <' || email || '>' AS full_email 
FROM customer;

SELECT CONCAT(first_name, ' ', last_name, ' <', email, '>') AS full_email 
FROM customer;


SELECT 
  -- Concatenate the category name to coverted to uppercase
  -- to the film title converted to title case
  UPPER(name)  || ': ' || INITCAP(title) AS film_category, --INITCAP() function which converts a string to title case
  -- Convert the description column to lowercase
  LOWER(description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;


SELECT 
  -- Replace whitespace in the film title with an underscore
  Replace(title, ' ', '_') AS title
FROM film; 


SELECT 
  -- Select the title and description columns
  title,
  description,
  -- Determine the length of the description column
  char_length(description) AS desc_len
FROM film;


SELECT 
  -- Select the first 50 characters of description
  left(description, 50) AS short_desc
FROM 
  film AS f; 


SELECT 
  -- Select only the street name from the address table
  substring(address FROM POSITION(' ' IN address)+1 FOR char_length(address))
FROM 
  address;


SELECT
  -- Extract the characters to the left of the '@'
  left(email, POSITION('@' IN email)-1) AS username,
  -- Extract the characters to the right of the '@'
  substring(email FROM POSITION('@' IN email)+1 FOR CHAR_LENGTH(email)) AS domain
FROM customer;


-- Concatenate the padded first_name and last_name 
SELECT 
	RPAD(first_name, CHAR_LENGTH(first_name)+1) || last_name AS full_name
FROM customer;


-- Concatenate the first_name and last_name 
SELECT 
	first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 


-- Concatenate the first_name and last_name 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 


-- Concatenate the uppercase category name and film title
SELECT 
    Concat(UPPER(name), ': ', title) AS film_category, 
  -- Truncate the description remove trailing whitespace
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;


SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  -- Truncate the description without cutting off a word
  LEFT(description, 50 - 
    -- Subtract the position of the first whitespace character
    POSITION(
      ' ' IN REVERSE(LEFT(description, 50))
    )
  ) 
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;