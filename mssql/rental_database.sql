-- Rental Database Creation

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

-- table dbo.applicant
IF OBJECT_ID (N'dbo.applicant', N'U') IS NOT NULL
DROP TABLE dbo.applicant;
GO

CREATE TABLE dbo.applicant
(
    app_id SMALLINT not null identity(1,1),
    app_ssn int NOT NULL check (app_ssn > 0 and app_ssn <= 999999999),
    app_state_id VARCHAR(45) NOT NULL,
    app_fname VARCHAR(15) NOT NULL,
    app_lname VARCHAR(30) NOT NULL,
    app_street VARCHAR(30) NOT NULL,
    app_city VARCHAR(30) NOT NULL,
    app_state CHAR(2) NOT NULL DEFAULT 'FL',
    app_zip int NOT NULL check (app_zip > 0 and app_zip <= 999999999),
    app_email VARCHAR(100) NULL,
    app_dob DATE NOT NULL,
    app_gender CHAR(1) NOT NULL CHECK (app_gender IN('m','f')),
    app_bckgd_check CHAR(1) NOT NULL CHECK (app_bckgd_check IN('n','y')),
    app_notes VARCHAR(45) NULL,
    PRIMARY KEY (app_id),
    -- SSN and State IDs unique
    CONSTRAINT ux_app_ssn unique nonclustered (app_ssn ASC),
    CONSTRAINT ux_app_state_id unique nonclustered (app_state_id ASC)
);

-- table dbo.property
IF OBJECT_ID (N'dbo.property', N'U') IS NOT NULL
DROP TABLE dbo.property;

CREATE TABLE dbo.property
(
    prp_id SMALLINT NOT NULL identity(1,1),
    prp_street VARCHAR(30) NOT NULL,
    prp_city VARCHAR(30) NOT NULL,
    prp_state CHAR(2) NOT NULL DEFAULT 'FL',
    prp_zip int NOT NULL check (prp_zip > 0 and prp_zip <= 999999999),
    prp_type VARCHAR(15) NOT NULL check (prp_type IN('house', 'condo', 'townhouse', 'duplex', 'apt', 'mobile home', 'room')),
    prp_rental_rate DECIMAL(7,2) NOT NULL CHECK (prp_rental_rate > 0),
    prp_status CHAR(1) NOT NULL CHECK (prp_status IN('a','u')),
    prp_notes VARCHAR(255) NULL,
    PRIMARY KEY (prp_id)
);

-- table dbo.agreement
IF OBJECT_ID (N'dbo.agreement', N'U') IS NOT NULL
DROP TABLE dbo.agreement;

CREATE TABLE dbo.agreement
(
    agr_id SMALLINT NOT NULL identity(1,1),
    prp_id SMALLINT NOT NULL,
    app_id SMALLINT NOT NULL,
    agr_signed DATE NOT NULL,
    agr_start DATE NOT NULL,
    agr_end DATE NOT NULL,
    agr_amt DECIMAL(7,2) NOT NULL CHECK (agr_amt > 0),
    agr_notes VARCHAR(255) NULL,
    PRIMARY KEY (agr_id),
    -- combination of prp_id, app_id, and agr_signed is unique
    CONSTRAINT ux_prp_id_app_id_agr_signed unique nonclustered (prp_id ASC, app_id ASC, agr_signed ASC),
    -- foreign keys
    CONSTRAINT fk_agreement_property
    FOREIGN KEY (prp_id)
    REFERENCES dbo.property (prp_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_agreement_applicant
    FOREIGN KEY (app_id)
    REFERENCES dbo.applicant (app_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- table dbo.feature
IF OBJECT_ID (N'dbo.feature', N'U') IS NOT NULL
DROP TABLE dbo.feature;

CREATE TABLE dbo.feature
(
    ftr_id TINYINT NOT NULL identity(1,1),
    ftr_type VARCHAR(45) NOT NULL,
    ftr_notes VARCHAR(255) NULL,
    PRIMARY KEY (ftr_id)
);

-- table dbo.prop_feature
IF OBJECT_ID (N'dbo.prop_feature', N'U') IS NOT NULL
DROP TABLE dbo.prop_feature;

CREATE TABLE dbo.prop_feature
(
    pft_id SMALLINT NOT NULL identity(1,1),
    prp_id SMALLINT NOT NULL,
    ftr_id TINYINT NOT NULL,
    pft_notes VARCHAR(255) NULL,
    PRIMARY KEY (pft_id),
    -- combination of prp_id and ftr_id is unique
    CONSTRAINT ux_prp_id_ftr_id unique nonclustered (prp_id ASC, ftr_id ASC),
    --foreign keys
    CONSTRAINT fk_prop_feat_property
    FOREIGN KEY (prp_id)
    REFERENCES dbo.property (prp_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_prop_feat_feature
    FOREIGN KEY (ftr_id)
    REFERENCES dbo.feature (ftr_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- table dbo.occupant
IF OBJECT_ID (N'dbo.occupant', N'U') IS NOT NULL
DROP TABLE dbo.occupant;

CREATE TABLE dbo.occupant
(
    ocp_id SMALLINT NOT NULL identity(1,1),
    app_id SMALLINT NOT NULL,
    ocp_ssn int NOT NULL check (ocp_ssn > 0 and ocp_ssn <= 999999999),
    ocp_state_id VARCHAR(45) NULL,
    ocp_fname VARCHAR(15) NOT NULL,
    ocp_lname VARCHAR(30) NOT NULL,
    ocp_email VARCHAR(100) NULL,
    ocp_dob DATE NOT NULL,
    ocp_gender CHAR(1) NOT NULL CHECK (ocp_gender IN('m','f')),
    ocp_bckgd_check CHAR(1) NOT NULL CHECK (ocp_bckgd_check IN('n','y')),
    ocp_notes VARCHAR(45) NULL,
    PRIMARY KEY (ocp_id),
    -- ssn and state ids unique
    CONSTRAINT ux_ocp_ssn unique nonclustered (ocp_ssn ASC),
    CONSTRAINT ux_ocp_state_id unique nonclustered (ocp_state_id ASC),
    -- foreign key
    CONSTRAINT fk_occupant_applicant
    FOREIGN KEY (app_id)
    REFERENCES dbo.applicant (app_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- table dbo.phone
IF OBJECT_ID (N'dbo.phone', N'U') IS NOT NULL
DROP TABLE dbo.phone;

CREATE TABLE dbo.phone
(
    phn_id SMALLINT NOT NULL identity(1,1),
    app_id SMALLINT NULL, -- can be null, but must provide at least one number
    ocp_id SMALLINT NULL,
    phn_num BIGINT NOT NULL check (phn_num > 0 and phn_num <= 9999999999),
    phn_type CHAR(1) NOT NULL CHECK (phn_type IN('c','h','w','f')),
    phn_notes VARCHAR(255) NULL,
    PRIMARY KEY (phn_id),
    --combinations of app_id + phn_num and ocp_id and phn_num are unique
    CONSTRAINT ux_app_id_phn_num unique nonclustered (app_id ASC, phn_num ASC),
    CONSTRAINT ux_ocp_id_phn_num unique nonclustered (ocp_id ASC, phn_num ASC),
    -- foreign keys
    CONSTRAINT fk_phone_applicant
    FOREIGN KEY (app_id)
    REFERENCES dbo.applicant (app_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    -- no action because of multiple paths
    CONSTRAINT fk_phone_occupant
    FOREIGN KEY (ocp_id)
    REFERENCES dbo.occupant (ocp_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- table dbo.room_type
IF OBJECT_ID (N'dbo.room_type', N'U') IS NOT NULL
DROP TABLE dbo.room_type;

CREATE TABLE dbo.room_type
(
    rtp_id TINYINT NOT NULL identity(1,1),
    rtp_name VARCHAR(45) NOT NULL,
    rtp_notes VARCHAR(255) NULL,
    PRIMARY KEY (rtp_id)
);

-- table dbo.room
IF OBJECT_ID (N'dbo.room', N'U') IS NOT NULL
DROP TABLE dbo.room;

CREATE TABLE dbo.room
(
    rom_id SMALLINT NOT NULL identity(1,1),
    prp_id SMALLINT NOT NULL,
    rtp_id TINYINT NOT NULL,
    rom_size VARCHAR(45) NOT NULL,
    rom_notes VARCHAR(255) NULL,
    PRIMARY KEY (rom_id),
    -- foreign keys
    CONSTRAINT fk_room_property
    FOREIGN KEY (prp_id)
    REFERENCES dbo.property (prp_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_room_roomtype
    FOREIGN KEY (rtp_id)
    REFERENCES dbo.room_type (rtp_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- show tables
SELECT * FROM information_schema.tables;

-- disable all constraints (do this after table creation but before inserts)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"


-- data for dbo.feature
INSERT INTO dbo.feature
(ftr_type, ftr_notes)
VALUES
('Central A/C', NULL),
('Pool', NULL),
('Close to school', NULL),
('Furnished', NULL),
('Cable', NULL);

-- data for dbo.room_type
INSERT INTO dbo.room_type
(rtp_name, rtp_notes)
VALUES
('Bed', NULL),
('Bath', NULL),
('Kitchen', NULL),
('Lanai', NULL),
('Dining', NULL);

-- data for dbo.prop_feature
INSERT INTO dbo.prop_feature
(prp_id, ftr_id, pft_notes)
VALUES
(1, 4, NULL),
(2, 5, NULL),
(3, 3, NULL),
(4, 2, NULL),
(5, 1, NULL);

-- data for dbo.room
INSERT INTO dbo.room
(prp_id, rtp_id, rom_size, rom_notes)
VALUES
(1,1, '10'' x 10''', NULL),
(3,2, '20'' x 15''', NULL),
(4,3, '8'' x 8''', NULL),
(5,4, '50'' x 50''', NULL),
(2,5, '30'' x 30''', NULL);

-- data for dbo.property
INSERT INTO dbo.property
(prp_street, prp_city, prp_state, prp_zip, prp_type, prp_rental_rate, prp_status, prp_notes)
VALUES
('5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'house', 1800.00, 'u', NULL),
('923 Blah Way', 'Tallahasee', 'FL', '323011234', 'apt', 641.00, 'u', NULL),
('756 Coke Lane', 'Panama City', 'FL', '342001234', 'condo', 2400.00, 'a', NULL),
('574 Doritos Circle', 'Jacksonville', 'FL', '365231234', 'townhouse', 1942.99, 'a', NULL),
('2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 'apt', 610.00, 'u', NULL);

-- data for dbo.applicant
INSERT INTO dbo.applicant
(app_ssn, app_state_id, app_fname, app_lname, app_street, app_city, app_state, app_zip, app_email, app_dob, app_gender, app_bckgd_check, app_notes)
VALUES
('123456789', 'A12C3456Q7B', 'Carla', 'Vanderbilt', '5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'cvand@yahoo.com', '1961-11-26', 'f', 'y', NULL),
('590123654', 'B123A56D789', 'Amanda', 'Lindell', '2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 'alin@gmail.com', '1981-04-04', 'f', 'y', NULL),
('987456321', 'dfed66532sedd', 'David', 'Stephens', '1293 Banana Drive', 'Panama City', 'FL', '323081234', 'davids@aol.com', '1964-04-15', 'm', 'y', NULL),
('365214986', 'dgfda2515fdea', 'Chris', 'Thrombough', '987 Learn Drive', 'Tallahassee', 'FL', '323011234', 'cthrom@gmail.com', '1969-07-25', 'm', 'y', NULL),
('326598236', 'yadayada4517', 'Spencer', 'Moore', '787 Tharpe Road', 'Tallahassee', 'FL', '323061234', 'spencerm@yahoo.com', '1990-08-14', 'm', 'n', NULL);

-- data for dbo.agreement
INSERT INTO dbo.agreement
(prp_id, app_id, agr_signed, agr_start, agr_end, agr_amt, agr_notes)
VALUES
(3, 4, '2011-12-01', '2012-01-01', '2012-12-31', 1000.00, NULL),
(1, 1, '1983-01-01', '1983-01-01', '1987-12-31', 800.00, NULL),
(4, 2, '1999-12-31', '2000-01-01', '2004-12-31', 1200.00, NULL),
(5, 3, '1999-07-31', '1999-08-01', '2004-07-31', 750.00, NULL),
(2, 5, '2011-01-01', '2011-01-01', '2013-12-31', 900.00, NULL);

-- data for dbo.occupant
INSERT INTO dbo.occupant
(app_id, ocp_ssn, ocp_state_id, ocp_fname, ocp_lname, ocp_email, ocp_dob, ocp_gender, ocp_bckgd_check, ocp_notes)
VALUES
(1, '326532164', 'okd556ig4125', 'Bridget', 'Case', 'bc@gmail.com', '1988-03-23', 'f', 'y', NULL),
(1, '187452457', 'uhtooold', 'Brian', 'Smith', 'bs@yahoo.com', '1956-07-28', 'm', 'y', NULL),
(2, '123456780', 'thisisdoggie', 'Joe', 'Rogan', 'jr@aol.com', '2011-01-01', 'm', 'n', NULL),
(2, '098123664', 'thisiskitty', 'Smalls', 'Balls', 'sb@gmail.com', '1988-03-05', 'm', 'n', NULL),
(5, '857694032', 'thisiscat123', 'Sam', 'Smith', 'ss@aol.com', '1985-05-05', 'f', 'n', NULL);

-- data for dbo.phone
INSERT INTO dbo.phone
(app_id, ocp_id, phn_num, phn_type, phn_notes)
VALUES
(1, NULL, '5615233044', 'h', NULL),
(2, NULL, '5616859976', 'f', NULL),
(5, 5, '8504569872', 'h', NULL),
(NULL, 1, '5613080898', 'c', 'occupant''s number only'),
(3, NULL, '8504152365', 'w', NULL);


-- enable all constraints
exec sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL"

-- show data
select * from dbo.feature;
select * from dbo.prop_feature;
select * from dbo.room_type;
select * from dbo.room;
select * from dbo.property;
select * from dbo.applicant;
select * from dbo.agreement;
select * from dbo.occupant;
select * from dbo.phone;