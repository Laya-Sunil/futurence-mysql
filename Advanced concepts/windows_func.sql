-- WINDOWS FUNCTIONS



use hr;

select count(*) from employees;

--  1. Getting running total of salary

select e.first_name, e.salary, sum(j.salary)
from employees e inner join employees j
on e.employee_id>=j.employee_id
group by e.first_name, e.salary
order by e.salary desc;
-- where e.first_name like 'Bruce%';
-- using window

-- 
-- number of days diff between 1st and 2nd analyst
select ename, job, hiredate, lead(hiredate)over(order by hiredate) 'lead_hire',
			datediff(lead(hiredate)over(order by hiredate), hiredate) 'number of days'
            -- timestampdiff(day, hiredate, lead(hiredate)over(order by hiredate))
from db_optimised.emp
where job='analyst';

-- Find the fifth highest salary  and employees who draw that salary

-- dendse_rank()
explain format=tree
select first_name, salary 
from
		(select first_name, salary, dense_rank()over(order by salary desc) dr_
		from employees)a
where dr_ = 5;

-- with cte
explain format=tree
with cte as 
(
	select first_name, salary, dense_rank()over(order by salary desc) dr_
	from employees
)
select first_name, salary
from cte
where dr_=5;

-- nth value -- this does not work when there are same salaries involved
-- explain format=tree
select first_name, salary  from employees 
where salary in
(select nth_value(salary,3)over(partition by salary) nth_
from employees);

--



explain format=tree
select first_name, salary
from employees
where salary = (
select distinct salary
from employees
order by salary desc
limit 4,1);

-- get top 4 salary
-- explain format=tree
select first_name, salary
from employees e
where 4 >= (
select count(distinct salary)
from employees
where salary>e.salary
order by salary desc)
order by salary desc;

-- rank the salary without using window function
select salary, (select count(distinct salary)+1  from employees where salary>e.salary) as rank_
from employees e
order by salary desc;

-- display employee name, salry, their depart total salary
select first_name, salary, department_id, sum(salary)over() 'Total Salary', sum(salary)over(partition by department_id) 'Total department salary'
from employees;

-- find the no of days difference between first hired employee and every other employee
select first_name, hire_date, first_value(hire_date)over(order by hire_date),
			timestampdiff(day, first_value(hire_date)over(order by hire_date), hire_date) 'days_'
from employees;

-- -- find the no of years difference between first hired employee and last hired employee
-- explain format=tree
select distinct timestampdiff(day, first_value(hire_date)over(order by hire_date), last_value(hire_date)over()) 'days_'
from employees;

-- explain format=tree
select timestampdiff(day, min(hire_date), max(hire_date)) 'day_diff'
from employees;

-- logs problem (assessment)
create table log (id int, num int);

insert into log
values(1,1),(2,1),(3,1),(4,2),(5,1),(6,2),(7,2);

insert into log values(8,2);

select *
from log;
-- get numbers which appears atleast 3 times consecutively
select id,num from
(select  id, num, lead(num)over() num2, lead(num,2)over() num3
from log) a
where num=num2 and num2=num3;

SELECT l1.id, l1.num
FROM Log l1 INNER JOIN Log l2 INNER JOIN Log l3
ON l1.num = l2.num AND l1.num = l3.num 
AND l2.id =l1.id+1 AND l3.id=l1.id+2;

-- 29/01/23
-- List highest paid employees in each department.Display ename,deptno,sal
use db_optimised;

select * from emp;

select * from emp
where (deptno, sal) in 
		( select deptno, max(sal)
			from emp 
			group by deptno );

select * from (		
select empno, ename, sal, deptno, dense_rank()over(partition by deptno order by sal desc) r_
from emp)a
where r_= 1;

-- List highest paid employees in each job.Display ename,job ,sal
select * from (		
select empno, ename, sal, job, dense_rank()over(partition by job order by sal desc) r_
from emp)a
where r_= 1;
-- or
select * from emp
where (job, sal) in 
		( select job, max(sal)
			from emp 
			group by job );

-- Find the Seniormost Manager
explain format=tree
select * from emp where hiredate = (
				select min(hiredate)
				from emp
				where job = 'manager');
-- or


select * from emp inner join (
				select min(hiredate)hire
				from emp
				where job = 'manager')a
on emp.hiredate=a.hire
and job = 'manager';
-- or
explain format=tree
select * from (
select ename, hiredate, min(hiredate)over(partition by job) as min
from emp
where job = 'manager')a
where hiredate=min;



-- Find Highest paid Salesman
select * from emp where sal=
(select max(sal)
from emp
where job ='Salesman') and
job ='Salesman';

-- Find Lowest paid CLERK
select * from
(select *, min(sal)over(partition by job)min
from emp where job ='clerk')a
where sal=min;

-- Find Juniormost CLERK

-- Display employees who is taking more salary than average salary in their respective jobs
select * from (
select *, avg(sal)over(partition by job)avg
from emp)a
where sal>avg;

select * from emp e
where sal> (select avg(sal) from emp where job=e.job);

--  Display employee name,sal,sal difference for every employee And successive employee
select *, sal-next_sal as diff from (
select *, lead(sal)over(order by hiredate) next_sal
from emp)a;


-- Find the number of days difference between  1st analyst and 2nd analyst 
select *, timestampdiff(day, first_hire, last_hire) days_diff from (
select ename, job, hiredate, first_value(hiredate)over(order by hiredate)first_hire, last_value(hiredate)over() last_hire
from emp
where job='analyst')a;

select *, abs(last_sal-first_sal) sal_diff from (
select ename, job, hiredate, sal,first_value(sal)over(order by hiredate)first_sal, last_value(sal)over() last_sal
from emp
where job='salesman')a;

-- Using the WITH clause, write a query to display the department name and total salaries for those departments 
-- whose total salary is greater than the average salary across departments.

with cte as 
(
	select  avg(sal)avg from emp
),
cte_2 as (
	select deptno, sum(sal) total
	from emp
	group by deptno
)
select deptno, total from cte_2 join cte on total>avg;

-- 
with cte as 
(
	select  sum(sal)avg from emp
),
cte_2 as (
	select deptno, sum(sal) total
	from emp
	group by deptno
)
select deptno, total from cte_2 join cte on total>(1/8)*avg;

-- Write a query to display the last names of employees who have one or more
-- coworkers in their departments with later hire dates but higher salaries.
select * from (
select deptno, ename, hiredate, sal, lead(hiredate)over(partition by deptno order by hiredate) later_hire
			 ,lead(sal)over()high_sal
from emp
)a
where later_hire is not null and high_sal>sal;

-- 
