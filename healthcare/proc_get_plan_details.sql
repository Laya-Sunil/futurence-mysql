CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_plan_details`(p_compID int)
BEGIN
	select a.`planName`, a.`TotalClaims`,c.`diseaseName`
	from
	(
		select ip.`planName`, count(c.uin)'TotalClaims'
		from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
		inner join claim c on c.uin=ip.uin
		where ic.`companyID`=p_compID
		group by ip.`planName`
	)a
	inner join 
	(
		select * from (
			select ip.`planName`, d.`diseaseName`, count(c.uin), 
							dense_rank()over(partition by ip.`planName`order by count(c.uin) desc) rnk
			from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
			inner join claim c on c.uin=ip.uin
			inner join treatment t on t.`claimID`=c.`claimID`
			inner join disease d on d.`diseaseID`=t.`diseaseID`
			where ic.`companyID`=p_compID 
			group by ip.`planName`, d.`diseaseName`
		)b
		where rnk =1
	)c
	on a.`planName`=c.`planName`;
END