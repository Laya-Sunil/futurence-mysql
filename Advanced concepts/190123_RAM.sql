-- describe will give the structure of table where as explain gives the execution plan of our query without actually executing it

/*
type -- > 
null  no indexes available ie no primary key and foreign key
ref   non unique column index
const primary key/unique
index_merge where clause columns having individual indexes
all  when the column in where clause doesnt have an index
range when > < operators are used
system when nothing is happening then it utilise 
covering index - instead of going to table scan and index it will go only to index

*/

use db_optimised;
use hr;

explain select * from (Select max(sal) from emp) a;

explain select * from regions where region_id=4;

show indexes from emp;

alter table emp alter index dept_job_idx invisible;
desc emp;
-- when there are 2 individual indexes whi are being used in where cluse then it will automatically becomes  index merge
explain select * from emp where deptno =20 and job='clerk';

alter table emp
drop constraint `FK_DEPTNO`;

show create table emp;

explain select * from emp where hiredate = '1981-12-03';

explain select * from emp where comm is null;
explain select * from emp where comm is not null;


create index comm_idx on emp(comm);
create index hire_idx on emp(hiredate);

alter table emp alter index deptno_idx invisible;
alter table emp alter index job_idx invisible;
alter table emp alter index dept_job_idx visible;


show indexes from emp;

explain select * from emp where deptno =20;
explain format=tree select * from emp where deptno =20;
explain format=tree select * from emp force index(comm_idx) where deptno =20;


explain select * from emp where job = 'clerk';
explain format=tree select * from emp force index(comm_idx) where job = 'clerk';
explain format=tree select * from emp force index(comm_idx) where job = 'clerk';
-- whenever composite index is there we cannot force index non leading columns

-- to see the unused indexes
select * from sys.schema_unused_indexes;

explain select * from emp where empno between 1000 and 2000;
explain select * from emp where empno >1000;
explain select * from emp where sal between 1000 and 5000;
explain format=tree select empno from emp where deptno in (10,20);

explain format=tree select max(Sal) from emp;
explain format=tree select min(Sal) from emp;
explain format=tree select avg(Sal), sum(sal) from emp;
create index sal_idx on emp(sal);

explain format=tree select deptno,min(Sal) from emp group by deptno;
explain format=tree select job, sum(sal) from emp group by job;

explain format=tree select job, sum(sal) from emp 
where job like 'clerk%'
group by job;

explain format=tree select job, sum(sal) from emp 
group by job
having job like 'clerk%';

-- without index
explain format=tree select job, sum(sal) from check_ext 
where job like 'clerk%'
group by job;

explain format=tree select job, sum(sal) from check_ext 
group by job
having job like 'clerk%';

use db_optimised;

-- where vs having
explain format=tree select job, count(*) from list_job 
group by job
having job like 'clerk%';
explain format=tree select job, count(*) from list_job 
where job like 'clerk%'
group by job;

desc list_job;
-- with index
create index job_idx on check_ext(job);

explain format=tree select job, sum(sal) from check_ext 
where job like 'clerk%'
group by job;

explain format=tree select job, sum(sal) from check_ext 
group by job
having job like 'clerk%';

-- create a table 
create table student1(
student_id numeric(11) primary key, 
student_name varchar(15), 
result char(1),
check(result in ('P','F'))
 );

insert into student1(student_id, student_name) select employee_id, first_name from hr.employees;

truncate student1;
select * from student1;

update student1 
set result = (
	case 
		when student_name like '%s%' then 'P'
        else 'F'
	end
);

select * from student1;


select result, count(*) Total_students 
from student1
group by result;

explain format=tree select result, count(*) Total_students 
from student1
-- where result in ('P','F')
group by result;

create index res_idx on student1(result);

alter table student1
drop index sid_idx;

drop index res_idx on student1;

show indexes from student1;

-- union vs rollup
select sum(sal), job from emp group by job
union
select sum(sal), null from emp;

explain 
select sum(sal), job from emp group by job
union
select sum(sal), null from emp;

explain format=tree
select sum(sal), job from emp group by job
union
select sum(sal), null from emp;

explain format=tree
select sum(sal), job from emp group by job with rollup;



explain format=tree
select sum(salary), job_id from hr.employees group by job_id
union
select sum(salary), null from hr.employees;
explain format=tree
select sum(salary), job_id from hr.employees group by job_id with rollup;

create table reg1 as select * from hr.regions;

alter table reg1
add constraint primary key(region_id);


create table country1 as select * from hr.countries;

alter table country1
add constraint fk_reg_country
foreign key(region_id) references reg1(region_id);

explain format=tree select region_name, country_name from reg1 force index(reg1_idx) natural join country1;

select count(*) from hr.countries;
explain format=tree select region_name, country_name from hr.regions natural join hr.countries;

create index comp_idx on reg1(region_id, region_name);
show indexes from  hr.regions;

-- optimiser loops
-- nested loop
-- when there are no indexes on table optimiser performs hash join
drop index reg_idx on country1(region_id);
create index reg1_idx on reg1(region_id);

