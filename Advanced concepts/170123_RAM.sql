-- QUERY OPTIMISATION
select * from information_schema.files;

show variables like 'data_dir';

show variables like 'datadir';

show variables like 'basedir';

select tablespace_name, file_name from information_schema.files;


/*
---- when we create the table , architecture
tablespaces -> datafiles -> extents -> datapages -> rows

rows inside datapages
datapages inside extents
extents inside datafiles
datafiles inside tablespaces
*/

select database();
use db_optimised;

create table check_tab(c1 int);

select tablespace_name, file_name, total_extents from information_schema.files
where tablespace_name like 'db_optimised/che%';


create table check_ext as select * from emp;

select count(*) from emp;

delete from check_ext
where empno > 600000;

select max(empno) from check_ext;

alter table check_ext
modify empno int auto_increment primary key;

select * from check_ext;
truncate check_ext;

insert into check_ext(ename, job,mgr, hiredate, sal, comm, deptno)
select ename, job,mgr, hiredate, sal, comm, deptno from emp;

insert into check_ext(ename, job,mgr, hiredate, sal, comm, deptno)
select ename, job,mgr, hiredate, sal, comm, deptno from check_ext
where ename<>'king';

select count(*) from check_ext;








desc emp;
desc check_ext;


select tablespace_name, file_name, total_extents from information_schema.files
where tablespace_name like 'db_optimised/che%';

select count(*) from check_ext where job like 'clerk%';

create table list_job(
	empno int,
    ename varchar(20),
    job varchar(30)
)
partition by list columns(job)
(
partition p_clerk values in ('clerk'),
partition p_sales values in ('salesman'),
partition p_analy values in ('analyst'),
partition p_pres values in ('president'),
partition p_man values in ('manager')
);

insert into list_job select empno, ename, job from check_ext;

explain select count(*) from list_job where job = 'clerk';
explain select count(*) from check_ext where job = 'clerk';
show tables;

explain select * from emp;
explain select * from emp where deptno = 10;
explain select * from dept where dname = 'sales';
-- explain select * from regions where region_id =1;

explain select ename, sal from emp where sal in (select min(sal) from emp);

explain select deptno from emp where job = 'clerk'
union 
select deptno from emp where job = 'salesman';

explain select ename from emp
union 
select dname from dept;

explain select ename, dname from emp natural join dept;

create table fruit(
	id int,
    name varchar(30),
    price int
);

insert into fruit values(103,'Guava',80),(101,'mango',150),(105,'apple',200);

insert into fruit values(101,'peach',300);
explain format =tree select * from fruit where id = 101;

explain format =tree select * from list_job where job = 'president';
explain format =tree select * from check_ext where job = 'president';

explain format=tree select * from dept;
-- inside the index data will be sorted.
-- index automatically created for primary, foreign and unique keys
show index from hr.employees;

create table uni_tab(id int unique);

show create table uni_tab;
show index from uni_tab;

create index id_idx on fruit(id);
explain format = tree select * from fruit where id=101;
 -- above table has an index on id, so on serching first it goes to index and then it goes to table to fetch the data of that id
 
 explain format=tree select deptno from emp;
 -- for each query there are 3 possible read operations that can happen ie table scan, indx scan, index lookup

select distinct table_name, column_name, index_name from information_schema.statistics
where table_schema = 'db_optimised' and table_name = 'emp';

