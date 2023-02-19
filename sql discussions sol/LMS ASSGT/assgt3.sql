-- Active: 1670401223911@@127.0.0.1@3307@lms_assignments
-- DB lms_assignments
--- 1. DDL Table Creation Exercise
-- Patient
CREATE Table Patient(
    PID INTEGER(7) NOT NULL,
    P_Name VARCHAR(30) NOT NULL
);

-- add primary key 
ALTER Table patient
ADD CONSTRAINT pk_patient
PRIMARY KEY(PID);

-- Treatment
CREATE TABLE Treatment(
    TID INTEGER(7) NOT NULL,
    T_Name VARCHAR(30) NOT NULL
);

-- add primary key 
ALTER TABLE Treatment
ADD CONSTRAINT pk_treatment
PRIMARY KEY(TID); 

-- Patient_Treatment
CREATE TABLE Patient_Treatment(
    PID_PT INTEGER(7) NOT NULL,
    TID_PT INTEGER(7) NOT NULL,
    Date  DATETIME NOT NULL
);

-- add primary key 
ALTER TABLE Patient_Treatment
ADD CONSTRAINT pk_patient_treatment
PRIMARY KEY(PID_PT,TID_PT);

-- add foreign key 
ALTER TABLE Patient_Treatment
ADD CONSTRAINT fk_patient_treatment_patient
Foreign Key (PID_PT) REFERENCES patient(PID);

ALTER TABLE Patient_Treatment 
ADD CONSTRAINT fk_patient_treatment_treatment 
Foreign Key (TID_PT) REFERENCES treatment(TID); 

DESCRIBE patient_treatment;

--- 2. DDL Alter & Drop Exercise

--In the Patient table, change the maximum length for Patient’s names to be 35 characters long
ALTER TABLE patient
MODIFY COLUMN p_name VARCHAR(35);

desc patient;

/*
In the Patient_Treatment table, add a column called “Dosage” where the amount of the 
treatment given will be stored. This column is a fixed numerical value with a maximum 
of 99. This column cannot be null and the default value should be “0”. 
*/

ALTER TABLE patient_treatment
ADD COLUMN dosage TINYINT NOT NULL DEFAULT 0;

-- add check constraint to set max value limit as 99
ALTER TABLE patient_treatment
ADD CONSTRAINT ck_dosage
CHECK( dosage<=99);

-- In the Treatment table, change the column name “T_Name” to be “Treatment_Name”.
ALTER TABLE treatment
RENAME COLUMN `T_Name` TO `Treatment_Name`;

desc treatment;

-- Remove the Treatment table from the database
DROP TABLE IF EXISTS treatment;

/*
Remove the foreign key constraints from PID_PT and TID_PT columns in the 
Patient_Treatment table
*/
ALTER TABLE patient_treatment
DROP CONSTRAINT fk_patient_treatment_patient;

ALTER TABLE patient_treatment
DROP CONSTRAINT fk_patient_treatment_treatment;

-------------------------------**END**---
--------------------------------

