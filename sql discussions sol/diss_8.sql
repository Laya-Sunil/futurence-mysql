-- Active: 1670401223911@@127.0.0.1@3307@hr
show tables;

SELECT * from 
locations l inner join 
countries c 
on l.`COUNTRY_ID`=c.`COUNTRY_ID` ;

SELECT *
from locations l INNER JOIN departments d on l.`LOCATION_ID`=d.`LOCATION_ID`/;
select * from departments;

-- Write a query to find the addresses (location_id, street_address, city, state_province, country_name) of all the departments.

SELECT l.`LOCATION_ID`,`STREET_ADDRESS`,`CITY`,`STATE_PROVINCE`, `COUNTRY_NAME`, `DEPARTMENT_NAME`
from locations l 
inner join countries c
on l.`COUNTRY_ID` = c.`COUNTRY_ID`
inner JOIN departments d 
ON l.`LOCATION_ID` = d.`LOCATION_ID`;


-- Write a query to find the name (first_name, last name), department ID, and department name of all the employees.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, d.`DEPARTMENT_ID`, d.`DEPARTMENT_NAME`
from employees e left JOIN departments d 
ON e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`;
-- where d.`DEPARTMENT_ID` is NULL;

--Write a query to find the name (first_name, last_name), job, department ID, and name of the employees who work in London.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, j.`JOB_TITLE`,e.`DEPARTMENT_ID`
from employees e inner JOIN departments d
on e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`
INNER JOIN locations l
on d.`LOCATION_ID`=l.`LOCATION_ID` and l.`CITY`='London'
INNER JOIN jobs j
on e.`JOB_ID`= j.`JOB_ID`;

-- Write a query to find the employee id, name (last_name) along with their manager_id, and name (last_name).
SELECT e.`EMPLOYEE_ID`,e.`LAST_NAME`,m.`EMPLOYEE_ID`,m.`LAST_NAME`
from employees e  inner join employees m 
on e.`MANAGER_ID` = m.`EMPLOYEE_ID`;

-- Write a query to find the name (first_name, last_name) and hire date of the employees who were hired after 'Jones'.
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`HIRE_DATE`
from employees e 
where e.`HIRE_DATE`> (SELECT distinct `HIRE_DATE` from employees WHERE `LAST_NAME`='Jones');
-- SELECT distinct `HIRE_DATE` from employees WHERE `LAST_NAME`='Jones';
-- OR with non equi joi
explain SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`HIRE_DATE`
from employees e INNER JOIN employees p on e.`HIRE_DATE`>p.`HIRE_DATE`
and p.`LAST_NAME` like 'Jones%';

-- Write a query to get the department name and number of employees in the department.
-- select sum(c) from(
select d.`DEPARTMENT_NAME`, count(e.`EMPLOYEE_ID`)count_of_employees
from departments d left join employees e 
on d.`DEPARTMENT_ID` = e.`DEPARTMENT_ID`
GROUP BY d.`DEPARTMENT_ID`;
--)b;

-- 7.Write a query to find the employee ID, job title, number of days between the ending date and the starting date for all jobs in department 90.
SELECT jh.`EMPLOYEE_ID`,j.`JOB_TITLE`,DATEDIFF(jh.`END_DATE`,jh.`START_DATE`)number_of_days
from jobs j INNER JOIN job_history jh 
on j.`JOB_ID`=jh.`JOB_ID` and  jh.`DEPARTMENT_ID`=90;
-- OR
SELECT jh.`EMPLOYEE_ID`,j.`JOB_TITLE`,to_days(jh.`END_DATE`)-to_days(jh.`START_DATE`) as number_of_days
from jobs j INNER JOIN job_history jh 
on j.`JOB_ID`=jh.`JOB_ID` and  jh.`DEPARTMENT_ID`=90;


--INNER JOIN employees e 
--on jh.`EMPLOYEE_ID`=e.`EMPLOYEE_ID` 

-- 8.Write a query to display the department ID and name and first name of the manager.
SELECT d.`DEPARTMENT_ID`,`DEPARTMENT_NAME`,e.`FIRST_NAME`
from departments d left JOIN employees e 
on d.`MANAGER_ID` = e.`EMPLOYEE_ID`;

-- 9.Write a query to display the department name, manager name, and city.
SELECT `DEPARTMENT_NAME`,concat(e.`FIRST_NAME`,' ',e.`LAST_NAME`)manager_name, l.`CITY`
from departments d left JOIN locations l 
on d.`LOCATION_ID`=l.`LOCATION_ID`
left join employees e 
on d.`MANAGER_ID` = e.`EMPLOYEE_ID`;
-- and d.`DEPARTMENT_ID`=e.`DEPARTMENT_ID`;

-- 10.Write a query to display the job title and average salary of employees.
SELECT j.`JOB_TITLE`, AVG(e.`SALARY`)as average_salary
from jobs j LEFT JOIN employees e 
on j.`JOB_ID`=e.`JOB_ID`
GROUP BY j.`JOB_TITLE`;

-- 11.Write a query to display job title, employee name, and the difference between the salary of the employee and minimum salary for the job.
SELECT j.`JOB_TITLE`,CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)employee_name, (e.`SALARY`- j.`MIN_SALARY`)salary_diff 
FROM jobs j inner join employees e  
on j.`JOB_ID`=e.`JOB_ID`;

-- 12.Write a query to display the job history of any employee who is currently drawing more than 10000 of salary.
SELECT jh.*
FROM job_history jh inner join employees e
on jh.`EMPLOYEE_ID`=e.`EMPLOYEE_ID`
where e.`SALARY`>10000;


SELECT `EMPLOYEE_ID` FROM employees where `SALARY`>10000;

-- 13.Write a query to display department name, name (first_name, last_name), hire date, the salary of the manager for all
-- managers whose experience is more than 15 years.
SELECT d.`DEPARTMENT_NAME`, CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`HIRE_DATE`, e.`SALARY`
from departments d left join employees e on d.`MANAGER_ID`=e.`EMPLOYEE_ID`
--left JOIN job_history jh on d.`DEPARTMENT_ID`=jh.`DEPARTMENT_ID` and e.`EMPLOYEE_ID`=jh.`EMPLOYEE_ID`
where DATEDIFF(now(),`HIRE_DATE`)/365>15.0; 
--or jh.`END_DATE`-jh.`START_DATE`>15.0;
SELECT d.`DEPARTMENT_NAME`, CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`HIRE_DATE`, e.`SALARY`
from departments d inner join employees e on d.`MANAGER_ID`=e.`EMPLOYEE_ID`
--left JOIN job_history jh on d.`DEPARTMENT_ID`=jh.`DEPARTMENT_ID` and e.`EMPLOYEE_ID`=jh.`EMPLOYEE_ID`
where TIMESTAMPDIFF(year, e.`HIRE_DATE`,CURDATE())>15;
SELECT *
from job_history jh; 
INNER JOIN departments d on jh.`EMPLOYEE_ID`=d.`MANAGER_ID`
--where jh.`EMPLOYEE_ID` <>0
;
