-- Active: 1670401223911@@127.0.0.1@3307@test
SELECT truncate(5.235,2);
SELECT ROUND(5.235,2);
SELECT CEIL(2.0), CEIL(2.3);
SELECT FLOOR(2.9),FLOOR(2.0);

SELECT NULLIF(100,null);
create table demo1(id int AUTO_INCREMENT PRIMARY key,
                    a int, b int);

insert into demo1 VALUES(NULL,10,20),(NULL,100,200),(NULL,200,100),(NULL,10,20);
SELECT * from demo1;
select DISTINCT 
    CASE WHEN a>b then b else a 
    end as col1,
    CASE WHEN a>b THEN a ELSE b 
    end as col2
from demo1;


select a,b from demo1 GROUP BY a,b;
-- or
SELECT DISTINCT a,b from demo1; 

SELECT * FROM employees;

SELECT e.`EMPLOYEE_ID`,e.`FIRST_NAME`, 
        CASE 
            WHEN e.`SALARY`<10000 THEN "Grade 1"
            WHEN e.`SALARY`>=10000 and e.`SALARY`<20000 THEN "Grade 2"
            ELSE "Grade 3"
        END Grade
FROM employees e;


-- UNION
SELECT c.`contactFirstName`,
FROM customers c
UNION
SELECT e.`firstName`
FROM employees e
ORDER BY 1;

CREATE table employee(
    id int primary key AUTO_INCREMENT,
    name varchar(30) not null,
    age int, 
    salary int, 
    manager_id int,
    department_id int, 
    Foreign Key (department_id) REFERENCES Department(id)   
);
DESCRIBE employee;

CREATE table Department(
    id int PRIMARY KEY AUTO_INCREMENT, 
    name  VARCHAR(30) not null 
);

INSERT INTO department
VALUES(1,'Sales'),(2,'Marketing'),(3,'IT');

INSERT INTO employee
VALUES(null,'Alex',30,2000000,3,3),
    (null,'Lisa',26,1000000,1,2),(null,'July',33,1500000,1,3),
    (null,'Goofy',29,1600000,3,2);

INSERT INTO employee
VALUES(null,'Browni',30,900000,1,3),(null,'Kiki',29,1500000,2,2);

SELECT * from employee;
SELECT * from department;


(select e.name as Employee, d.name Department, e.age, e.salary
from employee e INNER JOIN department d
on e.department_id=d.id
where e.salary>=1500000
ORDER BY e.salary desc, e.name asc)
union 
(
select null as Employee, q.name Department, p.age, p.salary
from employee p INNER JOIN department q
on p.department_id=q.id
where p.salary<1500000
order by p.salary,p.age)
-- ORDER BY salary desc, Employee asc, age asc
;


select 
        CASE 
            when e.salary>1500000 then e.name
            else e.name=NULL 
        end as emps_name, d.name department, e.age, e.salary
from employee e JOIN department d
ON e.department_id=d.id
order by e.salary DESC,
if(e.salary>1500000,e.name,e.age) ASC;

select 
        CASE 
            when e.salary>1500000 then e.name
            else e.name=NULL 
        end as emps_name, d.name department, e.age, e.salary
from employee e JOIN department d
ON e.department_id=d.id
order by e.salary DESC,
if(e.salary>=1500000,e.name) ASC;,
if(e.salary<1500000,e.age)DESC;

select 
        CASE 
            when e.salary>1500000 then e.name
            else e.name=NULL 
        end as emps_name, d.name department, e.age, e.salary
from employee e JOIN department d
ON e.department_id=d.id
order by e.salary DESC,
(case when e.salary>=1500000 THEN e.name end) ASC,
(case when e.salary<1500000 then e.age end)DESC;

-- Horizontal stitch(join)
SELECT * from
(SELECT avg(e.salary) as "20-25(AVG)", MAX(e.salary)"20-25(Max)", MIN(e.salary)"20-25(Min)" from employee e where e.age BETWEEN 20 and 25)a,
(SELECT avg(e.salary) as "25>(AVG)",MAX(e.salary)"25>(Max)", MIN(e.salary)"25>(Min)" from employee e where e.age >25)b;

-- vertical stitching(union)
SELECT "20-25" as Age_Group, AVG(e.salary), MAX(e.salary), MIN(e.salary)
from employee e WHERE age BETWEEN 20 and 25
union
SELECT "25>" as Age_Group, AVG(e.salary), MAX(e.salary), MIN(e.salary)
from employee e WHERE age >25;


select "avg" as operation, "sal" as field, 
        AVG(CASE WHEN e.age>20 and e.age<=25 THEN e.salary END) as "20-25",
        AVG(CASE WHEN e.age>25 and e.age<30 THEN e.salary END )as "25-30"
FROM employee e
GROUP BY operation, field
union
select "min" as operation, "sal" as field, 
        min(CASE WHEN e.age>20 and e.age<=25 THEN e.salary END) as "20-25",
        min(CASE WHEN e.age>25 and e.age<30 THEN e.salary END )as "25-30"
FROM employee e
GROUP BY operation, field
union
select "max" as operation, "sal" as field, 
        MAX(CASE WHEN e.age>20 and e.age<=25 THEN e.salary END) as "20-25",
        MAX(CASE WHEN e.age>25 and e.age<30 THEN e.salary END )as "25-30"
FROM employee e
GROUP BY operation, field
UNION
select "avg" as operation, "age" as field, 
        FLOOR(avg(CASE WHEN e.age>20 and e.age<=25 THEN e.age END)) as "20-25",
        FLOOR(avg(CASE WHEN e.age>25 and e.age<30 THEN e.age END ))as "25-30"
FROM employee e
GROUP BY operation, field
UNION
select "min" as operation, "age" as field, 
        FLOOR(MIN(CASE WHEN e.age>20 and e.age<=25 THEN e.age END)) as "20-25",
        FLOOR(MIN(CASE WHEN e.age>25 and e.age<30 THEN e.age END ))as "25-30"
FROM employee e
GROUP BY operation, field
UNION;
select "max" as operation, "age" as field, 
        cast(FLOOR(MAX(CASE WHEN e.age>20 and e.age<=25 THEN e.age END))as int) as "20-25",
        Floor(MAX(CASE WHEN e.age>25 and e.age<30 THEN e.age END ))as "25-30"
FROM employee e
GROUP BY operation, field;

-- SELECT cast(23.6 as integer);
-- SELECT convert(23.55 , int);
-------------------------------------------------
SELECT "20-25" as age_group, FLOOR(AVG(e.age)) as AVG_AGE,
        FLOOR(max(e.age)) as MAX_AGE, FLOOR(MIN(e.age)) as MIN_AGE, AVG(e.salary) as AVG_SAL,
        MIN(e.salary)as MIN_SAL,MAX(e.salary)MAX_SAL
FROM employee e WHERE age BETWEEN 20 and 25
union
SELECT "25-30" as age_group, FLOOR(AVG(e.age)) as AVG,
        FLOOR(max(e.age)) as MAX, FLOOR(MIN(e.age)) as MIN,AVG(e.salary) as AVG_SAL,
        MIN(e.salary)as MIN_SAL,MAX(e.salary)MAX_SAL
FROM employee e WHERE age BETWEEN 25 and 30;

select @name = name, @SELECT e1.name n1, e1.age a1, e1.salary s1, 
        e2.name n2, e2.age a2, e2.salary s2
FROM employee e1 INNER JOIN employee e2;

SELECT 
        case WHEN e1.name n1 <> (sel)
        , e1.age a1, e1.salary s1, 
FROM employee e1 ;

SELECT name, age,department_id
from employee GROUP BY department_id;


--------------------------
SELECT con.contest_id, con.hacker_id, con.name, 
SUM(sg.total_submissions), SUM(sg.total_accepted_submissions), 
SUM(vg.total_views), SUM(vg.total_unique_views)
FROM Contests AS con
JOIN Colleges AS col ON con.contest_id = col.contest_id
JOIN Challenges AS cha ON cha.college_id = col.college_id
LEFT JOIN
(SELECT ss.challenge_id, SUM(ss.total_submissions) AS total_submissions, 
SUM(ss.total_accepted_submissions) AS total_accepted_submissions 
FROM Submission_Stats AS ss GROUP BY ss.challenge_id) AS sg
ON cha.challenge_id = sg.challenge_id
LEFT JOIN
(SELECT vs.challenge_id, SUM(vs.total_views) AS total_views, 
SUM(vs.total_unique_views) AS total_unique_views
FROM View_Stats AS vs GROUP BY vs.challenge_id) AS vg
ON cha.challenge_id = vg.challenge_id
GROUP BY con.contest_id, con.hacker_id, con.name
HAVING SUM(sg.total_submissions) +
       SUM(sg.total_accepted_submissions) +
       SUM(vg.total_views) +
       SUM(vg.total_unique_views) > 0
ORDER BY con.contest_id;
