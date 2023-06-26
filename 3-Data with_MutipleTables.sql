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


/*Visualize all tables*/
SELECT * 
FROM actor
LIMIT 5;
SELECT * 
FROM actor_info
LIMIT 5;
SELECT * 
FROM address
LIMIT 5;
SELECT * 
FROM category
LIMIT 5;
SELECT * 
FROM city
LIMIT 5;
SELECT * 
FROM country
LIMIT 5;
SELECT * 
FROM customer
LIMIT 5;
SELECT * 
FROM customer_list
LIMIT 5;
SELECT * 
FROM film
LIMIT 5;
SELECT * 
FROM film_actor
LIMIT 5;
SELECT * 
FROM film_category
LIMIT 5;
SELECT * 
FROM film_list
LIMIT 5;
SELECT * 
FROM film_text
LIMIT 5;
SELECT * 
FROM inventory
LIMIT 5;
SELECT * 
FROM language
LIMIT 5;
SELECT * 
FROM nicer_but_slower_film_list
LIMIT 5;
SELECT * 
FROM payment
LIMIT 5;
SELECT * 
FROM rental
LIMIT 5;
SELECT * 
FROM sales_by_film_category
LIMIT 5;
SELECT * 
FROM sales_by_store
LIMIT 5;
SELECT * 
FROM staff
LIMIT 5;
SELECT * 
FROM staff_list
LIMIT 5;
SELECT * 
FROM store
LIMIT 5;


/*Use the details from the address table and city table to display each address with its corresponding city*/
SELECT 
    city,
    address
FROM address
JOIN city
    ON address.city_id = city.city_id
LIMIT 603;

/*Let us check if there are any cities without adress*/
--1st Method
SELECT COUNT(*) AS 'Number of nan empty address' 
FROM address;
SELECT COUNT(*) AS 'Number of nan empty cities' 
FROM city;
/*Even though this method allows us to observe that there are more addresses than cities, it is still not an intuitive method*/

--2nd Method
SELECT 
    city,
    COUNT (city) 'Number of occurrences'
FROM address
JOIN city
    ON address.city_id = city.city_id
GROUP BY city
HAVING COUNT (city) > 1;
/*--> So, we can conclude that there are some cities which appear twice in the dataset. 
In other words, we can say that the fact that the number of addresses is greater than the number of cities 
can be explained by the possibility of multiple addresses appearing in the same city.*/


/*Now let us see thses adresses*/
SELECT 
    city,
    address
FROM address
JOIN city
    ON address.city_id = city.city_id
WHERE city = 'Aurora' OR city = 'Lethbridge' OR city ='London' OR city ='Woodridge';

/*Suppose that we don't know the countries of these cities. 
That is why, we will create temporary tables that will enable us to establish the relationship between cities and their respective countries*/
SELECT 
    city,
    country
FROM country
JOIN city
    ON country.country_id = city.country_id;

WITH Double_Addresses AS (
   SELECT 
    city,
    address
   FROM address
   JOIN city
    ON address.city_id = city.city_id
   WHERE city IN ('Aurora', 'Lethbridge', 'London', 'Woodridge')
), Country_City AS (
   SELECT 
    city,
    country
   FROM country
   JOIN city
    ON country.country_id = city.country_id
)
SELECT 
    Double_Addresses.address,
    Double_Addresses.city,
    Country_City.country
FROM Double_Addresses
JOIN Country_City
    ON Double_Addresses.city = Country_City.city;

