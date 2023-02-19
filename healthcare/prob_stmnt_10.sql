-- Active: 1673683090785@@127.0.0.1@3307@healthcaredb
/*
Problem Statement 1:
The healthcare department has requested a system to analyze the performance 
of insurance companies and their plan.For this purpose, create a stored 
procedure that returns the performance of different insurance plans of an 
insurance company. When passed the insurance company ID the procedure 
should generate and return all the insurance plan names the provided 
company issues, the number of treatments the plan was claimed for, and 
the name of the disease the plan was claimed for the most. The plans which 
are claimed more are expected to appear above the plans that are claimed 
less.

*/
select a.`planName`, a.`TotalClaims`,c.`diseaseName`
from
(
    select ip.`planName`, count(c.uin)'TotalClaims'
    from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
    inner join claim c on c.uin=ip.uin
    where ic.`companyID`=1839
    group by ip.`planName`
)a
inner join 
(
    select * from (
        select ip.`planName`, d.`diseaseName`, count(c.uin), 
                        dense_rank()over(partition by ip.`planName` order by count(c.uin) desc) rnk
        from insurancecompany ic inner join insuranceplan ip on ic.`companyID`=ip.`companyID`
        inner join claim c on c.uin=ip.uin
        inner join treatment t on t.`claimID`=c.`claimID`
        inner join disease d on d.`diseaseID`=t.`diseaseID`
        where ic.`companyID`=1839 --and ip.`planName`='M Care (Group)'
        group by ip.`planName`, d.`diseaseName`
    )b
    where rnk =1
)c
on a.`planName`=c.`planName`;


DELIMITER #
CREATE PROCEDURE `proc_get_plan_details`(p_compID int)
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
END #
DELIMITER ;

call proc_get_plan_details(1839);

/*
Problem Statement 2:
It was reported by some unverified sources that some pharmacies are more popular 
for certain diseases. The healthcare department wants to check the validity of 
this report. Create a stored procedure that takes a disease name as a parameter 
and would return the top 3 pharmacies the patients are preferring for the 
treatment of that disease in 2021 as well as for 2022. Check if there are common 
pharmacies in the top 3 list for a disease, in the years 2021 and the year 2022.
Call the stored procedure by passing the values “Asthma” and “Psoriasis” as 
disease names and draw a conclusion from the result.


*/
with cte_1 as (
        select d.`diseaseName`, ph.`pharmacyName`, 
                    sum(case year(t.`date`)
                        when 2021 then 1
                        else 0
                    end) as '2021',
                    sum(case year(t.`date`)
                        when 2022 then 1
                        else 0
                    end) as '2022'
                -- ,row_number()over(partition by d.`diseaseID` order by count(*) desc)row_
        from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
        inner join prescription pr on pr.`treatmentID`=t.`treatmentID`
        inner join pharmacy ph on ph.`pharmacyID`=pr.`pharmacyID`
        where year(t.`date`) in (2021, 2022)
        and pr.`pharmacyID` = 7759 
        --and d.`diseaseName`='Psoriasis'
        group by d.`diseaseName`, ph.`pharmacyName`
),
cte_2 as (
    select `diseaseName`, `pharmacyName`, `2021`,
        row_number()over(partition by `diseaseName` order by `2021` desc) row_2021, `2022`,
        row_number()over(partition by `diseaseName` order by `2022` desc) row_2022
    from cte_1
)

-- select * from cte_2 where (row_2022 <4 or row_2021<4);

select distinct `diseaseName`, case when row_2022<4 then `pharmacyName` end '2022', 
   case when row_2021<4 then `pharmacyName` end '2021'
from cte_2 c1 
where (row_2022 <4 or row_2021<4);

select distinct c1.`diseaseName`,  c1.`pharmacyName` '2022', 
   c2.`pharmacyName`  '2021'
from cte_2 c1 inner join cte_2 c2 on c1.`diseaseName`=c2.`diseaseName`
where (c1.row_2022 <4 and c2.row_2021<4) or (c2.row_2022 <4 and c1.row_2021<4);


select distinct c1.`diseaseName`, case when c1.row_2022<4 then c1.`pharmacyName` end '2022', 
   case when c2.row_2021<4 then c2.`pharmacyName` end '2021'
from cte_2 c1 inner join cte_2 c2 on c1.`diseaseName`=c2.`diseaseName`
where (c1.row_2022 <4 or c2.row_2021<4) and (c2.row_2022 <4 or c1.row_2021<4);


select `diseaseID`, `pharmacyID`, 
        sum(case `year` 
                when '2021' then count 
            end ) as '2021',  
        sum(case `year`
                when '2022' then count 
            end) as '2022' 
from (
        select d.`diseaseID`, pr.`pharmacyID`, year(t.`date`) 'year', count(*)count
                -- ,row_number()over(partition by d.`diseaseID` order by count(*) desc)row_
        from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
        inner join prescription pr on pr.`treatmentID`=t.`treatmentID`
        inner join pharmacy ph on ph.`pharmacyID`=pr.`pharmacyID`
        where year(t.`date`) in (2021, 2022)
        and pr.`pharmacyID` = 7759 and d.`diseaseID`=2
        group by d.`diseaseID`, pr.`pharmacyID`, `year`
        --order by d.`diseaseID`, count(*) desc);
)a
group by  `diseaseID`, `pharmacyID`;  



select d.`diseaseID`, pr.`pharmacyID`, year(t.`date`) 'year', count(*)count
                -- ,row_number()over(partition by d.`diseaseID` order by count(*) desc)row_
        from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
        inner join prescription pr on pr.`treatmentID`=t.`treatmentID`
        inner join pharmacy ph on ph.`pharmacyID`=pr.`pharmacyID`
        where year(t.`date`) in (2021, 2022)
        and pr.`pharmacyID` = 7759 and d.`diseaseID`=39
        group by d.`diseaseID`, pr.`pharmacyID`, `year`;


/*


*/


/*
Problem Statement 3:
Jacob, as a business strategist, wants to figure out if a state is appropriate 
for setting up an insurance company or not. Write a stored procedure that finds 
the num_patients, num_insurance_companies, and insurance_patient_ratio, the 
stored procedure should also find the avg_insurance_patient_ratio and if the 
insurance_patient_ratio of the given state is less than the 
avg_insurance_patient_ratio then it Recommendation section can have the value 
“Recommended” otherwise the value can be “Not Recommended”.

*/
with cte_count as (
        select a.state, count(pt.`patientID`)num_patients, count(ic.`companyID`)num_insurance_companies,
                count(ic.`companyID`)/count(pt.`patientID`) as insurance_patient_ratio
        from insurancecompany ic right join address a on a.`addressID`=ic.addressID
        left join person p on p.`addressID` = a.`addressID`
        inner join patient pt on pt.`patientID`=p.`personID`
        group by a.state
), 
cte_avg as (
        select avg(insurance_patient_ratio)avg_insurance_patient_ratio from cte_count
)
select state, num_patients, num_insurance_companies, insurance_patient_ratio,avg_insurance_patient_ratio,
            if(insurance_patient_ratio<avg_insurance_patient_ratio, 'Recommended', 'Not Recommended')
from cte_count join cte_avg;


/*
Problem Statement 4:
Currently, the data from every state is not in the database, The management
 has decided to add the data from other states and cities as well. It is 
 felt by the management that it would be helpful if the date and time were 
 to be stored whenever new city or state data is inserted.
The management has sent a requirement to create a PlacesAdded table if it 
doesn’t already exist, that has four attributes. placeID, placeName, 
placeType, and timeAdded.

*/
create table PlacesAdded (
    placeID int primary key AUTO_INCREMENT,
    placeName varchar(50) NOT NULL,
    placeType varchar(50) NOT NULL,
    timeAdded DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER #
CREATE DEFINER=`root`@`localhost` TRIGGER `address_AFTER_INSERT` AFTER INSERT ON `address` FOR EACH ROW BEGIN
	IF (NEW.city NOT IN (SELECT placeName FROM placesAdded WHERE placeType='city')) THEN
		INSERT INTO placesAdded(placeName, placeType) VALUES (NEW.city,'city');
	
    ELSEIF (NEW.state NOT IN (SELECT placeName FROM placesAdded WHERE placeType='state')) THEN
		INSERT INTO placesAdded(placeName, placeType) VALUES (NEW.state,'state');
	
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='**Error !! Record Insertion Failed in placesAdded Table**';
	END IF;
END #
 DELIMITER ;

insert into PlacesAdded  
values(102,'Mattanur', 'Kannur','Kerala',570702);

select * from PlacesAdded;

/*

Problem Statement 5:
Some pharmacies suspect there is some discrepancy in their inventory management. 
The quantity in the ‘Keep’ is updated regularly and there is no record of it. 
They have requested to create a system that keeps track of all the transactions 
whenever the quantity of the inventory is updated. You have been given the 
responsibility to create a system that automatically updates a Keep_Log table 
which has  the following fields:
id: It is a unique field that starts with 1 and increments by 1 for each new entry
medicineID: It is the medicineID of the medicine for which the quantity is updated.
quantity: The quantity of medicine which is to be added. If the quantity is reduced 
then the number can be negative.
For example:  If in Keep the old quantity was 700 and the new quantity to be updated 
is 1000, then in Keep_Log the quantity should be 300.
Example 2: If in Keep the old quantity was 700 and the new quantity to be updated is 
100, then in Keep_Log the quantity should be -600.


*/

create table Keep_Log(
    id int PRIMARY KEY AUTO_INCREMENT,
    medicineID int NOT NULL,
    quantity int NOT NULL
);

DELIMITER #
CREATE DEFINER=`root`@`localhost` TRIGGER `keep_AFTER_UPDATE` AFTER UPDATE ON `keep` FOR EACH ROW BEGIN
	DECLARE qty INT;
	SET qty= NEW.quantity - OLD.quantity;
	-- if (new.medicineID not in (select distinct medicineID from keep_log)) then 
		insert into keep_log(medicineID, quantity) values (new.medicineID, qty);
	-- else 
		-- update keep_log set quantity = qty where medicineID = new.medicineID;
	-- end if;
END #

DELIMITER ;

desc Keep;
select * from keep_log;

update keep
set quantity = 5949 where pharmacyID = 1008 and medicineID = 1111;