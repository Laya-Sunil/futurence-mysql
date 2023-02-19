-- Active: 1670401223911@@127.0.0.1@3307@lms_assgt2
--- assignment 6 
--- lms_assgt2 DATABASE 

-- SHOW TABLES;

-- 1. **Write a query to list the number of jobs available in the employees
-- table.**

SELECT COUNT(DISTINCT `JOB_ID`)
FROM employees;

-- 2. **Write a query to get the total salaries payable to employees.**
SELECT SUM(`SALARY`)
FROM employees;

--3. **Write a query to get the minimum salary from the employees table.**
SELECT MIN(`SALARY`)
FROM employees;

-- 4.**Write a query to get the maximum salary of an employee working as a Programmer.**
SELECT MAX(`SALARY`)
FROM employees INNER JOIN jobs USING(`JOB_ID`) 
WHERE `JOB_TITLE` LIKE 'Programmer%';

--5. **Write a query to get the average salary and number of employees working in department 90.**
SELECT AVG(`SALARY`), COUNT(`EMPLOYEE_ID`)
FROM employees
WHERE `DEPARTMENT_ID`=90;

--6. **Write a query to get the highest, lowest, sum, and average salary of all employees**
SELECT MAX(`SALARY`), MIN(`SALARY`), SUM(`SALARY`), AVG(`SALARY`)
FROM employees;

--7. **Write a query to get the number of employees with the same job.**
SELECT j.`JOB_TITLE`, count(e.`EMPLOYEE_ID`) count
FROM employees e INNER JOIN jobs j 
ON e.`JOB_ID`=j.`JOB_ID` 
GROUP BY j.`JOB_ID`;

--8. **Write a query to get the difference between the highest and lowest salaries.**
SELECT MAX(`SALARY`)-MIN(`SALARY`)
FROM employees;

--9. **Write a query to find the manager ID and the salary of the lowest-paid employee for that manager.**
SELECT `FIRST_NAME`, `LAST_NAME`,`SALARY`
FROM
(SELECT m.`FIRST_NAME`, m.`LAST_NAME`,e.`SALARY`,
        DENSE_RANK()OVER(PARTITION BY m.`EMPLOYEE_ID` ORDER BY e.`SALARY`)rn_
FROM employees e INNER JOIN employees m 
ON e.`MANAGER_ID`=m.`EMPLOYEE_ID`)a  
WHERE rn_=1;

--10. **Write a query to get the department ID and the total salary payable in each department.**
SELECT `DEPARTMENT_ID`,SUM(`SALARY`)
FROM employees 
GROUP BY `DEPARTMENT_ID`;

--11. **Write a query to get the average salary for each job ID excluding programmer.**
SELECT j.`JOB_ID`, AVG(e.`SALARY`)
FROM employees e INNER JOIN jobs j 
ON e.`JOB_ID`=j.`JOB_ID`
WHERE j.`JOB_TITLE` NOT LIKE 'Programmer%'
GROUP BY j.`JOB_ID`;

--12. **Write a query to get the total salary, maximum, minimum, average 
-- salary of employees (job ID wise), for department ID 90 only.**
SELECT j.`JOB_ID`, AVG(e.`SALARY`), SUM(e.`SALARY`),MAX(e.`SALARY`),MIN(e.`SALARY`)
FROM employees e INNER JOIN jobs j 
ON e.`JOB_ID`=j.`JOB_ID`
WHERE e.`DEPARTMENT_ID`=90
GROUP BY j.`JOB_ID`;

--13. **Write a query to get the job ID and maximum salary of the 
-- employees where maximum salary is greater than or equal to $4000.**
SELECT `JOB_ID`, MAX(`SALARY`)
FROM employees
GROUP BY `JOB_ID`
HAVING MAX(`SALARY`)>4000;

--14. **Write a query to get the average salary for all 
-- departments employing more than 10 employees.**
SELECT `DEPARTMENT_ID`, AVG(`SALARY`)
FROM employees e 
GROUP BY `DEPARTMENT_ID`
HAVING COUNT(`EMPLOYEE_ID`)>10;
