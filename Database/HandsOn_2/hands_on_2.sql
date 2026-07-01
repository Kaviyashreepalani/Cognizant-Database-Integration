-- ==========================================
-- HANDS-ON 2 : Writing SQL Queries
-- Module 3 - Database Integration
-- ==========================================

USE college_db;

-- ==========================================
-- TASK 1 : INSERT, UPDATE AND DELETE DATA
-- ==========================================

-- Departments

INSERT INTO departments (dept_name, head_of_dept, budget) VALUES
('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
('Electronics', 'Dr. Priya Nair', 620000.00),
('Mechanical', 'Dr. Suresh Iyer', 540000.00),
('Civil', 'Dr. Ananya Sharma', 430000.00);

-- Students

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Arjun','Mehta','[arjun.mehta@college.edu](mailto:arjun.mehta@college.edu)','2003-04-12',1,2022),
('Priya','Suresh','[priya.suresh@college.edu](mailto:priya.suresh@college.edu)','2003-07-25',1,2022),
('Rohan','Verma','[rohan.verma@college.edu](mailto:rohan.verma@college.edu)','2002-11-08',2,2021),
('Sneha','Patel','[sneha.patel@college.edu](mailto:sneha.patel@college.edu)','2004-01-30',3,2023),
('Vikram','Das','[vikram.das@college.edu](mailto:vikram.das@college.edu)','2003-09-14',1,2022),
('Kavya','Menon','[kavya.menon@college.edu](mailto:kavya.menon@college.edu)','2002-05-17',2,2021),
('Aditya','Singh','[aditya.singh@college.edu](mailto:aditya.singh@college.edu)','2004-03-22',4,2023),
('Deepika','Rao','[deepika.rao@college.edu](mailto:deepika.rao@college.edu)','2003-08-09',1,2022);

-- Courses

INSERT INTO courses
(course_name,course_code,credits,department_id)
VALUES
('Data Structures & Algorithms','CS101',4,1),
('Database Management Systems','CS102',3,1),
('Object Oriented Programming','CS103',4,1),
('Circuit Theory','EC101',3,2),
('Thermodynamics','ME101',3,3);

-- Enrollments

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(1,1,'2022-07-01','A'),
(1,2,'2022-07-01','B'),
(2,1,'2022-07-01','B'),
(2,3,'2022-07-01','A'),
(3,4,'2021-07-01','A'),
(4,5,'2023-07-01',NULL),
(5,1,'2022-07-01','C'),
(5,2,'2022-07-01','A'),
(6,4,'2021-07-01','B'),
(7,5,'2023-07-01',NULL),
(8,1,'2022-07-01','A'),
(8,3,'2022-07-01','B');

-- Professors

INSERT INTO professors
(prof_name,email,department_id,salary)
VALUES
('Dr. Anand Krishnan','[anand.k@college.edu](mailto:anand.k@college.edu)',1,95000),
('Dr. Meena Pillai','[meena.p@college.edu](mailto:meena.p@college.edu)',1,88000),
('Dr. Sunil Rajan','[sunil.r@college.edu](mailto:sunil.r@college.edu)',2,82000),
('Dr. Latha Gopal','[latha.g@college.edu](mailto:latha.g@college.edu)',3,79000),
('Dr. Kartik Bose','[kartik.b@college.edu](mailto:kartik.b@college.edu)',4,76000);

-- Add two additional students

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Kaviyashree','Palani','[kaviyashree@college.edu](mailto:kaviyashree@college.edu)','2004-06-15',1,2023),
('Nisha','Kumar','[nisha@college.edu](mailto:nisha@college.edu)','2004-02-10',2,2023);

-- Verify student count

SELECT COUNT(*) AS total_students
FROM students;

-- Update grade

UPDATE enrollments
SET grade='B'
WHERE student_id=5
AND course_id=1;

-- Verify update

SELECT *
FROM enrollments
WHERE student_id=5
AND course_id=1;

-- Preview NULL grades

SELECT *
FROM enrollments
WHERE grade IS NULL;

-- Delete NULL grades

DELETE FROM enrollments
WHERE grade IS NULL;

-- Verify deletion

SELECT *
FROM enrollments
WHERE grade IS NULL;

-- Final counts

SELECT COUNT(*) AS total_students
FROM students;

SELECT COUNT(*) AS total_enrollments
FROM enrollments;

-- ==========================================
-- TASK 2 : SINGLE TABLE QUERIES
-- ==========================================

-- Students enrolled in 2022

SELECT *
FROM students
WHERE enrollment_year = 2022
ORDER BY last_name;

-- Courses with credits > 3

SELECT *
FROM courses
WHERE credits > 3
ORDER BY credits DESC;

-- Professors salary between 80000 and 95000

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

-- Email ending with @college.edu

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

-- Student count per enrollment year

SELECT
enrollment_year,
COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;

-- ==========================================
-- TASK 3 : MULTI TABLE JOINS
-- ==========================================

-- Student and Department

SELECT
CONCAT(s.first_name,' ',s.last_name) AS student_name,
d.dept_name
FROM students s
JOIN departments d
ON s.department_id = d.department_id;

-- Enrollment + Student + Course

SELECT
CONCAT(s.first_name,' ',s.last_name) AS student_name,
c.course_name,
e.grade
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id;

-- Students not enrolled

SELECT
s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS student_name
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- Course enrollment count

SELECT
c.course_name,
COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,c.course_name;

-- Department with professors

SELECT
d.dept_name,
p.prof_name,
p.salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id;

-- ==========================================
-- TASK 4 : AGGREGATIONS AND GROUPING
-- ==========================================

-- Total enrollments per course

SELECT
c.course_name,
COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,c.course_name;

-- Average salary per department

SELECT
d.dept_name,
ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id
GROUP BY d.department_id,d.dept_name;

-- Departments with budget > 600000

SELECT
dept_name,
budget
FROM departments
WHERE budget > 600000;

-- Grade distribution for CS101

SELECT
e.grade,
COUNT(*) AS grade_count
FROM enrollments e
JOIN courses c
ON e.course_id = c.course_id
WHERE c.course_code='CS101'
GROUP BY e.grade;

-- Departments with more than 2 students

SELECT
d.dept_name,
COUNT(s.student_id) AS total_students
FROM departments d
JOIN students s
ON d.department_id=s.department_id
GROUP BY d.department_id,d.dept_name
HAVING COUNT(s.student_id) > 2;
