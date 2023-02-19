-- FUNCTIONS
/*
PROCEDURE							
    may or may not return values
    does not contain return statement
    cant be used directly with sql statement

FUNCTIONS
	must return a single values
    return statement is must
    can be used with SQL state directly
    
create function <function name>()
returns datatype deterministic
begin
	declare
    
    ...
    return
end
*/
use hr;
-- create a  function to pass empid as parameter and return bonus
select func_emp_bonus(184);

select employee_id, job_id, salary, func_emp_bonus(employee_id)as bonus from employees;

-- create a function to pass empid and return if the joined in leap year or not

select date_format('2024-12-31','%j'); -- returns the number of days in that year

select func_leap_year(201);
select employee_id, first_name, hire_date, func_leap_year(employee_id) from employees;

-- create function for employee getting on or before 15 of a month will be paid joining bonus
-- on the last friday after 1 year
-- 2022-01-15 2023-01-26 last friday
-- 2022-01-18 2023-02-26 last friday

-- TRIGGER
/*
whenever event occurs triggers fires
trigger enforces complex business rules
trigger events
----- insert, update, delete
trigger timings
----- before after
row level triggers  -- new old
insert new  _
update new old
delete  _  old

syntax
-- create trigger <trigger name>
	on <table name> 
    for each row
    begin 
		statements
	end
    
*/
-- create a trigger to insert into retired table whenever delete happens in employee table
delimiter #
CREATE DEFINER=`root`@`localhost` TRIGGER `employees_BEFORE_DELETE` 
BEFORE DELETE ON `employees` 
FOR EACH ROW BEGIN
	insert into retired values(old.employee_id, old.job_id, old.first_name, old.last_name);
END #

create table retired 
as select employee_id, job_id, first_name, last_name
from employees where 1=2;

start transaction;

delete from employees where employee_id = 101;

select * from retired;

rollback;


select * from  job_grades;


create table e1 as select * from regions;

select * from e1;

start transaction;

delete from e1; 

rollback;

create table date_table(slno int primary key, date1 date check(date1<=curdate()));


create table date_table(slno int primary key, date1 date );

insert into date_table values(1,'2023-01-31');

-- create a trigger to restrict deduction of salary (use a duplicate employee table)
create table employee_duplicate
as select * from employees;

select * from employee_duplicate;

update employee_duplicate
set salary = salary - 100
where employee_id = 122;

create table account(
	accno int primary key,
    name varchar(20),
    balance numeric(11,2)
);

create table trans(
	accno int,
    withdraw numeric(11,2),
    deposit numeric(11,2),
    foreign key(accno)
    references account(accno)
);

insert into account values(1,'Alisa',10000),(2,'Ben',2300),(3,'Quin',3000);

insert into trans values(3, 1000, 0);

update trans set deposit = 200 where accno=1;

select * from account;

-----------------------------------------------------


