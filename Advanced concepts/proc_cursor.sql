CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_cursor_1`(pno int, pout varchar(200))
BEGIN
	declare v1 numeric(11,2);
    declare v2 varchar(20); 
    
	declare v3 int default 0;
    
    declare cursr cursor  for select sal, ename from emp where deptno=pno; 
	declare continue handler for not found set v3 = 1;
    open cursr;
    get_cur: loop
			fetch cursr into v1,v2;
            if v3 =1 then
				leave get_cur;
			 end if;
            insert into tab_1 values(concat('sal = ',v1,' ','name = ',v2));
             
	end loop get_cur;
    close cursr;
END