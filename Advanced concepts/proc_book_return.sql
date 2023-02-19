CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_book_return`(p_bid int, p_cid int, p_status varchar(20), out msg varchar(30))
BEGIN
	declare v1 date;
    select resdate into v1 from bres where bookid = p_bid;
    if v1 is not null then
		set msg = concat('this book is reseved on ',v1);
	else 
		set msg = p_status;
	end if;
    update bcopy set status = p_status where c_id = p_cid;
    update bloan set act_date = curdate() where bookid = p_bid;
END