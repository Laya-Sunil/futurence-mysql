
-- 1
ALTER TABLE claim ADD CONSTRAINT `FK_Insurance_Claim` 
FOREIGN KEY (uin) REFERENCES insuranceplan (uin);
-- 2
ALTER TABLE insuranceplan ADD CONSTRAINT `FK_InsCompany_InsPlan` 
FOREIGN KEY (companyId) REFERENCES insurancecompany (companyId);
-- 3
ALTER TABLE treatment ADD CONSTRAINT `FK_patient_treatment` 
FOREIGN KEY (patientId) REFERENCES patient (patientId);
--  4
ALTER TABLE treatment ADD CONSTRAINT `FK_disease_treatment` 
FOREIGN KEY (diseaseId) REFERENCES disease (diseaseId);
-- 5
ALTER TABLE treatment ADD CONSTRAINT `FK_claim_treatment` 
FOREIGN KEY (claimId) REFERENCES claim (claimId);
-- 6
ALTER TABLE patient ADD CONSTRAINT `FK_person_patient` 
FOREIGN KEY (patientId) REFERENCES person (personId);
-- 7
ALTER TABLE person ADD CONSTRAINT `FK_address_person` 
FOREIGN KEY (addressId) REFERENCES address (addressId);
-- 8
ALTER TABLE prescription ADD CONSTRAINT `FK_pharmacy_prescription` 
FOREIGN KEY (pharmacyId) REFERENCES pharmacy (pharmacyId);
-- 9
ALTER TABLE prescription ADD CONSTRAINT `FK_treatment_prescription` 
FOREIGN KEY (treatmentId) REFERENCES treatment (treatmentId);
-- 10
ALTER TABLE contain ADD CONSTRAINT `FK_prescription_contain` 
FOREIGN KEY (prescriptionId) REFERENCES prescription (prescriptionId);
-- 11
ALTER TABLE contain ADD CONSTRAINT `FK_medicine_contain` 
FOREIGN KEY (medicineId) REFERENCES medicine (medicineId);
-- 12
ALTER TABLE pharmacy ADD CONSTRAINT `FK_address_pharmacy` 
FOREIGN KEY (addressId) REFERENCES address (addressId);
-- 13
ALTER TABLE keep ADD CONSTRAINT `FK_medicine_keep` 
FOREIGN KEY (medicineId) REFERENCES medicine (medicineId);
-- 14
ALTER TABLE keep ADD CONSTRAINT `FK_pharmacy_keep` 
FOREIGN KEY (pharmacyId) REFERENCES pharmacy (pharmacyId);
-- 15
ALTER TABLE insurancecompany ADD CONSTRAINT `FK_address_InsCompany` 
FOREIGN KEY (addressId) REFERENCES address (addressId);