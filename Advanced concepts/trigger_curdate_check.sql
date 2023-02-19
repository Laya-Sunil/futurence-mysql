CREATE DEFINER=`root`@`localhost` TRIGGER `date_table_BEFORE_INSERT` BEFORE INSERT ON `date_table` FOR EACH ROW BEGIN
 if new.date1 > curdate() then
	signal sqlstate '45000' set message_text='date1<=curdate()';
end if;
END