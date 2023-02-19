show tables;
desc bres;
select * from bcopy;

show tables;

select * from member;
desc member;
desc book;
desc bcopy;
select * from book;
select * from bcopy;



desc bloan;
select * from bloan;
truncate bloan;
select * from bres;
-- 1
call proc_insert_member('Laya', 1234567890);
-- 2
call proc_insert_book('Penguin','Gillian Flynn','Gone Girl','Thriller');
-- 3
select func_new_rental(8,3) as return_date;
-- 4
call proc_book_return(7,1,'rented', @res);
select @res as status;
-- 5
call proc_reserve_book(1,1,@res);
select @res as 'update';

select true as v1 from dual 
where exists (
select c_id from bcopy where bookid = 1 and status <> 'rented');
select min(act_date) as v2 from bloan where bookid = 7;

select * from bcopy;

update bcopy set status = 'available';



