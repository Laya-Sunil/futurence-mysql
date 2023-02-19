CREATE DEFINER=`root`@`localhost` TRIGGER `employees_BEFORE_DELETE` 
BEFORE DELETE ON `employees` 
FOR EACH ROW 
BEGIN
	insert into retired values(old.employee_id, old.job_id, old.first_name, old.last_name);
END