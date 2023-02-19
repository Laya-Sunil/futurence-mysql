CREATE DEFINER=`root`@`localhost` FUNCTION `func_find_disease`(p_state varchar(10), p_year int) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	declare diseasename varchar(50);
	select a.`diseaseName`  into diseasename
    from (
			select d.`diseaseName`, count(t.`treatmentID`), row_number()over(order by count(t.`treatmentID`) desc)rnk_
			from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
			inner join patient pt on pt.`patientID`=t.`patientID`
			inner join person p on p.`personID`=pt.`patientID`
			inner join address a on a.`addressID`=p.`addressID`
			where year(t.date)=p_year and a.state=p_state
			group by d.`diseaseName`
		)a
	where rnk_=1;
	RETURN diseasename;
    
END