CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_2`(p1 int, p2 int)
BEGIN
	declare vprod numeric(11,2);
    set vprod = p1*p2;
    select concat('product of ',p1,' and ',p2,' = ', vprod)product;
END