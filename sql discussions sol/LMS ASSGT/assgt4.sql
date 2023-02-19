-- db lms_assignments
-- DML Insert Update Delete Exercises

--Using the ERD below, write the SQL code for the tables shown
 
 -- student
 CREATE TABLE student (
    SID INTEGER(5) NOT NULL,
    S_FName VARCHAR(20) NOT NULL,
    S_LName VARCHAR(30) NOT NULL  
 );

 -- add primary key 
 ALTER TABLE student
 ADD CONSTRAINT pk_student 
 PRIMARY KEY (SID); 

-- course
CREATE TABLE course(
    CID INTEGER(6) NOT NULL,
    C_Name VARCHAR(30) NOT NULL
);
ALTER TABLE course
ADD CONSTRAINT pk_course
PRIMARY KEY(CID);

-- course_grades

CREATE TABLE course_grades(
    CGID INTEGER(7) NOT NULL,
    semester CHAR(4) NOT NULL,
    CID INT(6),
    SID INT(5),
    Grade CHAR(2) NOT NULL
);

-- add primary key 
ALTER TABLE course_grades
ADD CONSTRAINT pk_course_grades
PRIMARY KEY(CGID);

ALTER TABLE course_grades
ADD CONSTRAINT fk_course_grades_course
Foreign Key (CID) REFERENCES course(CID);

ALTER TABLE course_grades
ADD CONSTRAINT fk_course_grades_student
Foreign Key (SID) REFERENCES student(SID);


-- 2. Write the SQL to insert the following data into the respective tables
-- student 
INSERT INTO student
VALUES(12345, 'Chris', 'Rock'),
(23456, 'Chris', 'Farley'),(34567, 'David', 'Spade'), 
(45678, 'Liz', 'Lemon'),(56789, 'Jack', 'Donaghy'); 

SELECT * FROM student;
-- course
INSERT INTO course(CID,course_name)
VALUES(101001, 'Intro to Computers'),
(101002, 'Programming'),
(101003, 'Databases'),
(101004, 'Websites'),
(101005, 'IS Management');

SELECT * FROM course;
desc course;

-- course_grades
INSERT INTO course_grades
VALUES(2010101, 'SP10', 101005, 34567, 'D+'),
(2010308, 'FA10', 101005, 34567, 'A-'),
(2010309, 'FA10', 101001, 45678, 'B+'),
(2011308, 'FA11', 101003, 23456, 'B-'),
(2012206, 'SU12', 101002, 56789, 'A+');

SELECT * FROM course_grades;


-- 3. In the Student table, change the maximum length for Student first names to be 30 characters long.
ALTER TABLE student
MODIFY COLUMN s_fname VARCHAR(30);

/*
 4.In the Course table, add a column called “Faculty_LName” where the Faculty last name 
can vary up to 30 characters long. This column cannot be null and the default value 
should be “TBD”.
*/
 ALTER TABLE course
 ADD COLUMN Faculty_LName VARCHAR(30) NOT NULL DEFAULT 'TBD';

 /*
 5. In the Course table, update CID 101001 where will be Faculty_LName is “Potter” and 
C_Name is “Intro to Wizardry”
 */
UPDATE course 
SET `course_name` = "Intro to Wizardry" -- and `Faculty_LName`='Potter'
WHERE CID=101001;

UPDATE course 
SET `Faculty_LName`='Potter' 
WHERE CID=101001;
 -- 6.In the Course table, change the column name “C_Name” to be “Course_Name"
 ALTER TABLE course
 RENAME COLUMN `c_name` to `course_name`;

 -- 7. Delete the “Websites” class from the Course table
DELETE FROM course
WHERE `course_name` = 'Websites';

-- 8.Remove the Student table from the database
DROP TABLE student;

-- 9.Remove all the data from the Course table, but retain the table structure
TRUNCATE course;

-- 10. Remove the foreign key constraints from CID and SID columns in the Course_Grades table
ALTER TABLE course_grades
DROP CONSTRAINT fk_course_grades_student;

ALTER TABLE course_grades
DROP CONSTRAINT fk_course_grades_course;

