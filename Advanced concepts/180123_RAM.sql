/*
STRUCTURE

select  -> parsing ->optimizing ->executing ->fetching
DML  -> parsing ->optimizing ->executing

-- parsing where syntax is verified and parse tree is prepared
-- optimiser prepares multiple p[ossible plans and use best one which costs least(tuning)
-- 

-- Forcing index -->
	- use index  eg: select * from emp force index(nameidx) where deptno=20 and job='clerk'  
    - force index 
    - ignore index
    
  

*/

use hr;
use db_optimised;

explain format=tree select * from regions where region_id = 1;

explain format=tree select ename from emp where job ='clerk';

explain format=tree select ename from emp where job ='clerk';

show indexes from db_optimised.emp;

explain select * from dept where dname = 'sales';
explain format=tree select * from dept where dname = 'sales';

select * from emp where deptno=20 and job='clerk';
explain select * from emp where deptno=20 and job='clerk';
explain format=tree select * from emp where deptno=20 and job='clerk';

explain format=tree select * from emp force index(deptno_idx) where deptno=20 and job='clerk';
explain format=tree select * from emp force index(job_idx) where deptno=20 and job='clerk';
explain format=tree select * from emp force index(dept_job_idx) where deptno=20 and job='clerk';

explain format=tree select * from emp where deptno=20 and job='clerk';
desc fruit;
show create table fruit;
explain format=tree select * from fruit where id=101;
explain select * from fruit where id=101;


alter table fruit add constraint primary key(id);

show indexes from fruit;

-- make index invisible
alter table emp alter index FK_DEPTNO invisible;
-- make index visible
alter table emp alter index FK_DEPTNO visible;
-- check if it is visble or not
show indexes from emp;

select index_name, is_visible from information_schema.statistics
where table_schema = 'db_optimised' and table_name='emp';


explain  select * from check_ext;

create index dname_idx on dept(dname);
-- composite index
create index dept_job_idx on emp(deptno, job);
create index job_idx on emp(job);
create index deptno_idx on emp(deptno);
desc dept;

-- range partitioning
create table range_part(empno int ,
						ename varchar(20),
                        sal int
						)
partition by range(sal)
(
	partition p_1000 values less than (1000),
    partition p_2000 values less than (2000),
    partition p_3000 values less than (3000),
    partition p_4000 values less than (4000),
    partition p_5000 values less than (5000),
    partition p_6000 values less than (6000)
);

insert into range_part select empno, ename, sal from check_ext;

explain select * from range_part where sal=3000;

explain select * from range_part where sal between 2000 and 3000;

-- range_part based on year of hiredate
create table range_part_hiredate (
				empno int, hiredate date, sal int
)
partition by range(year(hiredate))
(
	partition p_1980 values less than (1980),
    partition p_1985 values less than (1985),
    partition p_1990 values less than (1990)

);

insert into range_part_hiredate select empno, hiredate, sal from check_ext;
select partition_name, partition_ordinal_position, table_rows
from information_schema.partitions
where table_name = 'range_part_hiredate';

select count(*) from check_ext where 
year(hiredate) between 1985 and 1990;

-- too see each parttion data
select * from range_part_hiredate partition(p_1985);

explain select * from range_part_hiredate where year(hiredate)=1980;
EXPLAIN SELECT * FROM range_part_hiredate
WHERE hiredate BETWEEN DATE_FORMAT("1983-00-00", "%Y-%m-%d") AND DATE_FORMAT("1985-00-00", "%Y-%m-%d");

select distinct year(hiredate) from check_ext;

select DATE_FORMAT("1984-00-00", "%Y");

/*
create table range_part_hiredate_2 (
				empno int, hiredate date, sal int
)
partition by range(DATE_FORMAT(hiredate, "%Y"))
(
	partition p_1980 values less than (1980),
    partition p_1985 values less than (1985),
    partition p_1990 values less than (1990)

);
*** this throws function not allowed error as date_format cannot be used in partitions 


*/

-- HASH PARTITIONING
-- used for uniform distribution of data 
create table hash_part_empno (
				empno int, hiredate date, sal int
)
partition by hash(empno)
partitions 4;

-- drop table range_part_hiredate_2;
insert into hash_part_empno select empno, hiredate, sal from check_ext;

explain select * from hash_part_empno where empno =23;

select partition_name, partition_ordinal_position, table_rows
from information_schema.partitions
where table_name = 'hash_part_empno';

select * from hash_part_empno partition(p0);


-- composite partition



-- temp tables
-- all data are lost when session closes. its data is available only in the session in which it was created. 
-- also for atemp table no extent or data pages are created. so many overheads are avoided hence it is used for data staging 
-- (staging tables)
create temporary table  temp_1(
	sal float
);

insert into temp_1 select sal from emp;

select * from temp_1;

show tables;

-- cursors - to handle the result row by row
-- it is used in programming only ie in procedures, functions, triggers
-- steps -> declare open fetch close
-- syntax - cursor cursor_name for select statement
-- open curs_name;
-- fetch curs_name into var_name
call proc_cursor_1(20, @pout);
select @pout;

create table tab_1(v1 varchar(50));
select * from tab_1;
