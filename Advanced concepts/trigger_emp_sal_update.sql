CREATE DEFINER=`root`@`localhost` TRIGGER `employee_duplicate_BEFORE_UPDATE` BEFORE UPDATE ON `employee_duplicate` FOR EACH ROW BEGIN
	if new.salary<old.salary then
		signal sqlstate '45000' set message_text = 'BEWARE I want a hike !!!';
	end if;
END