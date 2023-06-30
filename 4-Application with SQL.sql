-- --------------------------------------------------------
-- # 1- View databases
-- --------------------------------------------------------
SHOW DATABASES;
DROP DATABASE MSIGD; -- Delete a database
DROP DATABASE MISIGD; -- Delete a database

-- --------------------------------------------------------
-- #2 Create the "MSIGD" database
-- --------------------------------------------------------
CREATE DATABASE IF NOT EXISTS MSIGD;

-- --------------------------------------------------------
-- #3 Delete the "MSIGD" database and create the "MISIGD" database
-- --------------------------------------------------------
DROP DATABASE MSIGD; -- Delete a database
CREATE DATABASE IF NOT EXISTS MISIGD DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; -- Importance of collation
SHOW DATABASES; -- View all databases
USE MISIGD; -- Use the MISIGD database

-- --------------------------------------------------------
-- #4 Create the "students" table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS students
(
	id 	INT NOT NULL,
	name VARCHAR(150) NOT NULL,
	age INT NOT NULL
) ENGINE=InnoDB; -- IMPORTANT: Specify the "InnoDB" engine to enable FOREIGN KEY constraints https://dev.mysql.com/doc/refman/5.7/en/create-table-foreign-keys.html or https://dev.mysql.com/doc/refman/8.0/en/ansi-diff-foreign-keys.html

SHOW TABLES; -- View all tables in the current database

SELECT * FROM students; -- List all rows in the "students" table (returns 0 rows since the table is empty)

-- --------------------------------------------------------
-- #5 Modify the "students" table
-- --------------------------------------------------------
ALTER TABLE students ADD PRIMARY KEY (id); -- Add a primary key constraint on the "id" column
ALTER TABLE students MODIFY id INT NOT NULL AUTO_INCREMENT; -- Modify the "id" column and add the AUTO_INCREMENT attribute

-- --------------------------------------------------------
-- #6 Add the "first_name" column
-- --------------------------------------------------------
ALTER TABLE students ADD first_name VARCHAR(255) NOT NULL;

-- --------------------------------------------------------
-- #7 Display the information of the "students" table
-- --------------------------------------------------------
SHOW COLUMNS FROM students; -- Display the columns of a table
SHOW TABLE STATUS FROM MISIGD; -- Display the information of tables in a database

-- --------------------------------------------------------
-- #8 Create the "addresses" table
-- --------------------------------------------------------
CREATE TABLE addresses
(
	id 			INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	address 	VARCHAR(250) NOT NULL,
	city 		VARCHAR(50) NULL,
	postal_code INT NULL,
	student 	INT NOT NULL
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- #9 Add a foreign key constraint
-- --------------------------------------------------------
ALTER TABLE addresses -- specifies the table to modify
ADD CONSTRAINT FK_student FOREIGN KEY (student) REFERENCES students(id); -- add the FK between the "student" column of the "addresses" table and the "id" column of the "students" table

-- --------------------------------------------------------
-- #10 Create tables notes, notes_matieres, telephones, & telephones_type + FK
-- --------------------------------------------------------
CREATE TABLE notes
(
    id 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student 	INT NOT NULL,
    grade 		FLOAT NOT NULL,
    subject 	INT NOT NULL
) Engine=InnoDB;

CREATE TABLE subject_grades
(
    id 		INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title	VARCHAR(255) NOT NULL
) Engine=InnoDB;

ALTER TABLE notes
ADD CONSTRAINT FK_student_01 FOREIGN KEY (student) REFERENCES students(id); -- There is already an FK called FK_student (See above). So, I'm adding the suffix _01

ALTER TABLE notes
ADD CONSTRAINT FK_subject FOREIGN KEY (subject) REFERENCES subject_grades(id); 

CREATE TABLE phones
(
	id 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	number		VARCHAR(250) NOT NULL,
	type		INT NOT NULL,
	student 	INT NOT NULL
) Engine=InnoDB;
	
CREATE TABLE phone_types
(
	id 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	label		VARCHAR(50) NOT NULL
) Engine=InnoDB;

ALTER TABLE phones
ADD CONSTRAINT FK_student_02 FOREIGN KEY (student) REFERENCES students(id);

ALTER TABLE phones
ADD CONSTRAINT FK_type FOREIGN KEY (type) REFERENCES phone_types(id);

-- --------------------------------------------------------
-- #11 Insert data
-- --------------------------------------------------------

-- Inserting one row at a time
SELECT * FROM students; 
INSERT INTO students (name, first_name, age) VALUES ('BAZIN', 'Cyril', 36);
INSERT INTO students (name, first_name, age) VALUES ('DUPOND', 'Jean', 30);
INSERT INTO students (name, first_name, age) VALUES ('CODD', 'Edgar', 96);

-- Inserting with a single optimized query
INSERT INTO students (name, first_name, age)
VALUES
	('CURIE', 'Marie', 153),
	('CURIE', 'Pierre', 161),
	('MENIER', 'Regis', 50);

INSERT INTO subject_grades (title) VALUES ('Math'), ('French');
INSERT INTO phone_types (label) VALUES ('Fixed'), ('Mobile');


-- --------------------------------------------------------
-- #12 Insert additional data *** WITH HARD-CODED FK IDs ****
-- --------------------------------------------------------
-- Table notes: Jean DUPOND The grades "10", "11", and "12" in Math
INSERT INTO notes (student, grade, subject) 
VALUES
	(2, 10, 1),
	(2, 11, 1),
	(2, 12, 1);
-- Table notes: Jean DUPOND The grades "11", "12", and "13" in French
INSERT INTO notes (student, grade, subject) 
VALUES
	(2, 11, 2),
	(2, 12, 2),
	(2, 13, 2);
-- Table telephones: Jean DUPOND The fixed phone number "01.10.11.12.13" & the mobile phone number "06.60.61.62.63"
INSERT INTO phones (number, type, student)
VALUES
	('01.10.11.12.13', 1, 2),
	('06.60.61.62.63', 2, 2);

-- Table notes: Regis MENIER The grades "15", "16", and "17" in Math & the grades "16", "14", and "15" in French
INSERT INTO notes (student, grade, subject)
VALUES
	(6, 15, 1),
	(6, 16, 1),
	(6, 17, 1),
	(6, 16, 2),
	(6, 14, 2),
	(6, 15, 2);
-- Table telephones: Regis MENIER The fixed phone number "02.20.21.22.23" & the mobile phone number "07.70.71.72.73"
INSERT INTO phones (number, type, student)
VALUES
	('02.20.21.22.23', 1, 6),
	('07.70.71.72.73', 2, 6);

-- --------------------------------------------------------
-- #13 Insert additional data *** WITH JOINS TO RETRIEVE THE CORRECT IDs
-- --------------------------------------------------------
-- *** METHOD 1 Select by column ***
-- Cyril BAZIN: The grades "10", "10.25", and "12" in Math

INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(10),                                                                        -- column 2 grade
(SELECT id FROM subject_grades WHERE title = 'Math');                         -- column 3 subject

INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(10.25),                                                                     -- column 2 grade NOTE the dot, not the comma
(SELECT id FROM subject_grades WHERE title = 'Math');                         -- column 3 subject

INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(12),                                                                        -- column 2 grade
(SELECT id FROM subject_grades WHERE title = 'Math');                         -- column 3 subject


-- Cyril Bazin: The grades "18", "18.5", and "5.5" in French
INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(18),                                                                        -- column 2 grade
(SELECT id FROM subject_grades WHERE title = 'French');                      -- Column 3 subject

INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(18.50),                                                                     -- column 2 grade NOTE the dot, not the comma
(SELECT id FROM subject_grades WHERE title = 'French');                      -- Column 3 subject

INSERT INTO notes (student, grade, subject)
SELECT
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'), -- column 1 student
(5.5),                                                                       -- column 2 grade
(SELECT id FROM subject_grades WHERE title = 'French');                      -- Column 3 subject


-- Cyril Bazin: The fixed phone number "06.06.06.06.06"
INSERT INTO phones (number, type, student)
SELECT
('06.06.06.06.06'),                                                          -- column 1 phone number
(SELECT id FROM phone_types WHERE label = 'Fixed'),                            -- Column 2 phone type
(SELECT id FROM students WHERE name = 'BAZIN' AND first_name = 'Cyril'); -- column 3 student

-- *** METHOD 2 Join ***
-- Join between the students table and the subject_grades table. This join may seem strange because there is no direct relationship between the "students" and "subject_grades" tables.
-- Edgar CODD: The grades "18", "18.5", and "15.5" in Maths
SHOW TABLES;
INSERT INTO notes (student, grade, subject)
SELECT s.id, '18', sg.id 
FROM students s, subject_grades sg				
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Maths';

INSERT INTO notes (student, grade, subject)
SELECT s.id, '18.5', sg.id 
FROM students s, subject_grades sg
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Maths';

INSERT INTO notes (student, grade, subject)
SELECT s.id, '15.5', sg.id 
FROM students s, subject_grades sg
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Maths';


-- *** METHOD 3 Insert multiple rows with UNION ***
-- Edgar CODD: The grades "5", "5.25", and "6" in French
INSERT INTO notes (student, grade, subject)
SELECT s.id, '5', sg.id 							-- grade 5
FROM students s, subject_grades sg				
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Francais'
UNION
SELECT s.id, '5', sg.id 						-- grade 5.25
FROM students s, subject_grades sg				
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Francais'
UNION
SELECT s.id, '6', sg.id 						-- grade 5.25
FROM students s, subject_grades sg				
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	sg.title = 'Francais';

-- --------------------------------------------------------
-- Differences between methods 1, 2, and 3:
-- --------------------------------------------------------
-- Method 1: Simple difficulty - One INSERT per grade + One SELECT per column
--     => Result for 3 grades to insert: 3 INSERT and 9 SELECTs

-- Method 2: Medium difficulty with join - One INSERT per grade + One unique SELECT for all columns
--     => Result for 3 grades to insert: 3 INSERT and 3 SELECTs

-- Method 3: Complicated but optimized difficulty - One INSERT for all grades + One SELECT per grade
--     => Result for 3 grades to insert: 1 INSERT and 3 SELECTs

-- Marie CURIE: Grades "19", "20", and "20" in Math, and grades "19.5", "20", and "20" in French
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (19), (SELECT id FROM subject_grades WHERE title = 'Math');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM subject_grades WHERE title = 'Math');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM subject_grades WHERE title = 'Math');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (19.5), (SELECT id FROM subject_grades WHERE title = 'French');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM subject_grades WHERE title = 'French');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM students WHERE name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM subject_grades WHERE title = 'French');

-- Pierre CURIE: 3 points less than Marie
-- The purpose of this exercise is to demonstrate that it is possible to perform multiple joins on the same table. (Here, 2 joins on the same table "etudiants")
INSERT INTO notes (student, grade, subject)
SELECT 
	ePierre.id, 						-- Pierre's ID
	n.grade - 3, 						-- Mathematical expression: grade - 3
	n.subject  
FROM 
	notes n
	JOIN students eMarie ON eMarie.name = 'CURIE' AND eMarie.first_name = 'Marie' 	-- 1st Join with "students" table to retrieve Marie's notes
	JOIN students ePierre ON ePierre.name = 'CURIE' AND ePierre.first_name = 'Pierre'	-- 2nd Join with "students" table to retrieve Pierre's ID
WHERE
	n.student = eMarie.id 				-- Retrieve Marie's notes
	AND ePierre.name = 'CURIE' AND ePierre.first_name = 'Pierre';

-- --------------------------------------------------------
-- #14 Create a view to retrieve all tables with the WHERE clause
-- --------------------------------------------------------
-- It's not possible to use SELECT * because it will result in column name duplication (e.g., column "id").
-- The view returns no results for empty tables. The WHERE clause enforces the equijoin.

CREATE VIEW view_students_where AS
	SELECT 
		s.id 		as 'student_id',
		s.name		as 'student_name',
		s.first_name	as 'student_firstname',
		s.age		as 'student_age',
		a.id		as 'address_id',
		a.address	as 'address_address',
		a.city 	as 'address_city',
		a.postal_code as 'address_zipcode',
		a.student 	as 'address_student',
		n.id		as 'note_id',
		n.student	as 'note_student',
		n.grade		as 'note_grade',
		n.subject	as 'note_subject',
		sg.id		as 'subject_grade_id',
		sg.title	as 'subject_grade_title',
		p.id		as 'phone_id',
		p.number	as 'phone_number',
		p.type		as 'phone_type',
		p.student	as 'phone_student',
		pt.id		as 'phone_type_id',
		pt.label	as 'phone_type_label'
	FROM
		students s
		JOIN addresses a
			ON s.id = a.student		-- Join students and addresses tables
		JOIN notes n
			ON s.id = n.student		-- Join students and notes tables
		JOIN subject_grades sg
			ON n.subject = sg.id	-- Join notes and subject_grades tables
		JOIN phones p
			ON s.id = p.student		-- Join students and phones tables
		JOIN phone_types pt
			ON p.type = pt.id		-- Join phones and phone_types tables
	;

SELECT * FROM view_students_where;
-- --------------------------------------------------------
-- #15 Create a view to retrieve all tables with LEFT JOIN clause
-- --------------------------------------------------------
-- The view returns NULL results for empty tables 
-- --------------------------------------------------------
-- #15 Create a view to retrieve all tables with LEFT JOIN clause
-- --------------------------------------------------------
-- The view returns NULL results for empty tables 
CREATE VIEW view_students_leftjoin AS
	SELECT 
		s.id 		as 'student_id',
		s.name		as 'student_name',
		s.first_name	as 'student_firstname',
		s.age		as 'student_age',
		a.id		as 'address_id',
		a.address	as 'address_address',
		a.city 		as 'address_city',
		a.postal_code 	as 'address_zipcode',
		a.student 	as 'address_student',
		n.id		as 'note_id',
		n.student	as 'note_student',
		n.grade		as 'note_grade',
		n.subject	as 'note_subject',
		sg.id		as 'subject_grade_id',
		sg.title	as 'subject_grade_title',
		p.id		as 'phone_id',
		p.number	as 'phone_number',
		p.type		as 'phone_type',
		p.student	as 'phone_student',
		pt.id		as 'phone_type_id',
		pt.label	as 'phone_type_label'
	FROM
		students s
		LEFT JOIN addresses a
			ON s.id = a.student		-- Join students and addresses tables
		LEFT JOIN notes n
			ON s.id = n.student		-- Join students and notes tables	
		LEFT JOIN phones p
			ON s.id = p.student		-- Join students and phones tables
		LEFT JOIN subject_grades sg
			ON n.subject = sg.id		-- Join notes and subject_grades tables
		LEFT JOIN phone_types pt
			ON p.type = pt.id			-- Join phones and phone_types tables	
	;

SELECT * FROM view_students_leftjoin;



