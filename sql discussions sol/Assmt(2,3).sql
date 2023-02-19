-- Active: 1670401223911@@127.0.0.1@3307@hr
SELECT SUM(e.`SALARY`)sum, max(e.`SALARY`), MIN(e.`SALARY`),
        AVG(e.`SALARY`)
FROM employees e 
WHERE e.`DEPARTMENT_ID`=90
GROUP BY e.`JOB_ID`;


-- LOGS TABLE
CREATE Table logs(id int PRIMARY KEY AUTO_INCREMENT,
num VARCHAR(20));
INSERT INTO logs values
(NULL,1),(NULL,1),(NULL,1),(NULL,1),(NULL,2),(NULL,1),
(NULL,2),(NULL,2),(NULL,1);

INSERT INTO logs VALUES (null,2),(null,2),(null,2);

SELECT * FROM logs;

SELECT distinct l1.*
FROM logs l1 INNER JOIN logs l2 ON l2.id = l1.id+1 and l1.num=l2.num
INNER JOIN logs l3 ON l3.id=l1.id+2 and l3.num=l1.num and l2.num=l3.num;


--
select * from logs
where id in(
SELECT distinct l1.id 
FROM logs l1 INNER JOIN logs l2 INNER JOIN logs l3
ON l1.num = l2.num and l1.num = l3.num 
and l2.id =l1.id+1 and l3.id=l2.id+1);


SELECT distinct l1.id 
FROM logs l1 INNER JOIN logs l2 INNER JOIN logs l3
ON l1.num = l2.num and l1.num = l3.num 
and l2.id =l1.id+1 and l3.id=l2.id+1;

SELECT  l1.id id1, l1.num n1, l2.id id2, l2.num n2, l3.id id3, l3.num n3
FROM Logs l1 INNER JOIN Logs l2 INNER JOIN Logs l3
ON l1.num = l2.num AND l1.num = l3.num 
AND l2.id =l1.id+1 AND l3.id=l2.id+1;

select * from logs;
with cte as(
SELECT  l1.id id1, l1.num n1, l2.id id2, l2.num n2, l3.id id3, l3.num n3
FROM Logs l1 INNER JOIN Logs l2 INNER JOIN Logs l3
ON l1.num = l2.num AND l1.num = l3.num 
AND l2.id =l1.id+1 AND l3.id=l2.id+1
)
select id1 as id, n1 as num from cte  
union
SELECT id2, n2 from cte   
union
SELECT id3, n2 from cte
ORDER BY id;

-- 4- TREE 
SELECT id,CASE 
        WHEN pid IS NULL THEN "Root"
        WHEN id in (SELECT DISTINCT pid FROM tree) THEN "Inner"
        ELSE "Leaf"  
FROM Tree
ORDER BY id;

-- Top earners
SELECT e.`SALARY`, e.`DEPARTMENT_ID`
from employees e 
where 3>
        (
        SELECT count(distinct `SALARY`) from employees
        where e.`SALARY`<`SALARY`
        and e.`DEPARTMENT_ID`= `DEPARTMENT_ID`)
ORDER BY e.`DEPARTMENT_ID`, e.`SALARY` DESC;

-- CREATE
create Table if NOT exists emp(
    emp_id int NOT NULL,
    f_name VARCHAR(10) not NULL,
    l_name VARCHAR(10)NOT NULL,
    job_id int, 
    sal DECIMAL(6,2)

);
ALTER TABLE emp 
add constraint pk_emp PRIMARY KEY(emp_id);

ALTER TABLE emp
ADD constraint fk_job_emp
Foreign Key (job_id) REFERENCES job(id) on update CASCADE on delete CASCADE;

create Table job(id int PRIMARY key, job VARCHAR(10));


---5 STADIUM

SELECT s1.id, s1.visit_date, s1.people
FROM Stadium s1 INNER JOIN Stadium s2 INNER JOIN Stadium s3
ON s2.id = s1.id+1 and s3.id=s1.id+2
and s1.people>=100 and s2.people>=100
and s3.people>=100
ORDER BY s1.visit_date DESC;

--
with cte_std as (

SELECT s1.id id1, s1.visit_date vd1, s1.people sp1,
    s2.id id2, s2.visit_date vd2, s2.people sp2,
    s3.id id3, s3.visit_date vd3, s3.people sp3
FROM Stadium s1 INNER JOIN Stadium s2 INNER JOIN Stadium s3
ON s2.id = s1.id+1 and s3.id=s1.id+2
and s1.people>=100 and s2.people>=100
and s3.people>=100

)
SELECT id1 id, vd1 visit_date, sp1 people
FROM cte_std
UNION
SELECT id2, vd2, sp2
FROM cte_std
UNION
SELECT id3, vd3, sp3
FROM cte_std
ORDER BY visit_date DESC;



--- 2 Trips
SELECT Day, ROUND((Cancelled_requests/Total_requests),2)as Cancellation Rate
FROM
    (SELECT t.request_at as Day, count(*)Cancelled_requests 
    FROM Trips t INNER JOIN Users u 
    ON t.client_id=u.users_id OR t.client_id=u.driver_id
    AND u.banned = 'No' 
    WHERE t.status like 'cancelled%'
    GROUP BY t.request_at)a
INNER JOIN 
    (SELECT t.request_at as Day, count(*)as Total_requests
    FROM Trips t INNER JOIN Users u 
    ON t.client_id=u.users_id OR t.client_id=u.driver_id
    AND u.banned = 'No' 
    GROUP BY t.request_at)b
USING (Day)
where Day BETWEEN '2013-10-01' AND '2013-10-03'
ORDER BY Day;



(SELECT t.request_at, count(*) FROM Trips t 
WHERE t.status like 'cancelled%'
GROUP BY t.request_at)
(SELECT t.request_at, count(*)as Total_requests
FROM Trips t INNER JOIN Users u 
--INNER JOIN Users d 
ON t.client_id=u.users_id AND u.role LIKE 'client%'
AND t.driver_id=d.users_id AND d.role LIKE 'driver%'
AND u.banned = 'No' AND d.banned = 'No'
where t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at);


SELECT distinct l1.num as ConsecutiveNums
FROM logs l1 INNER JOIN logs l2 INNER JOIN logs l3
ON l1.num = l2.num and l1.num = l3.num 
and l2.id =l1.id+1 and l3.id=l2.id+1;

SELECT l1.id, l1.num
FROM Logs l1 INNER JOIN Logs l2 INNER JOIN Logs l3
ON l1.num = l2.num AND l1.num = l3.num 
AND l2.id =l1.id+1 AND l3.id=l1.id+2;

SELECT li.id;

SELECT * from logs;
