--
grant all privileges on hr.employees to 'test'@'localhost';
revoke all privileges on hr.employees from 'test'@'localhost';

show databases;

create database test;

use test;

create table auto(
	c1 int primary key auto_increment,
    c2 date
);

desc auto;
insert into auto(c2)
values(curdate()), ('2022-12-23'),( '2022-03-02');

insert into auto values(4,'2022-07-09');

select * from auto;

select last_insert_id();

---

-- VIEWS
/*
it is used to protect the table and only provide minimal access to others.
it is virtual table which takes data from backend table. Only partial rows/columns can be provided to the particular teams
so all changes applied to views is reflected on original table as well

simple view
- created out of a single table
- permits updates

complex view
- more than 1 table
- not always permits updates

dmls on view are prohibited if it contains union, group by, group functions, distinct operators

*/
use hr;

select * from employees;

create view v1 as 
select employee_id, first_name, last_name,salary, job_id
from employees 
where department_id=60;

create view v2 
as select sum(salary) 'Total', department_id
from employees
where department_id is not null
group by department_id;

select * from v2;

start transaction;
delete from v2
where total>55000;

create view v3 as
select distinct department_id, job_id from employees;

select * from v3;

delete from v3
where department_id=90;

-- complex view
create view v4
as select region_name, country_name
from regions natural join countries;

select * from v4;

-- with check option

create view v5
as select * from employees
where department_id =90 with check option;


select * from v5;

update v5
set email='kings'
where employee_id=100;

update v5
set department_id=12;  -- throws check option failed error

-- programming in mysql
/*
no concept of anonymous blocks
no seperate print statement in mysql, set and select is used for assignment and print
for delimiter donot use \(backslash) as it is an escape character
use ; in the procedure body to end each statement
end delimiter and then redefine the delimiter to ;

procedures are required in DB to perform particular activity like select, insert
do not use ddl, dcl commands

stored routines are pre compiled hence more efficient so they prefered in real time 
in trigger select, tcl commands are not allowed

--PROCEDURES
--------------
specific actions (select, insert, update, delete) 
it supports modular programming
they are precompiled, hence parsing is done only once

delimiter $$ 
create procedure <procedureName>() #parameters are specified here
	begin
		statements;
	end $$
delimiter ;
 
 --	RULES FOR VARIABLES
 -should be declared after begin statement
 -each variable should be declared seperately
 eg -- declare v1 int;
	   declare v2 int;
-dont use columns names as variable/parameter 
 -- no alter option for procedure

3 attributes of programming
sequence => order in which code should flow
selection => choice making process if elseif else
iteration => while simple repeat

while<condition>do
	statement 1;
    statement 2;
end while;

if <condition> then
	statements;
end if;

if <condition> then 
	statement;
else
	statement;

if <condition> then
	statement;
elseif
	statement;
else 
	statement;
end if;


*/
call new_procedure();
call proc_2(3,6);
-- create a procedure to pass employee id as parameter and print salary of that employee
call get_emp_salary(101);
-- create a procedure to pass employee id and get the full name  of employee and department name
call get_emp_details(101);

create table odd_even(
	slno int primary key, descn varchar(4)
    check(descn in('odd','even'))
);

-- truncate odd_even;
-- create procedure to insert rows into it using loop and if elseif else . pass lower and upper limit
call proc_insert_oddeven(10000,20000);

select count(*) from odd_even;

-- create a procedure to dob as parameter and print day of birth starting from dob to current date
select concat('2014',right('2022-02-12',6));

call proc_print_days('1998-02-05');

create table birth_days(day date, dayname varchar(10));
select count(*) from birth_days;
truncate birth_days;

show create procedure proc_print_days; -- to view the proc body
select specific_name, routine_type
from information_schema.routines
where routine_schema = 'hr';


-- exception handling
-- signal sqlstate '45000' set msg_test='invalid entry'

use hr;

call proc_exception_handle(10000);

call proc_exceptn_handle_2(10000);

-- parameter modes
/*
	in --- read (by default)
    out --- write
    inout --- read write
    
    https://www.javatpoint.com/mysql-procedure
    
*/
call proc_params(100,@p2);
select @p2;

set @p = 'Tom and Jerry';
call proc_inout(@p);
select @p as output;

use hr;

call nth_highest_sal(2);

select salary from employees order by salary desc;


with recursive cte_birthdays as 
(
    select '1998-02-05' as 'dob' from dual
    union all 
    select date_add(dob,interval 1 year) from cte_birthdays
    where year(cte_birthdays.dob)<year(curdate())
) 
select dob,dayname(dob) from cte_birthdays;

use db_optimised;
call proc_cursor_1();







