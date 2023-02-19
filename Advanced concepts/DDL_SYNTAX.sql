-- DDL SYNTAX

-- CREATE DATABASE
create database database_name;

-- create table
create table tabl_name (col_1 int primary key, col_2 varchar(20));

-- add constraint
alter table tabl_name
add constraint pk_tabl_name
primary key(col_1);

alter table tabl_name
add constraint fk_child_parent
foreign key(child_col) references parent_tabl(parent_col);

alter table tabl_name
add constraint ck_name
check(condition);

-- drop table
drop table tabl_name;
-- drop database
drop database db_name
-- drop constraint

alter table tabl_name
drop constraint constraint_name;

-- create index
create index index_name on tabl_name(col_name);

alter table table_name
add index index_name;

alter table table_name
alter index index_name visible;

-- alter inside the alter is used for constraints not on table level

-- rename column
alter table table_name
rename 'old_col_name' to 'new_col_name';
-- 
truncate table table_name;

-- delete
delete from tabl_name 
where condition;

--
create user 'user'@'hostname'  identified 'password';

alter user 'user'@'localhost' identified by 'new_password'

set password for 'username'@'localhost' = password(new_password);

rename user 'old_user_name' to 'new_user_name';

-- change the user
system mysql -u username -p --port=3307;

-- DCL
grant all privilages on db_name.table_name to 'test'@'localhost';

show grants for 'test'@'localhost';

REVOKE ALL PRIVILEGES ON * . * FROM 'user_name'@'localhost';

--  export 
mysqldump -u username -p db_name > 'file_name';
-- import
mysql -u username -p db_name < 'file_name';

-- view
create or replace view view_name as select * from tabl_name;

-- temp table
create temporary table temp_ select * from employees;

create temporary table temp_tbl1 (id int);
insert into temp_tbl1 values(1);

-- TRIGGER
create trigger trigger_name 
before|after  insert|update|delete
on table_name for each row
begin 
	<statement>
end

-- PROCEDURE
delimiter #
create procedure proc_name(parameters)
begin 
	<statements>
end #
delimiter ;


-- deterministic always returns the same output for same input but non deterministic may return differnt value for the same input

-- FUNCTION
create function  fun_name(parameters)
returns datatype deterministic 
begin 
	<statement>
    return 0;
end

 
-- CURSOR
declare cur_name cursor for <select statement>;
open cur_name;
fetch cur_name into <variable names>;
close cur_name;

declare continue handler for not found set var = <value>;