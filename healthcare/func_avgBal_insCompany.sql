CREATE DEFINER=`root`@`localhost` FUNCTION `func_avgBal_insCompany`(p_comp varchar(100)) RETURNS decimal(20,4)
    DETERMINISTIC
BEGIN
	declare avgBal decimal(20,4);
	select avg(c.balance) into avgBal
	from treatment t inner join claim c on c.`claimID`=t.`claimID`
	inner join insuranceplan ip on c.uin=ip.uin
	inner join insurancecompany ic on ic.`companyID`=ip.`companyID`
	where year(t.date)=2022 and ic.`companyName`=p_comp
	group by ic.`companyID`;
    
    return avgBal;

END