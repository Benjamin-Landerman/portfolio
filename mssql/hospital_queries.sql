-- Hospital Database T-SQL Statements

-- a. Using JOIN ON, create a transactionthat lists all patients’ first, last names, any patients’ notes, as well as all of their medication names, prices, shelf lives, prescription dosages and number of refills., order by medicine price in descending order.
use bdl16;
go

begin transaction;
  select pat_fname, pat_lname, pat_notes, med_name, med_price, med_shelf_life, pre_dosage, pre_num_refills
  from medication m
    join prescription pr on pr.med_id = m.med_id
    join patient p on pr.pat_id = p.pat_id
  order by med_price desc;
commit;

-- b. Using old-style join, create a view(dbo.v_physician_patient_treatments)that lists all physicians’ first, last names, treatment names, treatment prices, treatment results,as well as start and end times, order by treatment pricein descending order.
IF OBJECT_ID (N'dbo.v_physician_patient_treatments', N'V') IS NOT NULL
DROP VIEW dbo.v_physician_patient_treatments;
go

create view dbo.v_physician_patient_treatments as
  select phy_fname, phy_lname, trt_name, trt_price, ptr_results, ptr_date, ptr_start, ptr_end
  from physician p, patient_treatment pt, treatment t
  where p.phy_id=pt.phy_id
    and pt.trt_id=t.trt_id;
go

select * from dbo.v_physician_patient_treatments order by trt_price desc;
go

-- c. Create a stored procedure(AddRecord) that adds the following record to the patient treatment table, andthat uses the view aboveafterthe added record:patient id 5, physician id 5, treatment id 5, 4/23/13, 11am, 12:30p, released, ok
use bdl16;
go

select * from dbo.v_physician_patient_treatments;

IF OBJECT_ID('AddRecord') IS NOT NULL
DROP procedure AddRecord;
go

CREATE PROCEDURE AddRecord as
  insert into dbo.patient_treatment (pat_id, phy_id, trt_id, ptr_date, ptr_start, ptr_end, ptr_results, ptr_notes)
  values (5, 5, 5, '2013-04-23', '11:00:00', '12:30:00', 'released', 'ok');

select * from dbo.v_physician_patient_treatments;
go

EXEC AddRecord;

-- d. Create a transactionthat removes *only* the fifth record in the administration lookup table
begin transaction;
  select * from dbo.administration_lu;
  delete from dbo.administration_lu where pre_id = 5 and ptr_id = 1;
  select * from dbo.administration_lu;
commit;

-- e. Create a stored procedure(UpdateRecord) to update the patient’s last name to “Vanderbilt” whose id is 3.
use bdl16;
go

IF OBJECT_ID('dbo.UpdateRecord') IS NOT NULL
DROP PROCEDURE dbo.UpdateRecord;
go

CREATE PROCEDURE dbo.UpdateRecord as
  select * from dbo.patient;
  update dbo.patient
    set pat_lname = 'Vanderbilt'
    where pat_id = 3;
  select * from dbo.patient;
go;

EXEC dbo.UpdateRecord;

-- f. Use an alter statement to create a “prognosis” attribute in the patient treatment table capable of storing 255 alpha-numeric characters, just above the “notes” attribute. The attribute value can be null.

-- can't alter the order of columns in ms sql server

/* MySQL
describe patient_treatment;
alter table patient_treatment add ptr_prognosis varchar(255) NULL default 'testing' after ptr_results;
describe patient_treatment;
*/

-- MS SQL Server
EXEC sp_help 'dbo.patient_treatment'; -- describe
ALTER TABLE dbo.patient_treatment add ptr_prognosis varchar(255) NULL default 'testing';
EXEC sp_help 'dbo.patient_treatment'; -- describe

-- extra credit: Create a stored procedure (AddShowRecords) that adds a patient record when called, thendisplays all treatments (i.e., descriptions) associated with patients and their doctors, include their names, start/end times, sorted by the most recent date. 
use bdl16;

IF OBJECT_ID('dbo.AddShowRecords') IS NOT NULL
DROP PROCEDURE dbo.AddShowRecords;
go

CREATE PROCEDURE dbo.AddShowRecords as
  select * from dbo.patient;
  insert into dbo.patient (pat_ssn, pat_fname, pat_lname, pat_street, pat_city, pat_state, pat_zip, pat_phone, pat_email, pat_dob, pat_gender, pat_notes)
  values (756889432, 'John', 'Doe', '123 Main St', 'Tallahassee', 'FL', '32405', '8507863241', 'jdoe@fsu.edu', '1999-05-10', 'm', 'testing notes');
  select * from dbo.patient;

  select phy_fname, phy_lname, pat_fname, pat_lname, trt_name, ptr_start, ptr_end, ptr_date
  from dbo.patient p
    join dbo.patient_treatment pt on p.pat_id=pt.pat_id
    join dbo.physician pn on pn.phy_id=pt.phy_id
    join dbo.treatment t on t.trt_id=pt.trt_id
  order by ptr_date desc;
go

EXEC dbo.AddShowRecords;
go