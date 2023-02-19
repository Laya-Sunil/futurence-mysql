-- List employees having experience greater than 200 months
use hr;
select first_name from employees where timestampdiff(month, hire_date, curdate())>200;
-- 12, 16

--
select first_name, hire_date, date_add(hire_date, interval 6 month), dayname(date_add(hire_date, interval 6 month)),
		case 
			when weekday(date_add(hire_date, interval 6 month))=0 then date_add(hire_date, interval 6 month)
            else date_add(date_add(hire_date, interval 6 month), interval 7- weekday(date_add(hire_date, interval 6 month)) day)
		end as `Review Day`
from employees;

/*
calculating the next monday day 
weekday(sun) = 6
weekday(mon) = 0

if its monday then value =0 
		then return that day itself
else return the day which (6-weekday()) ahead 

eg: wed ==> weekday(wed) = 2
6-2 = 4 
add 4 days ahead it will be a monday.
---- calculate next wednesday
 wed = 2 
 

*/
select date_format(curdate()-1,'%w'),weekday(curdate());

/*
in date_format('%w') -- sun = 0 sat = 6

 
*/

-- find the next wednesday for given date
set @d = curdate()+1;
select @d, date_format(@d,'%w')-2, date_format(adddate(@d, interval 7 day), '%W') ;

SELECT 
  DATE_ADD(@d,INTERVAL IF(WEEKDAY(@d)>=5,
                             (6-WEEKDAY(@d)),
                             (5-WEEKDAY(@d))) DAY) 'day';
                             
SELECT @d,
  DATE_ADD(@d,INTERVAL IF(WEEKDAY(@d)>=5,
                             (6-WEEKDAY(@d)),
                             (5-WEEKDAY(@d))) DAY);
                             

-- Write a query which returns the DAY of the week for any date entered in the format dd.mm.yy
select dayname(str_to_date('23 01 23','%d %m %y')), str_to_date('23 01 23','%d %m %y');

-- Display name, hire date, and day of the week on which the  employee started. 
-- Label the column DAY. Order the results by the day of the week starting with Monday

select first_name, hire_date, dayname(hire_date) 'day'
from employees
order by weekday(HIRE_DATE);

-- Find the details of employee whose joining date is in 4th quarter and day is ‘Monday'
select first_name, hire_date, quarter(hire_date)
from employees
where quarter(hire_date)=3
 and dayname(hire_date)='Monday';
 
 -- 
 select last_day(curdate()); -- returns the last day of month
 
 set @d = '2023-01-22';
 select @d, case
				when day(@d)<=15 then date_sub(LAST_DAY(date_add(@d, interval 1 year)), interval ((7 + WEEKDAY(LAST_DAY(date_add(@d, interval 1 year))) - 4) % 7) day)
				else  date_sub(LAST_DAY(date_add(date_add(@d, interval 1 year), interval 1 month)), interval ((7 + WEEKDAY(LAST_DAY(date_add(date_add(@d, interval 1 year), interval 1 month))) - 4) % 7) day)
			end as 'day';
 -- if day(@d)<=15 then last_day(date_add(@d, interval last_day(date_add(@d, interval 1 year))1 year))
 
 
 -- to find the last particular day of a month- subtract (7 + weekday(last day)- weekday of given day )%7
 SELECT @d, WEEKDAY(LAST_DAY(@d)), date_sub(LAST_DAY(@d), interval ((7 + WEEKDAY(LAST_DAY(@d)) - 0) % 7) day);
 
 
 -- 
 select timestampdiff(day, '1998-02-05',curdate());
 
 select first_name, if(COMMISSION_PCT = 0, 'no commission', COMMISSION_PCT) as comm
 from employees;
 
 desc employees;
 -- Write a query to find out first ‘Sunday’ of  hiredate
SET @firstday = '2023-03-01';

-- first particular day of month
SELECT ADDDATE( @firstday , MOD((7-weekday(@firstday)+1),7)) as first_monday;

-- ----- DATE
-- Find out  the experience of each employee and arrange in the increasing order of experience.
select first_name, hire_date, concat(year(curdate())-year(HIRE_DATE),'.',abs(month(curdate())-month(hire_date))) exp,
			timestampdiff(year, hire_date, curdate()), timestampdiff(month, hire_date, curdate())
from employees
order by hire_date;



-- Select a query to return next Sunday
set @d = date_add(curdate(), interval 20 day);
select @d, case weekday(@d)
					when 6 then date(date_add(@d, interval 7 day))
                    else  date(date_sub(@d, interval weekday(@d)-6 day))
				end 'sunday';

--  employees hired on monday
select first_name, hire_date
from employees
where dayname(hire_date)='monday';

-- Show all employees who were hired in the first half of the month 
select first_name, hire_date, date_format(hire_date, '%d')
from employees
where date_format(hire_date, '%d')<16;
-- day(hire_date)<16;

-- Write a Query to find out the last day of  any given year.
select dayname(last_day('2022-12-9'));

-- Add  1 year to each employee and display as a separate column.
select first_name, hire_date, date_add(hire_date, interval 1 year)
from employees;
-- Write a query to find first Sunday of hiredate. (first Sunday in the joining month)
select date_add('2023-02-25', interval 6- weekday(subdate('2023-02-25',day('2023-02-25')-1)) day);

select 7-weekday('2023-02-25')-25, subdate('2023-02-25',day('2023-02-25')-1);

-- leap year
SELECT ename FROM db_optimised.emp WHERE 
(case when MOD(YEAR(`HIREDATE`),4)=0 then 1
	when MOD(YEAR(`HIREDATE`),100)<>0 and MOD(YEAR(`HIREDATE`),400)=0 then 1
end)=1;

--

select DATE_FORMAT(CONCAT(year(CURDATE()),'-12-31'),'%j');

-- Null comes first in asc ORDER
SELECT comm FROM db_optimised.emp ORDER BY comm;

--
select CONCAT(ename,' joined on ',
		DATE_FORMAT(hiredate,'%D'),', ',
		DATE_FORMAT(hiredate,'%W'),' ',
		DATE_FORMAT(hiredate,'%M'),' ',
		DATE_FORMAT(hiredate,'%Y'))
from db_optimised.emp;





