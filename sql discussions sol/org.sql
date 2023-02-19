-- Active: 1673683090785@@127.0.0.1@3307@org
DROP DATABASE IF EXISTS `org`;

CREATE DATABASE IF NOT EXISTS `org`;

USE `org`;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
(001, 5000, '16-02-20'),
(002, 3000, '16-06-11'),
(003, 4000, '16-02-20'),
(001, 4500, '16-02-20'),
(002, 3500, '16-06-11');

CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
(001, 'Manager', '2016-02-20 00:00:00'),
(002, 'Executive', '2016-06-11 00:00:00'),
(008, 'Executive', '2016-06-11 00:00:00'),
(005, 'Manager', '2016-06-11 00:00:00'),
(004, 'Asst. Manager', '2016-06-11 00:00:00'),
(007, 'Executive', '2016-06-11 00:00:00'),
(006, 'Lead', '2016-06-11 00:00:00'),
(003, 'Lead', '2016-06-11 00:00:00');



-------------------23-12-2022-----------------------
-- RAM sir SESSION
show tables;

SHOW COLUMNS FROM dept;

desc emp;
desc salgrade;

select * from emp
where job like 'salesman%';

select * from emp
where sal>2975;

select * from emp
where sal<=1250;

select * from emp
where job not like 'clerk%';

select * from emp
where job <>'clerk%';

select * from emp
where job !='clerk%';

select * from emp
where job  like 'clerk%' and deptno=20;


select * from emp where ename='smith';


select * from emp where ename like 'smith';

select * from emp 
where ename like 'smith';


select * from emp 
where ename = 'smith';

alter Table emp
modify column ename char(10);

desc emp;

select * from emp where not sal<3000;
-- OR
select * from emp where sal not between 0 and 2999;

select * from emp where deptno =20 or deptno=30;

select * from emp where deptno in (10,30);
select * from emp where ename 
between 'james' and 'turner';

select * from emp where ename like 'j%';

select * from emp where ename like '%T%';

select * from emp where ename like '__R%';


select * from emp where ename like '____';

create table emp1 as select * from emp;
select * from emp1;

update emp1 set job='sales_rep' where job='salesman';

update emp1 set job='hr_clerk' where job='clerk';

select * from emp1 where job like '%\_%';

update emp1 set job='hr%clerk' where job='hr_clerk';

select * from emp1 where job like '%\%%';


select * from emp1 where year(`HIREDATE`)=1981 and ename not like '%s%';

select ename, comm from emp
where comm is NULL;

CREATE TABLE company_new(
	compid SMALLINT PRIMARY KEY,
	compname VARCHAR(20)
);

-- default order method
INSERT INTO company_new
VALUES(1,'Wipro');
-- changes ORDER
INSERT INTO company_new(compid, compname)
VALUES(2,'TCS');
-- multiple rows
INSERT INTO company_new
VALUES(3,'Oracle'),(4,'CTS'),(5,'SG'),(6,'Infosys');

-- using set variable option
set @v1=7, @v2="emc2";
INSERT INTO company_new
VALUES(@v1, @v2);

-- inserting NULL
INSERT INTO company_new
VALUES(8,NULL); 
INSERT INTO company_new(compid)
VALUES(9);

-- copy from another table 
INSERT INTO company_new
SELECT deptno, dname from dept; 

select * from company_new;

create table default_tab
(c1 int PRIMARY key, c2 TIMESTAMP DEFAULT now());
-- using default option
insert into default_tab VALUES(1,DEFAULT);

update company_new set compname='EY' WHERE compid=7;



-- NULL!=NULL because NULL can be anything its unknown values so use is operator

SELECT id, name, dob, TIMESTAMPDIFF(year, dob, CURDATE())age 
from emp;

SELECT ename, job, `HIREDATE`, TIMESTAMPDIFF(YEAR,`HIREDATE`,CURDATE())EXP_yrs
FROM emp1;

CREATE  VIEW emp_exp
AS SELECT ename, job, `HIREDATE`, TIMESTAMPDIFF(YEAR,`HIREDATE`,CURDATE())EXP_yrs
FROM emp1;

use db_optimised;
SELECT * FROM emp_exp;

ALTER TABLE emp1 ADD (street VARCHAR(20),pincode numeric(6));

SELECT * FROM dept;


CREATE TABLE CUSTOMER
(
	CUSTID INT AUTO_INCREMENT PRIMARY KEY,
	CNAME VARCHAR(30) NOT NULL,
	CLOC VARCHAR(30)
);

CREATE TABLE INV_CUST
(
	INVNO INT PRIMARY KEY,
	CUSTID INT,
	FOREIGN KEY(CUSTID) REFERENCES CUSTOMER(CUSTID)
);

DESC INV_CUST;

/*
-- FK DOES NOT WORK ON COLUMN LEVEL IN MYSQL... 
CREATE TABLE TT_1
(ID INT, FKID INT REFERENCES INV_CUST(INVNO));

DESC TT_1;

INSERT INTO tt_1 VALUES(1,123); 
*/
CREATE TABLE INV_ITEM
(
	INVNO INT NOT NULL,
	SLNO INT NOT NULL,
	ITEM VARCHAR(20) NOT NULL,
	QTY INT DEFAULT 0,
	TOTAL NUMERIC(6)
);

ALTER TABLE inv_item 
ADD CONSTRAINT PK_INV_ITEM
PRIMARY KEY(INVNO,SLNO);

ALTER TABLE inv_item
ADD CONSTRAINT FK_INV_ITEM_CUST
FOREIGN KEY(INVNO) REFERENCES INV_CUST(INVNO);

DESC INV_CUST;
DESC INV_ITEM;

SHOW INDEXES FROM INV_ITEM;

INSERT INTO customer
VALUES(NULL, 'XYZ', 'HYD'),(NULL, 'ABC', 'BLR');

INSERT INTO inv_cust
VALUES(5001, 1),(5002,2),(5003,1);

INSERT INTO inv_item
VALUES(5001, 1, 'TFT',10,100000),
(5001,2,'KB',20,13000),(5001,3,'SMPS',14,50000),
(5002,1,'RAM',3,40000),(5002,2,'MOUSE',22,27999),
(5003,1,'HDD',30,300000);


-- INSERT INTO inv_item VALUES(5005,2,'QQQ',2,3000);

-- DELETE FROM customer WHERE `CUSTID`=1;

SELECT ename,sal,(0.4*sal)hra,(0.3*sal)da,(0.12*sal)pf,(0.1*sal)tax,
(0.4*sal)+(0.3*sal)+(0.12*sal)+(0.1*sal)+sal as total_salary
FROM emp;


select sal,@hra=0.4*sal ,@da=0.3*sal ,@tax=0.1*sal, @pf=0.12*sal
from emp;

SELECT @hra,@da;

select @hra 
SELECT ename,sal,(0.4*sal)hra,(0.3*sal)da,(0.12*sal)pf,(0.1*sal)tax,
(0.4*sal)+(0.3*sal)+(0.12*sal)+(0.1*sal)+sal as total_salary
FROM emp;
set @v1=1250;

SELECT ename as "n" FROM emp 
ORDER BY "n";  -- wth double quotes it wont work


SELECT distinct sal from emp 
ORDER BY sal desc limit 3 offset 1;

-- Built in Functions
-- 1
SELECT CONCAT(ename,' ''s job is ',job)
FROM emp;

-- SELECT CONCAT(ename,' \'s job is ',job)
-- FROM emp;

-- 2
SELECT UPPER('laya'),LOWER('SUNIL');

-- 3
SELECT SUBSTRING('HEllO world',2,4);

SELECT SUBSTR('Hello world',4);

SELECT SUBSTR("World",-1);

set @str='World';
select @str, CONCAT(lower(substr(@str,1,length(@str)-1)),upper(substr(@str,-1)));


select INSTR('laya','a');

SELECT ename , instr(ename,SUBSTR(ename,-1)), SUBSTR(ename,-1)
from emp
where instr(ename,SUBSTR(ename,-1))<LENGTH(ename);


SELECT ename, LEFT(ename, 2), RIGHT(ename, 2)
from emp;

SELECT ename, 
			CONCAT(lower(left(ename,length(ename)-1)),upper(RIGHT(ename,1)))
			from emp;

select trim(' leyla  '), LTRIM('  Leyla   '),RTRIM('  lowan  ');

select trim("k" from "Brekkar");

select REPLACE("mary had a little lamb","lamb","bomb");

set @s="mary had a little lamb";
-- count no. of a
select length(@s)-length(REPLACE(@s,"a",""));

-- reporting functions
select ename, lpad(ename,10,'_'), rpad(ename,10,'*')
FROM emp;


select REPEAT('hello',5);

SELECT empno from emp where mod(empno,2)=1;
-- sign functions compares the given two numbers
SELECT SIGN(10-20), SIGN(20-5),SIGN(10-10);

-- find employees who take comm>salary

SELECT ename,sal,comm FROM emp WHERE SIGN(comm-sal)=1;

SELECT abs(-98), ASCII('A'), CHAR(97 USING ASCII;

select ROUND(157.2588), ROUND(157.2588,2), ROUND(157.2588,-2),ROUND(157.2588,-3);

select TRUNCATE(157.33,-2);
select TRUNCATE(157.33999,4);

SELECT ROUND(140.777,-3);

SELECT CEIL(91.09), FLOOR(91.09);

-- DATE functions
SELECT CURDATE(),CURRENT_DATE;
SELECT NOW(),SYSDATE(),CURRENT_TIMESTAMP;

SELECT date(now()), time(CURRENT_TIMESTAMP);

SELECT YEAR(CURDATE()), MONTH(CURDATE()), MONTHNAME(NOW());

SELECT DAY(CURDATE()), DAYNAME(CURDATE());

select ename from emp  
where dayname(hiredate) like 'tuesday%'; 

SELECT ename FROM emp
WHERE MONTH(hiredate)=12;

SELECT ename FROM emp
where ename not like '%s%' and year(hiredate)=1981;	


SELECT QUARTER(CURDATE()), HOUR(NOW());

-- date FORMAT
-- %a - 3 letter DAY
-- %b - 3 letter MONTH
-- %y - 2 digits
-- %Y - 4 digits
-- %d - day count in MONTH
-- %w - day count in WEEK
-- %j - day count in year


SELECT ename FROM emp WHERE 
(case when MOD(YEAR(`HIREDATE`),4)=0 then 1
	when MOD(YEAR(`HIREDATE`),100)<>0 and MOD(YEAR(`HIREDATE`),400)=0 then 1
end)=1;

select DATE_FORMAT(CONCAT(year(CURDATE()),'-12-31'),'%j');

-- Null comes first in asc ORDER
SELECT comm FROM emp ORDER BY comm;

SELECT `HIREDATE`, DATE_FORMAT(`HIREDATE`,'%D')
from emp;

SELECT ename, hiredate from emp 
where DAYNAME(`HIREDATE`) like 'thursday%' 
and DATE_FORMAT(`HIREDATE`,'%d') BETWEEN 1 AND 7 ;

select CONCAT(ename,' joined on ',
		DATE_FORMAT(hiredate,'%D'),', ',
		DATE_FORMAT(hiredate,'%W'),' ',
		DATE_FORMAT(hiredate,'%M'),' ',
		DATE_FORMAT(hiredate,'%Y'))
from emp;

select  EXTRACT(YEAR FROM CURDATE()),
		EXTRACT(month FROM CURDATE()),
		EXTRACT(DAY FROM CURDATE());

select DATEDIFF(CURDATE(),hiredate) days,
	   TIMESTAMPDIFF(YEAR,hiredate,CURDATE()) as years,
	   TIMESTAMPDIFF(MONTH,hiredate,CURDATE()) months,
	   TIMESTAMPDIFF(DAY,hiredate,CURDATE()) days
from emp;

set @dob='1998-02-05';

select DATEDIFF(CURDATE(),@dob) Total_days,
	   TIMESTAMPDIFF(YEAR,@dob,CURDATE()) as years,
	   MOD(TIMESTAMPDIFF(MONTH,@dob,CURDATE()),12) months,
	   day(CURDATE())-DATE_FORMAT(@dob,'%d') days,
	   DATE_FORMAT(@dob,'%d');

select DATE_FORMAT(CURDATE(),'%Y');

SELECT DATEDIFF(CURDATE(),@dob);

-- modifying dates 
-- date_add years,months, days interval '1'
-- date_sub years,months, days interval '1'

SELECT DATE_ADD(CURDATE(),INTERVAL '1' YEAR)'add1year',
	   DATE_SUB(CURDATE(),INTERVAL '3' YEAR)'deduct3year';

SELECT DATE_ADD(CURDATE(),INTERVAL '1' DAY)"ADD_1_DAY",
	   DATE_SUB(CURDATE(),INTERVAL '1' DAY) "SUB_1_DAY";

SELECT DATE_ADD(CURDATE(),INTERVAL '1' MONTH)"ADD_1_MONTH",
	   DATE_SUB(CURDATE(),INTERVAL '1' MONTH)"SUB_1_MONTH";
SELECT LAST_DAY(CURDATE()); -- last day of MONTH
SELECT LAST_DAY(@dob);

SELECT MAKEDATE(2019,2),MAKEDATE(2022,266);

-- control functions
-- if, case, nullif, ifnull

SELECT ename, QUARTER(hiredate),
		if(QUARTER(hiredate));

SELECT ename, sal, IF(sal>=3000,'high salary','low salary')
FROM emp;

SELECT ename, hiredate, IF(QUARTER(hiredate)=1,'First QTR',
						IF(QUARTER(`HIREDATE`)=2,'Second QTR',
						IF(QUARTER(`HIREDATE`)=3,'Third QTR','Fourth QTR')))QUARTER
from emp;

SELECT ename, hiredate, case quarter(hiredate)
							when 1 then 'First'
							when 2 then 'Second'
							when 3 then 'Third'
							else 'Fourth'
						end QUARTER
FROM emp
ORDER BY 1;
--OR
SELECT ename, hiredate, case 
							when quarter(hiredate)=1 then 'First'
							when quarter(hiredate)=2 then 'Second'
							when quarter(hiredate)=3 then 'Third'
							else 'Fourth'
						end QUARTER
FROM emp
ORDER BY 1;

SELECT ename, sal, job, case job
							when 'SALESMAN' then 2.0*sal
							when 'CLERK' then 1.9*sal
							when 'ANALYST' then 1.75*sal
							else sal
						end bonus
FROM emp
ORDER BY 2;

-- 
set @dob='2012-12-29';
SELECT DAY(@dob), MONTH(@dob), YEAR(@dob);

SELECT case 
			when day(@dob)=day(CURDATE()) and month(@dob)=month(CURDATE()) then REPEAT('Happy Birthday ',5)
			when day(@dob)=day(CURDATE())-1 and month(@dob)=month(CURDATE()) then REPEAT('Belated Birthday ',2)
			when day(@dob)=day(CURDATE())+1 and month(@dob)=month(CURDATE()) then 'Advanced Birthday '
		end 'Message';


-- nullif(a,b) if a=b then returns null else a 
select NULLIF(10,10),NULLIF(10,20);
select ename, length(ename), sal, length(Sal),NULLIF(length(ename),length(sal)) 'nullif'
from emp;

-- ifnull ifnull(a,b) a=null then b else a

SELECT ifnull(10,20),ifnull(null,70);
select ename, sal, comm, sal+comm,IFNULL((sal+comm),sal)'ifnull'
from emp;  

SELECT STR_TO_DATE('10-feb-2021','%d-%M-%Y'),
	   STR_TO_DATE('5-05-1998','%d-%m-%Y');


-- set @@sql_mode='only_full_group_by';

-- AGGREGATE FUNCTION 
-- count(*) includes nulls and count(column) exclude nulls 
select count(comm) from emp;
select count(*) from emp;   

select COUNT(empno) from emp where job like 'clerk%';

-- count, min, max works for all datatypes
-- sum, avg works for numeric datatypes
select max(hiredate),max(ename),max(sal) from emp;

select sum(Sal), avg(Sal) from emp;

select YEAR(hiredate) YEAR, count(empno) total_employess
from emp 
group by year(hiredate)
ORDER BY 1;
select YEAR(hiredate)year, QUARTER(hiredate)QUARTER, count(empno)
from emp
group by year, QUARTER
order by 1,2; 

select MONTHNAME(hiredate)'MONTH',count(empno)
from emp
group by MONTHNAME(hiredate),MONTH(`HIREDATE`)
order by month(hiredate);


--- whtaever is used in order by should be there in group by and whatever is in select should be in group by 
-- below throws error
select job, count(*)
from emp group by job
ORDER BY empno;

-- 
select job, case job  
				when 'clerk' then concat(count(empno),' total employess')
				when 'salesman' then concat(max(sal),' max salary')
				when 'analyst' then concat(sum(sal),' Total salary')
				else concat(ROUND(avg(sal),2),' average salary')
			end 'metrics'
from emp
group by job;

select sal, count(*) from emp
group by sal  
having count(*)>1;

-- 7
select `DEPTNO`, AVG(sal)
from emp
group by `DEPTNO`
having count(*)>5;

select job 
from emp 
group by job
having max(sal)>=3000; 

select job,sum(sal), max(sal), min(sal), avg(sal) 
from emp
where `DEPTNO`=20 
group by `JOB`,`DEPTNO`
having  AVG(sal)>1000;  

select SIGN(1020);
select SIGN(ABS(NULLIF(-32,0)));

SELECT  distinct job FROM emp WHERE deptno in (10,20);
SELECT job FROM emp WHERE `DEPTNO`=20
INTERSECT
SELECT job FROM emp WHERE `DEPTNO`=30;


SELECT job FROM emp WHERE `DEPTNO`=20
UNION ALL
SELECT job FROM emp WHERE `DEPTNO`=30;

select job, sum(sal) job_wise, (select sum(sal) from emp)Total_salary 
from emp
group by job;

select job, sum(sal) from emp group by job
UNION
select "total salary", sum(sal) from emp;

select ename as Name, "employee" from emp
UNION
select dname, "Dept" from dept;

select ename as ename, null as dname from emp
UNION
select null as ename, dname from dept;


select job,deptno, sum(sal)
from emp
group by  deptno, job with rollup;

select job,deptno, sum(sal)
from emp
group by  deptno, job with rollup;

select job,deptno, sum(sal)
from emp
group by job, deptno with rollup;


select job,deptno, sum(sal)
from emp
group by  deptno, job with rollup
UNION
select job,deptno, sum(sal)
from emp
group by  job,deptno with rollup;

-- below throws error as only first select statement columns can be used in order by 
--clause and it orders whole result.
select ename from emp
UNION
select dname from dept
order by dname;

select e.ename, d.dname 
from emp e inner join dept d
on e.deptno=d.deptno; 

select d.dname, sum(sal)  
from emp e inner join dept d
on e.deptno=d.deptno
where dname in ('sales','accounting')
group by dname;

select ename 
from emp e inner join dept d 
on e.deptno=d.deptno
where d.loc like 'chicago%'
and job like 'clerk%';

use db_optimised;
select ename, dname  
from emp e left OUTER join dept d 
on e.deptno=d.deptno;  

select ename, dname  
from emp e right OUTER join dept d 
on e.deptno=d.deptno;  

-- below throws error   
select ename, dname  
from emp e full OUTER join dept d 
on e.deptno=d.deptno;  

--non equi join 
select ename, grade 
from emp e join salgrade s 
on e.sal between s.losal and s.hisal;

-- 
select ename, dname, grade 
from emp e inner join dept d 
inner join salgrade s 
on e.deptno=d.deptno and e.`SAL` between s.`LOSAL` and s.`HISAL`;  

SELECT distinct e.`job`, e.`HIREDATE`, a.`job`, a.`HIREDATE`
from emp e INNER JOIN emp a 
on  e.`JOB`=a.`JOB`
and month(e.`HIREDATE`) between 7 and 12 
and month(a.`HIREDATE`) between 1 and 6
and year(a.`HIREDATE`)=year(e.`HIREDATE`)+1;


SELECT job,YEAR(e1.hiredate) 'YEAR', MONTH(e1.hiredate) 'Month'
FROM emp e1 
WHERE YEAR(e1.hiredate) IN 
			(Select YEAR(e2.hiredate)-1 
			FROM emp e2 WHERE QUARTER(e2.hiredate)>3
			AND QUARTER(e1.hiredate)>2);

select * from emp natural join dept;

