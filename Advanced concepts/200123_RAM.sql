-- foreign key cannot be declared as a column level constraint in mysql where as its possible in oracle
use db_optimised;
create table auto_new(c1 int primary key auto_increment, c2 date);

insert into auto_new values(null, '2001-02-02');
select last_insert_id();

alter table auto_new auto_increment = 100;

insert into auto_new values(null, '2001-02-09');

select * from auto_new;

----------------------------------------------------------------------------
-- COMPOSITE PARTITION
-- MAIN PARTITION  SHOULD BE LIST/RANGE
-- SUBPARTITION HASH
-- SUITABLE FOR AND OPERATOR
-- there is no ineterval partion in mysql it si available in oracle

create table compo_range(
	empno int,
    ename varchar(20),
    sal int,
    job varchar(20)
)
partition by range(sal)
subpartition by hash(empno)
subpartitions 2
(
	partition p_1k values less than (1000),
    partition p_2k values less than (2000),
    partition p_3k values less than (3000),
    partition p_4k values less than (4000),
    partition p_max values less than maxvalue
);
desc check_ext;

insert into compo_range 
select empno, ename, sal, job 
from check_ext; 

select partition_name, table_rows, subpartition_name
from information_schema.partitions
where table_name= 'compo_range';

show create table compo_range;

select * from compo_range partition(p_max);
-- IMP
-- when in is used the cost is high as it compares with each value but = only look for that particular one so less cost
explain format=tree select * from emp force index(sal_idx) where sal = (select min(sal) from emp);

explain format=tree select min(sal) from emp;

show indexes from emp;

explain format= tree
select ename, sal, deptno
from emp e 
where sal> (select avg(sal) from emp where deptno = e.deptno);

explain format=tree
with cte as (
	select avg(sal), deptno from emp group by deptno
)
select ename, sal, deptno from emp inner join cte using(deptno);

explain format=tree
select ename, sal, deptno from emp 
inner join (select avg(sal), deptno from emp group by deptno) a 
using(deptno);

-- corelated sub query make use of exits operator it reduces the cost or using ranking also helps

explain format=tree
select dname, deptno
from dept where deptno not in (select deptno from emp);

explain format=tree
select dname, deptno
from dept d 
where  not exists (select 1 from emp e where e.deptno = d.deptno);

show create table emp;
show engines;

-- types of indexes -- btree unique and btree non unique
-- hash index, functional index
-- hash index should not used in innoDB
-- full text index
-- geo spatial index
-- LHS should be matching the index column

show indexes from emp;

alter table emp alter index hire_idx visible;

explain format=tree select * from emp where monthname(hiredate)='January'; 
-- when we apply function in index it wont be used
explain format=tree select * from emp where hiredate='1981-12-03'; -- index is used here


explain format=tree select * from emp where monthname(hiredate)='January'; 

alter table emp
add index((monthname(hiredate))); -- extra parenthesis required

show indexes from emp;

explain format=tree select * from emp where year(hiredate)=1981; 

-- creating functional index
alter table emp
add index((year(hiredate))); 


create table testhash (
	fname varchar(50) not null,
    lname varchar(20) not null,
    key using hash(fname)
)engine=memory;			-- hash index should be created in memory engine

insert into testhash select first_name, last_name
from hr.employees
where department_id in (60,90);

show indexes from testhash;

explain format=tree select * from testhash;

explain format=tree select * from testhash
where fname = 'Bruce';

-- full text index -- full text is a datatype
create table full_text as select first_name, last_name from hr.employees;
alter table full_text add fulltext(first_name, last_name);
explain format=tree select * from full_text where match(first_name, last_name) against ('%Bruce%');


explain format=tree
select ename, case 
				when sal<3000 then 'Poor Salary'
                when sal=3000 then 'average slary'
                else 'Good salary'
			  end as Status
from emp;


explain format=tree
select ename, case 
				when sal<3000 then 'Poor Salary'
                when sal=3000 then 'average slary'
                else 'Good salary'
			  end as Status
from emp force index(deptno_idx)
where deptno =30;

explain format=tree
select ename, if(sal<3000, 'PoorSalary',if(sal=3000,'Average Salary','Good Salary'))as Status
from emp 
where deptno =30;

alter table emp alter index deptno_idx visible;
show indexes from emp;

select ename, sal, sal*1.5 as newSal
from emp;

explain format=tree
select ename, sal, sal*1.5 as newSal
from emp
where sal*1.5 >3000;  -- since we are performing a operation(*) on column so index is not used
-- LHS should be matching the index column
explain format=tree
select ename, sal, sal*1.5 as newSal
from emp
where sal >3000/1.5; 

-- PROFILING -- to analyse the overall performance of db driven application
select @@profiling;
set profiling=1;

select * from hr.regions;
select count(*) from check_ext;
select * from compo_range where sal=3000;
show profile for query 3;

set profiling=0; -- stop profiling

-- index lookup we use index to look up the table and read data
-- index scan get data directly from index


create table dummy_1 select * from emp;

create table dummy_2 select * from dept;

create index dept_idx on dummy_2(deptno);
alter table dummy_2
drop index dept_idx;

alter table dummy_2
modify column deptno int unique;

alter table dummy_1
add constraint fk_dummy_2
foreign key(deptno) references dummy_2(deptno);

alter table dummy_1
drop constraint fk_dummy_2;

-- to create a foreign key on a column it must have a index in parent table

alter table emp
modify column comm float unique;  -- unique column can have multiple null values, null!=null
select null is null;

desc emp;

---------------------
use db_optimised;
create table t1(id int);
create table t2(id2 int);

insert into t1
values(1),(1),(1),(2),(4);
select * from t1;


insert into t2
values(1),(1),(1),(null),(5);
select * from t2;
drop table t2;
select count(*) from t1 inner join t2 on t1.id = t2.id2;

select count(*) from t1  join t2; -- outer join

select * from t1 left join t2 on t1.id = t2.id2;

select * from t1 right join t2 on t1.id = t2.id2;