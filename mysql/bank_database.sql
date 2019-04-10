-- Bank Database Creation

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema bdl16
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bdl16` ;

-- -----------------------------------------------------
-- Schema bdl16
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bdl16` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `bdl16` ;

-- -----------------------------------------------------
-- Table `bdl16`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`user` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`user` (
  `usr_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `usr_fname` VARCHAR(15) NOT NULL,
  `usr_lname` VARCHAR(30) NOT NULL,
  `usr_street` VARCHAR(30) NOT NULL,
  `usr_city` VARCHAR(30) NOT NULL,
  `usr_state` CHAR(2) NOT NULL,
  `usr_zip` INT UNSIGNED ZEROFILL NOT NULL,
  `usr_phone` BIGINT UNSIGNED NOT NULL,
  `usr_email` VARCHAR(100) NULL,
  `usr_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`usr_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`institution`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`institution` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`institution` (
  `ins_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ins_name` VARCHAR(30) NOT NULL,
  `ins_street` VARCHAR(30) NOT NULL,
  `ins_city` VARCHAR(30) NOT NULL,
  `ins_state` CHAR(2) NOT NULL,
  `ins_zip` INT UNSIGNED ZEROFILL NOT NULL,
  `ins_phone` BIGINT UNSIGNED NOT NULL,
  `ins_email` VARCHAR(100) NOT NULL,
  `ins_url` VARCHAR(100) NOT NULL,
  `ins_contact` VARCHAR(45) NULL COMMENT 'person\'s full name',
  `ins_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`ins_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`account` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`account` (
  `act_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `act_type` VARCHAR(20) NOT NULL,
  `act_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`act_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`source` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`source` (
  `src_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `usr_id` TINYINT UNSIGNED NOT NULL,
  `ins_id` TINYINT UNSIGNED NOT NULL,
  `act_id` TINYINT UNSIGNED NOT NULL,
  `src_start_date` DATE NOT NULL,
  `src_end_date` DATE NULL,
  `src_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`src_id`),
  INDEX `fk_source_user_idx` (`usr_id` ASC),
  INDEX `fk_source_institution1_idx` (`ins_id` ASC),
  INDEX `fk_source_account1_idx` (`act_id` ASC),
  UNIQUE INDEX `ux_usr_ins_act` (`usr_id` ASC, `act_id` ASC, `ins_id` ASC),
  CONSTRAINT `fk_source_user`
    FOREIGN KEY (`usr_id`)
    REFERENCES `bdl16`.`user` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_source_institution1`
    FOREIGN KEY (`ins_id`)
    REFERENCES `bdl16`.`institution` (`ins_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_source_account1`
    FOREIGN KEY (`act_id`)
    REFERENCES `bdl16`.`account` (`act_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`category` (
  `cat_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cat_type` ENUM('salary', 'bonus', 'pension', 'social security', 'unemployment', 'disability', 'royalty', 'interest', 'dividend', 'tax return', 'gift', 'child support', 'alimony', 'award', 'grant', 'scholarship', 'inheritance', 'housing', 'food', 'transportation', 'charity', 'investment', 'insurance', 'clothing', 'saving', 'health', 'personal', 'recreation', 'debt', 'school', 'childcare', 'misc') NOT NULL,
  `cat_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`cat_id`),
  UNIQUE INDEX `cat_type_UNIQUE` (`cat_type` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`transaction` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`transaction` (
  `trn_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `src_id` SMALLINT UNSIGNED NOT NULL,
  `cat_id` TINYINT UNSIGNED NOT NULL,
  `trn_type` ENUM('credit', 'debit') NOT NULL,
  `trn_method` VARCHAR(15) NOT NULL COMMENT 'for example, atm, pos, check number, transfer, bank, etc.',
  `trn_amt` DECIMAL(7,2) UNSIGNED NOT NULL,
  `trn_date` DATETIME NOT NULL,
  `trn_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`trn_id`),
  INDEX `fk_transaction_source1_idx` (`src_id` ASC),
  INDEX `fk_transaction_category1_idx` (`cat_id` ASC),
  CONSTRAINT `fk_transaction_source1`
    FOREIGN KEY (`src_id`)
    REFERENCES `bdl16`.`source` (`src_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_category1`
    FOREIGN KEY (`cat_id`)
    REFERENCES `bdl16`.`category` (`cat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `bdl16`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`user` (`usr_id`, `usr_fname`, `usr_lname`, `usr_street`, `usr_city`, `usr_state`, `usr_zip`, `usr_phone`, `usr_email`, `usr_notes`) VALUES (DEFAULT, 'Tom', 'Petty', '523 West Road', 'Birmingham', 'AL', 254785698, 3698547412, 'tpetty@gmail.com', NULL);
INSERT INTO `bdl16`.`user` (`usr_id`, `usr_fname`, `usr_lname`, `usr_street`, `usr_city`, `usr_state`, `usr_zip`, `usr_phone`, `usr_email`, `usr_notes`) VALUES (DEFAULT, 'Joe', 'Smith', '4778 North Street', 'Pensacola', 'FL', 521423658, 2545889654, NULL, NULL);
INSERT INTO `bdl16`.`user` (`usr_id`, `usr_fname`, `usr_lname`, `usr_street`, `usr_city`, `usr_state`, `usr_zip`, `usr_phone`, `usr_email`, `usr_notes`) VALUES (DEFAULT, 'Rachael', 'Johnson', '514 South Avenue', 'San Diego', 'CA', 125469866, 2369556854, NULL, 'asf;l kasf; asklf laksjf klsf');
INSERT INTO `bdl16`.`user` (`usr_id`, `usr_fname`, `usr_lname`, `usr_street`, `usr_city`, `usr_state`, `usr_zip`, `usr_phone`, `usr_email`, `usr_notes`) VALUES (DEFAULT, 'Alyssa', 'Watkins', '853 East Road', 'Orlando', 'FL', 236545856, 5478563258, 'awatkins@aol.com', NULL);
INSERT INTO `bdl16`.`user` (`usr_id`, `usr_fname`, `usr_lname`, `usr_street`, `usr_city`, `usr_state`, `usr_zip`, `usr_phone`, `usr_email`, `usr_notes`) VALUES (DEFAULT, 'Tim', 'Wright', '563 Blue Court', 'New York', 'NY', 147412563, 1254774585, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`institution`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`institution` (`ins_id`, `ins_name`, `ins_street`, `ins_city`, `ins_state`, `ins_zip`, `ins_phone`, `ins_email`, `ins_url`, `ins_contact`, `ins_notes`) VALUES (DEFAULT, 'Bank of America', '123 Bank Road', 'Orlando', 'FL', 324756987, 4023657856, 'boa@gmail.com', 'www.boa.com', '', 'alskf alksfj lasfj alksfj ');
INSERT INTO `bdl16`.`institution` (`ins_id`, `ins_name`, `ins_street`, `ins_city`, `ins_state`, `ins_zip`, `ins_phone`, `ins_email`, `ins_url`, `ins_contact`, `ins_notes`) VALUES (DEFAULT, 'Wells Fargo', '751 Orange Street', 'Atlanta', 'GA', 125456983, 5875699654, 'wellsfargo@aol.com', 'www.wellsfargo.com', 'John Smith', 'aslkfj asklf jalsf');
INSERT INTO `bdl16`.`institution` (`ins_id`, `ins_name`, `ins_street`, `ins_city`, `ins_state`, `ins_zip`, `ins_phone`, `ins_email`, `ins_url`, `ins_contact`, `ins_notes`) VALUES (DEFAULT, 'Chase', '128 Grove Street', 'Los Angeles', 'CA', 254785369, 2036556969, 'chasebank@yahoo.com', 'www.chasebank.com', NULL, NULL);
INSERT INTO `bdl16`.`institution` (`ins_id`, `ins_name`, `ins_street`, `ins_city`, `ins_state`, `ins_zip`, `ins_phone`, `ins_email`, `ins_url`, `ins_contact`, `ins_notes`) VALUES (DEFAULT, 'Wells Fargo', '2045 Write Avenue', 'Winter Park', 'FL', 125463698, 2452554125, 'wellsfargo@aol.com', 'www.wellsfargo.com', NULL, NULL);
INSERT INTO `bdl16`.`institution` (`ins_id`, `ins_name`, `ins_street`, `ins_city`, `ins_state`, `ins_zip`, `ins_phone`, `ins_email`, `ins_url`, `ins_contact`, `ins_notes`) VALUES (DEFAULT, 'Chase', '885 Blue Road', 'Salt Lake City', 'UT', 425369875, 2012033656, 'chasebank@yahoo.com', 'www.chasebank.com', NULL, 'alskjf laskfj lasfjk l');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`account`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`account` (`act_id`, `act_type`, `act_notes`) VALUES (DEFAULT, 'saving', 'asf lajsf ljsaf ');
INSERT INTO `bdl16`.`account` (`act_id`, `act_type`, `act_notes`) VALUES (DEFAULT, 'checking', NULL);
INSERT INTO `bdl16`.`account` (`act_id`, `act_type`, `act_notes`) VALUES (DEFAULT, 'mortgage', 'alsfj aslkf jfs ');
INSERT INTO `bdl16`.`account` (`act_id`, `act_type`, `act_notes`) VALUES (DEFAULT, 'loans', NULL);
INSERT INTO `bdl16`.`account` (`act_id`, `act_type`, `act_notes`) VALUES (DEFAULT, 'investment', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`source`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`source` (`src_id`, `usr_id`, `ins_id`, `act_id`, `src_start_date`, `src_end_date`, `src_notes`) VALUES (DEFAULT, 2, 1, 2, '2008-05-15', '2016-12-05', NULL);
INSERT INTO `bdl16`.`source` (`src_id`, `usr_id`, `ins_id`, `act_id`, `src_start_date`, `src_end_date`, `src_notes`) VALUES (DEFAULT, 5, 2, 1, '2018-10-12', NULL, 'vljafsl kjafoiqif jq');
INSERT INTO `bdl16`.`source` (`src_id`, `usr_id`, `ins_id`, `act_id`, `src_start_date`, `src_end_date`, `src_notes`) VALUES (DEFAULT, 3, 3, 3, '2016-02-14', NULL, NULL);
INSERT INTO `bdl16`.`source` (`src_id`, `usr_id`, `ins_id`, `act_id`, `src_start_date`, `src_end_date`, `src_notes`) VALUES (DEFAULT, 1, 4, 5, '2005-08-21', '2010-08-10', NULL);
INSERT INTO `bdl16`.`source` (`src_id`, `usr_id`, `ins_id`, `act_id`, `src_start_date`, `src_end_date`, `src_notes`) VALUES (DEFAULT, 4, 5, 4, '2015-04-05', NULL, 'qoweur iqwou ofl aflk ');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`category`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'salary', 'aslfjk asklf jaklsdfj alskf j');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'child support', 'salf kjslkf jaslf jasfl');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'food', NULL);
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'transportation', NULL);
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'health', 'aslfkj skfdj alskjfd saldjf klsf j');

COMMIT;

