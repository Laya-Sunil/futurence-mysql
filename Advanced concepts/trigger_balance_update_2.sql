CREATE DEFINER = CURRENT_USER TRIGGER `hr`.`trans_BEFORE_INSERT_1` BEFORE INSERT ON `trans` FOR EACH ROW
BEGIN
	if new.deposit is not null then
		update account set balance = balance + new.deposit
        where accno = new.accno;
	else
		update account set balance = balance - new.withdraw
        where accno = new.accno;
	end if;
END