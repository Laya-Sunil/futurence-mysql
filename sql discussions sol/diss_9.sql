-- Active: 1670401223911@@127.0.0.1@3307@hr

-- Discussion 9
--------------------------------

-- 1.Write a query to list the number of jobs available in the employees table.
SELECT `JOB_ID`, count(*)
FROM employees e
GROUP BY `JOB_ID`;

-- 2.Write a query to get the total salaries payable to employees.
SELECT SUM(salary)
FROM employees;

-- 3.Write a query to get the minimum salary from the employees table.
SELECT MIN(salary)
FROM employees;

-- 4.Write a query to get the maximum salary of an employee working as a Programmer.
SELECT MAX(salary) max_salary
FROM employees e 
WHERE e.`JOB_ID` = (
                        SELECT j.`JOB_ID` FROM jobs j 
                        WHERE j.`JOB_TITLE` like 'Programmer%'
                    );

-- 5.Write a query to get the average salary and number of employees working in department 90.
SELECT Round(AVG(e.`SALARY`),2)AVG, COUNT(*)Total_Employees
FROM employees e 
WHERE e.`DEPARTMENT_ID`=90;

-- 6.Write a query to get the highest, lowest, sum, and average salary of all employees
SELECT MAX(e.`SALARY`)Max, MIN(e.`SALARY`)Min, SUM(e.`SALARY`)Sum, AVG(e.`SALARY`)Avg
FROM employees e;

-- 7.Write a query to get the number of employees with the same job.
SELECT e.`JOB_ID`, COUNT(*)Count
FROM employees e
GROUP BY e.`JOB_ID`;

-- 8.Write a query to get the difference between the highest and lowest salaries.
SELECT MAX(e.`SALARY`)-MIN(e.`SALARY`) as Diff_Sal
FROM employees e;

-- 9.Write a query to find the manager ID and the salary of the lowest-paid employee for that manager.
SELECT e.`MANAGER_ID`, MIN(e.`SALARY`)Min_Salary
FROM employees e 
GROUP BY e.`MANAGER_ID`;

-- 10.Write a query to get the department ID and the total salary payable in each department
SELECT e.`DEPARTMENT_ID`, SUM(e.`SALARY`)Total_Salary
FROM employees e 
GROUP BY e.`DEPARTMENT_ID`;

-- 11.Write a query to get the average salary for each job ID excluding programmer.
SELECT e.`JOB_ID`, AVG(e.`SALARY`)AVG
FROM employees e
WHERE e.`JOB_ID` <> (
                        SELECT `JOB_ID` FROM jobs WHERE `JOB_TITLE` LIKE 'Programmer%'
                    )
GROUP BY e.`JOB_ID`;


-- 12.Write a query to get the total salary, maximum, minimum, average salary of employees 
--(job ID wise), for department ID 90 only.
SELECT e.`JOB_ID`, SUM(e.`SALARY`)Total, AVG(e.`SALARY`)Avg, MAX(e.`SALARY`)Max,
        MIN(E.`SALARY`)Min
FROM employees e 
WHERE e.`DEPARTMENT_ID`=90
GROUP BY e.`JOB_ID`;

-- 13.Write a query to get the job ID and maximum salary of the employees 
-- where maximum salary is greater than or equal to $4000.
SELECT e.`JOB_ID`, MAX(e.`SALARY`)Max_Sal
FROM employees e
WHERE e.`SALARY`>4000
GROUP BY e.`JOB_ID`;

-- 14.Write a query to get the average salary for 
-- all departments employing more than 10 employees.
SELECT e.`DEPARTMENT_ID`,AVG(e.`SALARY`)Avg
FROM employees e 
GROUP BY e.`DEPARTMENT_ID`
HAVING COUNT(*)>10;