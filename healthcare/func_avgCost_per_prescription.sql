CREATE DEFINER=`root`@`localhost` FUNCTION `func_avg_cost_per_prescription`(p_pharmacyID int, p_year int) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
	declare avgCost decimal(10,2);
	select avg(m.`maxPrice`) into avgCost
	from pharmacy p inner join prescription pr on p.`pharmacyID` = pr.`pharmacyID`
	inner join contain c on c.`prescriptionID`=pr.`prescriptionID`
	inner join medicine m on m.`medicineID`=c.`medicineID`
	inner join treatment t on t.`treatmentID` = pr.`treatmentID`
	where year(t.`date`)=p_year and p.`pharmacyID` =p_pharmacyID
	group by p.`pharmacyID`;
	
    RETURN avgCost;
END