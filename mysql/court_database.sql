-- P1 Database Creation

DROP TABLE IF EXISTS person;
CREATE TABLE IF NOT EXISTS person (
    per_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_ssn BINARY(64) NULL,
    per_salt binary(64) null COMMENT '*only* demo purposes - do *NOT* use *salt* in the name!',
    per_fname VARCHAR(15) not null,
    per_lname VARCHAR(30) not null,
    per_street VARCHAR(30) not null,
    per_city VARCHAR(30) not null,
    per_state char(2) not null,
    per_zip int(9) UNSIGNED ZEROFILL not null,
    per_email VARCHAR(100) not null,
    per_dob date not null,
    per_type enum('a','c','j') not null,
    per_notes VARCHAR(255) null,
    primary key (per_id),
    UNIQUE INDEX ux_per_ssn (per_ssn ASC)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS attorney;
CREATE TABLE IF NOT EXISTS attorney (
    per_id SMALLINT UNSIGNED not null,
    aty_start_date date not null,
    aty_end_date date null default null,
    aty_hourly_rate decimal(5,2) unsigned not null,
    aty_years_in_practice tinyint not null,
    aty_notes varchar(255) null default null,
    primary key (per_id),

    index idx_er_id (per_id ASC),

    CONSTRAINT fk_attorney_erson
     FOREIGN KEY (per_id)
     REFERENCES person (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS client;
CREATE TABLE IF NOT EXISTS client (
    per_id smallint unsigned not null,
    cli_notes varchar(255) null default null,
    primary key (per_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_client_person
     FOREIGN KEY (per_id)
     REFERENCES person (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS court;
CREATE TABLE IF NOT EXISTS court (
    crt_id tinyint unsigned not null AUTO_INCREMENT,
    crt_name varchar(45) not null,
    crt_street varchar(30) not null,
    crt_city varchar(30) not null,
    crt_state char(2) not null,
    crt_zip int(9) unsigned ZEROFILL not null,
    crt_phone bigint not null,
    crt_email varchar(100) not null,
    crt_url varchar(100) not null,
    crt_notes varchar(255) null,
    primary key (crt_id)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS judge;
CREATE TABLE IF NOT EXISTS judge (
    per_id smallint unsigned not null,
    crt_id tinyint unsigned null default null,
    jud_salary decimal(8,2) not null,
    jud_years_in_practice tinyint unsigned not null,
    jud_notes varchar(255) null default null,
    primary key (per_id),

    INDEX idx_per_id (per_id ASC),
    INDEX idx_crt_id (crt_id ASC),

    CONSTRAINT fk_judge_person
     FOREIGN KEY (per_id)
     REFERENCES person (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE,

     CONSTRAINT fk_judge_court
      FOREIGN KEY (crt_id)
      REFERENCES court (crt_id)
      ON DELETE NO ACTION
      ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS judge_hist;
CREATE TABLE IF NOT EXISTS judge_hist (
    jhs_id smallint unsigned not null AUTO_INCREMENT,
    per_id smallint unsigned not null,
    jhs_crt_id tinyint null,
    jhs_date timestamp not null default current_timestamp(),
    jhs_type enum('i','u','d') not null default 'i',
    jhs_salary decimal(8,2) not null,
    jhs_notes varchar(255) null,
    primary key (jhs_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_judge_hist_judge
     FOREIGN KEY (per_id)
     REFERENCES judge (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS `case`;
CREATE TABLE IF NOT EXISTS `case` (
    cse_id smallint unsigned not null AUTO_INCREMENT,
    per_id smallint unsigned not null,
    cse_type varchar(45) not null,
    cse_description TEXT not null,
    cse_start_date date not null,
    cse_end_date date null,
    cse_notes varchar(255) null,
    primary key (cse_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_court_case_judge
     FOREIGN KEY (per_id)
     REFERENCES judge (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS bar;
CREATE TABLE IF NOT EXISTS bar (
    bar_id tinyint unsigned not null AUTO_INCREMENT,
    per_id smallint unsigned not null,
    bar_name varchar(45) not null,
    bar_notes varchar(255) null,
    primary key (bar_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_bar_attorney
     FOREIGN KEY (per_id)
     REFERENCES attorney (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS specialty;
CREATE TABLE IF NOT EXISTS specialty (
    spc_id tinyint unsigned not null AUTO_INCREMENT,
    per_id smallint unsigned not null,
    spc_type varchar(45) not null,
    spc_notes varchar(255) null,
    primary key (spc_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_specialty_attorney
     FOREIGN KEY (per_id)
     REFERENCES attorney (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS assignment;
CREATE TABLE IF NOT EXISTS assignment (
    asn_id smallint unsigned not null AUTO_INCREMENT,
    per_cid smallint unsigned not null,
    per_aid smallint unsigned not null,
    cse_id smallint unsigned not null,
    asn_notes varchar(255) null,
    primary key (asn_id),

    INDEX idx_per_cid (per_cid ASC),
    INDEX idx_per_aid (per_aid ASC),
    INDEX idx_cse_id (cse_id ASC),

    UNIQUE INDEX ux_per_cid_per_aid_cse_id (per_cid ASC, per_aid ASC, cse_id ASC),

    CONSTRAINT fk_assign_case
     FOREIGN KEY (cse_id)
     REFERENCES `case` (cse_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE,

    CONSTRAINT fk_assignment_client
      FOREIGN KEY (per_cid)
      REFERENCES client (per_id)
      ON DELETE NO ACTION
      ON UPDATE CASCADE,

    CONSTRAINT fk_assignment_attorney
     FOREIGN KEY (per_aid)
     REFERENCES attorney (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

DROP TABLE IF EXISTS phone;
CREATE TABLE IF NOT EXISTS phone (
    phn_id smallint unsigned not null AUTO_INCREMENT,
    per_id smallint unsigned not null,
    phn_num bigint unsigned not null,
    phn_type enum('h','c','w','f') not null comment 'home, cell, work, fax',
    phn_notes varchar(255) null,
    primary key (phn_id),

    INDEX idx_per_id (per_id ASC),

    CONSTRAINT fk_phone_person
     FOREIGN KEY (per_id)
     REFERENCES person (per_id)
     ON DELETE NO ACTION
     ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

-- Data

-- person table
START TRANSACTION;

INSERT INTO person 
(per_id, per_ssn, per_salt, per_fname, per_lname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes)
VALUES
(NULL, NULL, NULL, 'Steve', 'Rogers', '437 Soutern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', '1923-10-03', 'c', NULL),
(NULL, NULL, NULL, 'Bruce', 'Wayne', '1007 Mountain Drive', 'Gotham', 'NY', 003208440, 'bwayne@knology.net', '1968-03-20', 'c', NULL),
(NULL, NULL, NULL, 'Peter', 'Parker', '20 Ingram Street', 'New York', 'NY', 102862341, 'pparker@msn.com', '1988-09-12', 'c', NULL),
(NULL, NULL, NULL, 'Jane', 'Thompson', '13563 Ocean View Drive', 'Seattle', 'WA', 032084409, 'jthompson@gmail.com', '1978-05-08', 'c', NULL),
(NULL, NULL, NULL, 'Debra', 'Steele', '543 Oak Ln', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', '1994-07-19', 'c', NULL),
(NULL, NULL, NULL, 'Tony', 'Stark', '332 Palm Avenue', 'Malibu', 'CA', 902638332, 'tstark@yahoo.com', '1972-05-04', 'a', NULL),
(NULL, NULL, NULL, 'Hank', 'Pymi', '2355 Brown Street', 'Cleveland', 'OH', 022348890, 'hpym@aol.com', '1980-08-28', 'a', NULL),
(NULL, NULL, NULL, 'Bob', 'Best', '4902 Avendale Avenue', 'Scottsdale', 'AZ', 872638332, 'bbest@yahoo.com', '1992-02-10', 'a', NULL),
(NULL, NULL, NULL, 'Sandra', 'Dole', '87912 Lawrence Ave', 'Atlanta', 'GA', 002348890, 'sdole@gmail.com', '1990-01-26', 'a', NULL),
(NULL, NULL, NULL, 'Ben', 'Avery', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', '1983-12-24', 'a', NULL),
(NULL, NULL, NULL, 'Arthur', 'Curry', '3304 Euclid Avenue', 'Miami', 'FL', 000219932, 'acurry@gmil.com', '1975-12-15', 'j', NULL),
(NULL, NULL, NULL, 'Diana', 'Price', '944 Green Street', 'Las Vegas', 'NV', 332048823, 'dprice@symaptico.com', '1980-08-22', 'j', NULL),
(NULL, NULL, NULL, 'Adam', 'Jurris', '98435 Valencia Dr.', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', '1995-01-31', 'j', NULL),
(NULL, NULL, NULL, 'Judy', 'Sleen', '56343 Rover Ct.', 'Billings', 'MT', 672048823, 'jsleen@ymapico.com', '1970-03-22', 'j', NULL),
(NULL, NULL, NULL, 'Bill', 'Neiderheim', '43567 Netherland Blvd', 'South Bend', 'IN', 320219932, 'bneiderheim@comcast.net', '1982-03-13', 'j', NULL);

COMMIT;

-- phone table
START TRANSACTION;

INSERT INTO phone
(phn_id, per_id, phn_num, phn_type, phn_notes)
VALUES
(NULL, 1, 8032288827, 'c', NULL),
(NULL, 2, 2052338293, 'h', NULL),
(NULL, 4, 1034325598, 'w', 'has two office numbers'),
(NULL, 5, 6402338494, 'w', NULL),
(NULL, 6, 5508329842, 'f', 'fax number not currently working'),
(NULL, 7, 8202052203, 'c', 'prefers home calls'),
(NULL, 8, 4008338294, 'h', NULL),
(NULL, 9, 7654328912, 'w', NULL),
(NULL, 10, 5463721984, 'f', 'work fax number'),
(NULL, 11, 4537821902, 'h', 'prefers cell phone calls'),
(NULL, 12, 7867821902, 'w', 'best number'),
(NULL, 13, 4537821654, 'w', 'call during lunch'),
(NULL, 14, 3721821902, 'c', 'prefers cell phone calls'),
(NULL, 15, 9217821945, 'f', 'use for faxing legal docs');

COMMIT;

-- client table
START TRANSACTION;

INSERT INTO client
(per_id, cli_notes)
VALUES
(1, NULL),
(2, NULL),
(3, NULL),
(4, NULL),
(5, NULL);

COMMIT;

-- attorney table
START TRANSACTION;

INSERT INTO attorney
(per_id, aty_start_date, aty_end_date, aty_hourly_rate, aty_years_in_practice, aty_notes)
VALUES
(6, '2006-06-12', NULL, 85, 5, NULL),
(7, '2003-08-20', NULL, 130, 28, NULL),
(8, '2009-12-12', NULL, 70, 17, NULL),
(9, '2008-06-08', NULL, 78, 13, NULL),
(10, '2011-09-12', NULL, 60, 24, NULL);

COMMIT;

-- bar table
START TRANSACTION;

INSERT INTO bar
(bar_id, per_id, bar_name, bar_notes)
VALUES
(NULL, 6, 'Florida bar', NULL),
(NULL, 7, 'Alabama bar', NULL),
(NULL, 8, 'Georgia bar', NULL),
(NULL, 9, 'Michigan bar', NULL),
(NULL, 10, 'South Carolina bar', NULL),
(NULL, 6, 'Montana bar', NULL),
(NULL, 7, 'Arizona bar', NULL),
(NULL, 8, 'Nevada bar', NULL),
(NULL, 9, 'New York bar', NULL),
(NULL, 10, 'New York bar', NULL),
(NULL, 6, 'Mississippi bar', NULL),
(NULL, 7, 'California bar', NULL),
(NULL, 8, 'Illinois bar', NULL),
(NULL, 9, 'Indiana bar', NULL),
(NULL, 10, 'Illinois bar', NULL),
(NULL, 6, 'Tallahassee bar', NULL),
(NULL, 7, 'Ocala bar', NULL),
(NULL, 8, 'Bay County bar', NULL),
(NULL, 9, 'Cincinatti bar', NULL);

COMMIT;

-- specialty table
START TRANSACTION;

INSERT INTO specialty
(spc_id, per_id, spc_type, spc_notes)
VALUES
(NULL, 6, 'business', NULL),
(NULL, 7, 'traffic', NULL),
(NULL, 8, 'bankruptcy', NULL),
(NULL, 9, 'insurance', NULL),
(NULL, 10, 'judicial', NULL),
(NULL, 6, 'environmental', NULL),
(NULL, 7, 'criminal', NULL),
(NULL, 8, 'real estate', NULL),
(NULL, 9, 'malpractice', NULL);

COMMIT;

-- court table
START TRANSACTION;

INSERT INTO court
(crt_id, crt_name, crt_street, crt_city, crt_state, crt_zip, crt_phone, crt_email, crt_url, crt_notes)
VALUES
(NULL, 'leon county circuit court', '301 south monroe street', 'tallahassee', 'fl', 323035292, 8506065504, 'lccc@us.fl.gov', 'http://www.leoncountycircuitcourt.gov/', NULL),
(NULL, 'leon county traffic court', '1921 thomasville road', 'tallahassee', 'fl', 323035292, 8505774100, 'lctc@us.fl.gov', 'http://www.leoncountytrafficcourt.gov/', NULL),
(NULL, 'florida supreme court', '500 south duval street', 'tallahassee', 'fl', 323035292, 8504880125, 'fsc@us.fl.gov', 'http://floridasupremecourt.org/', NULL),
(NULL, 'orange county courthouse', '424 north orange avenue', 'orlando', 'fl', 328012248, 4078362000, 'occ@us.fl.gov', 'http://www.ninthcircuit.org/', NULL),
(NULL, 'fifth district court of appeal', '300 south beach street', 'daytona beach', 'fl', 321158763, 3862258600, '5dca@us.fl.gov', 'http://www.5dca.org/', NULL);

COMMIT;

-- judge table
START TRANSACTION;

INSERT INTO judge
(per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
VALUES
(11, 5, 150000, 10, NULL),
(12, 4, 185000, 3, NULL),
(13, 4, 135000, 2, NULL),
(14, 3, 170000, 6, NULL),
(15, 1, 120000, 1, NULL);

COMMIT;

-- judge_hist table
START TRANSACTION;

INSERT INTO judge_hist
(jhs_id, per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
VALUES
(NULL, 11, 3, '2009-01-16', 'i', 130000, NULL),
(NULL, 12, 2, '2010-05-27', 'i', 140000, NULL),
(NULL, 13, 5, '2000-01-02', 'i', 115000, NULL),
(NULL, 13, 4, '2005-07-05', 'i', 135000, NULL),
(NULL, 14, 4, '2008-12-09', 'i', 155000, NULL),
(NULL, 15, 1, '2011-03-17', 'i', 120000, 'freshman justice'),
(NULL, 11, 5, '2010-07-05', 'i', 150000, 'assigned to another court'),
(NULL, 12, 4, '2012-10-08', 'i', 165000, 'became chief justice'),
(NULL, 14, 3, '2009-04-19', 'i', 170000, 'reassigned to court');

COMMIT;

-- case table
START TRANSACTION;

INSERT INTO `case`
(cse_id, per_id, cse_type, cse_description, cse_start_date, cse_end_date, cse_notes)
VALUES
(NULL, 13, 'civil', 'client says logo being used without consent', '2010-09-09', NULL, 'copyright infringement'),
(NULL, 12, 'criminal', 'client charged with assaulting husband', '2009-11-18', '2010-12-23', 'assault'),
(NULL, 14, 'civil', 'client broke ankle while shopping - no wet floor sign', '2008-05-06', '2008-07-23', 'slip and fall'),
(NULL, 11, 'criminal', 'client charged with stealing tvs', '2011-05-20', NULL, 'grand theft'),
(NULL, 13, 'criminal', 'client charged with possession of cocaine', '2011-06-05', NULL, 'possession of narcotics'),
(NULL, 14, 'civil', 'client alleges newspaper printed false info about him', '2007-01-19', '2007-05-20', 'defamation'),
(NULL, 12, 'criminal', 'client charged with murder of co-worker', '2010-03-20', NULL, 'murder'),
(NULL, 15, 'civil', 'client made the horrible mistake of selecting degree other than IT and had to declare bankruptcy', '2012-01-26', '2013-02-28', 'bankruptcy');

COMMIT;

-- assignment table
START TRANSACTION;

INSERT INTO assignment
(asn_id, per_cid, per_aid, cse_id, asn_notes)
VALUES
(NULL, 1, 6, 7, NULL),
(NULL, 2, 6, 6, NULL),
(NULL, 3, 7, 2, NULL),
(NULL, 4, 8, 2, NULL),
(NULL, 5, 9, 5, NULL),
(NULL, 1, 10, 1, NULL),
(NULL, 2, 6, 3, NULL),
(NULL, 3, 7, 8, NULL),
(NULL, 4, 8, 8, NULL),
(NULL, 5, 9, 8, NULL),
(NULL, 4, 10, 4, NULL);

COMMIT;

-- Populate person table with hashed and salted SSN
DROP PROCEDURE IF EXISTS CreatePersonSSN;
DELIMITER //
CREATE PROCEDURE CreatePersonSSN()
BEGIN
DECLARE x, y INT;
SET x = 1;

select count(*) into y from person;

WHILE x <= y DO
 SET @salt=RANDOM_BYTES(64);
 SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111;
 SET @ssn=unhex(sha2(concat(@salt, @ran_num), 512));

 update person
 set per_ssn=@ssn, per_salt=@salt
 where per_id=x;

 SET x = x + 1;

 END WHILE;

END//
DELIMITER ;
call CreatePersonSSN();