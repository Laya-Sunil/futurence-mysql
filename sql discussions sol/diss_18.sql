-- Active: 1670401223911@@127.0.0.1@3307@db_ddl
-- 1

CREATE TABLE countries
(
    country_id int NOT NULL,
    country_name varchar(30) not null,
    region_id int
    
);

ALTER Table countries
ADD CONSTRAINT uq_country_region
UNIQUE(country_id, region_id);

ALTER TABLE countries
ADD CONSTRAINT pk_countries
PRIMARY KEY(country_id);

desc countries;

SHOW CREATE TABLE countries;
SHOW indexes FROM countries;

-- DROP INDEX PRIMARY on countries;

CREATE TABLE jobs
(
    job_id int NOT NULL,
    job_title varchar(30) NOT NULL DEFAULT '',
    min_salary decimal DEFAULT 8000,
    max_salary decimal 
);

ALTER TABLE jobs
ADD CONSTRAINT pk_jobs
PRIMARY KEY(job_id);

ALTER TABLE jobs
ALTER COLUMN max_salary
SET DEFAULT  NULL;



CREATE TABLE job_history
(
    employee_id decimal(6,2) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    job_id decimal(6,2),
    department_id decimal(6,2)
);


CREATE TABLE employees
(
    employee_id decimal(6,2) NOT NULL,
    first_name varchar(30) NOT NULL,
    last_name varchar(30),
    email varchar(30) NOT NULL,
    phone_number varchar(20) DEFAULT NULL,
    hire_date date NOT NULL,
    job_id int NOT NULL,
    salary decimal(8,2) DEFAULT NULL,
    commission decimal(2,2) DEFAULT NULL,
    manager_id DECIMAL(6,2) DEFAULT NULL,
    department_id decimal(6,2) DEFAULT NULL
);

ALTER TABLE employees
ADD CONSTRAINT pk_employees
PRIMARY KEY(employee_id);

CREATE TABLE departments
(
    department_id decimal(6,2) DEFAULT 0,
    department_name varchar(30) NOT NULL,
    manager_id decimal(6,2) DEFAULT 0,
    location_id decimal(6,2)
);

ALTER TABLE departments
ADD CONSTRAINT pk_departments
PRIMARY KEY(department_id, manager_id);

ALTER Table employees
ADD CONSTRAINT fk_department_employees
Foreign Key (department_id,manager_id) 
REFERENCES departments(department_id,manager_id);


DESCRIBE departments;

drop table departments;

------------------------------------------------
CREATE TABLE employees_1(
    employee_id decimal(4,0) NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20),
    email varchar(20) NOT NULL,
    phone_number int(15) DEFAULT NULL,
    hire__date date NOT NULL,
    job_id varchar(10) NOT NULL,
    salary decimal(10,3) DEFAULT NULL,
    commission decimal(2,2) DEFAULT NULL,
    manager_id decimal(6,0) DEFAULT NULL,
    department_id decimal(4,0) DEFAULT NULL
);

ALTER TABLE employees_1 ADD CONSTRAINT PK_employees_1 PRIMARY KEY(employee_id);

ALTER TABLE employees_1
    ADD CONSTRAINT  FK_departments_employees_1   
        FOREIGN KEY
            (department_id)
                REFERENCES 
                    departments(department_id);

ALTER TABLE employees_1
    ADD CONSTRAINT  FK_jobs_employees_1   
        FOREIGN KEY
            (job_id)
                REFERENCES 
                    jobs(job_id);

SHOW INDEXES FROM employees_1;


--- 6

CREATE TABLE employees_casc
(
    employee_id decimal(6,2) NOT NULL,
    first_name varchar(30) NOT NULL,
    last_name varchar(30),
    email varchar(30) NOT NULL,
    phone_number varchar(20) DEFAULT NULL,
    hire_date date NOT NULL,
    job_id int NOT NULL,
    salary decimal(8,2) DEFAULT NULL,
    commission decimal(2,2) DEFAULT NULL,
    manager_id DECIMAL(6,2) DEFAULT NULL,
    department_id decimal(6,2) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS jobs (
    JOB_ID integer NOT NULL UNIQUE PRIMARY KEY,
    JOB_TITLE varchar(35) NOT NULL DEFAULT ' ',
    MIN_SALARY decimal(6, 0) DEFAULT 8000,
    MAX_SALARY decimal(6, 0) DEFAULT NULL
) ENGINE = InnoDB;

ALTER TABLE employees_casc
ADD CONSTRAINT fk_jobs_employees_casc
Foreign Key (job_id) REFERENCES jobs(job_id)
ON delete CASCADE on update RESTRICT;

DROP TABLE employees_casc;

--- 7
CREATE TABLE employees_casc
(
    employee_id decimal(6,2) NOT NULL,
    first_name varchar(30) NOT NULL,
    last_name varchar(30),
    email varchar(30) NOT NULL,
    phone_number varchar(20) DEFAULT NULL,
    hire_date date NOT NULL,
    job_id int ,
    salary decimal(8,2) DEFAULT NULL,
    commission decimal(2,2) DEFAULT NULL,
    manager_id DECIMAL(6,2) DEFAULT NULL,
    department_id decimal(6,2) DEFAULT NULL
);



ALTER TABLE employees_casc
ADD CONSTRAINT fk_jobs_employees_casc
Foreign Key (job_id) REFERENCES jobs(job_id)
ON delete SET NULL on update set NULL;

desc jobs;

-- 8 on update no action on delete no action
CREATE TABLE employees_casc
(
    employee_id decimal(6,2) NOT NULL,
    first_name varchar(30) NOT NULL,
    last_name varchar(30),
    email varchar(30) NOT NULL,
    phone_number varchar(20) DEFAULT NULL,
    hire_date date NOT NULL,
    job_id int NOT NULL,
    salary decimal(8,2) DEFAULT NULL,
    commission decimal(2,2) DEFAULT NULL,
    manager_id DECIMAL(6,2) DEFAULT NULL,
    department_id decimal(6,2) DEFAULT NULL
);

ALTER TABLE employees_casc
ADD CONSTRAINT fk_jobs_employees_casc
Foreign Key (job_id) REFERENCES jobs(job_id)
ON delete no action on update no action;

-------------------------------------testing---------------------------------------------
create table dummy1 (id int, name VARCHAR(10), dummy2_ int );

create table dummy2 (id int, name VARCHAR(10));

ALTER table dummy2
add constraint pk_dummy2
PRIMARY KEY(id);

alter Table dummy1
add constraint fk_dummy2_dummy1
Foreign Key (dummy2_) REFERENCES dummy2(id);