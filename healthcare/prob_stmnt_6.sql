/*
Problem Statement 1: 
The healthcare department wants a pharmacy report on the percentage of 
hospital-exclusive medicine prescribed in the year 2022.
Assist the healthcare department to view for each pharmacy, the pharmacy 
id, pharmacy name, total quantity of medicine prescribed in 2022, total 
quantity of hospital-exclusive medicine prescribed by the pharmacy in 2022, 
and the percentage of hospital-exclusive medicine to the total medicine 
prescribed in 2022.
Order the result in descending order of the percentage found. 

*/


select ph.`pharmacyID`, ph.`pharmacyName`,sum(c.quantity) as 'Total_quantity',
        sum(if(m.`hospitalExclusive`='S',c.quantity,0)) as 'Hospital_exclusive',
        (sum(if(m.`hospitalExclusive`='S',c.quantity,0))/sum(c.quantity))*100 'Percentage'

from pharmacy ph inner join prescription pr on pr.`pharmacyID`=ph.`pharmacyID`
inner join treatment t on t.`treatmentID`=pr.`treatmentID`
inner join contain c on c.`prescriptionID`= pr.`prescriptionID`
inner join medicine m on m.`medicineID` = c.`medicineID`
where year(t.`date`)=2022
group by ph.`pharmacyID`, ph.`pharmacyName`
order by Percentage desc;


/*
Problem Statement 2:  
Sarah, from the healthcare department, has noticed many people do not claim
 insurance for their treatment. She has requested a state-wise report of 
 the percentage of treatments that took place without claiming insurance. 
 Assist Sarah by creating a report as per her requirement.

*/
-- AK AL - 150, 280

select  a.state, sum(if(t.`claimID` is NULL,1,0)) 'Not_claimed', count(*) 'Total_treatments',
                (sum(if(t.`claimID` is NULL,1,0))/count(*))*100 `Not_claimed_percentage`
from treatment t inner join patient pt on t.`patientID`=pt.`patientID`
inner join person p on p.`personID`=pt.`patientID`
inner join address a on a.`addressID`=p.`addressID`
-- where t.`claimID` is null and 
-- a.state = 'CA'
group by a.state
order by a.state;
--order by `Not_claimed_percentage` desc;


select * from treatment where `claimID` is null; 


/*
Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some diseases 
are spreading in a particular region. Assist Sarah by creating a report which 
shows for each state, the number of the most and least treated diseases by the 
patients of that state in the year 2022. 

*/

select state, `diseaseName`, cnt as count from 
(
    select a.state, d.`diseaseName`, count(*)cnt,
                        dense_rank()over(partition by a.state order by count(*) desc) max_rnk,
                        dense_rank()over(partition by a.state order by count(*)) min_rnk
    from disease d inner join treatment t on d.`diseaseID` = t.`diseaseID`
    inner join patient pt on pt.`patientID`=t.`patientID`
    inner join person p on p.`personID`=pt.`patientID`
    inner join address a on a.`addressID` = p.`addressID`
    where year(t.`date`)=2022 
    -- and a.state = 'AK'
    group by a.state, d.`diseaseName`
    -- having max_rnk=1 or min_rnk=1
    order by a.state
)a 
where max_rnk=1 or min_rnk=1;

with cte_max_treated as (
    select a.state, d.`diseaseName`, count(*)cnt,
                    dense_rank()over(partition by a.state order by count(*) desc) max_rnk 
    from disease d inner join treatment t on d.`diseaseID` = t.`diseaseID`
    inner join patient pt on pt.`patientID`=t.`patientID`
    inner join person p on p.`personID`=pt.`patientID`
    inner join address a on a.`addressID` = p.`addressID`
    where year(t.`date`)=2022 
    -- and a.state = 'AK'
    group by a.state, d.`diseaseName`
    order by a.state
),
cte_min_treated as (
    select *, dense_rank()over(partition by state order by cnt) min_rnk
    from cte_max_treated
)
select * from cte_min_treated
where max_rnk=1 or min_rnk=1;


/*


Problem Statement 4: 
Manish, from the healthcare department, wants to know how many registered 
people are registered as patients as well, in each city. Generate a report 
that shows each city that has 10 or more registered people belonging to it 
and the number of patients from that city as well as the percentage of the 
patient with respect to the registered people.

*/

select a.city, count(p.`personID`)'Total_Registered_People', 
        count(pt.`patientID`) 'Total_Registered_Patients',
        (count(pt.`patientID`)/count(p.`personID`))*100 'Percentage'
from address a left join person p on a.`addressID`=p.`addressID`
left join patient pt on pt.`patientID`=p.`personID`
group by a.city
having count(p.`personID`)>=10;

-- select count(`personID`) from address left join person using (`addressID`)
-- group by city
-- having count(`personID`)>=10;

/*
Problem Statement 5:  
It is suspected by healthcare research department that the substance 
“ranitidine” might be causing some side effects. Find the top 3 companies 
using the substance in their medicine so that they can be informed about it.

*/
select * from (
    select m.`companyName`, count(*), 
        DENSE_RANK()over(order by count(*) desc)rnk
    from medicine m  
    where m.`substanceName` like '%ranitidina%'
    group by m.`companyName`
    order by count(*) desc
)a 
where rnk<4;