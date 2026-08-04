-- Query 1
-- Question: Display all employee details.
SELECT * FROM employees;

-- Query 2
-- Question: Display employee_id, first_name, last_name and salary.
SELECT employee_id, first_name, last_name, salary
FROM employees;

-- Query 3
-- Question: Display employees earning more than 10000.
SELECT *
FROM employees
WHERE salary > 10000;

-- Query 4
-- Question: Display employees working in department 50.
SELECT *
FROM employees
WHERE department_id = 50;

-- Query 5
-- Question: Display employees whose first name starts with 'A'.
SELECT *
FROM employees
WHERE first_name LIKE 'A%';

-- Query 6
-- Question: Display employees ordered by salary in descending order.
SELECT *
FROM employees
ORDER BY salary DESC;

-- Query 7
-- Question: Find the highest salary.
SELECT MAX(salary) AS highest_salary
FROM employees;

-- Query 8
-- Question: Find the second highest salary.
SELECT MAX(salary)
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);

-- Query 9
-- Question: Find department-wise employee count.
SELECT department_id,
       COUNT(*) AS total_emp
FROM employees
GROUP BY department_id;

-- Query 10
-- Question: Display departments having more than 5 employees.
SELECT department_id,
       COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;

-- Query 11
-- Question: Display maximum salary in each department.
SELECT department_id,
       MAX(salary)
FROM employees
GROUP BY department_id;

-- Query 12
-- Question: Display employee name with department name.
SELECT e.first_name,
       e.last_name,
       d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- Query 13
-- Question: Display all departments even if no employees exist.
SELECT d.department_name,
       e.first_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id;

-- Query 14
-- Question: Display employee and manager names.
SELECT e.first_name AS Employee,
       m.first_name AS Manager
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;

-- Query 15
-- Question: Display employees earning more than their manager.
SELECT e.first_name,
       e.salary,
       m.first_name AS manager,
       m.salary
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- Query 16
-- Question: Display employees with NULL commission.
SELECT *
FROM employees
WHERE commission_pct IS NULL;

-- Query 17
-- Question: Replace NULL commission with zero.
SELECT first_name,
       NVL(commission_pct, 0) AS commission
FROM employees;

-- Query 18
-- Question: Display employees whose salary is above average.
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Query 19
-- Question: Display top 5 highest-paid employees.
SELECT *
FROM (
    SELECT *
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 5;

-- Query 20
-- Question: Display third highest salary.
SELECT salary
FROM (
    SELECT DISTINCT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) r
    FROM employees
)
WHERE r = 3;

-- Query 21
-- Question: Display duplicate salaries.
SELECT salary,
       COUNT(*)
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

-- Query 22
-- Question: Display employees hired after 01-JAN-2005.
SELECT *
FROM employees
WHERE hire_date > DATE '2005-01-01';

-- Query 23
-- Question: Display years of service.
SELECT first_name,
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS years_service
FROM employees;

-- Query 24
-- Question: Display city of each employee.
SELECT e.first_name,
       l.city
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;

-- Query 25
-- Question: Display employee, department and country.
SELECT e.first_name,
       d.department_name,
       c.country_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id;

-- Query 26
-- Question: Display employee, department and region.
SELECT e.first_name,
       d.department_name,
       r.region_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id;

-- Query 27
-- Question: Display departments having employees using EXISTS.
SELECT *
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);

-- Query 28
-- Question: Classify salary using CASE.
SELECT first_name,
       CASE
           WHEN salary >= 15000 THEN 'HIGH'
           WHEN salary >= 8000 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS salary_grade
FROM employees;

-- Query 29
-- Question: Display employees not assigned to any department.
SELECT *
FROM employees
WHERE department_id IS NULL;

-- Query 30
-- Question: Display job title of every employee.
SELECT e.first_name,
       j.job_title
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id;