SET ANSI_WARNINGS ON;
go

use master;
go

IF EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE name = N'bdl16')
DROP DATABASE bdl16;
go

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'bdl16')
CREATE DATABASE bdl16;
go

use bdl16;
go

-- table: person
IF OBJECT_ID (N'dbo.person', N'U') IS NOT NULL
DROP TABLE dbo.person;
go

CREATE TABLE dbo.person (
    per_id smallint not null identity(1,1),
    per_ssn binary(64) null,
    per_salt binary(64) null,
    per_fname varchar(15) not null,
    per_lname varchar(30) not null,
    per_gender char(1) not null check (per_gender IN('m', 'f')),
    per_dob date not null,
    per_street varchar(30) not null,
    per_city varchar(30) not null,
    per_state char(2) not null default 'FL',
    per_zip int not null check (per_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    per_email varchar(100) null,
    per_type char(1) not null check (per_type IN('c','s')),
    per_notes varchar(45) null,
    primary key (per_id),

    CONSTRAINT ux_per_ssn unique nonclustered (per_ssn ASC)
);
go

-- table: phone
IF OBJECT_ID (N'dbo.phone', N'U') IS NOT NULL
DROP TABLE dbo.phone;
go

CREATE TABLE dbo.phone (
    phn_id smallint not null identity(1,1),
    per_id smallint not null,
    phn_num bigint not null check (phn_num like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phn_type char(1) not null check (phn_type in('h','c','w','f')),
    phn_notes varchar(255) null,
    primary key (phn_id),

    CONSTRAINT fk_phone_person
     FOREIGN KEY (per_id)
     REFERENCES dbo.person (per_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: customer
IF OBJECT_ID (N'dbo.customer', N'U') IS NOT NULL
DROP TABLE dbo.customer;
go

CREATE TABLE dbo.customer (
    per_id smallint not null,
    cus_balance decimal(7,2) not null check (cus_balance >= 0),
    cus_total_sales decimal(7,2) not null check (cus_total_sales >= 0),
    cus_notes varchar(45) null,
    primary key (per_id),

    CONSTRAINT fk_customer_person
    FOREIGN KEY (per_id)
    REFERENCES dbo.person (per_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
go

-- table: slsrep
IF OBJECT_ID (N'dbo.slsrep', N'U') IS NOT NULL
DROP TABLE dbo.slsrep;
go

CREATE TABLE dbo.slsrep (
    per_id smallint not null,
    srp_yr_sales_goal decimal(8,2) not null check (srp_yr_sales_goal >= 0),
    srp_ytd_sales decimal(8,2) not null check (srp_ytd_sales >= 0),
    srp_ytd_comm decimal(7,2) not null check (srp_ytd_comm >= 0),
    srp_notes varchar(45) null,
    primary key (per_id),
    
    CONSTRAINT fk_slsrep_person
     FOREIGN KEY (per_id)
     REFERENCES dbo.person (per_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: srp_hist
IF OBJECT_ID (N'dbo.srp_hist', N'U') IS NOT NULL
DROP TABLE dbo.srp_hist;
go

CREATE TABLE dbo.srp_hist (
    sht_id smallint not null identity(1,1),
    per_id smallint not null,
    sht_type char(1) not null check (sht_type in('i','u','d')),
    sht_modified datetime not null,
    sht_modifier varchar(45) not null default system_user,
    sht_date date not null default getDate(),
    sht_yr_sales_goal decimal(8,2) not null check (sht_yr_sales_goal >= 0),
    sht_yr_total_sales decimal(8,2) not null check (sht_yr_total_sales >= 0),
    sht_yr_total_comm decimal(7,2) not null check (sht_yr_total_comm >=  0),
    sht_notes varchar(45) null,
    primary key (sht_id),

    CONSTRAINT fk_srp_hist_slsrep
     FOREIGN KEY (per_id)
     REFERENCES dbo.slsrep (per_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: contact
IF OBJECT_ID (N'dbo.contact', N'U') IS NOT NULL
DROP TABLE dbo.contact;
go

CREATE TABLE dbo.contact (
    cnt_id int not null identity(1,1),
    per_cid smallint not null,
    per_sid smallint not null,
    cnt_date datetime not null,
    cnt_notes varchar(255) null,
    primary key (cnt_id),

    CONSTRAINT fk_contact_customer
     FOREIGN KEY (per_cid)
     REFERENCES dbo.customer (per_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,

    CONSTRAINT fk_contact_slsrep
     FOREIGN KEY (per_sid)
     REFERENCES dbo.slsrep (per_id)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION
);
go

-- table: order
IF OBJECT_ID (N'dbo.[order]', N'U') IS NOT NULL
DROP TABLE dbo.[order];
go

CREATE TABLE dbo.[order] (
    ord_id int not null identity(1,1),
    cnt_id int not null,
    ord_placed_date datetime not null,
    ord_filled_date datetime null,
    ord_notes varchar(255) null,
    primary key (ord_id),

    CONSTRAINT fk_order_contact
     FOREIGN KEY (cnt_id)
     REFERENCES dbo.contact(cnt_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: region
IF OBJECT_ID (N'dbo.region', N'U') IS NOT NULL
DROP TABLE dbo.region;
go

CREATE TABLE dbo.region (
    reg_id tinyint not null identity(1,1),
    reg_name char(1) not null,
    reg_notes varchar(255) null,
    primary key (reg_id)
);
go

-- table: state
IF OBJECT_ID (N'dbo.state', N'U') IS NOT NULL
DROP TABLE dbo.state;
go

CREATE TABLE dbo.state (
    ste_id tinyint not null identity(1,1),
    reg_id tinyint not null,
    ste_name char(2) not null default 'FL',
    ste_notes varchar(255) null,
    primary key (ste_id),

    CONSTRAINT fk_state_region
     FOREIGN KEY (reg_id)
     REFERENCES dbo.region (reg_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: city
IF OBJECT_ID (N'dbo.city', N'U') IS NOT NULL
DROP TABLE dbo.city;
go

CREATE TABLE dbo.city (
    cty_id smallint not null identity(1,1),
    ste_id tinyint not null,
    cty_name varchar(30) not null,
    cty_notes varchar(255) null,
    primary key (cty_id),

    CONSTRAINT fk_city_state
     FOREIGN KEY (ste_id)
     REFERENCES dbo.state (ste_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: store
IF OBJECT_ID (N'dbo.store', N'U') IS NOT NULL
DROP TABLE dbo.store;
go

CREATE TABLE dbo.store (
    str_id smallint not null identity(1,1),
    cty_id smallint not null,
    str_name varchar(45) not null,
    str_street varchar(30) not null,
    str_city varchar(30) not null,
    str_state char(2) not null default 'FL',
    str_zip int NOT NULL check (str_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_phone bigint not null check (str_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_email varchar(100) not null,
    str_url varchar(100) not null,
    str_notes varchar(255) null,
    primary key (str_id),

    CONSTRAINT fk_store_city
     FOREIGN KEY (cty_id)
     REFERENCES dbo.city (cty_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: invoice
IF OBJECT_ID (N'dbo.invoice', N'U') IS NOT NULL
DROP TABLE dbo.invoice;
go

CREATE TABLE dbo.invoice (
    inv_id int not null identity(1,1),
    ord_id int not null,
    str_id smallint not null,
    inv_date datetime not null,
    inv_total decimal(8,2) not null check (inv_total >= 0),
    inv_paid bit not null,
    inv_notes varchar(255) null,
    primary key (inv_id),

    CONSTRAINT ux_ord_id unique nonclustered (ord_id ASC),

    CONSTRAINT fk_invoice_order
     FOREIGN KEY (ord_id)
     REFERENCES dbo.[order] (ord_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,

    CONSTRAINT fk_invoice_store
     FOREIGN KEY (str_id)
     REFERENCES dbo.store (str_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: payment
IF OBJECT_ID (N'dbo.payment', N'U') IS NOT NULL
DROP TABLE dbo.payment;
go

CREATE TABLE dbo.payment (
    pay_id int not null identity(1,1),
    inv_id int not null,
    pay_date datetime not null,
    pay_amt decimal(7,2) not null check (pay_amt >= 0),
    pay_notes varchar(255) null,
    primary key (pay_id),

    CONSTRAINT fk_payment_invoice
     FOREIGN KEY (inv_id)
     REFERENCES dbo.invoice (inv_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: vendor
IF OBJECT_ID (N'dbo.vendor', N'U') IS NOT NULL
DROP TABLE dbo.vendor;
go

CREATE TABLE dbo.vendor (
    ven_id smallint not null identity(1,1),
    ven_name varchar(45) not null,
    ven_street varchar(30) not null,
    ven_city varchar(30) not null,
    ven_state char(2) not null default 'FL',
    ven_zip int not null check (ven_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_phone bigint not null check (ven_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_email varchar(100) null,
    ven_url varchar(100) null,
    ven_notes varchar(255) null,
    primary key (ven_id)
);
go

-- table: product
IF OBJECT_ID (N'dbo.product', N'U') IS NOT NULL
DROP TABLE dbo.product;
go

CREATE TABLE dbo.product (
    pro_id smallint not null identity(1,1),
    ven_id smallint not null,
    pro_name varchar(30) not null,
    pro_descript varchar(45) null,
    pro_weight float not null check (pro_weight >= 0),
    pro_qoh smallint not null check (pro_qoh >= 0),
    pro_cost decimal(7,2) not null check (pro_cost >= 0),
    pro_price decimal(7,2) not null check (pro_price >= 0),
    pro_discount decimal(3,0) null,
    pro_notes varchar(255) null,
    primary key (pro_id),

    CONSTRAINT fk_product_vendor
     FOREIGN KEY (ven_id)
     REFERENCES dbo.vendor (ven_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: product_hist
IF OBJECT_ID (N'dbo.product_hist', N'U') IS NOT NULL
DROP TABLE dbo.product_hist;
go

CREATE TABLE dbo.product_hist (
    pht_id int not null identity(1,1),
    pro_id smallint not null,
    pht_date datetime not null,
    pht_cost decimal(7,2) not null check (pht_cost >= 0),
    pht_price decimal(7,2) not null check (pht_price >= 0),
    pht_discount decimal(3,0) null,
    pht_notes varchar(255) null,
    primary key (pht_id),

    CONSTRAINT fk_product_hist_product
     FOREIGN KEY (pro_id)
     REFERENCES dbo.product (pro_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: order_line
IF OBJECT_ID (N'dbo.order_line', N'U') IS NOT NULL
DROP TABLE dbo.order_line;
go

CREATE TABLE dbo.order_line (
    oln_id int not null identity(1,1),
    ord_id int not null,
    pro_id smallint not null,
    oln_qty smallint not null check (oln_qty >= 0),
    oln_price decimal(7,2) not null check (oln_price >= 0),
    oln_notes varchar(255) null,
    primary key (oln_id),

    CONSTRAINT fk_order_line_order
     FOREIGN KEY (ord_id)
     REFERENCES dbo.[order] (ord_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,

    CONSTRAINT fk_order_line_product
     FOREIGN KEY (pro_id)
     REFERENCES dbo.product (pro_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

-- table: time
IF OBJECT_ID (N'dbo.time', N'U') IS NOT NULL
DROP TABLE dbo.time;
go

CREATE TABLE dbo.time (
    tim_id int not null identity(1,1),
    tim_yr smallint not null,
    tim_qtr tinyint not null,
    tim_month tinyint not null,
    tim_week tinyint not null,
    tim_day tinyint not null,
    tim_time time not null,
    tim_notes varchar(255) null,
    primary key (tim_id)
);
go

-- table: sale
IF OBJECT_ID (N'dbo.sale', N'U') IS NOT NULL
DROP TABLE dbo.sale;
go

CREATE TABLE dbo.sale (
    pro_id smallint not null,
    str_id smallint not null,
    cnt_id int not null,
    tim_id int not null,
    sal_qty smallint not null,
    sal_price decimal(8,2) not null,
    sal_total decimal(8,2) not null,
    sal_notes varchar(255) null,
    primary key (pro_id, cnt_id, tim_id, str_id),

    CONSTRAINT ux_pro_id_str_id_cnt_id_tim_id
    unique nonclustered (pro_id ASC, str_id ASC, cnt_id ASC, tim_id ASC),

    CONSTRAINT fk_sale_time
     FOREIGN KEY (tim_id)
     REFERENCES dbo.time (tim_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,

    CONSTRAINT fk_sale_contact
     FOREIGN KEY (cnt_id)
     REFERENCES dbo.contact (cnt_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,

    CONSTRAINT fk_sale_store
     FOREIGN KEY (str_id)
     REFERENCES dbo.store (str_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE,
    
    CONSTRAINT fk_sale_product
     FOREIGN KEY (pro_id)
     REFERENCES dbo.product (pro_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE
);
go

SELECT * FROM information_schema.tables;

-- data for tables
-- person
INSERT INTO dbo.person
(per_ssn, per_salt, per_fname, per_lname, per_gender, per_dob, per_street, per_city, per_state, per_zip, per_email, per_type, per_notes)
VALUES
(1, NULL, 'Steve', 'Rogers', 'm', '1923-10-03', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', 's', NULL),
(2, NULL, 'Bruce', 'Wayne', 'm', '1968-03-20', '1007 Mountain Drive', 'Gotham', 'NY', 983208440, 'bwayne@knology.net', 's', NULL),
(3, NULL, 'Peter', 'Parker', 'm', '1988-09-12', '20 Ingram Street', 'New York', 'NY', 102862341, 'pparker@msn.com', 's', NULL),
(4, NULL, 'Jane', 'Thompson', 'f', '1978-05-08', '13563 Ocean View Drive', 'Seattle', 'WA', 132084409, 'jthompson@gmail.com', 's', NULL),
(5, NULL, 'Debra', 'Steele', 'f', '1994-07-19', '543 Oak Ln', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', 's', NULL),
(6, NULL, 'Tony', 'Smith', 'm', '1972-05-04', '332 Palm Avenue', 'Malibu', 'CA', 902638332, 'tstark@yahoo.com', 'c', NULL),
(7, NULL, 'Hank', 'Pymi', 'm', '1980-08-28', '2355 Brown Street', 'Cleveland', 'OH', 822348890, 'hpym@aol.com', 'c', NULL),
(8, NULL, 'Bob', 'Best', 'm', '1992-02-10', '4902 Avendale Avenue', 'Scottsdale', 'AZ', 872638332, 'bbest@yahoo.com', 'c', NULL),
(9, NULL, 'Sandra', 'Smith', 'f', '1990-01-26', '87912 Lawrence Ave', 'Atlanta', 'GA', 672348890, 'sdole@gmail.com', 'c', NULL),
(10, NULL, 'Ben', 'Avery', 'm', '1983-12-24', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', 'c', NULL),
(11, NULL, 'Arthur', 'Curry', 'm', '1975-12-15', '3304 Euclid Avenue', 'Miami', 'FL', 342219932, 'acurry@gmail.com', 'c', NULL),
(12, NULL, 'Diana', 'Price', 'f', '1980-08-22', '944 Green Street', 'Las Vegas', 'NV', 332048823, 'dprice@symaptico.com', 'c', NULL),
(13, NULL, 'Adam', 'Smith', 'm', '1995-01-31', '98435 Valencia Dr.', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', 'c', NULL),
(14, NULL, 'Judy', 'Sleen', 'f', '1970-03-22', '56343 Rover Ct.', 'Billings', 'MT', 672048823, 'jsleen@symaptico.com', 'c', NULL),
(15, NULL, 'Bill', 'Neiderheim', 'm', '1982-06-13', '43567 Netherland Blvd', 'South Bend', 'IN', 320219932, 'bneiderheim@comcast.net', 'c', NULL);
go

CREATE PROC dbo.CreatePersonSSN
AS
BEGIN

 DECLARE @salt binary(64);
 DECLARE @ran_num int;
 DECLARE @ssn binary(64);
 DECLARE @x INT, @y INT;
 SET @x = 1;

 SET @y=(select count(*) from dbo.person);

  WHILE (@x <= @y)
  BEGIN

  SET @salt=CRYPT_GEN_RANDOM(64);
  SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111;
  SET @ssn=HASHBYTES('SHA2_512', concat(@salt, @ran_num));

  update dbo.person
  set per_ssn=@ssn, per_salt=@salt
  where per_id=@x;

  SET @x = @x +1;

  END
END;
GO

exec dbo.CreatePersonSSN

-- slsrep
INSERT INTO dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
VALUES
(1, 100000, 60000, 1800, NULL),
(2, 80000, 35000, 3500, NULL),
(3, 150000, 84000, 9650, 'Great salesperson!'),
(4, 125000, 87000, 15300, NULL),
(5, 98000, 43000, 8750, NULL);
go

-- customer
INSERT INTO dbo.customer
(per_id, cus_balance, cus_total_sales, cus_notes)
VALUES
(6, 120, 14789, NULL),
(7, 98.46, 234.92, NULL),
(8, 0, 4578, 'Customer always pays on time.'),
(9, 981.73, 1672.38, 'High balance'),
(10, 541.23, 782.57, NULL),
(11, 251.02, 13782.96, 'Good customer'),
(12, 582.67, 963.12, 'Previously paid in full'),
(13, 121.67, 1057.45, 'Recent customer'),
(14, 765.43, 6789.42, 'Buys bulk quantities'),
(15, 304.39, 456.81, 'Has not purchased recently');
go

-- contact
INSERT INTO dbo.contact
(per_sid, per_cid, cnt_date, cnt_notes)
VALUES
(1, 6, '1999-01-01', NULL),
(2, 6, '2001-09-29', NULL),
(3, 7, '2002-08-15', NULL),
(2, 7, '2002-09-01', NULL),
(4, 7, '2004-01-05', NULL),
(5, 8, '2004-02-28', NULL),
(4, 8, '2004-03-03', NULL),
(1, 9, '2004-04-07', NULL),
(5, 9, '2004-07-29', NULL),
(3, 11, '2005-05-02', NULL),
(4, 13, '2005-06-14', NULL),
(2, 15, '2005-07-02', NULL);
go

-- order
INSERT INTO dbo.[order]
(cnt_id, ord_placed_date, ord_filled_date, ord_notes)
VALUES
(11, '2010-11-23', '2010-12-24', NULL),
(2, '2005-03-19', '2005-07-28', NULL),
(3, '2011-07-01', '2011-07-06', NULL),
(4, '2009-12-24', '2010-01-05', NULL),
(5, '2008-09-21', '2008-11-26', NULL),
(6, '2009-04-17', '2009-04-30', NULL),
(7, '2010-05-31', '2010-06-07', NULL),
(8, '2007-09-02', '2007-09-16', NULL),
(9, '2011-12-08', '2011-12-13', NULL),
(10, '2012-02-29', '2012-05-02', NULL);
go

-- region
INSERT INTO dbo.region
(reg_name, reg_notes)
VALUES
('c', NULL),
('n', NULL),
('e', NULL),
('s', NULL),
('w', NULL);
go

-- state
INSERT INTO dbo.state
(reg_id, ste_name, ste_notes)
VALUES
(1, 'MI', null),
(3, 'IL', null),
(4, 'WA', null),
(5, 'FL', null),
(2, 'TX', null);
go

-- city
INSERT INTO dbo.city
(ste_id, cty_name, cty_notes)
VALUES
(1, 'Detroit', null),
(2, 'Aspen', null),
(2, 'Chicago', null),
(3, 'Clover', null),
(4, 'St. Louis', null);
go

-- store
INSERT INTO dbo.store
(cty_id, str_name, str_street, str_city, str_state, str_zip, str_phone, str_email, str_url, str_notes)
VALUES
(2, 'Walgreens', '14567 Walnut Ln', 'Aspen', 'IL', '475315690', '3127658127', 'info@walgreens.com', 'http://www.walgreens.com', NULL),
(3, 'CVS', '572 Casper Rd', 'Chicago', 'IL', '505231519', '3128926534', 'help@cvs.com', 'http://www.cvs.com', 'Rumor of merger.'),
(4, 'Lowes', '81309 Catapult Ave', 'Clover', 'WA', '802345671', '9017653421', 'sales@lowes.com', 'http://www.lowes.com', NULL),
(5, 'Walmart', '14567 Walnut Ln', 'St. Louis', 'FL', '387563628', '8722718923', 'info@walmart.com', 'http://www.walmart.com', NULL),
(1, 'Dollar General', '47583 Davison Rd', 'Detroit', 'MI', '482983456', '3137583492', 'ask@dollargeneral.com', 'http://www.dollargeneral.com', 'recently sold property.');
go

-- invoice
INSERT INTO dbo.invoice
(ord_id, str_id, inv_date, inv_total, inv_paid, inv_notes)
VALUES
(5, 1, '2001-05-03', 58.32, 0, NULL),
(4, 1, '2006-11-11', 100.59, 0, NULL),
(1, 1, '2010-09-16', 57.34, 0, NULL),
(3, 2, '2011-01-10', 99.32, 1, NULL),
(2, 3, '2008-06-24', 1109.67, 1, NULL),
(6, 4, '2009-04-20', 239.83, 0, NULL),
(7, 5, '2010-06-05', 537.29, 0, NULL),
(8, 2, '2007-09-09', 644.21, 1, NULL),
(9, 3, '2011-12-17', 944.12, 1, NULL),
(10, 4, '2012-03-18', 27.45, 0, NULL);
go

-- vendor
INSERT INTO dbo.vendor
(ven_name, ven_street, ven_city, ven_state, ven_zip, ven_phone, ven_email, ven_url, ven_notes)
VALUES
('Sysco', '531 Dolphin Run', 'Orlando', 'FL', '344761234', '7641238543','sales@sysco.com', 'htp://www.sysco.com', NULL),
('General Electric', '100 Happy Trails Dr', 'Boston', 'MA', '123458743', '2134569641', 'support@ge.com', 'http://www.ge.com', 'very good turnaround'),
('Cisco', '300 Cisco Dr', 'Stanford', 'OR', '872315492', '7823456723', 'cisco@cisco.com', 'http://www.cisco.com', NULL),
('Goodyear', '100 Goodyear Dr.', 'Gary', 'IN', '485321956', '5784218427', 'sales@goodyear.com', 'http://www.goodyear.com', 'competing well with Firestone'),
('Snap-On', '42185 Magenta Ave', 'Lake Falls', 'ND', '387513649', '9197345632', 'support@snapon.com', 'http://www.snap-on.com', 'good quality tools');
go

-- product
INSERT INTO dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
VALUES
(1, 'hammer', '', 2.5, 45, 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2,'screwdriver', '', 1.8, 120, 1.99, 3.49, NULL, NULL),
(4, 'pail', '16 Gallon', 2.8, 48, 3.89, 7.99, 40, NULL),
(5, 'cooking oil', 'Peanut oil', 15, 19, 19.99, 28.99, NULL, 'gallons'),
(3, 'frying pan', '', 3.5, 178, 8.45, 13.99, 50, 'currently 1/2 price sale');
go

-- order_line
INSERT INTO dbo.order_line
(ord_id, pro_id, oln_qty, oln_price, oln_notes)
VALUES
(1, 2, 10, 8.0, NULL),
(2, 3, 7, 9.88, NULL),
(3, 4, 3, 6.99, NULL),
(5, 1, 2, 12.76, NULL),
(4, 5, 13, 58.99, NULL);
go

-- payment
INSERT INTO dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
VALUES
(15, '2008-07-01', 5.99, NULL),
(14, '2010-09-28', 4.99, NULL),
(11, '2008-07-23', 8.75, NULL),
(13, '2010-10-31', 19.55, NULL),
(12, '2011-03-29', 32.5, NULL),
(16, '2010-10-03', 20.00, NULL),
(8, '2008-08-09', 1000.00, NULL),
(9, '2009-01-10', 103.68, NULL),
(7, '2007-03-15', 25.00, NULL),
(10, '2007-05-12', 40.00, NULL),
(14, '2007-05-22', 9.33, NULL);
go

-- product_hist
INSERT INTO dbo.product_hist
(pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
VALUES
(1, '2005-01-02 11:53:34', 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, '2005-02-03 09:13:56', 1.99, 3.49, NULL, NULL),
(3, '2005-03-04 23:21:49', 3.89, 7.99, 40, NULL),
(4, '2006-05-06 18:09:04', 19.99, 28.99, NULL, 'gallons'),
(5, '2006-05-07 15:07:29', 8.45, 13.99, 50, 'currently 1/2 price sale.');
go

-- srp_hist
INSERT INTO dbo.srp_hist
(per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
VALUES
(1, 'i', getDate(), SYSTEM_USER, getDate(), 100000, 110000, 11000, NULL),
(4, 'i', getDate(), SYSTEM_USER, getDate(), 150000, 175000, 17500, NULL),
(3, 'u', getDate(), SYSTEM_USER, getDate(), 200000, 185000, 18500, NULL),
(2, 'u', getDate(), ORIGINAL_LOGIN(), getDate(), 210000, 220000, 22000, NULL),
(5, 'i', getDate(), ORIGINAL_LOGIN(), getDate(), 225000, 230000, 2300, NULL);
go

-- phone
INSERT INTO dbo.phone
(per_id, phn_num, phn_type, phn_notes)
VALUES
(5, 1547856931, 'h', NULL),
(6, 5478532563, 'h', NULL),
(7, 4125785692, 'w', NULL),
(8, 4587458585, 'f', NULL),
(9, 3258965877, 'c', NULL);
go

-- time
INSERT INTO dbo.time
(tim_yr, tim_qtr, tim_month, tim_week, tim_day, tim_time, tim_notes)
VALUES
(2008, 2, 5, 19, 7, '11:59:59', null),
(2010, 4, 12, 49, 4, '08:34:21', null),
(1999, 4, 12, 52, 5, '05:21:34', null),
(2011, 3, 8, 36, 1, '09:32:18', null),
(2001, 3, 7, 27, 2, '23:35:32', null),
(2008, 1, 1, 5, 4, '04:22:36', null),
(2010, 2, 4, 14, 5, '02:49:11', null),
(2014, 1, 2, 8, 2, '12:27:14', null),
(2013, 3, 9, 38, 4, '10:12:28', null),
(2012, 4, 11, 47, 3, '22:36:22', null),
(2014, 2, 6, 23, 3, '19:07:10', null);
go

-- sale
INSERT INTO dbo.sale
(pro_id, str_id, cnt_id, tim_id, sal_qty, sal_price, sal_total, sal_notes)
VALUES
(1, 5, 5, 3, 20, 9.99, 199.8, null),
(2, 4, 6, 2, 5, 5.99, 29.95, null),
(3, 3, 4, 1, 30, 3.99, 19.7, null),
(4, 2, 1, 5, 15, 18.99, 284.85, null),
(5, 1, 2, 4, 6, 11.9, 71.94, null),
(5, 2, 5, 6, 10, 9.99, 199.8, null),
(4, 3, 6, 7, 5, 5.99, 29.95, null),
(3, 1, 4, 8, 30, 3.99, 119.7, null),
(2, 3, 1, 9, 15, 18.99, 284.85, null),
(1, 4, 2, 10, 6, 11.99, 71.94, null),
(1, 2, 3, 11, 10, 11.99, 119.9, null),
(3, 5, 1, 8, 20, 13.99, 140.9, null),
(1, 2, 4, 5, 10, 7.99, 20.9, null),
(5, 4, 1, 10, 15, 8.99, 12.9, null),
(2, 3, 5, 11, 20, 10.99, 115.5, null),
(5, 2, 6, 9, 6, 3.99, 18.99, null),
(3, 4, 2, 5, 30, 12.99, 220.9, null),
(4, 3, 2, 6, 10, 3.99, 14.99, null),
(1, 2, 5, 11, 20, 4.99, 15.90, null),
(5, 3, 4, 8, 15, 2.99, 8.99, null),
(2, 5, 6, 10, 10, 11.99, 285.9, null),
(3, 4, 1, 3, 30, 50.99, 280.5, null),
(1, 3, 2, 5, 20, 5.99, 20.99, null),
(4, 3, 6, 9, 10, 7.99, 13.99, null),
(5, 4, 1, 7, 20, 8.99, 20.50, null);
go

select * from dbo.phone;
select * from dbo.customer;
select * from dbo.person;
select * from dbo.srp_hist;
select * from dbo.contact;
select * from dbo.slsrep;
select * from dbo.srp_hist;
select * from dbo.[order];
select * from dbo.order_line;
select * from dbo.invoice;
select * from dbo.payment;
select * from dbo.store;
select * from dbo.vendor;
select * from dbo.product;
select * from dbo.product_hist;
select * from dbo.city;
select * from dbo.state;
select * from dbo.region;
select * from dbo.sale;
select * from dbo.time;