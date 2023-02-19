-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
/*
Problem Statement 1: 
Johansson is trying to prepare a report on patients who have gone 
through treatments more than once. Help Johansson prepare a report that 
shows the patient's name, the number of treatments they have undergone, 
and their age, Sort the data in a way that the patients who have undergone 
more treatments appear on top.

*/
select p.`personName`, TIMESTAMPDIFF(year, pt.dob, CURDATE())as Age,
        count(t.`treatmentID`) 'Total_treatments'
from patient pt inner join person p on pt.`patientID` = p.`personID`
inner join  treatment t on t.`patientID` = pt.`patientID`
group by p.`personName`, TIMESTAMPDIFF(year, pt.dob, CURDATE())
having `Total_treatments`>1
order by `Total_treatments` desc;


-- select count(*) from patient;

select count(distinct patientid) from treatment;

/*

Problem Statement 2:  
Bharat is researching the impact of gender on different diseases, He wants to 
analyze if a certain disease is more likely to infect a certain gender or not.
Help Bharat analyze this by creating a report showing for every disease how many 
males and females underwent treatment for each in the year 2021. It would also be 
helpful for Bharat if the male-to-female ratio is also shown.

*/

select d.`diseaseName`,a.Male_count,b.Female_count, a.Male_count/b.Female_count as `male-to-female-ratio` from 
    (
        select t.`diseaseID`, count(t.`patientID`) 'Male_count'
        from person p inner join patient pt on p.`personID` = pt.`patientID`
        inner join treatment t on t.`patientID` = pt.`patientID`
        where p.gender = 'male' and year(t.date) = 2021
        group by t.`diseaseID` 
    ) a
inner join 
    (
        select t.`diseaseID`, count(t.`patientID`) 'Female_count'
        from person p inner join patient pt on p.`personID` = pt.`patientID`
        inner join treatment t on t.`patientID` = pt.`patientID`
        where p.gender = 'female' and year(t.date) = 2021
        group by t.`diseaseID` 
    ) b 
inner join disease d on d.`diseaseID` = b.`diseaseID`
on a.`diseaseID` = b.`diseaseID`;



-- order by t.`diseaseID`;
-- 29 157  -- 18  174 1 -- 173, 268

/*

Problem Statement 3:  
Kelly, from the Fortis Hospital management, has requested a report that shows 
for each disease, the top 3 cities that had the most number treatment for that 
disease.
Generate a report for Kelly’s requirement.
*/

with cte_treat_count as (
        select t.`diseaseID`, a.city, count(t.`treatmentID`) `Treatment_count`
        from address a inner join pharmacy p on a.`addressID`=p.`addressID`
        inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
        inner join treatment t on t.`treatmentID`  =pr.`treatmentID`
        group by t.`diseaseID`, a.city
        order by t.`diseaseID`
        
),
cte_rank as (
        select d.`diseaseName`,c.city,c.Treatment_count, dense_rank()over(partition by c.`diseaseID` order by c.Treatment_count desc)rnk_
        from cte_treat_count c inner join disease d on d.`diseaseID` = c.`diseaseID`
)
select * from cte_rank;
-- where rnk_<4;



with cte_treat_count as (
        select t.`diseaseID`, a.city, count(t.`treatmentID`) `Treatment_count`,
            dense_rank()over(partition by t.`diseaseID` order by count(t.`treatmentID`) desc)rnk_
        from address a inner join pharmacy p on a.`addressID`=p.`addressID`
        inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
        inner join treatment t on t.`treatmentID`  =pr.`treatmentID`
        group by t.`diseaseID`, a.city
        order by t.`diseaseID`
        
)
select * from cte_treat_count
-- order by `diseaseID`, city;
where rnk_<4;


/*

Problem Statement 4: 
Brooke is trying to figure out if patients with a particular disease are 
preferring some pharmacies over others or not, For this purpose, she has 
requested a detailed pharmacy report that shows each pharmacy name, and how 
many prescriptions they have prescribed for each disease in 2021 and 2022, 
She expects the number of prescriptions prescribed in 2021 and 2022 be 
displayed in two separate columns.
Write a query for Brooke’s requirement.

*/
select a.`pharmacyName`, a.`diseaseID`,a.2021_count, b.2022_count from 
    (
        select  p.`pharmacyName`, t.`diseaseID`, count(pr.`prescriptionID`)`2021_count`
        from pharmacy p  inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
        right join treatment t on t.`treatmentID` = pr.`treatmentID`
        where year(t.date)=2021
        group by p.`pharmacyName`, t.`diseaseID`
        --order by p.`pharmacyName`, t.`diseaseID`
    ) a
inner join 
    (
        select  p.`pharmacyName`, t.`diseaseID`, count(pr.`prescriptionID`) `2022_count`
        from pharmacy p  inner join prescription pr on pr.`pharmacyID` = p.`pharmacyID`
        right join treatment t on t.`treatmentID` = pr.`treatmentID`
        where year(t.date)=2022
        group by p.`pharmacyName`, t.`diseaseID`
        --order by p.`pharmacyName`, t.`diseaseID`
    ) b
on a.`pharmacyName`=b.`pharmacyName` and a.`diseaseID`=b.`diseaseID`
order by a.`pharmacyName`, a.`diseaseID`;



select ph.`pharmacyName`, d.`diseaseName`, sum(if(year(t.date)=2021,1,0)) '2021_count',
                                        sum(if(year(t.date)=2022,1,0)) '2022_count'
from pharmacy ph inner join prescription pr on ph.`pharmacyID`=pr.`pharmacyID`
inner join treatment t on t.`treatmentID`= pr.`treatmentID`
inner join disease d on d.`diseaseID` = t.`diseaseID`
where year(t.date) in (2021,2022)
group by ph.`pharmacyID`,d.`diseaseName`
order by ph.`pharmacyName`, d.`diseaseName`;

select ph.`pharmacyName`, d.`diseaseName`,  sum(case year(t.date)
                                                    when 2021 then 1
                                                    else 0
                                                end
                                                ) '2021_count',
                                            sum(case year(t.date)
                                                    when 2022 then 1
                                                    else 0
                                                end 
                                                ) '2022_count'
from pharmacy ph inner join prescription pr on ph.`pharmacyID`=pr.`pharmacyID`
inner join treatment t on t.`treatmentID`= pr.`treatmentID`
inner join disease d on d.`diseaseID` = t.`diseaseID`
where year(t.date) in (2021,2022)
group by ph.`pharmacyID`,d.`diseaseName`
order by ph.`pharmacyName`, d.`diseaseName`;


/*

Problem Statement 5:  
Walde, from Rock tower insurance, has sent a requirement for a report 
that presents which insurance company is targeting the patients of which 
state the most. Write a query for Walde that fulfills the requirement 
of Walde.
Note: We can assume that the insurance company is targeting a region 
more if the patients of that region are claiming more insurance of 
that company.

*/

select `companyName`, state, count from
(
        select  ic.`companyName`, a.state,  count(c.`claimID`) count, 
                DENSE_RANK()over(PARTITION BY ic.`companyName`order by count(c.`claimID`) desc)rnk
        from treatment t inner join patient pt on t.`patientID`=pt.`patientID`
        inner join  person p on p.`personID`=pt.`patientID`
        inner join address a on a.`addressID`=p.`addressID`
        inner join claim c on t.`claimID`= c.`claimID`
        inner join insuranceplan ip on ip.uin = c.uin
        inner join insurancecompany ic on ic.`companyID`=ip.`companyID`
        group by ic.`companyName`, a.state
)a
where rnk=1;

with cte_claim_count as(
    select  ic.`companyName`, a.state,  count(c.`claimID`) count, 
                DENSE_RANK()over(PARTITION BY ic.`companyName`order by count(c.`claimID`) desc)rnk
        from treatment t inner join patient pt on t.`patientID`=pt.`patientID`
        inner join  person p on p.`personID`=pt.`patientID`
        inner join address a on a.`addressID`=p.`addressID`
        inner join claim c on t.`claimID`= c.`claimID`
        inner join insuranceplan ip on ip.uin = c.uin
        inner join insurancecompany ic on ic.`companyID`=ip.`companyID`
        group by ic.`companyName`, a.state
)
select `companyName`, state, count from cte_claim_count
where rnk=1;