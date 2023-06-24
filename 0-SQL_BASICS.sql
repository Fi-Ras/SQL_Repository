---This is a basic script of MySQL commands---

-- Create my database SQL_learn
DROP DATABASE IF EXISTS sql_learn;
CREATE DATABASE sql_learn;

-- See the DATABASES
SHOW DATABASES;

-- Choosing our DATABASE
USE sql_learn;

-- Creating our first table
DROP TABLE IF EXISTS celebs;
CREATE TABLE celebs (
id INT,
name TEXT,
age INT
);

-- See the tables of the DATABASE
SHOW TABLES;

-- Insert values into my table
-- Method 1
INSERT INTO celebs (id, name, age)
VALUES (1, 'Justin Bieber', 22);
INSERT INTO celebs (id, name, age)
VALUES (2, 'Beyonce Knowles', 33);
INSERT INTO celebs (id, name, age)
VALUES (3, 'Jeremy Lin', 26);
INSERT INTO celebs (id, name, age)
VALUES (4, 'Taylor Swift', 26);

-- Method 2
INSERT INTO celebs (id, name, age)
VALUES
(1, 'Justin Bieber', 22),
(2, 'Beyonce Knowles', 33),
(3, 'Jeremy Lin', 26),
(4, 'Taylor Swift', 26);

-- Method 3
INSERT INTO celebs
VALUES
(1, 'Justin Bieber', 22),
(2, 'Beyonce Knowles', 33),
(3, 'Jeremy Lin', 26),
(4, 'Taylor Swift', 26);

-- Method 4 (IF WE HAVE MANY VARIABLES, WE CAN SIMPLY USE AN EXCEL/CSV FILE)

-- SHOW THE TABLE AFTER THE INSERTION
SELECT * FROM celebs;

-- Modifying the table by adding a new COLUMN: "twitter_handle"
ALTER TABLE celebs
ADD COLUMN twitter_handle TEXT;

-- See the table after modifications
SELECT * FROM celebs;

-- Modifying the content of the table, in particular the new COLUMN
UPDATE celebs
SET twitter_handle = 'taylorswift13'
WHERE id = 4;

-- See the table after modifications
SELECT * FROM celebs;
COMMIT;

-- Deleting empty lines in my table
DELETE FROM celebs
WHERE twitter_handle IS NULL;

-- See the table after modifications
SELECT * FROM celebs;

-- Create awards table
DROP TABLE IF EXISTS awards;
CREATE TABLE awards (
id INTEGER PRIMARY KEY,
recipient VARCHAR(255) NOT NULL,
award_name VARCHAR(255) DEFAULT 'Grammy'
);

-- Here we can't use text; we must use VARCHAR(n)
-- See the tables of the DATABASE
SHOW TABLES;

SELECT * FROM awards;