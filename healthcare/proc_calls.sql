use healthcaredb;
call proc_disease_claim_status(11);

call proc_gender_report(15);

call proc_get_plan_details(1839);
call proc_top_pharmacy("Alzheimer's disease");
select companyid from insurancecompany;

select diseaseName from disease where diseaseID=1;

call proc_recommend_ins();


desc placesAdded;

INSERT INTO address VALUES(102,'Mattanur', 'Kannur','Kerala',570702);

select * from placesAdded;


select * from medicine;
-- 1
call proc_find_pharmacy('OSTENAN', 'MARJAN INDUSTRIA E COMERCIO LTDA');
-- 2
select pharmacyID, pharmacyName, func_avg_cost_per_prescription(pharmacyID, 2021) as AvgCost
from pharmacy;

-- 3
select state, func_find_disease(state, 2021)
from address;
-- 4
SELECT 'Edmond' as city, "Alzheimer's disease" disease, func_city_disease_count('Edmond',"Alzheimer's disease",2021) as count;
-- 5
select `companyID`, `companyName`, func_avgBal_insCompany(`companyName`) as Average_Balance
from insurancecompany;