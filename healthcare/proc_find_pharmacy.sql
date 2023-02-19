CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_find_pharmacy`(p_medicine_name varchar(40), p_company_name varchar(50))
BEGIN
	select p.`pharmacyName`, p.phone
	from medicine m inner join keep k on k.`medicineID`=m.`medicineID`
	inner join pharmacy p on p.`pharmacyID`=k.`pharmacyID`
	where m.`productName` = p_medicine_name and m.`companyName` = p_company_name
	and k.quantity <> 0;
END