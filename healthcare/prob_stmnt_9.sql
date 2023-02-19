-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
/*

Problem Statement 1: 
Brian, the healthcare department, has requested for a report that shows for 
each state how many people underwent treatment for the disease “Autism”.  
He expects the report to show the data for each state as well as each gender 
and for each state and gender combination. 
Prepare a report for Brian for his requirement.

*/

select a.state, COALESCE(p.gender,'Total Count') gender, count(t.`patientID`) 'Total patients'
from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
inner join patient pt on pt.`patientID` = t.`patientID`
inner join person p on p.`personID` = pt.`patientID`
inner join address a on a.`addressID`=p.`addressID`
where d.`diseaseName` = 'Autism'
group by a.state, p.gender with rollup;

/*
Problem Statement 2:  
Insurance companies want to evaluate the performance of different insurance 
plans they offer. Generate a report that shows each insurance plan, the 
company that issues the plan, and the number of treatments the plan was 
claimed for. The report would be more relevant if the data compares the 
performance for different years(2020, 2021 and 2022) and if the report 
also includes the total number of claims in the different years, as well 
as the total number of claims for each plan in all 3 years combined.

*/
with cte_1 as (
    select ic.`companyName`, ip.`planName`, year(t.date) 'year', count(c.uin) 'totalClaims'
    from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
    inner join claim c on c.uin=ip.uin 
    inner join treatment t on t.`claimID`=c.`claimID`
    where year(t.`date`) in (2020,2021,2022)
    --and ic.`companyName` = 'Bajaj Allianz General Insuarnce Co. Ltd'
    group by ic.`companyName`, ip.`planName`, year(t.date)
),
-- select * from cte_1; where `planName` = 'Health Prime (Group)';
-- select `companyName`, `planName`, 
--         (case `year`
--             when  '2022' then `totalClaims`
--         end) as '2022'
-- from cte_1
-- group by `companyName`, `planName`, `year`;

cte_2 as (
    select COALESCE(`companyName`, 'GRANT TOTAL') `companyName`, 
            COALESCE(`planName`, 'TOTAL') `planName`, 
            sum(case 
                when  year=2020 then totalClaims
            end) as '2020', 
            sum(case  
                when year=2021 then totalClaims
            end) as '2021',
            sum(case  
                when year=2022 then totalClaims
            end) as '2022'     
    from cte_1
    --where `companyName` is not null
    group by `companyName`, `planName` with rollup
)
select *, (`2020`+`2021`+`2022`) Total
from cte_2;

/*
Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some 
diseases are spreading in a particular region. Assist Sarah by creating a 
report which shows each state the number of the most and least treated 
diseases by the patients of that state in the year 2022. It would be 
helpful for Sarah if the aggregation for the different combinations is 
found as well. Assist Sarah to create this report. 

*/
with cte_max_treated as (
    select a.state, d.`diseaseName`,count(*)cnt,
            dense_rank()over(partition by state order by count(*)) min_rnk,
            dense_rank()over(partition by state order by count(*) desc) max_rnk
 
    from disease d inner join treatment t on d.`diseaseID` = t.`diseaseID`
    inner join patient pt on pt.`patientID`=t.`patientID`
    inner join person p on p.`personID`=pt.`patientID`
    inner join address a on a.`addressID` = p.`addressID`
    where year(t.`date`)=2022 
    -- and a.state = 'AK'
    group by a.state, d.`diseaseName` -- with rollup
    order by a.state
),
cte_2 as (
    select COALESCE(state, 'State-wise Total') State, 
            COALESCE(`diseaseName`, 'Disease-wise Total') as Disease, 
            sum(cnt) Count, 
    if(max_rnk=1,'Most Treated',if(min_rnk=1, 'Leat Treated', null)) Tag
    from cte_max_treated where --( state = 'AK' and
    (max_rnk=1 or min_rnk=1) 
    group by state, `diseaseName`, tag  with rollup
)
-- select COALESCE(state, 'States Total') State,
--         COALESCE(Tag, 'Total') Tag,

--         sum(Count) Total_Treated, count(*) Count
-- from cte_2
-- group by state, Tag with rollup;

select *, sum(Count)over(partition by state, tag) Total
from cte_2
where (tag is not null or `Disease` = 'Disease-wise Total' );



/*

Problem Statement 4: 
Jackson has requested a detailed pharmacy report that shows each 
pharmacy name, and how many prescriptions they have prescribed for 
each disease in the year 2022, along with this Jackson also needs 
to view how many prescriptions were prescribed by each pharmacy, 
and the total number prescriptions were prescribed for each disease.
Assist Jackson to create this report. 
*/

with cte_1 as (
    select ph.`pharmacyName`, d.`diseaseName`, count( pr.`prescriptionID`) cnt
    from pharmacy ph left join prescription pr on pr.`pharmacyID`=ph.`pharmacyID`
    inner join treatment t on t.`treatmentID`=pr.`treatmentID`
    inner join disease d  on d.`diseaseID`=t.`diseaseID`
    where year(t.`date`)=2022
    group by ph.`pharmacyName`, d.`diseaseName` with rollup
)
select COALESCE(`pharmacyName`, 'GRANT TOTAL (pharmacy-wise)') pharmacy, COALESCE(`diseaseName`, 'TOTAL')disease, cnt as count 
from cte_1
union
select 'TOTAL PRESCRIPTION',COALESCE(`diseaseName`, 'DISEASE-WISE TOTAL'), sum(cnt) as Total_Prescriptions
from cte_1
where `diseaseName` is not null
group by `diseaseName` with rollup;







/*

Problem Statement 5:  
Praveen has requested for a report that finds for every disease how 
many males and females underwent treatment for each in the year 2022. 
It would be helpful for Praveen if the aggregation for the different 
combinations is found as well.
Assist Praveen to create this report. 

*/
with cte_1 as (
        select COALESCE(d.`diseaseName`, 'GRANT TOTAL') Disease, 
        COALESCE(p.gender, 'TOTAL') Gender, count(*)count
        from disease d inner join treatment t on t.`diseaseID`=d.`diseaseID`
        inner join patient pt on pt.`patientID`=t.`patientID`
        inner join person p on p.`personID`=pt.`patientID`
        where year(t.date)=2022   
        group by d.`diseaseName`, p.gender with rollup
    )


select * from cte_1    
union 
select 'GRANT TOTAL', gender, sum(count) 
from cte_1
where gender <> 'TOTAL'
group by gender;