CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insert_member`(p_name varchar(20),p_phone decimal(10,0))
BEGIN
	insert into member values(null, p_name, p_phone, curdate());
END