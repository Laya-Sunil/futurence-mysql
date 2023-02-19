CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_exceptn_handle_2`(p_empid int)
BEGIN
	-- declare v1 int;
	
	if p_empid not in (select employee_id from employees) then
		signal sqlstate '45000' set message_text='please give valid employee id !!!';
	end if;
	select salary from employees where employee_id=p_empid;
END