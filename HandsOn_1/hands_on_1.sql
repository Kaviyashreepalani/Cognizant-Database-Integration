-- ==================================
-- Task 1 : CREATE DATABASE
-- ==================================


CREATE DATABASE college_db;

USE college_db;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);

CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- ==================================
-- Task 2 : Normalization Analysis
-- ==================================

-- 1NF (First Normal Form)
-- All attributes contain atomic values.
-- No column stores multiple values in a single field.
-- Example violation: storing multiple phone numbers in one column.

-- 2NF (Second Normal Form)
-- Every non-key attribute depends fully on the primary key.
-- No partial dependency exists in any table.
-- Each table has a single-column primary key.

-- 3NF (Third Normal Form)
-- No transitive dependency exists.
-- Department details are stored in departments table.
-- Students reference departments using department_id.
-- This avoids redundancy and update anomalies.

-- Enrollments Table Analysis
-- enrollment_id uniquely identifies each record.
-- grade and enrollment_date depend directly on enrollment_id.
-- No non-key attribute depends on another non-key attribute.
-- Therefore enrollments table satisfies 3NF.


-- ==================================
-- Task 3 : ALTER TABLE Operations
-- ==================================

ALTER TABLE students
ADD phone_number VARCHAR(15);

ALTER TABLE courses
ADD max_seats INT DEFAULT 60;

ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

ALTER TABLE departments
CHANGE hod_name head_of_dept VARCHAR(100);

ALTER TABLE students
DROP COLUMN phone_number;