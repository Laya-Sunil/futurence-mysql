CREATE DEFINER=`root`@`localhost` FUNCTION `func_city_disease_count`(p_city varchar(10), p_disease varchar(50), p_year int) RETURNS int
    DETERMINISTIC
BEGIN
	declare dis_count int;
    
	select count(t.`treatmentID`) into dis_count
	from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
	inner join patient pt on pt.`patientID`=t.`patientID`
	inner join person p on p.`personID`=pt.`patientID`
	inner join address a on a.`addressID`=p.`addressID`
	where year(t.date)= p_year 
    and a.city=p_city and d.`diseaseName`=p_disease
	group by a.city, d.`diseaseName`;

	RETURN dis_count;
END