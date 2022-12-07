show databases;
use hr;
show tables;
-----------------------------------------------------------------------
select * 
from hr.employees;
---------------------------------------
-- Write a query to display the names (first_name, last_name) using alias name “First Name", "Last Name".
select e.first_name as "First Name", e.last_name as "Last Name"
from hr.employees as e;

-- Write a query to get unique department ID from employee table.
select distinct department_id
from hr.departments;

-- Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is calculated as 15% of salary).
select first_name, last_name, salary, round((0.15*salary),2) as PF
from employees;

-- Write a query to get the maximum and minimum salary from employees table.
select max(salary), min(salary)
from employees;

-- Write a query to get the average salary and number of employees in the employees table.
select avg(salary), count(employee_id)
from employees e;

-- Write a query get all first name from employees table in upper case.
select upper(first_name)
from employees;

-- Write a query to get the first 3 characters of first name from employees table.
select left(first_name, 3)
from employees;

-- Write a query to select first 10 records from a table.
select *
from employees
limit 10;

-- Write a query to get monthly salary (round 2 decimal places) of each and every employee.
select round(salary,2)
from employees;

-- Write a query to display the name (first_name, last_name) and department ID of all employees in departments 30 or 100 in ascending order.
select first_name, last_name, department_id
from employees
where department_id in (30,100);
-- OR
select first_name, last_name, department_id
from employees
where department_id=30 or department_id=100;


select * from employees;

-- discussion 17 ----------------------------------------------

-- Write a query to display the name (first_name, last_name) and salary for all employees whose salary is not in the range $10,000 through $15,000.
select first_name, last_name, salary
from employees
where salary between 10000 and 15000;

-- Write a query to display the name (first_name, last_name) and salary for all employees whose salary is not in the range $10,000 through $15,000 and are in department 30 or 100.
select  concat(first_name, ' ', last_name)name, salary
from employees
where salary<10000  or salary>15000
and department_id in (30,100);

-- Write a query to display the name (first_name, last_name) and hire date for all employees who were hired in 1987.
select concat(first_name, ' ', last_name)name, hire_date
from employees
where year(hire_date) = '1987';

-- Write a query to display the first_name of all employees who have both "b" and "c" in their first name.
select first_name
from employees
where first_name like '%b%' and first_name like '%c%';

-- Write a query to display the last name, job, and salary for all employees whose job is that of a Programmer or a Shipping Clerk, 
-- and whose salary is not equal to $4,500, $10,000, or $15,000.
select last_name, job_title, salary
from employees e
join jobs j
on e.job_id = j.job_id
where job_title in ('Programmer', 'Shipping Clerk')
and salary not in (4500,10000,15000);

-- Write a query to display the last name of employees having 'e' as the third character.
select last_name 
from employees
where last_name like '___e%';

-- Write a query to display the last name of employees whose names have exactly 6 characters.
select last_name 
from employees
where length(last_name)=6;

-- Write a query to select all record from employees where last name in 'BLAKE', 'SCOTT', 'KING' and 'FORD'.
select * 
from employees
where last_name in ('blake','scott','king','ford');

-- select * from countries;

describe countries;

alter table countries
add constraint uq_countries
unique(country_id, region_id);




