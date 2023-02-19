CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_gender_report`(p_did int)
BEGIN
	with cte_count as (
        select d.`diseaseID`, d.`diseaseName`, p.gender, count(pt.`patientID`)cnt
        from disease d inner join treatment t on d.`diseaseID`= t.diseaseID
        inner join patient pt on t.`patientID` = pt.`patientID`
        inner join person p on p.`personID` = pt.`patientID`
        group by d.`diseaseID`, d.`diseaseName`, p.gender
        order by d.`diseaseName`, p.gender
        )


		select m.diseaseName, m.cnt as 'Male', f.cnt as 'Female',
						case 
								when m.cnt>f.cnt then 'Male'
								when m.cnt=f.cnt then 'Same'
								else 'Female' 
						end as 'more_treated_gender'
		from cte_count m inner join cte_Count f on m.`diseaseName` = f.`diseaseName`
		where m.gender = 'Male' and f.gender = 'Female'
		and m.`diseaseID` = p_did;
END