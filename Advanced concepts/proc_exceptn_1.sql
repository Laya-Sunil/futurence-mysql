CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_exception_handle`(p_empid int)
BEGIN
	declare v1 numeric(11,2);
	select salary into v1 from employees where employee_id=p_empid;
    if v1 is null then
		signal sqlstate '45000' set message_text='invalid employee id !!!';
	end if;
END