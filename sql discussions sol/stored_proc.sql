use lms_assgt2;

call get_countries_data;  -- no parameters passed

call get_data_region(2);  -- input parameters passed

call get_employees(6000, '1987-05-12'); -- passed two parameters

call print_employees_count(@count); -- out parameter
-- select @count;

call inout_proc(@total_salary,90);  -- in and out parameter
select @total_salary as Total;

set @sal=7000;
call sum_salary(@sal);  -- using inout to for both input and output

set @c=1;
call counter(@c,2);
select @c;

SET @counter = 1;
CALL SetCounter(@counter,1); -- 2
CALL SetCounter(@counter,1); -- 3
CALL SetCounter(@counter,5); -- 8
SELECT @counter; -- 8

----------------------------------------
-- even odd
call even_or_odd(10,@res);
select @res as result;

--  get even numbers under n
call n_even_nums(10,@res);
select @res as even_numbers;

-- check if prime numbers 
call check_prime(25, @r);
select @r as result;


-- prime numbers under n
call n_prime_nums(20,@r);
select @r as prime_numbers;

-- run multiple DML ops in a proc
call dml_ops(100,@res);
select @res as hire_date;



show tables;
select * from employees;

