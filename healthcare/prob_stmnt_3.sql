-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
-- Problem Statement 1:  Some complaints have been lodged by patients 
-- that they have been prescribed hospital-exclusive medicine that they 
-- can’t find elsewhere and facing problems due to that. Joshua, from the
-- pharmacy management, wants to get a report of which pharmacies have prescribed 
-- hospital-exclusive medicines the most in the years 2021 and 2022. Assist Joshua to 
-- generate the report so that the pharmacies who prescribe hospital-exclusive medicine 
-- more often are advised to avoid such practice if possible.   

with cte_hospital_exclusive as (
        select p.`pharmacyName`, year(t.date)year, count(m.`medicineID`) `Hospital_Exclusive`
        from medicine m inner join contain c on m.`medicineID` = c.`medicineID`
        inner join prescription pr on pr.`prescriptionID` = c.`prescriptionID`
        inner join pharmacy p on p.`pharmacyID` = pr.`pharmacyID`
        inner join treatment t on pr.`treatmentID` = t.`treatmentID`
        where m.`hospitalExclusive`='S'
        and year(t.`date`) in ('2021','2022')
        group by p.`pharmacyName`, year
        order by Hospital_Exclusive desc)

select * from cte_hospital_exclusive h1 where Hospital_Exclusive = 
        (
            select max(Hospital_Exclusive) from cte_hospital_exclusive h2
            where h1.year=h2.year
        );
        


/*
Problem Statement 2: Insurance companies want to assess the performance of their 
insurance plans. Generate a report that shows each insurance plan, the company that 
issues the plan, and the number of treatments the plan was claimed for.

*/

select ic.`companyName`, ip.`planName`,count(c.uin) 'Total_claims'
from insuranceplan ip inner join insurancecompany ic on ip.`companyID`= ic.`companyID`
inner join claim c on ip.uin = c.uin
group by ic.`companyName`, ip.`planName`;

/*

Problem Statement 3: Insurance companies want to assess the performance of their insurance
 plans. Generate a report that shows each insurance company's name with their most and 
 least claimed insurance plans.

*/
select * from claim;
with cte_claim_count as (

    select ic.`companyName`, ip.`planName`,count(c.uin) 'Total_claims'
    from insuranceplan ip inner join insurancecompany ic on ip.`companyID`= ic.`companyID`
    inner join claim c on ip.uin = c.uin
    group by ic.`companyName`, ip.`planName`
),
cte_least_most_claimed as (
    select *, max(c.Total_claims)over(partition by `companyName`) max_claim, 
            min(c.Total_claims)over(partition by `companyName`) min_claim
    from cte_claim_count c
)
select `companyName`,`planName`,Total_claims, 'Least claimed' as status from cte_least_most_claimed
where Total_claims = min_claim
union 
select `companyName`,`planName`,Total_claims, 'Most claimed' from cte_least_most_claimed
where Total_claims = max_claim
order by `companyName`;

-- horizontal result is not applicable her as there might top 2 plans or least 2 plans

-- select l.companyName,l.planName,m.planName
-- from cte_least_most_claimed l inner join cte_least_most_claimed m
-- on l.`companyName`=m.`companyName` and l.Total_claims = l.min_claim
-- and m.Total_claims = m.max_claim
-- where l.`companyName`= -- 'Aditya Birla Health Insurance Co. Ltd';
-- 'Aditya Birla Health Insurance Co. Ltd.';
-- l.Total_claims=l.min_claim and m.Total_claims=m.max_claim;

/*
Problem Statement 4:  The healthcare department wants a state-wise health 
report to assess which state requires more attention in the healthcare 
sector. Generate a report for them that shows the state name, number of 
registered people in the state, number of registered patients in the state,
and the people-to-patient ratio. sort the data by people-to-patient ratio. 
*/
select a.state, count(p.`personID`)'total_people', 
        count(pt.`patientID`) 'total_patients', 
        count(p.`personID`)/count(pt.`patientID`) as `people-to-patient`
from address a left join person p on a.`addressID`=p.`addressID`
left join patient pt on pt.`patientID` = p.`personID`
group by a.state
order by `people-to-patient`;


/*
Problem Statement 5:  Jhonny, from the finance department of Arizona(AZ), has 
requested a report that lists the total quantity of medicine each pharmacy in his 
state has prescribed that falls under Tax criteria I for treatments that took 
place in 2021. Assist Jhonny in generating the report. 
*/
-- EXPLAIN FORMAT=tree
select p.`pharmacyID`, p.pharmacyName, sum(k.quantity) 'Quantity'
from pharmacy p 
inner join (select `addressID` from address 
            where state='AZ') b
            on b.`addressID` = p.`addressID`
inner join keep k on k.`pharmacyID` = p.`pharmacyID`
inner join medicine m on m.`medicineID`=k.`medicineID`
inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
inner join (select `treatmentID` from treatment 
            where year(date)='2021') a
            on a.`treatmentID`=pr.`treatmentID`
where m.`taxCriteria` = 'I'
group by p.`pharmacyName`, p.`pharmacyID`;


select p.`pharmacyID`, p.pharmacyName, sum(k.quantity) 'Quantity'
from pharmacy p inner join address b
on b.`addressID` = p.`addressID`
inner join keep k on k.`pharmacyID` = p.`pharmacyID`
inner join medicine m on m.`medicineID`=k.`medicineID`
inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
inner join treatment a
on a.`treatmentID`=pr.`treatmentID`
where m.`taxCriteria` = 'I' and year(a.`date`)=2021 and b.state = 'AZ'
group by p.`pharmacyName`, p.`pharmacyID`
;
