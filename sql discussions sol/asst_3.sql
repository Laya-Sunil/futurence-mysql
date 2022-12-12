-- Active: 1670401223911@@127.0.0.1@3307@hr
-- 1. 
SELECT (SELECT sum(`SALARY`) FROM employees )total_salary, min(e.`SALARY`)min_sal,
        max(e.`SALARY`)max_sal,avg(e.`SALARY`)avg_sal
FROM employees e INNER JOIN departments d 
ON e.`DEPARTMENT_ID`=d.`DEPARTMENT_ID`
WHERE e.`DEPARTMENT_ID`=90
GROUP BY e.`JOB_ID`; 

-- 2. 
SELECT d.name, e.name, e.salary
FROM Employee e INNER JOIN Department d 
ON e.departmentid = d.id
WHERE 3>(
        SELECT count(distinct salary) from Employee c
        where c.departmentid=e.departmentid 
        and e.salary<c.salary
        )
ORDER BY d.name, e.name;


with cte_r(
SELECT distinct department_id, salary , 
    ROW_NUMBER()over(PARTITION BY department_id 
    ORDER BY department_id, salary desc)r_
FROM Employee )
SELECT d.name, c.name

with cte as(
select DISTINCT e.`JOB_ID`,e.`SALARY`, 
ROW_NUMBER()over(PARTITION BY e.`JOB_ID` ORDER BY e.`JOB_ID`,e.`SALARY` DESC )r_
from employees e 
)
SELECT * from cte WHERE r_<4;

select DISTINCT e.`JOB_ID`,e.`SALARY`, 
ROW_NUMBER()over(PARTITION BY e.`JOB_ID` 
                ORDER BY e.`JOB_ID`,e.`SALARY` DESC )r_
from employees e ;
-- GROUP BY e.`JOB_ID`
-- ORDER BY e.`SALARY` desc;

-- 3. 
SELECT distinct l1.num as ConsecutiveNums
FROM Logs l1 INNER JOIN Logs l2 INNER JOIN Logs l3
ON l1.num = l2.mum and l1.num = l3.num 
and l2.id =l1.id+1 and l3.id=l2.id+1;
            
-- 4.  
SELECT id, CASE
                WHEN pid = null then "Root"
                WHEN id in (SELECT DISTINCT pid from Tree ) then "Inner"
                ELSE "Leaf"
            END type 
FROM Tree
ORDER BY id;
