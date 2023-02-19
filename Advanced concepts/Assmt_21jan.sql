-- 1
create table person (slno int, name varchar(20), place varchar(20), dob date);

-- 2
insert into person
values(1002, 'hitesh','delhi', '2000-05-01'),
(1001, 'ritesh','mumbai','1998-07-12'),(1005, 'balan','kochi','1999-11-05');

-- 3
select tablespace_name, file_name from information_schema.files
where tablespace_name like '%person%';

-- 4
select * from person 
where slno = 1001;

-- 5
explain select * 
from person 
where slno =1001;

-- 6
create index slno_idx on person(slno);

explain format=tree 
select * 
from person 
where slno =1001;

-- 7
alter table person
add constraint pk_person
primary key(slno);


explain format=tree 
select * 
from person 
where slno =1001;

/*
-- observations
-- 5 
Here type of query is simple and out of 3 rows one row is fetched using where condition. since the probability is one third, filtered is showing 33.33% 
-- 6
After creating index on slno the index look up is being used here using slno_idx and cost is 0.35
-- 7
After creating slno as primary key cost has reduced to 0, as primary key index is being used here. so primary key is more optimised option available.
*/






alter table person
drop index slno_idx;

show indexes from person;


use hr;
-- 1
desc regions;
desc countries;
desc locations;

select l.city, r.region_name, c.country_name, l.location_id
from locations l inner join countries c on l.country_id = c.country_id
inner join regions r on r.region_id = c.region_id
where c.country_name = 'india' or c.country_name = 'brazil';

explain format =tree
select l.city, r.region_name, c.country_name, l.location_id
from locations l inner join countries c on l.country_id = c.country_id
inner join regions r on r.region_id = c.region_id
where c.country_name in ('india','brazil');

explain format=tree
select l.city, r.region_name, c.country_name, l.location_id
from locations l inner join countries c on l.country_id = c.country_id
inner join regions  r force index(primary) on r.region_id = c.region_id
where c.country_name = 'india' or c.country_name = 'brazil';

-> Nested loop inner join  (cost=6.72 rows=9)
     -> Nested loop inner join  (cost=4.55 rows=2)
         -> Table scan on r  (cost=0.91 rows=4)
         -> Filter: ((c.COUNTRY_NAME = 'india') or (c.COUNTRY_NAME = 'brazil'))  (cost=0.64 rows=1)
             ...
;
show indexes from regions;

alter table regions
drop index comp_idx;


-- PARTITION TABLE based on salary
create table range_part_1sal(employee_id int ,
						first_name varchar(20),
                        last_name varchar(20),
                        salary int
						)
partition by range(salary)
(
	partition p_5k values less than (5000),
    partition p_10k values less than (10000),
    partition p_15k values less than (15000),
    partition p_20k values less than (20000)
    
);

insert into range_part_1sal  select employee_id, first_name, last_name, salary from employees;
drop table range_part;

select * from range_part_1sal;
select partition_name, partition_ordinal_position, table_rows
from information_schema.partitions
where table_name = 'range_part_1sal';


explain format=tree
select * from range_part_1sal
where salary between 12000 and 17000;

explain format =tree
select EMPLOYEE_ID, FIRST_NAME,LAST_NAME,SALARY from employees
where salary between 12000 and 17000;

explain format=tree
select * from range_part_1sal
where salary between 12000 and 17000;
