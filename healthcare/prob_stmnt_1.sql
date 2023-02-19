use healthcaredb;
/*
Problem Statement 1:  Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
Assist Jimmy in generating the report. 

*/
select case 
			when timestampdiff(year, p.dob, curdate())>=0 and timestampdiff(year, dob, curdate())<15 then 'Children(0-14)'
            when timestampdiff(year, p.dob, curdate())>=15 and timestampdiff(year, dob, curdate())<25 then 'Youth(15-24)'
            when timestampdiff(year, p.dob, curdate())>=25 and timestampdiff(year, dob, curdate())<65 then 'Adults(25-64)'
            else 'Seniors(>65 years)'
		end as `Age group`, count(t.treatmentid) 'Total Treatments'
 from patient p right join treatment t on p.patientid = t.patientid
 group by `Age group`;
 
 /*
Problem Statement 2:  Jimmy, from the healthcare department, wants to know which disease is infecting people of which gender more often.
Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.

 */

 with cte_1 as 
 (
 
	 select d.diseasename as disease, pr.gender, count(t.diseaseid) 'infected'
	 from treatment t inner join disease d on t.diseaseid = d.diseaseid
	 inner join patient p on p.patientid = t.patientid
	 inner join person pr on pr.personid = p.patientid
	 group by d.diseasename,pr.gender
	 order by diseasename
 ),
 cte_2 as 
 (
	  select disease,  infected 'infected_female', lead(infected)over(partition by disease) 'infected_male'
	  from cte_1
 )
 select *, infected_male/infected_female as male_female_ratio
 from cte_2
 where infected_male is not null
 order by male_female_ratio desc;
 
 /*
 Problem Statement 3: Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments.
 He also wants to figure out if the gender of the patient has any impact on the insurance claim. Assist Jacob in this situation 
 by generating a report that finds for each gender the number of treatments, number of claims, and treatment-to-claim ratio. 
 And notice if there is a significant difference between the treatment-to-claim ratio of male and female patients.
 */
 
with cte as (
	 select pr.gender, count(t.treatmentid) 'treatments', count(t.claimid) 'claims'
	 from treatment t left join claim c on t.claimid=c.claimid
     inner join patient p on p.patientid = t.patientid
	 inner join person pr on pr.personid = p.patientid
	 group by pr.gender
     )
select *, treatments/claims as 'treatment-to-claim ratio'
from cte;

/*
Problem Statement 4: The Healthcare department wants a report about the inventory of pharmacies. Generate a report 
on their behalf that shows how many units of medicine each pharmacy has in their inventory, the total maximum retail 
price of those medicines, and the total price of all the medicines after discount. 
Note: discount field in keep signifies the percentage of discount on the maximum price.

*/

 select p.pharmacyid, p.pharmacyname, sum(quantity) 'Total stock', sum(maxprice) 'Total maxprice', 
			round(sum(maxprice*(discount/100)),2) as 'Discounted Price'
 from pharmacy p inner join keep k on p.pharmacyid = k.pharmacyid
 inner join medicine m on m.medicineid = k.medicineid
 group by pharmacyid, pharmacyname;
 
 

/*
Problem Statement 5:  The healthcare department suspects that some pharmacies prescribe more medicines than others 
in a single prescription, for them, generate a report that finds for each pharmacy the maximum, minimum and average number 
of medicines prescribed in their prescriptions. 

*/
select pharmacyid, pharmacyname, min(quantity), max(quantity), avg(quantity)
from (
	select ps.pharmacyid, p.pharmacyname, c.prescriptionid, sum(c.quantity) as quantity
	from pharmacy p inner join prescription ps on p.pharmacyid = ps.pharmacyid
	inner join contain c on c.prescriptionid=ps.prescriptionid
	group by ps.pharmacyid, c.prescriptionid
	) a
group by pharmacyid, pharmacyname;




