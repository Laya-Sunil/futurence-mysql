-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
-- logical reads and physical reads to 

/*
Problem Statement 1: A company needs to set up 3 new pharmacies, they have come up with an idea that the pharmacy 
can be set up in cities where the pharmacy-to-prescription ratio is the lowest and the number of prescriptions should exceed 100.
Assist the company to identify those cities where the pharmacy can be set up.


 */       
select  a.city, count(distinct p.pharmacyid)/count(pr.prescriptionID) as ratio
from address a left join pharmacy p on p.addressid=a.addressid
inner join prescription pr on p.pharmacyid = pr.pharmacyid
group by a.city
having count(pr.prescriptionID)>100
order by ratio
limit 3;

/*

Problem Statement 2: The State of Alabama (AL) is trying to manage its healthcare resources
 more efficiently. For each city in their state, they need to identify the disease for 
which the maximum number of patients have gone for treatment.
Assist the state for this purpose.
Note: The state of Alabama is represented as AL in Address Table.

*/
-- using cte and group by
with cte_1 as
	(
			select a.city, d.`diseaseName`, count(t.`treatmentID`) count
			from address a inner join person p on a.`addressID` = p.`addressID`
			inner join treatment t on t.`patientID` = p.`personID`
			inner join disease d on d.`diseaseID` = t.`diseaseID`
			where a.state = 'AL'
			group by a.city, d.`diseaseName`
	)
select *
from cte_1 c
where count  =(select max(count) from cte_1 t
				where t.city = c.city
				);

-- using subquery and window function
select city, `diseaseName`, cnt_disease from
(
	select *, dense_rank()over(partition by city order by cnt_disease desc) rnk
	from (
			select distinct a.city, d.`diseaseName`, count(*)over(partition by t.`diseaseID`, a.city)cnt_disease
			from treatment t inner join disease d on t.`diseaseID` = d.`diseaseID`
			inner join patient p on p.`patientID` = t.`patientID`
			inner join person pr on pr.`personID` = p.`patientID`
			inner join address a on a.`addressID` = pr.`addressID`
			where a.state = 'AL'
		)a
)b
where rnk = 1;


/*
Problem Statement 3: The healthcare department needs a report about insurance plans. 
The report is required to include the insurance plan, which was claimed the most and least 
for each disease.  Assist to create such a report.
*/

with claim_counts as (
    select c.uin,count(diseaseName) as claim_count,diseaseName 
    from claim c inner join treatment t using(`claimID`)
    inner join disease using(`diseaseID`) 
    group by uin,diseaseName
),
min_claims as (
    select diseaseName,min(claim_count) as min_claim
    from claim_counts
    group by `diseaseName`
),
max_claims as (
    select diseaseName,max(claim_count) as max_claim
    from claim_counts
    group by `diseaseName`
)
select cc.diseaseName, uin, mc.max_claim,mn.min_claim, cc.claim_count,
       case 
        when cc.claim_count = mc.max_claim then 'Max Claimed'
        else 'Least Claimed'
        end as claim_status
from claim_counts cc 
join max_claims mc on cc.diseaseName=mc.`diseaseName`
join min_claims mn ON cc.diseaseName = mn.`diseaseName`
where cc.claim_count = mc.max_claim OR cc.claim_count = mn.min_claim;


/*
Problem Statement 4: The Healthcare department wants to know which disease is most 
likely to infect multiple people in the same household. For each disease find the number 
of households that has more than one patient with the same disease. 
Note: 2 people are considered to be in the same household if they have the same address. 

*/

with cte_household_count as (
		select distinct a.`addressID`, pt.`patientID`, count(pt.`patientID`)over(partition by a.`addressID`)cnt
		from address a inner join person p on a.`addressID`=p.`addressID` 
		inner join patient pt on pt.`patientID`=p.`personID`
)

select d.`diseaseName`, count(cnt)
from treatment t inner join cte_household_count c on t.`patientID`= c.`patientID`
inner join disease d on d.`diseaseID` = t.`diseaseID`
where c.cnt>1
group by d.`diseaseName`;


select distinct a.`addressID`, pt.`patientID`, count(pt.`patientID`)over(partition by a.`addressID`)cnt
			from address a inner join person p on a.`addressID`=p.`addressID` 
			inner join patient pt on pt.`patientID`=p.`personID`;




select count(DISTINCT `addressID`) from (
	select p.`addressID`, t.`diseaseID`, count(pt.`patientID`)cnt
	from address a inner join person p on a.`addressID` = p.`addressID`
	inner join patient pt on pt.`patientID` = p.`personID`
	inner join treatment t on t.`patientID` = pt.`patientID`
	group by p.`addressID`, t.`diseaseID`
	having cnt>1
)a;

/*

Problem Statement 5:  An Insurance company wants a state wise report of the treatments to 
claim ratio between 1st April 2021 and 31st March 2022 (days both included). Assist 
them to create such a report.
*/



select a.state, count(t.`treatmentID`)/count(t.`claimID`) as ratio
from address a inner join person p on a.`addressID` = p.`addressID`
inner join patient pt on p.`personID` = pt.`patientID`
inner join treatment t on pt.`patientID` = t.`patientID`
where t.date between '2021-04-01' and '2022-03-31'
group by a.state;







