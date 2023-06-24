---This is a basic script of MySQL commands---
----------------------------------------------


-- Create my databse SQL_learn
drop database sql_learn;
CREATE database SQL_learn;

-- See the DATABASES 
show DATABASES;

--Choosing our DATABASE
use SQL_learn ;

--Creating our first table
drop TABLE celebs;
CREATE Table celebs (
    id INT,
    name TEXT, -- here we can also use (VARCHAR(n))  
    age INT
); 

--See the tables of the DATABASE
show TABLES;

--Insert values into my table
--Methode 1  
INSERT INTO celebs (id, name, age) 
VALUES (1, 'Justin Bieber', 22);
INSERT INTO celebs (id, name, age) 
VALUES (2, 'Beyonce Knowles', 33); 
INSERT INTO celebs (id, name, age) 
VALUES (3, 'Jeremy Lin', 26); 
INSERT INTO celebs (id, name, age) 
VALUES (4, 'Taylor Swift', 26); 

--Methode 2
INSERT INTO celebs (id, name, age)
VALUES 
(1, 'Justin Bieber', 22),
(2, 'Beyonce Knowles', 33),
(3, 'Jeremy Lin', 26),
(4, 'Taylor Swift', 26);

--Methode 3
INSERT INTO celebs
VALUES 
(1, 'Justin Bieber', 22),
(2, 'Beyonce Knowles', 33),
(3, 'Jeremy Lin', 26),
(4, 'Taylor Swift', 26);

--Methode 4 (IF WE HAVE MANY VARIBLES WE CAN SIMPLY USE AN EXCEL/CSV FILE)

--SHOW THE TABLE AFTER THE INSERTION 
SELECT * FROM celebs;

--Modifying table by adding a new COLUMN : "twitter_handle"
ALTER TABLE celebs 
ADD COLUMN twitter_handle TEXT;

--See the table after modifications
SELECT * FROM celebs;

--Modifying the continue of table, in particular the new COLUMN
Update celebs
set twitter_handle="taylorswift13"
where id=4;

--See the table after modifications
SELECT * FROM celebs;
COMMIT;

--Deleting empthy lines in my table
DELETE from celebs
WHERE twitter_handle is NULL;


--See the table after modifications
SELECT * FROM celebs;

--Create awards table;
drop TABLE awards;

CREATE TABLE awards (
   id INTEGER PRIMARY KEY,
   recipient VARCHAR(255) NOT NULL,
   award_name VARCHAR(255) DEFAULT 'Grammy'
   );
---Here we can't use text we must use VARCHAR(n)

--See the tables of the DATABASE
show TABLES;

SELECT * FROM awards;