CREATE DEFINER=`root`@`localhost` FUNCTION `func_new_rental`(p_bid int, p_mid int) RETURNS date
    DETERMINISTIC
BEGIN
	declare v1 date;
    declare v2 varchar(20);
    declare v3 int;
    select status, c_id into v2, v3 from bcopy where bookid = p_bid;
    if v2 = 'available' then
		set v1 = date_add(curdate(), interval 2 day);
        
        insert into bloan values(p_bid, curdate(), 10, p_mid, null,now()+1,v3);
        update bcopy set status ='rented' where bookid = p_bid;
	else
		set v1 = null;
	end if;
    
RETURN v1;
END