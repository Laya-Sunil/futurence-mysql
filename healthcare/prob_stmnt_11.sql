/*
Problem Statement 1:
Patients are complaining that it is often difficult to find some medicines. 
They move from pharmacy to pharmacy to get the required medicine. A system is 
required that finds the pharmacies and their contact number that have the 
required medicine in their inventory. So that the patients can contact the 
pharmacy and order the required medicine.
Create a stored procedure that can fix the issue.
*/

select p.`pharmacyName`, p.phone
from medicine m inner join keep k on k.`medicineID`=m.`medicineID`
inner join pharmacy p on p.`pharmacyID`=k.`pharmacyID`
where m.`productName` = 'OSTENAN' and m.`companyName` = ''
and k.quantity <> 0;

DELIMITER #
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_find_pharmacy`(p_medicine_name varchar(40), p_company_name varchar(50))
BEGIN
	select p.`pharmacyName`, p.phone
	from medicine m inner join keep k on k.`medicineID`=m.`medicineID`
	inner join pharmacy p on p.`pharmacyID`=k.`pharmacyID`
	where m.`productName` = p_medicine_name and m.`companyName` = p_company_name
	and k.quantity <> 0;
END #
DELIMITER ;


call proc_find_pharmacy('OSTENAN', 'MARJAN INDUSTRIA E COMERCIO LTDA');


/*

Problem Statement 2:
The pharmacies are trying to estimate the average cost of all the prescribed 
medicines per prescription, for all the prescriptions they have prescribed in a 
particular year. Create a stored function that will return the required value 
when the pharmacyID and year are passed to it. Test the function with multiple 
values.

*/

select p.`pharmacyID`, avg(m.`maxPrice`)
from pharmacy p inner join prescription pr on p.`pharmacyID` = pr.`pharmacyID`
inner join contain c on c.`prescriptionID`=pr.`prescriptionID`
inner join medicine m on m.`medicineID`=c.`medicineID`
inner join treatment t on t.`treatmentID` = pr.`treatmentID`
where year(t.`date`)=2022
group by p.`pharmacyID`;

DELIMITER #

CREATE DEFINER=`root`@`localhost` FUNCTION `func_avg_cost_per_prescription`(p_pharmacyID int, p_year int) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
	declare avgCost decimal(10,2);
	select avg(m.`maxPrice`) into avgCost
	from pharmacy p inner join prescription pr on p.`pharmacyID` = pr.`pharmacyID`
	inner join contain c on c.`prescriptionID`=pr.`prescriptionID`
	inner join medicine m on m.`medicineID`=c.`medicineID`
	inner join treatment t on t.`treatmentID` = pr.`treatmentID`
	where year(t.`date`)=p_year and p.`pharmacyID` =p_pharmacyID
	group by p.`pharmacyID`;
	
    RETURN avgCost;
END #

DELIMITER ;


select pharmacyID, pharmacyName, 
        func_avg_cost_per_prescription(pharmacyID, 2021) as AvgCost
from pharmacy;


/*
Problem Statement 3:
The healthcare department has requested an application that finds out the 
disease that was spread the most in a state for a given year. So that they 
can use the information to compare the historical data and gain some insight.
Create a stored function that returns the name of the disease for which the 
patients from a particular state had the most number of treatments for a 
particular year. Provided the name of the state and year is passed to the 
stored function.

*/
select `diseaseName`  -- into diseasename
    from (
			select d.`diseaseName`, count(t.`treatmentID`), row_number()over(order by count(t.`treatmentID`) desc)rnk_
			from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
			inner join patient pt on pt.`patientID`=t.`patientID`
			inner join person p on p.`personID`=pt.`patientID`
			inner join address a on a.`addressID`=p.`addressID`
			where year(t.date)=2022 and a.state='Kerala'
			group by d.`diseaseName`
		)a
	where rnk_=1;

DELIMITER #
CREATE DEFINER=`root`@`localhost` FUNCTION `func_find_disease`(p_state varchar(10), p_year int) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	declare diseasename varchar(50);
	select a.`diseaseName`  into diseasename
    from (
			select d.`diseaseName`, count(t.`treatmentID`), 
                    row_number()over(order by count(t.`treatmentID`) desc)rnk_
			from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
			inner join patient pt on pt.`patientID`=t.`patientID`
			inner join person p on p.`personID`=pt.`patientID`
			inner join address a on a.`addressID`=p.`addressID`
			where year(t.date)=p_year and a.state=p_state
			group by d.`diseaseName`
		)a
	where rnk_=1;
	RETURN diseasename;
    
END #

DELIMITER ;


select state, func_find_disease(state, 2021)
from address;

/*
Problem Statement 4:
The representative of the pharma union, Aubrey, has requested a system that 
she can use to find how many people in a specific city have been treated for 
a specific disease in a specific year.
Create a stored function for this purpose.


*/

select a.city, d.`diseaseName`, count(t.`treatmentID`)
from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
inner join patient pt on pt.`patientID`=t.`patientID`
inner join person p on p.`personID`=pt.`patientID`
inner join address a on a.`addressID`=p.`addressID`
where year(t.date)= 2022
group by a.city, d.`diseaseName`;


DELIMITER #

CREATE DEFINER=`root`@`localhost` FUNCTION `func_city_disease_count`(p_city varchar(10), p_disease varchar(50), p_year int) RETURNS int
    DETERMINISTIC
BEGIN
	declare dis_count int;
    
	select count(t.`treatmentID`) into dis_count
	from disease d inner join treatment t on d.`diseaseID`=t.`diseaseID`
	inner join patient pt on pt.`patientID`=t.`patientID`
	inner join person p on p.`personID`=pt.`patientID`
	inner join address a on a.`addressID`=p.`addressID`
	where year(t.date)= p_year 
    and a.city=p_city and d.`diseaseName`=p_disease
	group by a.city, d.`diseaseName`;

	RETURN dis_count;
END #

DELIMITER ;

SELECT 'Edmond' as city, "Alzheimer's disease" disease, func_city_disease_count('Edmond',"Alzheimer's disease",2021) as count;


/*

Problem Statement 5:
The representative of the pharma union, Aubrey, is trying to audit different 
aspects of the pharmacies. She has requested a system that can be used to 
find the average balance for claims submitted by a specific insurance company 
in the year 2022. 
Create a stored function that can be used in the requested application. 

*/

select avg(c.balance)
from treatment t inner join claim c on c.`claimID`=t.`claimID`
inner join insuranceplan ip on c.uin=ip.uin
inner join insurancecompany ic on ic.`companyID`=ip.`companyID`
where year(t.date)=2022 and ic.`companyName`='Star Health and Allied Insurrance Co. Ltd.'
group by ic.`companyID`;

DELIMITER #

CREATE DEFINER=`root`@`localhost` FUNCTION `func_avgBal_insCompany`(p_comp varchar(100)) RETURNS decimal(20,4)
    DETERMINISTIC
BEGIN
	declare avgBal decimal(20,4);
	select avg(c.balance) into avgBal
	from treatment t inner join claim c on c.`claimID`=t.`claimID`
	inner join insuranceplan ip on c.uin=ip.uin
	inner join insurancecompany ic on ic.`companyID`=ip.`companyID`
	where year(t.date)=2022 and ic.`companyName`=p_comp
	group by ic.`companyID`;
    
    return avgBal;

END #

DELIMITER ;

select `companyID`, `companyName`, func_avgBal_insCompany(`companyName`) as Average_Balance
from insurancecompany;