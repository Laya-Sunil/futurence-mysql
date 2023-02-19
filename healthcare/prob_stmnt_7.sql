-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
/*
Problem Statement 1: 
Insurance companies want to know if a disease is claimed higher or lower than 
average.  Write a stored procedure that returns “claimed higher than average” or 
“claimed lower than average” when the diseaseID is passed to it. 
Hint: Find average number of insurance claims for all the diseases.  
If the number of claims for the passed disease is higher than the average return 
“claimed higher than average” otherwise “claimed lower than average”.

*/
DELIMITER #

CREATE PROCEDURE `proc_disease_claim_status`(in p_did int)
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
END #
DELIMITER ;
call proc_disease_claim_status(1);

set @p_did = 11;
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
    where `diseaseID` = @p_did;

/*
Problem Statement 2:  
Joseph from Healthcare department has requested for an application which helps 
him get genderwise report for any disease. Write a stored procedure when passed 
a disease_id returns 4 columns,disease_name, number_of_male_treated, 
number_of_female_treated, more_treated_gender
Where, more_treated_gender is either ‘male’ or ‘female’ based on which gender 
underwent more often for the disease, if the number is same for both the genders, 
the value should be ‘same’.

*/
DELIMITER #
CREATE PROCEDURE `proc_gender_report`(p_did int)
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
END #

DELIMITER ;
call proc_gender_report(15);



set @did = 15;
with cte_count as (
        select d.`diseaseID`, d.`diseaseName`, p.gender, count(pt.`patientID`)cnt
        from disease d inner join treatment t on d.`diseaseID`= t.diseaseID
        inner join patient pt on t.`patientID` = pt.`patientID`
        inner join person p on p.`personID` = pt.`patientID`
        group by d.`diseaseID`, d.`diseaseName`, p.gender
        order by d.`diseaseName`, p.gender
        )
--select * from cte_count;

select m.diseaseName, m.cnt as 'Male', f.cnt as 'Female',
                case 
                        when m.cnt>f.cnt then 'Male'
                        when m.cnt=f.cnt then 'Same'
                        else 'Female' 
                end as 'more_treated_gender'
from cte_count m inner join cte_Count f on m.`diseaseName` = f.`diseaseName`
where m.gender = 'Male' and f.gender = 'Female'
and m.`diseaseID` = @did;

/*

Problem Statement 3:  
The insurance companies want a report on the claims of different insurance plans. 
Write a query that finds the top 3 most and top 3 least claimed insurance plans.
The query is expected to return the insurance plan name, the insurance company 
name which has that plan, and whether the plan is the most claimed or least claimed. 

*/
with cte_rank as (
        select ic.`companyName`, ip.`planName`, count(c.uin) 'total_claims',
                    dense_rank()over(partition by ic.`companyName` order by count(c.uin) desc) max_rnk,
                    dense_rank()over(partition by ic.`companyName` order by count(c.uin)) min_rnk 

        from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
        inner join claim c on c.uin = ip.uin
        group by ic.`companyName`, ip.`planName`
        order by ic.`companyName`
)
-- select * from cte_rank;

select `companyName`, `planName`, 
                                case 
                                    when max_rnk < 4 then 'Most Claimed'
                                    when min_rnk < 4 then 'Least Claimed'
                                end as Tag
from cte_rank
where max_rnk<4 or min_rnk<4
order by `companyName`;

/*

Problem Statement 4: 
The healthcare department wants to know which category of patients is being affected the most by each disease.
Assist the department in creating a report regarding this.
Provided the healthcare department has categorized the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.

*/
with cte as (
        select d.`diseaseName`, a.category, count(*), 
                    dense_rank()over(partition by `diseaseName` order by count(*) desc) rnk
        from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
        inner join  

        (
                select pt.`patientID`, 
                            case
                                when pt.dob>='2005-01-01' and p.gender='male' then 'YoungMale'
                                when pt.dob>='2005-01-01' and p.gender='female' then 'YoungFemale'
                                when pt.dob<'2005-01-01' and pt.dob>='1985-01-01' and p.gender='male' then 'AdultMale'
                                when pt.dob<'2005-01-01' and pt.dob>='1985-01-01' and p.gender='female' then 'AdultFemale'
                                when pt.dob<'1985-01-01' and pt.dob>='1970-01-01' and p.gender='male' then 'MidAgeMale'
                                when pt.dob<'1985-01-01' and pt.dob>='1970-01-01' and p.gender='Female' then 'MidAgeFemale'
                                when pt.dob<'1970-01-01' and p.gender='Male' then 'ElderMale'
                                when pt.dob<'1970-01-01' and p.gender='Female' then 'ElderFemale'
                            end as category
                from person p inner join patient pt on p.`personID`=pt.`patientID`
        )a  
        on  a.`patientID` = t.`patientID`
        group by d.`diseaseName`, a.category
        order by d.`diseaseName`
)
-- select * from cte;
select `diseaseName`, category
from cte 
where rnk=1; --and category <> 'ElderMale';

/*
Problem Statement 5:  
Anna wants a report on the pricing of the medicine. She wants a list 
of the most expensive and most affordable medicines only. 
Assist anna by creating a report of all the medicines which are pricey 
and affordable, listing the companyName, productName, description, 
maxPrice, and the price category of each. Sort the list in descending 
order of the maxPrice.
Note: A medicine is considered to be “pricey” if the max price exceeds 
1000 and “affordable” if the price is under 5. Write a query to find 

*/
with cte_category as (
        select  m.`companyName`, m.`productName`, m.description, m.`maxPrice`, 
                    case 
                        when m.`maxPrice`>1000 then 'Pricey'
                        when m.`maxPrice`<5 then 'Affordable'
                    end as category
        from medicine m
        where `maxPrice`>1000 or `maxPrice`<5
        order by m.`maxPrice` desc
),
cte_max_min as (
        select *, max(maxPrice)over()max, min(maxPrice)over()min
        from cte_category
)
select * from cte_max_min
where maxPrice = max or maxPrice=min;  