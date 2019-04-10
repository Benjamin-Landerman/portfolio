-- Rental Database T-SQL Statements

-- a. Create a transactionthat deletes applicant #1.
use bdl16;
GO

BEGIN TRANSACTION;
  select * from dbo.applicant;
  select * from dbo.occupant;
  select * from dbo.phone;
  select * from dbo.agreement;

  DELETE FROM dbo.applicant
  WHERE app_id = 1;

  select * from dbo.applicant;
  select * from dbo.occupant;
  select * from dbo.phone;
  select * from dbo.agreement;
COMMIT;

-- b. Create a viewto display the property id, property type, property rental rate, all of the room types (names) and associated sizes for property ID 3. Name it v_prop_info.
use bdl16;
GO

IF OBJECT_ID (N'dbo.v_prop_info', N'V') IS NOT NULL
DROP VIEW dbo.v_prop_info;
GO

CREATE VIEW dbo.v_prop_info as
  select p.prp_id, prp_type, prp_rental_rate, rtp_name, rom_size
  from property p
    join room r on p.prp_id = r.prp_id
    join room_type rt on r.rtp_id = rt.rtp_id
  where p.prp_id = 3;
GO

select * from information_schema.tables;
GO

-- show view defintion
select VIEW_DEFINITION
from INFORMATION_SCHEMA.VIEWS;
GO

select * from dbo.v_prop_info;
GO

-- c. Create a viewto display the property id, property type, property rental rate, and all of the property featuretypes for property IDs 4 and 5, order by property rental rate in descending order. Name it v_prop_info_feature.
use bdl16;
GO

IF OBJECT_ID (N'dbo.v_prop_info_feature', N'V') IS NOT NULL
DROP VIEW dbo.v_prop_info_feature;
GO

CREATE VIEW dbo.v_prop_info_feature as
  select p.prp_id, prp_type, prp_rental_rate, ftr_type
  from property p
    join prop_feature pf on p.prp_id = pf.prp_id
    join feature on pf.ftr_id = f.ftr_id
  where p.prp_id >= 4 and p.prp_id < 6;
GO

-- use order by outside of the view
select * from dbo.v_prop_info_feature
order by prp_rental_rate desc;
GO

-- d. Create a stored procedurethat accepts an applicant’s id to display an applicant’s social security number, state id number, first andlast names, and all of their respective phone numbers, and phone number types. Name it ApplicantInfo.
use bdl16;
GO

IF OBJECT_ID('dbo.ApplicantInfo') IS NOT NULL
DROP PROCEDURE dbo.ApplicantInfo;
GO

CREATE PROCEDURE dbo.ApplicantInfo(@appid INT) as
  select app_ssn, app_state_id, app_fname, app_lname, phn_num, phn_type
  from applicant a, phone p
  where a.app_id = p.app_id
  and a.app_id = @appid;
GO

EXEC dbo.ApplicantInfo 3;

-- e. Create a stored procedureto display *all* phone numbersand phone types, as well as occupants' social security numbers,state id numbers, first and last names. Display *all* phone numbers, even if occupants may *not* have a phone number.Name it OccupantInfo.
use bdl16;
GO

IF OBJECT_ID('dbo.OccupantInfo') IS NOT NULL
DROP PROCEDURE dbo.OccupantInfo;
GO

CREATE PROCEDURE dbo.OccupantInfo as
  select ocp_ssn, ocp_state_id, ocp_fname, ocp_lname, phn_num, phn_type
  from phone p
    LEFT OUTER JOIN occupant o ON o.ocp_id = p.ocp_id;
GO

EXEC dbo.OccupantInfo;
GO