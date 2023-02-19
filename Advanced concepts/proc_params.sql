CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_params`(
	in p1 int, 
    out p2 varchar(20)
)
BEGIN
	select first_name into p2 from employees
    where employee_id = p1;
END