use org;

set @dob = '1998-02-05';

with recursive cte_birthdays as 
(
    select @dob as 'dob' from dual
    union all 
    select date_add(dob,interval 1 year) from cte_birthdays
    where year(cte_birthdays.dob)<year(curdate())
) 
select dob,dayname(dob) from cte_birthdays;

use library_case;

show triggers;
show create function func_new_rental;

with recursive cte as 
(
    select '2001-01-01' as 'day_' 
    union all 
    select date_add(day_,interval 1 year) from cte
    where year(cte.day_)<=year(curdate())
) 
select dayname(day_) from cte;


use db_optimised;
-- 1
select ename,sal, rank()over(order by sal desc) 'rank_', 
dense_rank()over(order by sal desc) 'dense_rank_'
from emp;
-- 2
select ename,sal,  lead(sal)over(order by sal)'lead', 
lag(sal)over(order by sal)'lag'
from emp;
-- 3
select ename, sal, deptno, max(sal)over(partition by deptno)'max_sal'
from emp;
-- 4
with cte as (
select ename, job, hiredate, first_value(hiredate)over(order by hiredate desc) 'last_joined'
from emp
where job like'clerk%'
)
select * from cte where hiredate = last_joined;

select * from emp where job like'clerk%' order by hiredate desc;

 with recursive cte_2
 as
 (
	select 1 'n'
    union all
    select n+1 from cte_2 where cte_2.n<=52
 )
 select * from cte_2;
 
 
 
 with recursive cte_birthdays as 
(
    select '1998-02-05' as 'dob' from dual
    union all 
    select date_add(dob,interval 1 year) from cte_birthdays
    where year(cte_birthdays.dob)<year(curdate())
) 
select dob,dayname(dob) from cte_birthdays;
