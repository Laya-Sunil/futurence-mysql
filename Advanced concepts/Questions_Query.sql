-- count occurence of character in string
select department_name, length(department_name), replace(lower(department_name),'a',''),
		length(department_name)-length(replace(lower(department_name),'a','')) "Total a's"
from departments;

-- last character of name
select substr(first_name, length(first_name), 1), first_name
from employees;
-- names with last character is repeated
select first_name, substr(first_name, length(first_name), 1) 'last character',
		locate(substr(first_name, length(first_name), 1), reverse(first_name),2) 'second pos of last character '
from employees
where locate(substr(first_name, length(first_name), 1), reverse(first_name),2)>0;

-- Display all first_name with last character being different case.
select concat(substring(first_name, 1, length(first_name)-1),Upper(right(first_name, 1))) 'Name'
from employees;

-- Display only those names where second character is getting repeated In 3rd position.
select first_name
from employees
where substr(first_name,2,1)=substr(first_name,3,1);

-- Display all the employees names replacing with * as per the length of their names
select  repeat('*', length(first_name)) 'name'
from employees;

--  Show those employees that have a name starting with ‘J’, ‘K’,’M’,’S’
select first_name
from employees
where first_name rlike '^[jmsk]';

-- employees names ending with a,s,n
select first_name
from employees
where first_name regexp ('[s,n]$');

--  name ending with en
select first_name
from employees
where first_name rlike 'en$';

-- or
select first_name
from employees
where first_name like '%en';

--
select job_id
from employees
where job_id rlike '[a-z]*';


select first_name
from employees
where first_name REGEXP_LIKE(first_name, 'w'); -- not supported

-- names containg k
select first_name
from employees
where first_name like '%k%';
-- using regexp
select first_name
from employees
where first_name regexp 'k';
-- or
select first_name
from employees
where first_name rlike 'k';

-- names containing e, a 
select first_name
from employees
where first_name like '%e%a%';
-- or
select first_name
from employees
where first_name rlike '[e]+.*[a]+';

-- name containing exactly 5 characters
select first_name 
from employees
where first_name like '_____';

select first_name 
from employees
where first_name rlike '^.....$';
-- or
select first_name 
from employees
where first_name rlike '^.{5}$'; -- repeat 5 times

-- contains 1 or more a in name
select first_name
from employees
where first_name rlike 'a+';
-- contains 3 or more a 
select first_name 
from employees
where first_name REGEXP 'e{1}+.*e{1}+';

-- third letter is a
select first_name 
from employees
where first_name REGEXP '^..a';
-- thirds character is vowels
select first_name
from employees
where first_name regexp '^..[aeiou]';


-- contains only digits
select first_name 
from employees
where first_name REGEXP '[:digit:]';

-- contains only alphabets
select first_name 
from employees
where first_name REGEXP '[:alpha:]';

select first_name 
from employees
where first_name REGEXP '[0-9]+';

select first_name 
from employees
where first_name REGEXP '^al';

-- names does not start with al or end with k
select first_name 
from employees
where first_name REGEXP '^[^al]|k$';
-- names does not start with al and end with k
select first_name 
from employees
where first_name REGEXP '^[^al].*k$';
-- job id with 'a' getting repeated
select distinct job_id
from employees
where job_id rlike 'a+.*a+';
/*
REGEXP NOTES
----------------------------
. - indicates exactly one character
^ - begining of the string
$ - ending of the string
+ - 1 or more
* - 0 or more
.* - everything
{} - denotes the number of occurences
[abc]	Any character listed between the square brackets
[^abc]	Any character not listed between the square brackets
? - Match zero or one instances of the strings preceding it.
p1|p2|p3	Alternation; matches any of the patterns p1, p2, or p3

https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/

*/

-- AGGREGATE
select count(job_id) from employees;


-- Count the number of people who joined in the leap year.

SELECT count(*) FROM db_optimised.emp 
WHERE 
(case when MOD(YEAR(`HIREDATE`),4)=0 and  MOD(YEAR(`HIREDATE`),100)<>0 then 1
		when MOD(YEAR(`HIREDATE`),400)=0 then 1
end)=1;

--  Find out the number of people having vowels as a last character in their enames
select first_name, right(first_name,1)
from employees
 where right(first_name, 1) rlike '[aeiou]$';
 
 select count(*)
 from employees
 where right(first_name, 1) rlike '[aeiou]$';
 
 select job_id, count(*) c, max(SALARY), min(SALARY)
 from employees
 group by job_id
 order by c desc;
 
 select department_id, job_id, avg(salary)
 from employees
 where job_id <> 'SH_CLERK'
 group by department_id, job_id;
 
 select department_id, avg(Salary)
 from employees 
 group by DEPARTMENT_ID
 having count(*)>5;
 
 select job_id
 from employees
 group by job_id
 having max(salary)>=14000;
 
 select job_id, count(*)
 from employees
 group by job_id
 having count(*)=1;
 
 -- set operators
 select first_name, last_name 
 from employees
union all
 select first_name, last_name 
 from employees
 where first_name like 's%';
 
(  select first_name, last_name 
 from employees)

 (select first_name, last_name 
 from employees
 where first_name like 's%');
 
 select *
 from employees e left join employees m
 on e.EMPLOYEE_ID=m.EMPLOYEE_ID
 union
  select *
 from employees e cross join employees m
 on e.EMPLOYEE_ID=m.EMPLOYEE_ID;
 
 -- joins available in mysql -- cross join, inner join, left join, right join, natural join
 -- List all employees who joined the company before their manager.
select e.employee_id, e.first_name, e.hire_date, m.hire_date
from employees e inner join employees m
on e.manager_id = m.employee_id
where e.hire_date<m.hire_date;

--
select e.employee_id, e.first_name, m.FIRST_NAME, e.salary, m.salary
from employees e inner join employees m
on e.manager_id = m.employee_id
where e.SALARY>m.SALARY;

--
select e.employee_id, e.first_name, m.first_name 'manager', d.DEPARTMENT_NAME
from employees e inner join employees m
on e.manager_id = m.employee_id
inner join departments d on m.DEPARTMENT_ID = d.DEPARTMENT_ID;

--
explain format =tree
select DEPARTMENT_NAME, count(e.employee_id) count
from employees e inner join departments d
on e.department_id = d.department_id
group by department_name
order by count desc
limit 1;

-- 
-- explain format =tree
with cte as (
select distinct DEPARTMENT_NAME, count(e.employee_id) over (partition by department_name) count
from employees e inner join departments d
on e.department_id = d.department_id
),
cte_2 as (select max(count)max_ from cte)
select department_name, count from cte inner join cte_2 on cte.count=cte_2.max_;

select * from (
select distinct DEPARTMENT_NAME, count(e.employee_id) over (partition by department_name) count
from employees e inner join departments d
on e.department_id = d.department_id )a
where count = ( select max(count) from (select count(employee_id)count from employees group by department_id)b);

desc db_optimised.job_grade;
show tables;
use hr;
desc departments;
use db_optimised;

select e.EMPLOYEE_ID, e.FIRST_NAME
from employees e inner join departments d on e.department_id=d.department_id
where d.location_id =1800;

-- Find the job_id that was filled in first half of  any year and the same job_id that was filled during first half of next year
select c.job_id, c.hire_date, n.job_id
from employees c inner join employees n
on year(n.hire_date) = year(c.hire_date)+1 and c.job_id = n.job_id
where month(c.hire_date) between 1 and 7
and  month(n.hire_date) between 1 and 12;

SELECT distinct e.`job`, e.`HIREDATE`, a.`job`, a.`HIREDATE`
from db_optimised.emp  e INNER JOIN db_optimised.emp a 
on  e.`JOB`=a.`JOB`
and month(e.`HIREDATE`) between 7 and 12 
and month(a.`HIREDATE`) between 1 and 6
and year(a.`HIREDATE`)=year(e.`HIREDATE`)+1;


-- subqueries

-- 
select * from employees
where salary>any
(SELECT salary
 FROM   employees
 WHERE  last_name in('Kochhar','Russell'));
 
 -- 
 select * from employees
where salary>all
(SELECT salary
 FROM   employees
 WHERE  last_name in('Kochhar','Russell'));


SELECT salary
 FROM   employees
 WHERE  last_name in('Kochhar','Russell');
 
 select max(salary) from employees;
 
 -- employees receiving max salary in their departments
 select * from employees
 where (department_id, salary) in
 (select department_id, max(SALARY)
 from employees 
 group by department_id);
 
 -- corelated
 -- employees getting salary greater than the department avg salary
 
explain format=tree
 select * 
 from employees e
 where salary> (
	select avg(SALARY)
    from employees
    where DEPARTMENT_ID=e.DEPARTMENT_ID
 );
 and DEPARTMENT_ID in (40,50);

select *, count(*)over()
from employees;

-- explain format=tree
 select * 
 from employees e
 where salary> (
	select avg(SALARY)
    from employees
    where DEPARTMENT_ID=e.DEPARTMENT_ID
     -- and DEPARTMENT_ID in (40,50)
     );
 
explain format=tree
with cte as (
	select department_id, avg(salary) avg_sal
    from employees
    group by DEPARTMENT_ID
)
select e.* 
from employees e inner join cte
on e.DEPARTMENT_ID = cte.department_id
and e.salary > cte.avg_sal;


explain format=tree
select e.*
from employees e inner join 
		(select department_id, avg(salary) avg_sal
			from employees
			group by DEPARTMENT_ID) a
using(department_id)
where e.salary > a.avg_sal;

-- in above case subquery is the most optimised one
-- List department_id with maximum average salary

select department_id, avg(salary) avg_
from employees
group by department_id
order by avg_ desc
limit 1;
-- or -- subquery
select department_id, avg_
from (select department_id, avg(salary) avg_
	from employees
	group by department_id)t
where avg_ = ( select max(avg_) from 
		(selec\avg(salary) avg_
		from employees
		group by department_id)t
);
-- or -- cte + window

with cte as
(
	select department_id, dense_rank()over(order by avg_ desc) r_
    from (select department_id, avg(salary)avg_
		from employees
        group by department_id)t
)
select * from cte where r_=3;
;

select * from (
select department_id, dense_rank()over(order by avg_ desc) r_
    from (select department_id, avg(salary) avg_
		from employees
        group by department_id)t
        ) s
        where r_=1;
        
        
        
select first_name, employee_id, salary, job_id
from employees
where (job_id,salary) in (select job_id, max(salary)
					from employees 
                    group by job_id);
        
select first_name, employee_id, salary, job_id
from employees
where (department_id, hire_date) in
(select department_id, max(hire_date)
from employees
group by department_id);

select first_name, employee_id, salary, job_id
from employees
where (job_id,salary) in (select job_id, min(salary)
					from employees 
                    group by job_id);

select job_id, max(salary)
					from employees 
                    group by job_id;
                    
-- List departments for which no employees exists.
select * from departments
where DEPARTMENT_ID not in (select distinct department_id from employees);

select d.* 
from departments d left outer join employees e
on d.DEPARTMENT_ID =e.DEPARTMENT_ID;

use hr;
-- In which year did most people join the company. Display the year and   no of employees

select year(hire_date) year, count(*)
from employees
group by year;

--
select first_name from employees where  
	(
	select job_id, max(emps)
	from (
		select job_id, count(employee_id) emps
		from employees
		group by job_id) a 
	)
;

select job_id
	from (
		select job_id, count(employee_id) emps
		from employees
		group by job_id) 
	group by job_id 
    having emps= (select max(employee_id) emps
		from employees
		group by job_id) ;
        
        


select job_id, first_value()over(partition by job_id)
		from employees;
		
        
with cte as (
select job_id, row_number()over(partition by job_id)
		from employees
)
;
-- Write a query to list first_names with job having maximum no., of employees
explain format=tree
select first_name from employees where job_id in (
	select job_id from
	(
	select job_id, emps, dense_rank()over(order by emps desc)r_
	from
		(select job_id, count(employee_id) emps
			from employees
			group by job_id)a
	)b
where r_ = 1);
explain format=tree
with cte_1 as (select job_id, count(employee_id) emps
				from employees
				group by job_id),

cte as (
		select job_id, emps, dense_rank()over(order by emps desc)r_
		from cte_1
)
select first_name
from employees e inner join cte 
on e.job_id = cte.job_id
and cte.r_ = 1;


-- Write a query to list first_names having maximum number of characters in their name
select first_name from employees 
where length(first_name)=
	(
		select max(length(first_name)) len
		from employees
    );
    
  -- salary more than average sal  
    select employee_id, first_name
    from employees
    where salary>(
		select avg(salary) from employees
    );
    
-- 
select curdate()<curdate()+1;

desc departments;

-- Find employees who earn highest salary in each job_id type
select first_name from employees a where salary = 
	
	(
		select max(salary) emps
			from employees e
			where e.job_id=a.job_id
	);

-- Find out names of the employees who have joined on the same date
select first_name, hire_date, row_number()over(partition by hire_date order by first_name) row_
from employees;


show tables from ;
use db_optimised;

select * from t1;  -- 5 rows

select * from t2;  --  5 rows

select * from t1 inner join t2 on t1.id = t2.id2;  -- 9 rows -- inner join doesnt take null values

select * from t1 cross join t2;  -- 25 rows including nulls

select * from t1 left join t2 on t1.id = t2.id2; -- 11 rows


select * from t1 left outer join t2 on t1.id = t2.id2; -- same as left join

select * from t1 right join t2 on t1.id = t2.id2; --

insert into t1 values(null);

-- Find the department name where maximum numbers of employees are working.

explain format=tree
select DEPARTMENT_NAME from (
			select DEPARTMENT_NAME, count(employee_id) count_emp 
			from employees e inner join departments d
			on e.department_id = d.department_id
			group by DEPARTMENT_NAME) a
where count_emp = (select max(count_emp) from  
								( select department_id, count(*) count_emp
									from employees
									group by department_id)t);



-- explain format=tree
with  cte_1 as (
			select department_id, count(*) count_emp
			from employees
			group by department_id
),
cte_2 as (
		select max(count_emp)max_ from  cte_1
)
select DEPARTMENT_NAME, cte_1.DEPARTMENT_ID
from cte_1 inner join departments d on cte_1.department_id = d.department_id
inner join cte_2 on cte_1.count_emp = cte_2.max_;

use db_optimised;
use hr;
select deptno, count(ename)over(partition by deptno) from emp;

explain format=tree
select department_id, m as max_emp_count_dept
from (select e.*, max(cnt) over () m
      from (select employees.*, count(first_name) over (partition by department_id) cnt from employees
			) e
      ) t
where cnt = m
group by department_id, m;

select EMPLOYEE_ID, max(salary)over()
from employees;

select max(salary) from employees;

select DEPARTMENT_NAME from (
			select DEPARTMENT_NAME, count(employee_id) count_emp 
			from employees e inner join departments d
			on e.department_id = d.department_id
			group by DEPARTMENT_NAME) a
where count_emp = (select max(count_emp) from  
								( select department_id, count(*) count_emp
									from employees
									group by department_id)t);
                                    
