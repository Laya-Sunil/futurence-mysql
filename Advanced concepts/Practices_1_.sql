-- PRACTICE SEESION 1
use hr;

-- 1
select first_name, last_name , salary
from employees
where salary>1000;

-- 2
desc employees;

select concat(m.first_name,' ',m.last_name) as Manager, count(e.employee_id) Total_Employees
from employees e inner join employees m 
on e.manager_id = m.employee_id
group by Manager;

-- 3
select first_name
from employees 
where job_id like 'SA_REP%';

desc jobs;
select distinct job_title from jobs;

-- 7
select e.first_name, e.employee_id
from employees e inner join employees m 
on e.employee_id <> m.employee_id;


select * from employees where manager_id in(205,204,202);

--
explain format=tree
select * 
from employees 
where job_id in ('PU_clerk','ST_CLERK');

explain format=tree
select * 
from employees 
where job_id = 'PU_clerk' or job_id ='ST_CLERK';

-- 
select month(hire_date) from employees;

select first_name, last_name
from employees
where month(hire_date) = 8; 

select first_name from employees where first_name like '___n%';

select * from employees
where commission_pct is  null;

desc employees;


select first_name, job_id 
from employees
where manager_id is null;
-- ||, + does not work as concat operators here
select first_name,last_name
from employees;

--
select first_name, hire_date
from employees
order by hire_date desc;

select first_name, salary
from employees
order by salary desc, department_id desc;

-- limit
select * from employees
order by employee_id 
limit 4
offset 4;

select * from employees
order by employee_id 
limit 4,4;

-- single row functions
-- character
-- case manipulation
select upper(first_name), lower(first_name)
from employees;

select lcase('aADN KJ AsrrR'), ucase('qnfdjAADCFvmkf');



-- character manipulation 
-- concat_ws(seperator, exp1, exp2...) sperator is required here, if not provided it returns concatinated string with no space and put exp with numeric value first
select concat(first_name,' ', last_name), concat_ws(first_name, employee_id,job_id)
from employees;

use hr;
--
select first_name, substr(first_name,5,1), substring(first_name,2), mid(first_name,2,4) # start pos, length req
from employees;

select mid('abcd efgh',-4,3), substr('abcd efgh',-4,3), substring('abcd efgh',-4,3); -- negative start pos starts from ending
select mid('abcde',2,10);

-- substring_index(string,delimiter, length)
select substring_index('Hii.com.in','.',3);
select substring_index('abc@gmail.com.in','@',1);


-- instr(first_name, 'a')  returns the position of first occurence of 'a' if found else return 0
select first_name, length(first_name), instr(first_name, 'a')
from employees;

-- lpad(first_name, 7, '*') -- make the given string length 7 by adding the * on left side
select first_name, lpad(first_name, 7, '*'), rpad(first_name, 7, '*')
from employees;
select lpad('helloWorld',5,'$'), rpad('helloWorld',5,'$');

--
select first_name, trim(first_name), ltrim(first_name), rtrim(first_name)
from employees;

-- replace(string, character to be replaced, character which replaces)
select replace(first_name, 'a', 'AA')
from employees;

select replace('Hiii abcsdxcfABCw werabc dfgAb','abc','___'); -- its case sensitive

select ascii('S');

-- ascii(character)
select ascii(first_name)  -- returns the ascii value of first letter of passed string
from employees;

-- char_length(first_name), character_length(first_name) returns the length in number of characters
-- 3 gives same result but length returns length in bytes 
select char_length(first_name), character_length(first_name), length(first_name) -- 
from employees;
-- where char_length(first_name)<>character_length(first_name);
-- where character_length(first_name)<> length(first_name);

--
select field(1, 2, 4, 5, 1);

SELECT FIELD('a','hnacc'); -- returns 0 if not found

-- 
select find_in_set('a','q,d,f,a,c'); -- returns position of a in the list
select find_in_set('a','1,p,2'); -- returns 0 when not found
select find_in_set('a', null); -- returns null when list is null
select find_in_set('a'); -- error - parameter count
select find_in_set('a','');  -- returns 0 as list is empty

-- format(number, decimal_places) -- returns string type
select format(2.44450, 2); -- returns 2.44 no rounding
select format(3.4567, -1); -- returns 3
select format(3446.4567, 0); -- returns result as #,##,###.## -- 3,446
select format(90878945.4567, 3); -- 90,878,945.457
select format(344.65); -- error

-- insert(string, start_pos, no_characters_to_replace, string_which_replaces)
select insert('hello world !!',7,8,'universe');
select insert('HEY you',3,2, 'XYZZZZVV');

-- 
select left('abcdef',3); -- extract 3 chars from left side -- abc
select left('abc',5); -- if length exceeds returns the string

select right('qwerlkgi',4); -- 4 characters from right
select right('abcde',10);

-- locate(substring, string, start)
select locate('abc','defabcklrabc');
select locate('abc','defabcklrabc',6); -- returns first occurence starting 6 pos
select locate('abc','defAbcklrabc');

select instr('abchdjabckd','abc');
select position('ab' in 'werabcvk'); -- returns pos of first occurence and 0 if not found

-- 
select repeat('abc',5);
select repeat('abc',0);
select repeat('abc',1);

--
select first_name, reverse(first_name)
from employees;

--
select space(10); -- returns string of 10 spaces
--
select strcmp('abc','ABC'); -- case insensitive, returns 0 if s1==s2
select strcmp('abc','abc');
select strcmp('abc','def'); -- abc<def -- by ascii values -- returns -1 when s1<s2
select strcmp('def','ABC'); -- returns 1 when s1>s2

-- Numeric Functions
-- abs() - returns absolute value(positive)
select abs(-123.567), abs(0), abs(-344), abs(233);

--  avg() -- average -- null values are ignored
select avg(salary) from employees;

select ceil(0.344), ceil(12.6778), ceil(-1.345); -- smallest integer value that is greater than or equal to number
select ceiling(0.234), ceiling(12.9999), ceiling(12.111111);

select floor(0.344), floor(12.6778); -- largest integer value that is lesser than or equal to number

-- degree() -- convert radian to degree
SELECT DEGREES(PI()*2);
-- radians() -- convert degree to radian
select radians(12);
-- div -- returns quotient after division, only int part
select 9 div 3, 8 div 5, 8/5, 10/3, 10 div 3;

-- exp(num) -- e to the power of num
select exp(1); -- e^1

-- GREATEST(arg1, arg2, arg3, ...)
select greatest(2,3,7,8);
select greatest('q','f','z');


-- least(arg1, arg2, arg3, ...)
select least(12,23,4,9,0);
select least('e','p','o',']'); -- based on ascii value
select least('!','$','*');
select ascii('!'), ascii('$'), ascii('*');

-- ln(num), log(num) - natural logarithm of num
-- log(base, num) - log of num to base 
-- log10(num) - base 10 log of num
-- log2(num)  - base 2 log of num
select log10(1), log2(1);
select ln(3), log(3);
select log(3, 2);

-- 
select max(salary), min(salary)
from employees;
--
select 10 mod 3, 10 % 3, mod(10,3), 2 % 8; -- returns reminder
--
select pi();
-- 
select pow(2,3), power(2,3);
-- rand(seed) -- returns a random value. if no seed given then returns completely random number >=0 and  <1
select rand(), rand(3), rand(1); -- for same seed value -- same output in same session
select rand(3);

--
select round(101.2345,2), round(34.555), round(0.9877,1);

select round(72.56, -1), round(721.56, -2), round(721.56, -3), round(721.56, -4);

--
select sign(10), sign(0), sign(-100);
--
select sqrt(81);
--
select sum(salary) from employees;
--
SELECT TRUNCATE(135.375, 2), truncate(101.2395,2);
select truncate(72.56, -1), truncate(72.56, -2), truncate(72.56, -5);

select truncate(12345.234, -1), truncate(12345.234, -2), truncate(12345.234, -3), truncate(12345.234, -4),truncate(12345.234, -5);

-- truncate vs round
select round(233.567,2), truncate(233.567,2);

select truncate(12345.234, -1), truncate(12345.234, -2), truncate(12345.234, -3), truncate(12345.234, -4),truncate(12345.234, -5);
select round(12345.234, -1), round(12345.234, -2), round(12345.234, -3), round(12345.234, -4),round(12345.234, -5),round(12345.234, -6);

-- -----------------------------------------------------------------
-- 	DATE FUNCTIONS
-- adddate(date, days) or adddate(date, interval value unit)
select adddate('2022-02-01', interval 3 day), adddate('2022-02-01',3);
select adddate('2022-02-01', interval 3 year);
select adddate('2022-02-01', interval 3 month);
select adddate('2022-02-01', interval 1 quarter);
select adddate('2022-02-01', interval 3 week);
--
select adddate('2022-02-01', interval -3 year);
select adddate('2022-02-01', interval -3 day), adddate('2022-02-01',-3);

select adddate('2022-02-01', interval -3 month);
select adddate('2022-02-01', interval -1 quarter);

--
SELECT ADDDATE("2017-06-15 09:34:21", INTERVAL 15 MINUTE);
select adddate('2022-02-01', interval -2 hour);

-- SUBDATE(date, INTERVAL value unit) or SUBDATE(date, days)
SELECT SUBDATE("2017-06-15 09:34:21", INTERVAL 15 MINUTE);

--  addtime(datetime, addtime) 
select addtime("2017-06-15 09:34:21.000001", "5.000003"); -- add 5 seconds and 3 micro seconds
select addtime("2017-06-15 09:35:21.000001", "2:15:30"); -- add 2 hrs 15mins 30 seconds
-- SUBTIME(datetime, time_interval)
SELECT SUBTIME("10:24:21", "-3:2:5");

-- curdate() - returns current date
select curdate(), current_date();

-- curtime() or current_time() -- returns current time hh:mm:ss (string) or hhmmss.uuuuuu (numeric)
select curtime(), current_time();

-- The date and time is returned as "YYYY-MM-DD HH-MM-SS" (string) or as YYYYMMDDHHMMSS.uuuuuu (numeric).
select current_timestamp(), now(), sysdate();

-- date(expr) -- extracts the date part
select date(hire_date) from employees;
select date('2002-09-18');
select date(current_timestamp());

-- datediff(date1, date2) - return number of days between date1 and date2
select datediff(curdate(), '2022-11-15');

-- date_add(date, interval value unit)

select date_add('2022-02-01', interval -3 month);
select date_add('2022-02-01', interval -1 quarter);

-- date_sub(date, interval value unit)

select date_sub('2022-02-01', interval -3 month);
select date_sub('2022-02-01', interval 1 quarter);

-- DATE_FORMAT() function formats a date as specified
-- day -- d,D,e
select curdate(), date_format(curdate(), '%d'), date_format(curdate(), '%D'), date_format(curdate(), '%e');
-- month -- M b m c
select curdate(), date_format(curdate(), '%M'), date_format(curdate(), '%m'), date_format(curdate(), '%c');
select curdate(), date_format(curdate(), '%b');
-- year -- Y y
select curdate(), date_format(curdate(), '%Y'), date_format(curdate(), '%y');
-- weekday -- W a
select curdate(), date_format(curdate(), '%W'), date_format(curdate(), '%a'), date_format(curdate(), '%b');
-- week number of month --

-- day of the year -- j
select curdate(), date_format(curdate(), '%j');
-- time -- r 12 hr format T 24 hr format
select current_timestamp(), date_format(current_timestamp(), '%r'), date_format(current_timestamp(), '%T');
-- Hour - l, h(12), k,H(23)  
select current_timestamp(), date_format(current_timestamp(), '%H'), date_format(current_timestamp(), '%h');
-- minute -- i second -- s S 
select current_timestamp(), date_format(current_timestamp(), '%i'), date_format(current_timestamp(), '%s');
-- AM/PM -- p
select current_timestamp(), date_format(current_timestamp(), '%p');

SELECT DATE_FORMAT("2017-06-15", "%W %M %D %Y");
select date_format(current_timestamp(),'%W %b %D %Y %r');
--

-- TIME_FORMAT(time, format)
select time_format('22:30:50','%h %i %s %p');
SELECT TIME_FORMAT("19:30:10", "%h %i %s %p");
SELECT TIME_FORMAT("19:30:10", '%T'), TIME_FORMAT("19:30:10", '%r');

-- day(date) day of the month for a given date (a number from 1 to 31).
select day(curdate()), dayofmonth(curdate()), day(current_timestamp()), day(current_time());
select current_time();
-- dayname() day name
select dayname(curdate());
-- dayofweek() - sun -1 to sat - 7
SELECT DAYOFWEEK(CURDATE());
-- dayofyear() - day of the year for a given date (a number from 1 to 366).
SELECT DAYOFYEAR(CURDATE());
-- EXTRACT() function extracts a part from a given date
select extract(month from curdate()), extract(year from curdate()), extract(week from '2022-12-20');
select extract(year_month from '2022-12-20'), extract(quarter from '2022-12-20');
select extract(minute_second from '2022-12-20'), extract(day_hour from '2022-12-20');

-- from_days() -- convert numeric value into date
-- last_day() -- last day of the month for a given date
select last_day(curdate());
-- makedate(year,days) - creates and returns a date based on a year and a number of days value
select makedate(2022,40);
-- MAKETIME(hour, minute, second)
SELECT MAKETIME(838, 59, 59);

-- minute() - get minute part,  ||ly microsecond(), second()
-- time() - hh:mm:ss or null
SELECT TIME(NULL), TIME("2017-08-15 19:30:10.000001");
-- TIMESTAMP(expression, time)
SELECT TIMESTAMP("2017-07-23",  "13:10:11");


select month(curdate()), monthname(curdate()), quarter(curdate());

-- PERIOD_ADD(period, number)
select period_add('202212',3), period_add('202212',-3);
-- PERIOD_DIFF(period1, period2) -- returns the no of months
select period_diff('202212','202202');
-- timediff(time1, time2)
SELECT TIMEDIFF("13:10:11", "13:10:10");


-- sec_to_time(seconds) -- returns a time based on the given seconds
SELECT SEC_TO_TIME(-6897);
SELECT TIME_TO_SEC("19:30:10"); -- returns seconds

-- STR_TO_DATE() function returns a date based on a string and a format
select str_to_date('2001 1 31','%Y %m %d');
select str_to_date('2001 1 31','%Y %m %d'); -- format should match the dtring given not output required
select str_to_date('22 January 31','%y %M %d');

select str_to_date('22 Jan 31st','%y %M %D');
select str_to_date('22 234','%y %j'); -- year and day of year is passed here

-- TO_DAYS(date)  number of days between a date and year 0 
SELECT TO_DAYS("2017-06-20 09:34:00");

-- week(date) -- gets week number
SELECT WEEK("2017-06-15"), weekofyear("2017-06-15");
select weekday(curdate()), weekday('2023-01-30');
-- 
select week(curdate()), weekofyear(curdate());
select weekday(curdate()); -- week day number mon=0 sun=6

select year(curdate()), yearweek(curdate());
-- ----------------------------------------------------------------------------------

-- ADVANCED FUNCTIONS
-- -------------------------------
-- bin(number) -- binary equivalent
select bin(10);

-- binary -- convert a value to binary
SELECT "HELLO" = "hello"; -- returns 1 by comparing char by char

SELECT binary "HELLO" = "hello"; -- returns 0 by comparing byte by byte and they are not equivalent

/*
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
*/
select count(*) count, case 
							when salary<5000 then '<5000'
							when salary>=5000 and salary<=10000 then '5000 - 10000'
							else '>10000'
						end `category(case)`, 
					if(salary<5000,'<5000',if(salary>=5000 and salary<=10000, '5000 - 10000','>10000')) `category(if)`
from employees
group by `category(case)`,`category(if)`;


select count(*), if(salary<5000,'<5000', 'nk') `category(if)`
-- if((salary>=5000 and salary<=10000), '5000 - 10000','>10000')) as 'category(if)'
from employees
group by `category(if)`;

-- CAST(value AS datatype)
select cast('abc' as binary) , binary 'abc';
select cast('12.00' as decimal);
select cast(123349 as time);
SELECT CAST("2017-08-29" AS DATE);

-- convert(values, datatype)
SELECT CONVERT("14:06:10", TIME);
SELECT CONVERT("2017-08-29 12:33:40", DATE);

-- COALESCE(val1, val2, ...., val_n) -- returns the first non null value 
select coalesce(10,20,50), coalesce(19,20, null), coalesce(1, null, 30), coalesce(null,null,4); 
SELECT COALESCE(NULL, 1, 2, 'W3Schools.com');
--
SELECT CONNECTION_ID(); -- unique connection_id for current connection
-- ifnull(exp, alt_value) -- if exp is null then alt_value
select ifnull(null, 100); -- a specified value if the expression is NULL
-- nullif(a,b) returns null if a=b else a
select nullif(10,10), nullif(10,0);


-- isnull(exp) If expression is NULL, this function returns 1. Otherwise, it returns 0
select isnull(100), isnull(null);
-- last_insert_id() - return the last auto_increment value
SELECT LAST_INSERT_ID();
-- 

-- CONV(number, from_base, to_base)
select conv(8,10,2), conv(9,16,8);

--
select current_user(), database();
select session_user(), user(), system_user();
--
select version();
--





-- --------------------------------------------------------------------
use hr;
select concat(first_name,' ',last_name) fullname
from employees
order by fullname;
select concat(first_name,' ',last_name) fullname
from employees
where length(fullname)>5; -- error -- alias are not applicable in where clause 

--
select employee_id from employees limit 1 offset 3;
select employee_id from employees limit 1, 3;
select employee_id from employees limit 3;

--
select count(d.department_id), count(r.region_id)
from departments d, regions r;

select count(*), 'departments' as label from departments 
union
select count(*), 'regions' from regions;


select first_name
from employees
where first_name like '%s%';

select first_name 
from employees
where first_name like 's%s';

select department_name
from departments;

select char(66 using ascii); 
select char(66); -- get character from ascii -- returns blob

select date_format('2023-01-01', '%w'); 

-- count occurence of character in string
select department_name, length(department_name), replace(lower(department_name),'a',''),
		length(department_name)-length(replace(lower(department_name),'a','')) "Total a's"
from departments;

select replace(first_name, mid(first_name,1,3),'123'), first_name
from employees;

select substr(first_name,3,1), first_name
from employees;

select concat_ws(',',(select * from departments)); -- error

--
select substr(first_name, length(first_name), 1), first_name
from employees;

