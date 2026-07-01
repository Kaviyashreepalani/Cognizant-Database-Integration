USE college_db;

-- ==========================================
-- TASK 1 : SUBQUERIES
-- ==========================================

-- 35. Students enrolled in more courses than average

SELECT s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS student_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id,s.first_name,s.last_name
HAVING COUNT(*) >
(
SELECT AVG(course_count)
FROM
(
SELECT COUNT(*) AS course_count
FROM enrollments
GROUP BY student_id
) avg_table
);

-- 36. Courses where all enrolled students received A

SELECT c.course_id,
c.course_name
FROM courses c
WHERE NOT EXISTS
(
SELECT *
FROM enrollments e
WHERE e.course_id = c.course_id
AND e.grade <> 'A'
);

-- 37. Highest paid professor in each department

SELECT p.prof_name,
p.salary,
p.department_id
FROM professors p
WHERE p.salary =
(
SELECT MAX(p2.salary)
FROM professors p2
WHERE p2.department_id = p.department_id
);

-- 38. Departments with average salary > 85000

SELECT *
FROM
(
SELECT d.dept_name,
AVG(p.salary) AS avg_salary
FROM departments d
JOIN professors p
ON d.department_id = p.department_id
GROUP BY d.department_id,d.dept_name
) dept_avg
WHERE avg_salary > 85000;

-- ==========================================
-- TASK 2 : VIEWS
-- ==========================================

-- 39. Student Enrollment Summary View

CREATE OR REPLACE VIEW vw_student_enrollment_summary AS
SELECT
s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS student_name,
d.dept_name,
COUNT(e.course_id) AS total_courses,
ROUND(
AVG(
CASE
WHEN e.grade='A' THEN 4
WHEN e.grade='B' THEN 3
WHEN e.grade='C' THEN 2
WHEN e.grade='D' THEN 1
WHEN e.grade='F' THEN 0
END
),2
) AS gpa
FROM students s
LEFT JOIN departments d
ON s.department_id=d.department_id
LEFT JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY s.student_id,student_name,d.dept_name;

-- 40. Course Stats View

CREATE OR REPLACE VIEW vw_course_stats AS
SELECT
c.course_name,
c.course_code,
COUNT(e.student_id) AS total_enrollments,
ROUND(
AVG(
CASE
WHEN e.grade='A' THEN 4
WHEN e.grade='B' THEN 3
WHEN e.grade='C' THEN 2
WHEN e.grade='D' THEN 1
WHEN e.grade='F' THEN 0
END
),2
) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name,c.course_code;

-- 41. Students with GPA above 3

SELECT *
FROM vw_student_enrollment_summary
WHERE gpa > 3.0;

-- 42. Attempt update through view

UPDATE vw_student_enrollment_summary
SET gpa = 4
WHERE student_id = 1;

-- Multi-table views are generally not updatable because
-- data comes from multiple base tables and SQL cannot
-- determine how to update underlying rows safely.

-- 43. Drop and recreate with CHECK OPTION

DROP VIEW IF EXISTS vw_student_enrollment_summary;

CREATE VIEW vw_student_enrollment_summary AS
SELECT student_id,
first_name,
last_name,
department_id
FROM students
WHERE department_id IS NOT NULL
WITH CHECK OPTION;

-- ==========================================
-- TASK 3 : STORED PROCEDURES & TRANSACTIONS
-- ==========================================

-- Create log table

CREATE TABLE IF NOT EXISTS department_transfer_log
(
log_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT,
old_department INT,
new_department INT,
transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 44. Stored Procedure

DELIMITER $$

CREATE PROCEDURE sp_enroll_student
(
IN p_student_id INT,
IN p_course_id INT,
IN p_enrollment_date DATE
)
BEGIN

```
IF EXISTS
(
    SELECT 1
    FROM enrollments
    WHERE student_id=p_student_id
    AND course_id=p_course_id
)
THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='Duplicate Enrollment';
ELSE
    INSERT INTO enrollments
    (
        student_id,
        course_id,
        enrollment_date
    )
    VALUES
    (
        p_student_id,
        p_course_id,
        p_enrollment_date
    );
END IF;
```

END$$

DELIMITER ;

-- Procedure Call Example

CALL sp_enroll_student(1,5,'2024-01-01');

-- 45. Transfer Student Procedure

DELIMITER $$

CREATE PROCEDURE sp_transfer_student
(
IN p_student_id INT,
IN p_new_department INT
)
BEGIN

```
DECLARE old_dept INT;

START TRANSACTION;

SELECT department_id
INTO old_dept
FROM students
WHERE student_id=p_student_id;

UPDATE students
SET department_id=p_new_department
WHERE student_id=p_student_id;

INSERT INTO department_transfer_log
(
    student_id,
    old_department,
    new_department
)
VALUES
(
    p_student_id,
    old_dept,
    p_new_department
);

COMMIT;
```

END$$

DELIMITER ;

-- Procedure Call Example

CALL sp_transfer_student(1,2);

-- 46. Transaction Rollback Test

START TRANSACTION;

UPDATE students
SET department_id=9999
WHERE student_id=1;

ROLLBACK;

-- 47. SAVEPOINT Example

START TRANSACTION;

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(2,2,CURDATE(),'A');

SAVEPOINT first_insert;

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(999,999,CURDATE(),'A');

ROLLBACK TO first_insert;

COMMIT;
