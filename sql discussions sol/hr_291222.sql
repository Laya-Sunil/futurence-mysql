-- Active: 1670401223911@@127.0.0.1@3307@hr
CREATE VIEW emp_details_view
AS
SELECT e.employee_id,
	e.job_id,
	e.manager_id,
	e.department_id,
	d.location_id,
	l.country_id,
	e.first_name,
	e.last_name,
	e.salary,
	e.commission_pct,
	d.department_name,
	j.job_title,
	l.city,
	l.state_province,
	c.country_name,
	r.region_name
FROM employees e,
	departments d,
	jobs j,
	locations l,
	countries c,
	regions r
WHERE e.department_id = d.department_id
	AND d.location_id = l.location_id
	AND l.country_id = c.country_id
	AND c.region_id = r.region_id
	AND j.job_id = e.job_id;


show tables;
create table job_grades
(grade_level char(1),
 lowest_sal numeric(11,2),
 high_sal numeric(11,2));

insert into job_grades
values ("A",1000,2999),
("B",3000,5999),
("C",6000,9999),
 ("D",10000,14999),
 ("E",15000,24999),
 ("F",25000,40000);



 SELECT r.`REGION_NAME`, c.`COUNTRY_NAME`
 FROM regions r INNER JOIN countries c
 on r.`REGION_ID`=c.`REGION_ID`;  

 SELECT c.`COUNTRY_NAME`, l.`CITY`
 FROM countries c INNER JOIN locations l 
 INNER JOIN regions r 
 on c.`COUNTRY_ID`=l.`COUNTRY_ID`
and  r.`REGION_ID`=c.`REGION_ID`; 


SELECT e.`FIRST_NAME`, d.`DEPARTMENT_NAME`, l.`CITY`
from employees e INNER JOIN departments d
on e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID` 
INNER JOIN locations l 
on  d.`LOCATION_ID`=l.`LOCATION_ID`;

-- self join
SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)employee,
    CONCAT(m.`FIRST_NAME`,' ',m.`LAST_NAME`)manager
FROM employees e INNER JOIN employees m
on e.`MANAGER_ID`=m.`EMPLOYEE_ID`; 

SELECT  distinct CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)employee, e.`SALARY`
    --CONCAT(m.`FIRST_NAME`,' ',m.`LAST_NAME`)manager
FROM employees e INNER JOIN employees m
on e.`SALARY`=m.`SALARY` 
and e.`EMPLOYEE_ID`<>m.`EMPLOYEE_ID`;
GROUP BY employee
having count(e.`SALARY`)>1; 

SELECT `FIRST_NAME`, `SALARY`
from employees e 
where e.`SALARY` in (
    SELECT `SALARY` from employees
    GROUP BY `SALARY`
    HAVING COUNT(`EMPLOYEE_ID`)>1
);

--- find job_id which filled in 2nd half of any year and again got filled in first half next year 
SELECT e.`JOB_ID`, e.`HIRE_DATE`, a.`JOB_ID`, a.`HIRE_DATE`
from employees e INNER JOIN employees a 
on  month(e.`HIRE_DATE`) between 7 and 12 
and month(a.`HIRE_DATE`) between 1 and 7
and year(a.`HIRE_DATE`)=year(e.`HIRE_DATE`)+1;

SELECT job_id,YEAR(e1.hire_date) 'YEAR', MONTH(e1.hire_date) 'Month'
FROM employees e1 
WHERE YEAR(e1.hire_date) IN (Select YEAR(e2.hire_date)-1 FROM employees e2 WHERE QUARTER(e2.hire_date)>3)
AND QUARTER(e1.hire_date)>2;

SELECT e1.job_id, e1.hire_date, year(e1.hire_date) as y1, e2.hire_date, year(e2.hire_date) as y2
FROM employees as e1 inner join employees as e2
ON e1.job_id = e2.job_id
where month( e1.hire_date) > 6 and month( e2.hire_date) <= 6
and year(e1.hire_date) = year(e2.hire_date)-1;

select count(*) from employees;


select * from employees NATURAL JOIN departments;

SELECT CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name, e.`HIRE_DATE`
from employees e
where e.`HIRE_DATE`>
                (select `HIRE_DATE` from employees
                WHERE `FIRST_NAME` like 'lisa%'); 

select d.`DEPARTMENT_NAME`
from employees e INNER join departments d 
on e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`
where e.`FIRST_NAME` like 'Steven%' and e.`LAST_NAME` like 'King%'; 

select `DEPARTMENT_NAME`
from departments
where `DEPARTMENT_ID` in (select `DEPARTMENT_ID` from employees
                            where `FIRST_NAME` like 'Steven%'
                            and `LAST_NAME` like  'King%');

select CONCAT(`FIRST_NAME`,' ',`LAST_NAME`)name
from employees 
where `MANAGER_ID`= (select `EMPLOYEE_ID` from employees 
                    where `FIRST_NAME`like 'neena%' and `LAST_NAME` like 'kochhar%');

select e.`EMPLOYEE_ID`,CONCAT(e.`FIRST_NAME`,' ',e.`LAST_NAME`)name,
        CONCAT(m.`FIRST_NAME`,' ',m.`LAST_NAME`)manager
from employees e INNER JOIN employees m  
on e.`MANAGER_ID`=m.`EMPLOYEE_ID`
where m.`FIRST_NAME` like 'Neena%' and m.`LAST_NAME` like 'Kochhar%';


SELECT e.`FIRST_NAME`, e.`LAST_NAME`, e.`SALARY`, j.grade_level
from employees e join job_grades j 
on e.`SALARY` BETWEEN j.lowest_sal and j.high_sal
and e.`DEPARTMENT_ID`=90;

select grade_level
from job_grades j 
where   (SELECT `SALARY`
        from employees
        where `FIRST_NAME` like 'Lex%' and `LAST_NAME` like '%Haan')
 BETWEEN j.lowest_sal AND j.high_sal;

 select * from job_grades;

select `EMPLOYEE_ID`, `FIRST_NAME`, `LAST_NAME`
from employees e
where `DEPARTMENT_ID` = (
            select `DEPARTMENT_ID`
            from employees
            where `FIRST_NAME` like 'neena%' and `LAST_NAME` like 'kochhar%'
            and e.`EMPLOYEE_ID`<> `EMPLOYEE_ID`);


select `DEPARTMENT_ID`, `JOB_ID`
            from employees
            where `FIRST_NAME` like 'Neena%' and `LAST_NAME` like 'Kochhar%';

-- employees working in same department as valli and lex  
select CONCAT(`FIRST_NAME`,' ',`LAST_NAME`)employees, `DEPARTMENT_ID`
from employees 
where `DEPARTMENT_ID` in (select `DEPARTMENT_ID` from employees
                            where `FIRST_NAME`in ('Valli','Lex'));

-- find out the dept name in which no employees are working
select d.`DEPARTMENT_NAME`--, e.`EMPLOYEE_ID`
from departments d left join employees e 
on d.`DEPARTMENT_ID`=e.`DEPARTMENT_ID`
-- and e.`EMPLOYEE_ID` is null;
GROUP BY d.`DEPARTMENT_ID`
having count(e.`EMPLOYEE_ID`)=0;
--ORDER BY e.`EMPLOYEE_ID`;
--and e.`DEPARTMENT_ID` is NULL 

select `DEPARTMENT_NAME`
from departments
where `DEPARTMENT_ID` not in (select distinct `DEPARTMENT_ID` from employees
                             where `DEPARTMENT_ID` is not NULL);

select distinct d.`DEPARTMENT_NAME`
from departments d
where d.`DEPARTMENT_ID` not in (select distinct `DEPARTMENT_ID`
                            from employees e
                            where e.`JOB_ID` = 'SA_REP'
                            and d.`DEPARTMENT_ID` is not null);

select d.`DEPARTMENT_NAME`
from departments d
where d.`DEPARTMENT_ID`  in (select distinct `DEPARTMENT_ID`
                            from employees e
                            where e.`JOB_ID` <> 'SA_REP'
                            and e.`DEPARTMENT_ID` is not null);

select distinct d.`DEPARTMENT_NAME`
from departments d INNER JOIN employees e 
on e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`
where e.`JOB_ID`<>'SA_REP'; 

select count(*) from employees where `DEPARTMENT_ID`=80;
select distinct `DEPARTMENT_ID` from employees;
select distinct `DEPARTMENT_ID`
                            from employees e
                            where e.`JOB_ID` <> 'SA_REP'
                            and e.`DEPARTMENT_ID` is not null;
select distinct `DEPARTMENT_ID`
from employees 
where `JOB_ID` <> 'SA_REP';


select `FIRST_NAME`, `HIRE_DATE`
from employees
where `HIRE_DATE`> any(select `HIRE_DATE` from employees
                        where `FIRST_NAME`in ('Laura','Susan'));

--  > any --> all records greater than the min value amoung the hiredate of laura and susan 
-- > all -- all records greater than the max hiredate amoung the hiredate of laura and susan. 


--
select `FIRST_NAME`, `SALARY`, `JOB_ID`
from employees j
where `SALARY` in (
select max(salary) from employees 
where j.`JOB_ID`=`JOB_ID`
GROUP BY `JOB_ID`);

select `FIRST_NAME`, `SALARY`, `JOB_ID`
from employees j
where (`SALARY`,`JOB_ID`) in (
select max(salary),`JOB_ID` from employees 
--where j.`JOB_ID`=`JOB_ID`
GROUP BY `JOB_ID`);

-- find out `JOB_ID` with max no of employees
select `JOB_ID`, count(`EMPLOYEE_ID`)max_emps
from employees
GROUP BY `JOB_ID`
having COUNT(`EMPLOYEE_ID`)
in (
    select max(c)
    from
        (select `JOB_ID`, count(`EMPLOYEE_ID`)c
        from employees
        group by `JOB_ID`)a);

select `FIRST_NAME`,`LAST_NAME`
from employees
where `JOB_ID` in (
        select `JOB_ID`
        from employees
        GROUP BY `JOB_ID`
        having COUNT(`EMPLOYEE_ID`)
        in (
            select max(c)
            from
                (select `JOB_ID`, count(`EMPLOYEE_ID`)c
                from employees
                group by `JOB_ID`)a));

-- employees with salary greater than the avg salary of their deptartment
SELECT `FIRST_NAME`, `LAST_NAME`, `SALARY`
from employees e
where `SALARY`> (
    select avg(salary) from employees 
    where e.`DEPARTMENT_ID`=`DEPARTMENT_ID`
    group by `DEPARTMENT_ID`);


SELECT e.`FIRST_NAME`,e.`LAST_NAME`,e.`SALARY`,e.`DEPARTMENT_ID`,a.AVG
from employees e INNER JOIN (SELECT `DEPARTMENT_ID`, AVG(`SALARY`)AVG 
                            from employees 
                            where `DEPARTMENT_ID` is not null 
                            GROUP BY `DEPARTMENT_ID` )a 

on e.`DEPARTMENT_ID`=a.`DEPARTMENT_ID`
and e.`SALARY`>a.avg 
ORDER BY 3;  


-- 
SELECT GROUP_CONCAT(' ',`FIRST_NAME`,' '), `DEPARTMENT_ID`
from employees
where `DEPARTMENT_ID`=60
GROUP BY `DEPARTMENT_ID`;



