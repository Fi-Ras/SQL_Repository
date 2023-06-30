-- --------------------------------------------------------
-- # 1- View databases
-- --------------------------------------------------------
SHOW DATABASES;

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
-- Join between the "etudiants" table and the "notes_matieres" table. This join may seem strange because there is no direct relationship between the "etudiants" and "notes_matieres" tables.
-- Edgar CODD: The grades "18", "18.5", and "15.5" in Maths
show tables ;
INSERT INTO notes (student, grade, subject)
SELECT e.id, '18', m.id 
FROM students s, subject_grades sg				
WHERE
	s.name = 'CODD' AND s.first_name = 'Edgar'
AND	m.titre = 'Maths';

INSERT INTO notes (student, grade, subject)
SELECT e.id, '18.5', m.id 
FROM etudiants e, notes_matieres m
WHERE
	e.nom = 'CODD' AND e.prenom = 'Edgar'
AND	m.titre = 'Maths';

INSERT INTO notes (student, grade, subject)
SELECT e.id, '15.5', m.id 
FROM etudiants e, notes_matieres m
WHERE
	e.nom = 'CODD' AND e.prenom = 'Edgar'
AND	m.titre = 'Maths';

-- *** METHOD 3 Insert multiple rows with UNION ***
-- Edgar CODD: The grades "5", "5.25", and "6" in French
INSERT INTO notes (student, grade, subject)
SELECT e.id, '5', m.id 							-- grade 5
FROM etudiants e, notes_matieres m				
WHERE
	e.nom = 'CODD' AND e.prenom = 'Edgar'
AND	m.titre = 'Francais'
UNION
SELECT e.id, '5.25', m.id 						-- grade 5.25
FROM etudiants e, notes_matieres m				
WHERE
	e.nom = 'CODD' AND e.prenom = 'Edgar'
AND	m.titre = 'Francais'
UNION
SELECT e.id, '6', m.id 							-- grade 6
FROM etudiants e, notes_matieres m				
WHERE
	e.nom = 'CODD' AND e.prenom = 'Edgar'
AND	m.titre = 'Francais';

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
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM etudiants WHERE last_name = 'CURIE' AND first_name = 'Marie'), (19), (SELECT id FROM notes_matieres WHERE title = 'Maths');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM etudiants WHERE last_name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM notes_matieres WHERE title = 'Maths');
INSERT INTO notes (student, grade, subject) SELECT (SELECT id FROM etudiants WHERE last_name = 'CURIE' AND first_name = 'Marie'), (20), (SELECT id FROM notes_matieres WHERE title = 'Maths');

-- Pierre CURIE: 3 points less than Marie
-- The purpose of this exercise is to demonstrate that it is possible to perform multiple joins on the same table. (Here, 2 joins on the same table "etudiants")
INSERT INTO notes (etudiant, note, matiere)
SELECT 
	ePierre.id, 						-- Pierre's ID
	n.note - 3, 						-- Mathematical expression: note - 3
	n.matiere  
FROM 
	notes n, 							
	etudiants eMarie, 					-- 1st Join with "etudiants" table to retrieve Marie's notes
	etudiants ePierre 					-- 2nd Join with "etudiants" table to retrieve Pierre's ID
WHERE 
	eMarie.nom = 'CURIE' AND eMarie.prenom = 'MARIE' 	
	AND n.etudiant = eMarie.id 			-- Retrieve Marie's notes
	AND ePierre.nom = 'CURIE' AND ePierre.prenom = 'Pierre';	-- Retrieve Pierre's ID	
	
-- --------------------------------------------------------
-- #14 Create a view to retrieve all tables with the WHERE clause
-- --------------------------------------------------------
-- It's not possible to use SELECT * because it will result in column name duplication (e.g., column "id").
-- The view returns no results because the addresses table is empty. The WHERE clause enforces an equijoin.

CREATE VIEW vue_etudiants_where AS
	SELECT 
		e.id 		as 'etudiant_id',
		e.nom		as 'etudiant_nom',
		e.prenom	as 'etudiant_prenom',
		e.age		as 'etudiant_age',
		a.id		as 'adresse_id',
		a.adresse	as 'adresse_adresse',
		a.ville 	as 'adresse_ville',
		a.codepostal as 'adresse_codepostal',
		a.etudiant 	as 'adresse_etudiant',
		n.id		as 'note_id',
		n.etudiant	as 'note_etudiant',
		n.note		as 'note_note',
		n.matiere	as 'note_matiere',
		nm.id		as 'notes_matiere_id',
		nm.titre	as 'notes_matiere_titre',
		t.id		as 'telephone_id',
		t.numero	as 'telephone_numero',
		t.type		as 'telephone_type',
		t.etudiant	as 'telephone_etudiant',
		tt.id		as 'telephone_type_id',
		tt.libelle	as 'telephone_type_libelle'
	FROM
		etudiants e,
		adresses a,
		notes n,
		notes_matieres nm,
		telephones t,
		telephones_type tt
	WHERE
			e.id = a.etudiant		-- Join etudiants and adresses tables
		AND	e.id = n.etudiant		-- Join etudiants and notes tables
		AND e.id = t.etudiant		-- Join etudiants and telephones tables
		AND n.matiere = nm.id		-- Join notes and notes_matieres tables
		AND t.type = tt.id			-- Join telephones and telephones_type tables
	;		

-- --------------------------------------------------------
-- #15 Create a view to retrieve all tables with the LEFT JOIN clause
-- --------------------------------------------------------
-- The view returns NULL results for empty tables

CREATE VIEW vue_etudiants_leftjoin AS
	SELECT 
		e.id 		as 'etudiant_id',
		e.nom		as 'etudiant_nom',
		e.prenom	as 'etudiant_prenom',
		e.age		as 'etudiant_age',
		a.id		as 'adresse_id',
		a.adresse	as 'adresse_adresse',
		a.ville 	as 'adresse_ville',
		a.codepostal as 'adresse_codepostal',
		a.etudiant 	as 'adresse_etudiant',
		n.id		as 'note_id',
		n.etudiant	as 'note_etudiant',
		n.note		as 'note_note',
		n.matiere	as 'note_matiere',
		nm.id		as 'notes_matiere_id',
		nm.titre	as 'notes_matiere_titre',
		t.id		as 'telephone_id',
		t.numero	as 'telephone_numero',
		t.type		as 'telephone_type',
		t.etudiant	as 'telephone_etudiant',
		tt.id		as 'telephone_type_id',
		tt.libelle	as 'telephone_type_libelle'
	FROM
		etudiants e
		LEFT JOIN adresses a
			ON e.id = a.etudiant		-- Join etudiants and adresses tables
		LEFT JOIN notes n
			ON e.id = n.etudiant		-- Join etudiants and notes tables		
		LEFT JOIN telephones t
			ON e.id = t.etudiant		-- Join etudiants and telephones tables
		LEFT JOIN notes_matieres nm
			ON n.matiere = nm.id		-- Join notes and notes_matieres tables
		LEFT JOIN telephones_type tt
			ON t.type = tt.id			-- Join telephones and telephones_type tables		
	;	
	
-- --------------------------------------------------------
-- #16 Create a view to retrieve all tables with the INNER JOIN clause
-- --------------------------------------------------------
-- Same result as the WHERE equijoin

CREATE VIEW vue_etudiants_innerjoin AS
	SELECT 
		e.id 		as 'etudiant_id',
		e.nom		as 'etudiant_nom',
		e.prenom	as 'etudiant_prenom',
		e.age		as 'etudiant_age',
		a.id		as 'adresse_id',
		a.adresse	as 'adresse_adresse',
		a.ville 	as 'adresse_ville',
		a.codepostal as 'adresse_codepostal',
		a.etudiant 	as 'adresse_etudiant',
		n.id		as 'note_id',
		n.etudiant	as 'note_etudiant',
		n.note		as 'note_note',
		n.matiere	as 'note_matiere',
		nm.id		as 'notes_matiere_id',
		nm.titre	as 'notes_matiere_titre',
		t.id		as 'telephone_id',
		t.numero	as 'telephone_numero',
		t.type		as 'telephone_type',
		t.etudiant	as 'telephone_etudiant',
		tt.id		as 'telephone_type_id',
		tt.libelle	as 'telephone_type_libelle'
	FROM
		etudiants e
		INNER JOIN adresses a
			ON e.id = a.etudiant		-- Join etudiants and adresses tables
		INNER JOIN notes n
			ON e.id = n.etudiant		-- Join etudiants and notes tables		
		INNER JOIN telephones t
			ON e.id = t.etudiant		-- Join etudiants and telephones tables
		INNER JOIN notes_matieres nm
			ON n.matiere = nm.id		-- Join notes and notes_matieres tables
		INNER JOIN telephones_type tt
			ON t.type = tt.id			-- Join telephones and telephones_type tables		
	;

-- --------------------------------------------------------
-- #17 Create a view to retrieve only the French notes for each student
-- --------------------------------------------------------
CREATE VIEW vue_etudiants_notes_francais AS
	SELECT 
		e.id 		as 'etudiant_id',
		e.nom		as 'etudiant_nom',
		e.prenom	as 'etudiant_prenom',
		n.note		as 'note',
		nm.titre	as 'matiere'
	FROM 
		etudiants e,
		notes n,
		notes_matieres nm
	WHERE
			e.id = n.etudiant 		-- Join etudiants and notes tables
		AND n.matiere = nm.id		-- Join notes and notes_matieres tables
		AND nm.titre = 'Francais'	-- Filter for the subject "Francais"
	;

-- --------------------------------------------------------
-- #18 Create a view to retrieve only the Math notes less than 12 for each student
-- --------------------------------------------------------
CREATE VIEW vue_etudiants_notes_maths_inf_12 AS
	SELECT 
		e.id 		as 'etudiant_id',
		e.nom		as 'etudiant_nom',
		e.prenom	as 'etudiant_prenom',
		n.note		as 'note',
		nm.titre	as 'matiere'
	FROM 
		etudiants e,
		notes n,
		notes_matieres nm
	WHERE
			e.id = n.etudiant 		-- Join etudiants and notes tables
		AND n.matiere = nm.id		-- Join notes and notes_matieres tables
		AND nm.titre = 'Maths'		-- Filter for the subject "Maths"
	HAVING
		n.note < 12					-- Filter for notes less than 12
	;


-- --------------------------------------------------------
-- #19. Rename the table telephones_type to telephones_types
-- --------------------------------------------------------
RENAME TABLE telephones_type TO telephones_types;

SHOW TABLES;

-- --------------------------------------------------------
-- #20. Delete the records in the table telephones using DELETE statement
-- --------------------------------------------------------
DELETE FROM telephones;

-- --------------------------------------------------------
-- #21. Truncate the table telephones using TRUNCATE statement
-- --------------------------------------------------------
TRUNCATE TABLE telephones;
