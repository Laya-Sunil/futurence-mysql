create database tt;

use tt;

create table t1(id int);

create table t2(id int);

insert into t1 values(1),(1),(1),;
insert into t1 values(2);

select * from t1;
select * from t2;


select * from t1 inner join t2 on t1.id=t2.id;
-- using(id);


select * from t1 cross join t2;


use hr;

select employee_id, case 
						when salary>5000 then salary
                        else null
					end as salary
from employees;