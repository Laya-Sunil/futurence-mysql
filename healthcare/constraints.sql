-- 1

alter table patient
add constraint fk_patient_person
foreign key(patientid) references person(personid);

-- 2

alter table person
add constraint fk_person_address
foreign key(addressid) references address(addressid);

-- 3

alter table insurancecompany
add constraint fk_insurancecompany_address
foreign key(addressid) references address(addressid);

-- 4

alter table insuranceplan
add constraint fk_insuranceplan_insurancecompany
foreign key(companyid) references insurancecompany(companyid);

-- 5
alter table pharmacy 
add constraint fk_pharmacy_address
foreign key(addressid) references address(addressid);

-- 6

alter table claim
add constraint fk_claim_insuranceplan
foreign key(uin) references insuranceplan(uin);




select count(*) from insuranceplan;


