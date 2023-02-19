CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_print_days`(dob date)
BEGIN
	declare y int;
	while (dob)<=(curdate()) do
		insert into birth_days values(dob, dayname(dob));
        set y = year(dob)+1;
        -- set dob = concat(y,right(dob,6));
        set dob = date_add(dob, interval 1 year);
    end while;
END