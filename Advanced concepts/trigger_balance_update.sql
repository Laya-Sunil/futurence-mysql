CREATE DEFINER=`root`@`localhost` TRIGGER `trans_BEFORE_INSERT` 
BEFORE INSERT ON `trans` FOR EACH ROW BEGIN
	update account
    set balance = (case 
						when new.withdraw>0 then balance- new.withdraw
						else balance+ new.deposit
					end)
	where accno = new.accno;

END