/*

Problem Statement 1: 
“HealthDirect” pharmacy finds it difficult to deal with the product type of medicine 
being displayed in numerical form, they want the product type in words. Also, they want
 to filter the medicines based on tax criteria. 
Display only the medicines of product categories 1, 2, and 3 for medicines that 
come under tax category I and medicines of product categories 4, 5, and 6 for 
medicines that come under tax category II. Write a SQL query to solve this problem.

*/

select m.`medicineID`, m.`companyName`, m.description, m.`taxCriteria`,
            case m.`productType`
                when 1 then 'Generic'
                when 2 then 'Patent'
                when 3 then 'Reference'                        
                when 4 then 'similar'
                when 5 then 'New'
                when 6 then 'Specific'
            end as  'Product Type'
from pharmacy p inner join keep k on p.`pharmacyID`=k.`pharmacyID`
inner join medicine m on m.`medicineID` = k.`medicineID`
where p.`pharmacyName` = 'HealthDirect'
and ((m.`productType` in (4,5,6) and m.`taxCriteria`='II')OR
(m.`productType`in (1,2,3) and m.`taxCriteria`='I')) ;


-- OR

/*
Problem Statement 2:  
'Ally Scripts' pharmacy company wants to find out the quantity of medicine 
prescribed in each of its prescriptions. Write a query that finds the sum of 
the quantity of all the medicines in a prescription and if the total quantity 
of medicine is less than 20 tag it as “low quantity”. If the quantity of 
medicine is from 20 to 49 (both numbers including) tag it as “medium quantity“
 and if the quantity is more than equal to 50 then tag it as “high quantity”.
Show the prescription Id, the Total Quantity of all the medicines in that 
prescription, and the Quantity tag for all the prescriptions issued by 
'Ally Scripts'. 3 rows from the resultant table may be as follows:
prescriptionID	totalQuantity	Tag
1147561399		43			Medium Quantity
1222719376		71			High Quantity
1408276190		48			Medium Quantity

*/

select pr.`prescriptionID`, sum(c.quantity), 
                        case 
                            when sum(c.quantity)<20 then 'low quantity'
                            when sum(quantity)>=20 and sum(c.quantity)<50 then 'medium quantity'
                            when sum(c.quantity)>=50 then 'high quantity'
                        end as 'Tag'
from pharmacy p inner join prescription pr on p.`pharmacyID` = pr.`pharmacyID`
inner join contain c on c.`prescriptionID`=pr.`prescriptionID`
where p.`pharmacyName` = 'Ally Scripts'
group by pr.`prescriptionID`;

/*

Problem Statement 3: 
In the Inventory of a pharmacy 'Spot Rx' the quantity of medicine is considered 
‘HIGH QUANTITY’ when the quantity exceeds 7500 and ‘LOW QUANTITY’ when the 
quantity falls short of 1000. The discount is considered “HIGH” if the discount 
rate on a product is 30% or higher, and the discount is considered “NONE” when 
the discount rate on a product is 0%.'Spot Rx' needs to find all the Low quantity 
products with high discounts and all the high-quantity products with no discount 
so they can adjust the discount rate according to the demand. 
Write a query for the pharmacy listing all the necessary details relevant to 
the given requirement.

Hint: Inventory is reflected in the Keep table.

*/

select  k.`medicineID`, k.quantity,
            case 
                when k.quantity>7500 then 'HIGH QUANTITY'
                when k.quantity<1000 then 'LOW QUANTITY'
            end as 'Quantity Status',
            case 
                when k.discount>=30 then  'higher'
                when k.discount=0 then 'NONE'
            end as 'discount status'
from pharmacy p inner join keep k on k.`pharmacyID` = p.`pharmacyID`
where p.`pharmacyName` = 'Spot Rx'
and (
    (k.quantity>7500 and k.discount=0) or (k.quantity<1000 and k.discount>=30)
); 

/*
Problem Statement 4: 
Mack, From HealthDirect Pharmacy, wants to get a list of all the affordable and 
costly, hospital-exclusive medicines in the database. Where affordable medicines 
are the medicines that have a maximum price of less than 50% of the avg maximum 
price of all the medicines in the database, and costly medicines are the medicines 
that have a maximum price of more than double the avg maximum price of all the 
medicines in the database.  Mack wants clear text next to each medicine name to 
be displayed that identifies the medicine as affordable or costly. The medicines 
that do not fall under either of the two categories need not be displayed.
Write a SQL query for Mack for this requirement.

*/

select * from  (
select m.`productName`,
        case
            when m.`maxPrice`<0.5*(select avg(`maxPrice`) from medicine) then 'Affordable'
            when m.`maxPrice`>2*(select avg(`maxPrice`) from medicine) then 'Costly'
        end as Tag
from medicine m inner join keep k on m.`medicineID`=k.`medicineID`
inner join pharmacy p on p.`pharmacyID` = k.`pharmacyID`
where m.`hospitalExclusive`='S'
and p.`pharmacyName` = 'HealthDirect')a 
where a.Tag is not null;


/*

Problem Statement 5:  
The healthcare department wants to categorize the patients into the following 
category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.

Write a SQL query to list all the patient name, gender, dob, and their category.

*/

select p.`personName`, p.gender, pt.dob, 
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
from person p inner join patient pt on p.`personID`=pt.`patientID`;


