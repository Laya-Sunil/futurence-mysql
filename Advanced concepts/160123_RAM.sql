/*
OLAP 
-- online analytical processing
-- date numeric datatype
-- window functions  -- over() clause
	over can have order by, partition, frame
    
    -- ranking functions
    row_number()
    rank() -- it leaves a gap
    dense_rank() -- no gap
    -- comparing functions
    LAG() -- return data from previous row
    LEAD() -- access data from next row
    first_value()
    last_value() -- 
			range - between unbounded preceding and unbounded following
            rows -  between unbounded preceeding and current row
					between current row and unbounded following
    nth_value()
    ntile() - divide into equal parts
*/
use hr;

select min(salary) over() 'minsal', max(Salary) over() 'maxsal', sum(salary) over() 'totalsal', 
avg(salary) over() 'avgsal', count(salary)over() 'count'
from employees;
-- running total
select e.first_name, e.salary, sum(j.salary)
from employees e inner join employees j on e.employee_id>=j.employee_id
group by first_name, e.salary;
-- or
select first_name, salary, (select sum(salary) from employees where employee_id<=e.employee_id)cumm_sum
from employees e;

select first_name, salary, sum(salary) over(order by salary desc) 'sum' from employees e;

select first_name, salary, row_number()over() from employees;

select first_name, salary, row_number()over(order by salary) 'row',
rank()over(order by salary) 'rank', dense_rank()over(order by salary) 'dense_rank'
from employees;

select first_name, salary, rank()over(order by salary) 'rank' from employees;
select first_name, salary, dense_rank()over(order by salary) 'dense_rank' from employees;

--

select first_name, salary, lag(salary)over(order by salary) 'prev_sal' ,
lead(Salary)over() 'next_salary'
from employees;

select first_name, salary, lag(salary,2)over() 'lag 2' from employees;

select first_name, salary, lead(salary)over(),lead(salary,3)over() 'lead 2' from employees;

use db_optimised;
show tables;
select ename, sal, lead(comm)over(order by comm) from emp;
--
select first_name, hire_date, lead(hire_date)over()'lead',
lag(hire_date)over()'lag' from hr.employees;


-- number of days diff between 1st and 2nd analyst
show tables;

select ename, hiredate, lag(hiredate)over(order by job, hiredate) 'analyst 2 hiredate', 
datediff(hiredate, lag(hiredate)over(order by job, hiredate))'diff' from db_optimised.emp
where job like 'analyst';

select ename, sal, first_value(sal)over(order by sal) '1st', last_value(sal)over() 'last' from db_optimised.emp;

select ename, hiredate, first_value(hiredate)over(order by hiredate) from db_optimised.emp where job like 'analyst';

select ename, sal, nth_value(sal, 5)over(order by sal desc)'3rd highest sal'
from db_optimised.emp;

select ename, sal, nth_value(Sal,4)over(order by sal desc)'nth';

select ename, sal, last_value(sal)over(order by sal asc range between unbounded preceding and unbounded following )'last value'
from db_optimised.emp;

select ename, sal, last_value(sal)over(rows between unbounded preceding and current row)'value - preceding - current',
last_value(sal)over(rows between current row and unbounded following)'value - current - following'
 from db_optimised.emp;

select ename, sal, sum(sal)over(partition by deptno)'total sal' from db_optimised.emp;
select ename, sal,deptno, first_value(hiredate)over(partition by deptno order by hiredate ) 'first_hired' from emp;

select ntile(5)over() 'groups', ename, deptno from emp;

-- CTE
/*

*/
with cte_1
as
(
select avg(Sal) avsal, deptno from emp group by deptno
)
select e.ename, e.sal, e.deptno, cte_1.avsal
from emp e join cte_1
on e.deptno = cte_1.deptno
and e.sal>cte_1.avsal;

select e.ename 'employee',e.deptno,count(*)over(partition by e.deptno)'count',
 m.ename 'manager', m.deptno, count(*)over(partition by m.deptno)'count' 
 from emp e join emp m on e.mgr = m.empno;
 
 
 -- recursive cte
 with recursive cte_2
 as
 (
	select 1 'n'
    union all
    select n+1 from cte_2 where cte_2.n<=30
 )
 select * from cte_2;
 
 -- write cte to generate calender for jan 2023
 set @d = '2023-01-01';
 with recursive cte_3
 as
 (
	select @d as 'date_'
    union all
    select date_add(date_, interval 1 day) from cte_3 where day(cte_3.date_)<=31
 )
 select * from cte_3;
 use db_optimised;
 
 select ename, hiredate, first_value(hiredate)over w 'ist',
	last_value(hiredate)over w 'Last',
    nth_value(hiredate, 5)over w '5th'
from emp
window w as (order by hiredate range between unbounded preceding and unbounded following);

--
with cte as (
select deptno, count(*) cnt from emp group by deptno
)
select e.ename 'employee',e.deptno,
 m.ename 'manager', m.deptno, c1.cnt 'emp_Count', c2.cnt 'mng_count'
 from emp e join emp m on e.mgr = m.empno
 join cte c1 on e.deptno = c1.deptno 
 join cte c2 on m.deptno = c2.deptno;
 
 
 select count(*) from emp where deptno = 20;
 