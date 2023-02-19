CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_disease_claim_status`(in p_did int)
BEGIN
	with cte_claim_count as (
		select `diseaseID`,count(`claimID`) cnt from treatment
        group by `diseaseID`
        ),
	cte_claim_avg as (
		select avg(cnt) avg_cnt from cte_claim_count
    )
	select case 
                when cnt>avg_cnt  then 'claimed higher than average'
                else 'claimed lower than average' 
			end
	from cte_claim_count join cte_claim_avg
    where `diseaseID` = p_did;
END