CREATE DEFINER=`root`@`localhost` FUNCTION `func_emp_bonus`(p1 int) RETURNS decimal(11,2)
    DETERMINISTIC
BEGIN
	declare v1 numeric(11,2);
    declare v2 numeric(11,2);
    declare v3 varchar(20);
    select  job_id, salary into v3,v1 from employees where employee_id=p1;
    if v3 = 'SH_CLERK' then
		set v2 = 1.5 *v1;
	elseif v3 = 'SA_REP' then
		set v2 = 1.75*v1;
	elseif v3 = 'MK_MAN' then
		set v2 = 2.0*v1;
	else
		set v2 = v1;
	end if;
RETURN v2;
END