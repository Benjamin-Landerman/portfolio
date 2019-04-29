-- Hospital Database Creation

SET ANSI_WARNINGS ON;
GO

use master;
GO

-- drop existing database
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'bdl16')
DROP DATABASE bdl16;
GO

-- create database
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'bdl16')
CREATE DATABASE bdl16;
GO

use bdl16;
GO

-- table dbo.patient
IF OBJECT_ID (N'dbo.patient', N'U') IS NOT NULL
DROP TABLE dbo.patient;
GO

CREATE TABLE dbo.patient
(
    pat_id SMALLINT not null identity(1,1),
    pat_ssn int NOT NULL check (pat_ssn > 0 and pat_ssn <= 999999999),
    pat_fname VARCHAR(15) NOT NULL,
    pat_lname VARCHAR(30) NOT NULL,
    pat_street VARCHAR(30) NOT NULL,
    pat_city VARCHAR(30) NOT NULL,
    pat_state CHAR(2) NOT NULL DEFAULT 'FL',
    pat_zip int NOT NULL check (pat_zip > 0 and pat_zip <= 999999999),
    pat_phone bigint NOT NULL check (pat_phone > 0 and pat_phone <= 9999999999),
    pat_email VARCHAR(100) NULL,
    pat_dob DATE NOT NULL,
    pat_gender CHAR(1) NOT NULL CHECK (pat_gender IN('m','f')),
    pat_notes VARCHAR(45) NULL,
    PRIMARY KEY (pat_id),

    CONSTRAINT ux_pat_ssn unique nonclustered (pat_ssn ASC)
);

-- table dbo.medication
IF OBJECT_ID (N'dbo.medication', N'U') IS NOT NULL
DROP TABLE dbo.medication;
GO

CREATE TABLE dbo.medication
(
    med_id SMALLINT NOT NULL identity(1,1),
    med_name VARCHAR(100) NOT NULL,
    med_price DECIMAL(5,2) NOT NULL CHECK (med_price > 0),
    med_shelf_life DATE NOT NULL,
    med_notes VARCHAR(255) NULL,
    PRIMARY KEY (med_id)
);

-- table dbo.prescription
IF OBJECT_ID (N'dbo.prescription', N'U') IS NOT NULL
DROP TABLE dbo.prescription;
GO

CREATE TABLE dbo.prescription
(
    pre_id SMALLINT NOT NULL identity(1,1),
    pat_id SMALLINT NOT NULL,
    med_id SMALLINT NOT NULL,
    pre_date DATE NOT NULL,
    pre_dosage VARCHAR(255) NOT NULL,
    pre_num_refills VARCHAR(3) NOT NULL,
    pre_notes VARCHAR(255) NULL,
    PRIMARY KEY (pre_id),

    -- combo of pat_id, med_id, pre_date unique
    CONSTRAINT ux_pat_id_med_id_pre_date unique nonclustered (pat_id ASC, med_id ASC, pre_date ASC),

    CONSTRAINT fk_prescription_patient
    FOREIGN KEY (pat_id)
    REFERENCES dbo.patient (pat_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

    CONSTRAINT fk_prescription_medication
    FOREIGN KEY (med_id)
    REFERENCES dbo.medication (med_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

-- table dbo.treatment
IF OBJECT_ID (N'dbo.treatment', N'U') IS NOT NULL
DROP TABLE dbo.treatment;
GO

CREATE TABLE dbo.treatment
(
    trt_id SMALLINT NOT NULL identity(1,1),
    trt_name VARCHAR(255) NOT NULL,
    trt_price DECIMAL(8,2) NOT NULL CHECK (trt_price > 0),
    trt_notes VARCHAR(255) NULL,
    PRIMARY KEY (trt_id)
);

-- table dbo.physician
IF OBJECT_ID (N'dbo.physician', N'U') IS NOT NULL
DROP TABLE dbo.physician;
GO

CREATE TABLE dbo.physician
(
    phy_id SMALLINT NOT NULL identity(1,1),
    phy_specialty VARCHAR(25) NOT NULL,
    phy_fname VARCHAR(15) NOT NULL,
    phy_lname VARCHAR(30) NOT NULL,
    phy_street VARCHAR(30) NOT NULL,
    phy_city VARCHAR(30) NOT NULL,
    phy_state CHAR(2) NOT NULL DEFAULT 'FL',
    phy_zip int NOT NULL check (phy_zip > 0 and phy_zip <= 999999999),
    phy_phone bigint NOT NULL check (phy_phone > 0 and phy_phone <= 9999999999),
    phy_fax bigint NOT NULL check (phy_fax > 0 and phy_fax <= 9999999999),
    phy_email VARCHAR(100) NULL,
    phy_url VARCHAR(100) NULL,
    phy_notes VARCHAR(255) NULL,
    PRIMARY KEY (phy_id)
);

-- table dbo.patient_treatment
IF OBJECT_ID (N'dbo.patient_treatment', N'U') IS NOT NULL
DROP TABLE dbo.patient_treatment;
GO

CREATE TABLE dbo.patient_treatment
(
    ptr_id SMALLINT NOT NULL identity(1,1),
    pat_id SMALLINT NOT NULL,
    phy_id SMALLINT NOT NULL,
    trt_id SMALLINT NOT NULL,
    ptr_date DATE NOT NULL,
    ptr_start TIME(0) NOT NULL,
    ptr_end TIME(0) NOT NULL,
    ptr_results VARCHAR(255) NULL,
    ptr_notes VARCHAR(255) NULL,
    PRIMARY KEY (ptr_id),

    -- combo of pat_id, phy_id, trt_id and prt_date unique
    CONSTRAINT ux_pat_id_phy_id_trt_id_ptr_date unique nonclustered (pat_id ASC, phy_id ASC, trt_id ASC, ptr_date ASC),

    CONSTRAINT fk_patient_treatment_patient
    FOREIGN KEY (pat_id)
    REFERENCES dbo.patient (pat_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    
    CONSTRAINT fk_patient_treatment_physician
    FOREIGN KEY (phy_id)
    REFERENCES dbo.physician (phy_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

    CONSTRAINT fk_patient_treatment_treatment
    FOREIGN KEY (trt_id)
    REFERENCES dbo.treatment (trt_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

-- table dbo.administration_lu
IF OBJECT_ID (N'dbo.administration_lu', N'U') IS NOT NULL
DROP TABLE dbo.administration_lu;
GO

CREATE TABLE dbo.administration_lu
(
    pre_id SMALLINT NOT NULL,
    ptr_id SMALLINT NOT NULL,
    PRIMARY KEY (pre_id, ptr_id),

    CONSTRAINT fk_administration_lu_prescription
    FOREIGN KEY (pre_id)
    REFERENCES dbo.prescription (pre_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

    CONSTRAINT fk_administration_lu_patient_treatment
    FOREIGN KEY (ptr_id)
    REFERENCES dbo.patient_treatment (ptr_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- show tables
select * from information_schema.tables;

-- disable constraints (after table creation, but before inserts)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- data dbo.patient
INSERT INTO dbo.patient
(pat_ssn, pat_fname, pat_lname, pat_street, pat_city, pat_state, pat_zip, pat_phone, pat_email, pat_dob, pat_gender, pat_notes)
VALUES
('123456789', 'Carla', 'Vanderbilt', '513 3rd Road', 'Lake Worth', 'FL', '334671234', 5674892390, 'cvan@gmail.com', '11-26-1961', 'f', NULL),
('223456789', 'John', 'Smith', '123 North Road', 'Tallahassee', 'FL', '324671234', 5674892391, 'jsmith@gmail.com', '12-26-1998', 'm', NULL),
('321456789', 'Sam', 'Stephens', '521 West Street', 'Orlando', 'FL', '344671294', 4854892390, 'ss@aol.com', '08-14-1985', 'm', NULL),
('456456789', 'Marla', 'Watkins', '146 Orange Ave', 'Winter Park', 'FL', '328671234', 5671232390, 'mwatkins@gmail.com', '05-26-2001', 'f', NULL),
('123456552', 'Joe', 'Tomas', '123 South Street', 'Pensacola', 'FL', '445671234', 5674891243, 'joet@gmail.com', '02-21-1992', 'm', NULL);

-- data dbo.medication
INSERT INTO dbo.medication
(med_name, med_price, med_shelf_life, med_notes)
VALUES
('Abilify', 200.00, '06-23-2014', NULL),
('Aciphex', 125.00, '02-23-2014', NULL),
('Actonel', 250.00, '01-15-2012', NULL),
('Actos', 89.00, '05-23-2010', NULL),
('Adderall XR', 69.00, '06-28-2015', NULL);

-- data dbo.prescription
INSERT INTO dbo.prescription
(pat_id, med_id, pre_date, pre_dosage, pre_num_refills, pre_notes)
VALUES
(1, 1, '2011-12-23', 'take one per day', '1', NULL),
(1, 2, '2011-12-24', 'take two per day', '2', NULL),
(2, 3, '2011-12-25', 'take one per day', '1', NULL),
(3, 5, '2011-12-26', 'take three per day', '2', NULL),
(2, 4, '2011-12-27', 'take two per day', '1', NULL);

-- data dbo.physcian
INSERT INTO dbo.physician
(phy_specialty, phy_fname, phy_lname, phy_street, phy_city, phy_state, phy_zip, phy_phone, phy_fax, phy_email, phy_url, phy_notes)
VALUES
('family medicine', 'Tom', 'Smith', '987 Peach Street', 'Tampa', 'FL', '33610', '9876541245', '9998854545', 'tsmith@gmail.com', 'tsmith.com', NULL),
('internal medicine', 'Steve', 'Williams', '921 Orange Street', 'Orlando', 'FL', '32310', '1236541245', '8878854545', 'stevew@gmail.com', 'stevewilliams.com', NULL),
('pediatrician', 'Ronald', 'Burns', '107 South Road', 'Tallahassee', 'FL', '32110', '4526541243', '9997754525', 'rburns@gmail.com', 'rburns.com', NULL),
('psychiatrist', 'Pete', 'Rogers', '442 Tennessee Street', 'Tallahassee', 'FL', '32314', '9871281245', '4568854545', 'peter@gmail.com', 'peter.com', NULL),
('dermatology', 'Dave', 'Johnson', '845 North Street', 'Pensacola', 'FL', '48610', '7816541245', '1279854545', 'djohnson@gmail.com', 'djohnson.com', NULL);

-- data dbo.treatment
INSERT INTO dbo.treatment
(trt_name, trt_price, trt_notes)
VALUES
('knee replacement', 2000.00, NULL),
('heart transplant', 130000.00, NULL),
('hip replancement', 40000.00, NULL),
('tonsils removed', 5000.00, NULL),
('skin graft', 2000.00, NULL);

-- data dbo.patient_treatment
INSERT INTO patient_treatment
(pat_id, phy_id, trt_id, ptr_date, ptr_start, ptr_end, ptr_results, ptr_notes)
VALUES
(1, 2, 3, '2011-12-23', '07:08:09', '10:12:15', 'success', NULL),
(1, 4, 2, '2008-12-20', '08:08:09', '11:12:15', 'complications', NULL),
(5, 1, 4, '2012-12-23', '09:08:09', '12:12:15', 'died', NULL),
(3, 2, 5, '2009-10-23', '10:08:09', '13:12:15', 'success', NULL),
(4, 3, 1, '2010-12-23', '11:08:09', '14:12:15', 'complications', NULL);

-- data dbo.administration_lu
INSERT INTO dbo.administration_lu
(pre_id, ptr_id)
VALUES 
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1);

-- enable constraints
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"