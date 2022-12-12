-- Active: 1670401223911@@127.0.0.1@3307@hr
-- disscussion 7
-- hr DATABASE

-- 1. Write a query to find the name (first_name, last_name) and the salary of the 
-- employees who have a higher salary than the employee whose last_name='Bull'.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e
where e.`SALARY`> (SELECT `SALARY` FROM employees e WHERE e.`LAST_NAME`='Bull'); 

-- 2.Write a query to find the name (first_name, last_name) 
-- of all employees who works in the IT department.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name
FROM employees e 
WHERE e.`DEPARTMENT_ID` = 
                (SELECT `DEPARTMENT_ID` FROM departments WHERE `DEPARTMENT_NAME`='IT');

-- 3.Write a query to find the name (first_name, last_name) of the employees who have 
-- a manager and worked in a USA-based department.
SELECT
FROM employees e inner join (select )
WHERE e.`MANAGER_ID` IN
                (SELECT `MANAGER_ID` FROM departments where c);

-- nested subquery
SELECT CONCAT(`FIRST_NAME`,' ',`LAST_NAME`)name
FROM employees
WHERE `MANAGER_ID` IN
    (SELECT `MANAGER_ID` FROM departments WHERE `LOCATION_ID` IN
        (SELECT `LOCATION_ID` FROM locations WHERE `COUNTRY_ID` IN
            (SELECT `COUNTRY_ID` FROM countries WHERE UPPER(`COUNTRY_NAME`) LIKE '%USA%' 
                or LOWER(`COUNTRY_NAME`) LIKE '%united states of america%')));


-- 4.Write a query to find the name (first_name, last_name) of the employees 
-- who are managers.
SELECT distinct CONCAT(m.`FIRST_NAME`,' ',m.`LAST_NAME`)name
FROM employees e INNER JOIN employees m 
ON e.`MANAGER_ID` = m.`EMPLOYEE_ID`;
-- OR
SELECT distinct CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name
FROM employees e
WHERE e.`EMPLOYEE_ID` IN
    (SELECT `MANAGER_ID` FROM employees);

-- 5.Write a query to find the name (first_name, last_name), 
-- and salary of the employees whose salary is greater than the average salary.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e
WHERE e.`SALARY`> (SELECT avg(`SALARY`) FROM employees);

-- 6.Write a query to find the name (first_name, last_name), and salary of the 
-- employees whose salary is equal to the minimum salary for their jobs.
-- correlated subquery
SELECT  CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`), e.`SALARY`
FROM employees e
WHERE e.`JOB_ID` IN
    (SELECT `JOB_ID` FROM jobs WHERE e.`SALARY`>`MIN_SALARY`);
-- OR
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`),e.`SALARY`
FROM employees e INNER JOIN jobs j 
ON e.`JOB_ID`=j.`JOB_ID` 
and e.`SALARY`> j.`MIN_SALARY`;


-- 7.Write a query to find the name (first_name, last_name), and salary of 
-- the employees who earns more than the average salary and works in any of 
-- the IT departments.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e
WHERE e.`DEPARTMENT_ID` IN 
    (SELECT `DEPARTMENT_ID` FROM departments WHERE `DEPARTMENT_NAME`='IT')
and e.`SALARY`>
    (SELECT AVG(e.`SALARY`) FROM employees e);

-- 8.Write a query to find the name (first_name, last_name), 
--and salary of the employees who earns more than the earnings of Mr. Bell.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`), e.`SALARY`
FROM employees e 
WHERE e.`SALARY`> (SELECT `SALARY` FROM employees WHERE `LAST_NAME`='Bell');

-- 9.Write a query to find the name (first_name, last_name), and salary of 
-- the employees who earn the same salary as the minimum salary for all departments.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e
WHERE e.`SALARY`=(SELECT d.`MIN_SALARY` FROM jobs d WHERE e.`JOB_ID`=d.`JOB_ID`);

SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e
WHERE e.`SALARY`= (SELECT MIN(`SALARY`)s FROM employees);

SELECT MIN(`SALARY`)s FROM employees GROUP BY `DEPARTMENT_ID` ORDER BY s LIMIT 1;
SELECT MIN(`SALARY`)s FROM employees ;
-- 10.Write a query to find the name (first_name, last_name), and salary of the 
-- employees whose salary is greater than the average salary of all departments.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`),e.`SALARY`
FROM employees e WHERE `SALARY`> ALL
        (SELECT AVG(e.`SALARY`)avg_salary FROM employees e
        GROUP BY e.`DEPARTMENT_ID`);

-- 11.Write a query to find the name (first_name, last_name) 
-- and salary of the employees who earn a salary that is higher than the salary of 
-- all the Shipping Clerk (JOB_ID = 'SH_CLERK'). Sort the results of the salary 
-- from the lowest to highest.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`SALARY`
FROM employees e 
WHERE e.`SALARY`> ALL(SELECT `SALARY` FROM employees WHERE `JOB_ID`='SH_CLERK')
ORDER BY e.`SALARY`;

-- 12.Write a query to find the name (first_name, last_name) of 
-- the employees who are not managers.
SELECT distinct CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name
FROM employees e
WHERE e.`EMPLOYEE_ID` NOT IN (SELECT `MANAGER_ID` FROM employees);

-- 13.Write a query to display the employee ID, first name, last name, 
-- and department names of all employees.
SELECT e.`EMPLOYEE_ID`,e.`FIRST_NAME`,e.`LAST_NAME`, d.`DEPARTMENT_NAME`
FROM employees e  LEFT JOIN departments d
ON e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`;

-- 14.Write a query to display the employee ID, first name, last name, 
-- salary of all employees whose salary is above average for their departments.
SELECT e.`EMPLOYEE_ID`,e.`FIRST_NAME`,e.`LAST_NAME`,e.`SALARY`
FROM employees e
WHERE  e.`SALARY`>
    (SELECT AVG(d.`SALARY`) FROM employees d WHERE d.`DEPARTMENT_ID`=e.`DEPARTMENT_ID`
    GROUP BY d.`DEPARTMENT_ID`);

-- 15.Write a query to fetch even numbered records from employees table.
with even_cte as(
SELECT *, ROW_NUMBER()OVER() as r_
FROM employees
)
SELECT *
FROM even_cte
WHERE MOD(r_,2)=0;

SELECT * FROM employees;

-- 16.Write a query to find the 5th maximum salary in the employees table.
SELECT e.`SALARY`
FROM employees e 
ORDER BY e.`SALARY` DESC
LIMIT 4,1; 

-- 17.Write a query to find the 4th minimum salary in the employees table.
SELECT e.`SALARY`
FROM employees e 
ORDER BY e.`SALARY`  
LIMIT 3,1;

-- 18.Write a query to select the last 10 records from a table.
SELECT * 
FROM (
    select * FROM employees e ORDER BY `EMPLOYEE_ID` DESC LIMIT 10)b
ORDER BY `EMPLOYEE_ID`; 

-- 19.Write a query to list the department ID and name of all the 
--departments where no employee is working.
SELECT d.`DEPARTMENT_ID`,d.`DEPARTMENT_NAME`
FROM departments d
WHERE d.`DEPARTMENT_ID` NOT IN (SELECT `DEPARTMENT_ID` FROM employees);
/*
SELECT d.`DEPARTMENT_ID`,d.`DEPARTMENT_NAME`,COUNT(e.`EMPLOYEE_ID`)c
FROM departments d left join employees e ON e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`
GROUP BY d.`DEPARTMENT_ID`,d.`DEPARTMENT_NAME`
HAVING c=0;
*/
--20.Write a query to get 3 maximum salaries.
SELECT distinct `SALARY`
FROM employees
order by `SALARY`DESC
LIMIT 3;

-- 21.Write a query to get 3 minimum salaries.
SELECT distinct `SALARY`
FROM employees
order by `SALARY`
LIMIT 3;

-- 22.Write a query to get nth max salaries of employees.
-- 11th salary
SELECT distinct `SALARY`
FROM employees 
ORDER BY `SALARY` desc
LIMIT 10,1;  
-- OR
SELECT distinct `SALARY`
FROM employees e
WHERE 10=(SELECT COUNT(distinct `SALARY`)
            FROM employees s WHERE s.`SALARY`> e.`SALARY` ) 