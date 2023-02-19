--
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
it is virtual table which takes data from backend table. Only partial rows/columns can be providede to the particular teams
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
set department_id=12;  -- throws check option failed error


