CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insert_oddeven`(p1 int, p2 int)
BEGIN
	declare v1 varchar(4);
	while p1<p2 do
		
        if mod(p1,2)=0 then
			set v1 = 'even';
		else
			set v1 = 'odd';
		end if;
        insert into odd_even values(p1,v1);
        set p1 = p1+1;
	end while;
END