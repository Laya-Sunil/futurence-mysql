CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insert_book`(
	p_pub varchar(20), p_auth varchar(20), p_title varchar(25), p_sub varchar(25)
    )
BEGIN
	insert into book values(null, p_pub, p_auth, p_title, p_sub);
END