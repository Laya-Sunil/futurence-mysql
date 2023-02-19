-- Create a view named V$DEPT30 that contains the employee  numbers, employee names, and department numbers for 
-- all employees in department 30.

use hr;

create view v_dept30 as
select employee_id, concat(first_name,' ', last_name)'Name', department_id
from employees 
where department_id = 30;

select * 
from v_dept30;

update v_dept30
set department_id = 40
where employee_id = 114; -- here if dept is changed then that value will not appear in the view anymore as it will be auto updated 
-- now that it doesnt satify the underlying condition applied while creating the view

-- .create a view which consists of    employees who have joined in the   second half of their joining year. 
create or replace view v_dept30 as
select  employee_id, concat(first_name,' ', last_name)'Name', department_id
from employees 
where month(hire_date) between 7 and 12;  -- this will replace the earlier view 
-- here if we update the depart no it will reflect in depart no column and data will not disappear because 
-- now that underlying condition applied does not depend on



select * from v_dept30 
where substr(name,1,instr(name,' ')) like '%s%';

create view v_emp_Under_200 as 
select employee_id, first_name, salary from employees
where employee_id<200;

drop view v_emp_Under_200;

select * from v_emp_Under_200;

insert into v_emp_Under_200
values(11,'abc',10000);

-- 
create view v_dept as
select empno, ename, deptno, sal
from emp
where deptno=30;

select * from v_dept;



grant select on db_optimised.v_dept to user1@localhost;


-- Display totalsalary,totsalary for each job_id,totalsalary for each deparment_id (employees table)
-- Using rollup
-- Using set operators
select  job, sum(sal) Total from emp group by job with rollup;

select job, sum(Sal)Total from emp group by job
union
select ' ', sum(sal) from emp;

select job,deptno, sum(sal)
from db_optimised.emp
group by  deptno, job with rollup;


use db_optimised;

select * from emp where comm <>300;
alter table emp
add column tt int;

desc emp;