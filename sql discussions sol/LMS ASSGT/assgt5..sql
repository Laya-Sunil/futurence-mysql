-- Active: 1670401223911@@127.0.0.1@3307@lms_assignments
-- lms_assignments

-- 1. **Select employees first name, last name, job_id and salary 
-- whose first name starts with alphabet S.**
SELECT  e.first_name, e.last_name, e.job_id, e.salary
FROM employees e   
WHERE e.first_name LIKE 'S%';

-- 2. **Write a query to select employee with the highest salary.**
SELECT CONCAT(e.first_name,' ',e.last_name)
FROM employees e 
where e.salary = (SELECT max(salary) FROM employees); 

-- 3. **Select employee with the second highest salary**.
SELECT e.first_name, e.salary
FROM employees e  
WHERE 2>(SELECT COUNT(DISTINCT salary) 
        FROM employees
        WHERE e.salary<salary);


SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary = (SELECT DISTINCT salary
                  FROM employees 
                  ORDER BY salary DESC
                  LIMIT 1,1); -- sub query to find second highest salary

-- 4. **Fetch employees with 2nd or 3rd highest salary**.
SELECT fn first_name, ln last_name, s salary
FROM 
    (SELECT e.first_name fn, e.last_name ln, e.salary s,
            DENSE_RANK()OVER(ORDER BY e.salary DESC)rn_
    FROM employees e)a 
WHERE a.rn_ in (2,3);

-- 5. **Write a query to select employees and their corresponding 
-- managers and their salaries**.
SELECT CONCAT(e.first_name,' ',e.last_name) Employee, e.salary Emp_salary,
       CONCAT(m.first_name,' ',m.last_name) Manager, m.salary Mng_salary
FROM employees e INNER JOIN employees m 
ON e.manager_id = m.employee_id; 

-- 6. **Write a query to show count of employees under each manager 
-- in descending order**.
SELECT CONCAT(m.first_name,' ',m.last_name)Manager, count(e.employee_id)
FROM employees e INNER JOIN employees m 
ON e.manager_id = m.employee_id
GROUP BY Manager
ORDER BY 2 DESC; 

-- 7. **Find the count of employees in each department**.
SELECT d.department_name, COUNT(e.employee_id)c
FROM employees e RIGHT JOIN departments d 
ON e.department_id=d.department_id
GROUP BY d.department_name
ORDER BY c DESC; 

-- 8. **Get the count of employees hired year wise**.
SELECT YEAR(e.hire_date)year, count(e.employee_id)count
FROM employees e 
GROUP BY YEAR(e.hire_date) 
ORDER BY year;

-- 9. **Find the salary range of employees**.
SELECT CONCAT(MIN(salary),' - ',MAX(salary))salary_range
FROM employees;

-- 10. **Write a query to divide people into three groups based 
-- on their salaries**.
-- set @min_salary = SELECT MIN(salary) FROM employees;
SELECT e.employee_id, e.first_name,
            CASE
                WHEN e.salary>=(SELECT MIN(salary) from employees) 
                    AND e.salary<(SELECT MAX(salary) FROM employees)/3
                THEN "1"
                WHEN e.salary>=(SELECT MAX(salary) from employees)/3
                    AND e.salary<(SELECT MAX(salary) FROM employees)*(2/3)
                THEN "2"
                WHEN e.salary>=(SELECT MAX(salary) FROM employees)*(2/3)
                    AND e.salary<(SELECT MAX(salary) FROM employees)
                THEN "3" 
            END as "Group"
FROM employees e;

-- 11. **Select the employees whose first_name contains “an”.**
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.first_name LIKE '%an%';

-- 12. **Select employee first name and the corresponding phone number 
-- in the format (_ _ _)-(_ _ _)-(_ _ _ _)**.

SELECT e.first_name, REPLACE(e.phone_number,'.','-')phone_number
FROM employees e;

--OR

SELECT e.first_name, 
        CONCAT(SUBSTRING(e.phone_number,1,3),'-',SUBSTR(e.phone_number,5,3),'-',SUBSTR(e.phone_number,9))phone_number
FROM employees e;

-- 13. **Find the employees who joined in August, 1994.**
SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE YEAR(e.hire_date)=1994 AND MONTH(e.hire_date)=8;

--14. **Write an SQL query to display employees who earn more 
-- than the average salary in that company**
SELECT e.employee_id, e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary> (SELECT AVG(salary) FROM employees)
ORDER BY 3 DESC;

-- 15. **Find the maximum salary from each department.**
SELECT d.department_name, MAX(e.salary) Max_salary
FROM employees e RIGHT JOIN departments d 
ON e.department_id=d.department_id
GROUP BY d.department_name; 

-- 16. **Write a SQL query to display the 5 least earning employees**.
SELECT fn first_name, ln last_name, s salary
FROM 
    (SELECT e.first_name fn, e.last_name ln, e.salary s,
            DENSE_RANK()over(ORDER BY e.salary )rn_
    FROM employees e)t
WHERE rn_ BETWEEN 1 AND 5;  

--17. **Find the employees hired in the 80s**.
SELECT first_name, last_name, hire_date
FROM employees 
WHERE YEAR(hire_date) BETWEEN 1980 and 1989;

-- 18. **Display the employees first name and the name in reverse order**.
SELECT first_name, REVERSE(first_name)
FROM employees; 

--19. **Find the employees who joined the company after 15th of the month.**
SELECT first_name, hire_date
FROM employees
WHERE DAY(hire_date)>15;

--20. **Display the managers and the reporting employees who work in 
-- different departments**.
SELECT CONCAT(m.first_name,' ',m.last_name)manager, m.department_id,
       CONCAT(e.first_name,' ',e.last_name)employ, e.department_id
FROM employees e INNER JOIN employees m 
ON e.manager_id = m.employee_id
AND  e.department_id <> m.department_id;



