CREATE DEFINER=`root`@`localhost` PROCEDURE `get_emp_salary`(p_empid int)
BEGIN
	select salary from employees where employee_id=p_empid;
END