-- Library Database Creation

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
-- Table `bdl16`.`member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`member` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`member` (
  `mem_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mem_fname` VARCHAR(15) NOT NULL,
  `mem_lname` VARCHAR(30) NOT NULL,
  `mem_street` VARCHAR(30) NOT NULL,
  `mem_city` VARCHAR(30) NOT NULL,
  `mem_state` CHAR(2) NOT NULL,
  `mem_zip` INT UNSIGNED NOT NULL,
  `mem_phone` BIGINT UNSIGNED NOT NULL,
  `mem_email` VARCHAR(100) NULL,
  `mem_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`mem_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`publisher`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`publisher` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`publisher` (
  `pub_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pub_name` VARCHAR(45) NOT NULL,
  `pub_street` VARCHAR(30) NOT NULL,
  `pub_city` VARCHAR(30) NOT NULL,
  `pub_state` CHAR(2) NOT NULL,
  `pub_zip` INT UNSIGNED NOT NULL,
  `pub_phone` BIGINT UNSIGNED NOT NULL,
  `pub_email` VARCHAR(100) NOT NULL,
  `pub_url` VARCHAR(100) NOT NULL,
  `pub_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`pub_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`book` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`book` (
  `bok_isbn` VARCHAR(13) NOT NULL,
  `pub_id` SMALLINT UNSIGNED NOT NULL,
  `bok_title` VARCHAR(100) NOT NULL,
  `bok_pub_date` DATE NOT NULL,
  `bok_num_pages` SMALLINT UNSIGNED NOT NULL,
  `bok_cost` DECIMAL(5,2) UNSIGNED NOT NULL,
  `bok_price` DECIMAL(5,2) UNSIGNED NULL,
  `bok_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`bok_isbn`),
  INDEX `fk_book_publisher1_idx` (`pub_id` ASC),
  CONSTRAINT `fk_book_publisher1`
    FOREIGN KEY (`pub_id`)
    REFERENCES `bdl16`.`publisher` (`pub_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`loaner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`loaner` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`loaner` (
  `lon_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mem_id` SMALLINT UNSIGNED NOT NULL,
  `bok_isbn` VARCHAR(13) NOT NULL,
  `lon_loan_date` DATE NOT NULL,
  `lon_due_date` DATE NOT NULL,
  `lon_return_date` DATE NULL,
  `lon_late_fee` DECIMAL(5,2) NULL,
  `lon_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`lon_id`),
  INDEX `fk_loaner_member_idx` (`mem_id` ASC),
  INDEX `fk_loaner_book1_idx` (`bok_isbn` ASC),
  UNIQUE INDEX `ux_mem_id_book_isbn_lon_loan_date` (`mem_id` ASC, `bok_isbn` ASC, `lon_loan_date` ASC),
  CONSTRAINT `fk_loaner_member`
    FOREIGN KEY (`mem_id`)
    REFERENCES `bdl16`.`member` (`mem_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_loaner_book1`
    FOREIGN KEY (`bok_isbn`)
    REFERENCES `bdl16`.`book` (`bok_isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`author` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`author` (
  `aut_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `aut_fname` VARCHAR(15) NOT NULL,
  `aut_lname` VARCHAR(30) NOT NULL,
  `aut_street` VARCHAR(30) NOT NULL,
  `aut_city` VARCHAR(30) NOT NULL,
  `aut_state` CHAR(2) NOT NULL,
  `aut_zip` INT UNSIGNED NOT NULL,
  `aut_phone` BIGINT UNSIGNED NOT NULL,
  `aut_email` VARCHAR(100) NOT NULL,
  `aut_url` VARCHAR(100) NOT NULL,
  `aut_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`aut_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`attribution`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`attribution` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`attribution` (
  `att_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `aut_id` MEDIUMINT UNSIGNED NOT NULL,
  `bok_isbn` VARCHAR(13) NOT NULL,
  `att_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`att_id`),
  INDEX `fk_attribution_author1_idx` (`aut_id` ASC),
  INDEX `fk_attribution_book1_idx` (`bok_isbn` ASC),
  UNIQUE INDEX `ux_aut_id_book_isbn` (`aut_id` ASC, `bok_isbn` ASC),
  CONSTRAINT `fk_attribution_author1`
    FOREIGN KEY (`aut_id`)
    REFERENCES `bdl16`.`author` (`aut_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attribution_book1`
    FOREIGN KEY (`bok_isbn`)
    REFERENCES `bdl16`.`book` (`bok_isbn`)
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
  `cat_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cat_type` VARCHAR(45) NOT NULL,
  `cat_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`cat_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`book_cat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`book_cat` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`book_cat` (
  `bct_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `bok_isbn` VARCHAR(13) NOT NULL,
  `cat_id` SMALLINT UNSIGNED NOT NULL,
  `bct_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`bct_id`),
  INDEX `fk_book_cat_book1_idx` (`bok_isbn` ASC),
  INDEX `fk_book_cat_category1_idx` (`cat_id` ASC),
  UNIQUE INDEX `ux_book_isbn_cat_id` (`bok_isbn` ASC, `cat_id` ASC),
  CONSTRAINT `fk_book_cat_book1`
    FOREIGN KEY (`bok_isbn`)
    REFERENCES `bdl16`.`book` (`bok_isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_cat_category1`
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
-- Data for table `bdl16`.`member`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`member` (`mem_id`, `mem_fname`, `mem_lname`, `mem_street`, `mem_city`, `mem_state`, `mem_zip`, `mem_phone`, `mem_email`, `mem_notes`) VALUES (DEFAULT, 'John', 'Smith', '147 Elm Street', 'Miami', 'FL', 42178, 1234567890, 'jsmith@gmail.com', 'asldkjfa osi jfoasjdf asoifj siaofj');
INSERT INTO `bdl16`.`member` (`mem_id`, `mem_fname`, `mem_lname`, `mem_street`, `mem_city`, `mem_state`, `mem_zip`, `mem_phone`, `mem_email`, `mem_notes`) VALUES (DEFAULT, 'Ian', 'Steph', '456 Tuscany Trail', 'Orlando', 'FL', 32746, 5432167891, 'iansteph@aol.com', NULL);
INSERT INTO `bdl16`.`member` (`mem_id`, `mem_fname`, `mem_lname`, `mem_street`, `mem_city`, `mem_state`, `mem_zip`, `mem_phone`, `mem_email`, `mem_notes`) VALUES (DEFAULT, 'James', 'Marsh', '1020 Tennessee Street', 'Tallahassee', 'FL', 32304, 8508508501, 'jmarsh@yahoo.com', 'alsjfsoaif jasfoid jsafdoi jasifoj ');
INSERT INTO `bdl16`.`member` (`mem_id`, `mem_fname`, `mem_lname`, `mem_street`, `mem_city`, `mem_state`, `mem_zip`, `mem_phone`, `mem_email`, `mem_notes`) VALUES (DEFAULT, 'Ashley', 'Johnson', '345 Winter Road', 'Fort Lauderdale', 'FL', 43056, 7894561230, NULL, NULL);
INSERT INTO `bdl16`.`member` (`mem_id`, `mem_fname`, `mem_lname`, `mem_street`, `mem_city`, `mem_state`, `mem_zip`, `mem_phone`, `mem_email`, `mem_notes`) VALUES (DEFAULT, 'Sam', 'Teague', '7894 Orange Avenue', 'Orlando', 'FL', 32714, 3216547895, 'samt@gmail.com', 'alskfj lsafkj oisadfj oiasj f');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`publisher`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`publisher` (`pub_id`, `pub_name`, `pub_street`, `pub_city`, `pub_state`, `pub_zip`, `pub_phone`, `pub_email`, `pub_url`, `pub_notes`) VALUES (DEFAULT, 'Best Publishing', '1123 Ward Street', 'New York', 'NY', 45678, 1238546810, 'bestpublishing@gmail.com', 'bestpublishing.com', 'lfsakjfd aosfj oasfdj iaosf j');
INSERT INTO `bdl16`.`publisher` (`pub_id`, `pub_name`, `pub_street`, `pub_city`, `pub_state`, `pub_zip`, `pub_phone`, `pub_email`, `pub_url`, `pub_notes`) VALUES (DEFAULT, 'Publishing 101', '452 Strong Road', 'St. Augustine', 'FL', 32568, 5467894585, 'publishing101@aol.com', 'publishing101.com', NULL);
INSERT INTO `bdl16`.`publisher` (`pub_id`, `pub_name`, `pub_street`, `pub_city`, `pub_state`, `pub_zip`, `pub_phone`, `pub_email`, `pub_url`, `pub_notes`) VALUES (DEFAULT, 'Publish For You', '726 Walker Avenue', 'Jupiter', 'FL', 45672, 5467125478, 'publishforyou@yahoo.com', 'publishforyou.com', 'lkasjf soijf siojf iasf');
INSERT INTO `bdl16`.`publisher` (`pub_id`, `pub_name`, `pub_street`, `pub_city`, `pub_state`, `pub_zip`, `pub_phone`, `pub_email`, `pub_url`, `pub_notes`) VALUES (DEFAULT, 'We Publish Books', '512 Truman Street', 'Winter Park', 'FL', 32789, 7418526985, 'wepublishbooks@gmail.com', 'wepublishbooks.com', 'lfasjfa lskjfalksdj ');
INSERT INTO `bdl16`.`publisher` (`pub_id`, `pub_name`, `pub_street`, `pub_city`, `pub_state`, `pub_zip`, `pub_phone`, `pub_email`, `pub_url`, `pub_notes`) VALUES (DEFAULT, 'Penguin Publishers', '1258 Terry Road', 'Vero Beach', 'FL', 54217, 4256985312, 'penguinpublishers@aol.com', 'penguinpublishers.com', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`book`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`book` (`bok_isbn`, `pub_id`, `bok_title`, `bok_pub_date`, `bok_num_pages`, `bok_cost`, `bok_price`, `bok_notes`) VALUES ('1234567891234', 2, 'Last Shot', '2004-05-23', 256, 035.56, 042.34, 'laksjf asofi jasofi jasoidf j');
INSERT INTO `bdl16`.`book` (`bok_isbn`, `pub_id`, `bok_title`, `bok_pub_date`, `bok_num_pages`, `bok_cost`, `bok_price`, `bok_notes`) VALUES ('1234567891235', 4, 'Information Technologies', '2008-12-14', 745, 123.84, 138.25, 'fask fjasoif fiop qwoieuf pqoi');
INSERT INTO `bdl16`.`book` (`bok_isbn`, `pub_id`, `bok_title`, `bok_pub_date`, `bok_num_pages`, `bok_cost`, `bok_price`, `bok_notes`) VALUES ('1234567891236', 3, 'War Zone', '2012-06-21', 388, 045.34, NULL, 'flaksj faoifsj ioasjf oajf ioasfj');
INSERT INTO `bdl16`.`book` (`bok_isbn`, `pub_id`, `bok_title`, `bok_pub_date`, `bok_num_pages`, `bok_cost`, `bok_price`, `bok_notes`) VALUES ('1234567891237', 5, 'Financial Accounting', '2001-10-24', 655, 212.46, 245.78, NULL);
INSERT INTO `bdl16`.`book` (`bok_isbn`, `pub_id`, `bok_title`, `bok_pub_date`, `bok_num_pages`, `bok_cost`, `bok_price`, `bok_notes`) VALUES ('1234567891238', 5, 'Accounting 101', '2003-05-10', 465, 145.35, 156.78, 'lksajdf aosfij asofdj asoidf j');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`loaner`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`loaner` (`lon_id`, `mem_id`, `bok_isbn`, `lon_loan_date`, `lon_due_date`, `lon_return_date`, `lon_late_fee`, `lon_notes`) VALUES (DEFAULT, 3, '1234567891234', '2017-12-15', '2018-01-06', '2018-01-03', NULL, 'alskfj soif jasfo jsaf oiasjf ioj');
INSERT INTO `bdl16`.`loaner` (`lon_id`, `mem_id`, `bok_isbn`, `lon_loan_date`, `lon_due_date`, `lon_return_date`, `lon_late_fee`, `lon_notes`) VALUES (DEFAULT, 1, '1234567891235', '2018-05-20', '2018-06-14', '2018-06-22', 012.46, 'ljfoiasj foiaj fpoqi jfoq');
INSERT INTO `bdl16`.`loaner` (`lon_id`, `mem_id`, `bok_isbn`, `lon_loan_date`, `lon_due_date`, `lon_return_date`, `lon_late_fee`, `lon_notes`) VALUES (DEFAULT, 2, '1234567891236', '2019-02-14', '2019-03-02', NULL, NULL, NULL);
INSERT INTO `bdl16`.`loaner` (`lon_id`, `mem_id`, `bok_isbn`, `lon_loan_date`, `lon_due_date`, `lon_return_date`, `lon_late_fee`, `lon_notes`) VALUES (DEFAULT, 2, '1234567891237', '2018-08-24', '2018-09-12', '2018-09-06', NULL, 'asldfkj saf ojisof asfoi jsaof ji');
INSERT INTO `bdl16`.`loaner` (`lon_id`, `mem_id`, `bok_isbn`, `lon_loan_date`, `lon_due_date`, `lon_return_date`, `lon_late_fee`, `lon_notes`) VALUES (DEFAULT, 5, '1234567891238', '2017-04-02', '2017-04-30', '2017-05-25', 024.89, 'kaljsdf aosjf aisofj asifod j');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`author`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`author` (`aut_id`, `aut_fname`, `aut_lname`, `aut_street`, `aut_city`, `aut_state`, `aut_zip`, `aut_phone`, `aut_email`, `aut_url`, `aut_notes`) VALUES (DEFAULT, 'Tom', 'Merlin', '412 Author Road', 'Orlando', 'FL', 25468, 3256984571, 'tmerlin@gmail.com', 'tmerlin.com', 'alksjfaklsjf alksjf kalsjdf');
INSERT INTO `bdl16`.`author` (`aut_id`, `aut_fname`, `aut_lname`, `aut_street`, `aut_city`, `aut_state`, `aut_zip`, `aut_phone`, `aut_email`, `aut_url`, `aut_notes`) VALUES (DEFAULT, 'James', 'Earl', '325 Timber Creek Drive', 'Orlando', 'FL', 24587, 7412546983, 'jearl@aol.com', 'jearl.com', 'lsakjdf asoif ajsfod iajsf oi');
INSERT INTO `bdl16`.`author` (`aut_id`, `aut_fname`, `aut_lname`, `aut_street`, `aut_city`, `aut_state`, `aut_zip`, `aut_phone`, `aut_email`, `aut_url`, `aut_notes`) VALUES (DEFAULT, 'Jessica', 'Stone', '569 Creek Avenue', 'Tallahassee', 'FL', 32303, 8502146857, 'jstone@yahoo.com', 'jstone.com', 'lskjf aslfk ajsf klajsdflk j');
INSERT INTO `bdl16`.`author` (`aut_id`, `aut_fname`, `aut_lname`, `aut_street`, `aut_city`, `aut_state`, `aut_zip`, `aut_phone`, `aut_email`, `aut_url`, `aut_notes`) VALUES (DEFAULT, 'Hannah', 'Watkins', '8754 String Road', 'Maitland', 'FL', 32714, 4075248796, 'hwatkins@gmail.com', 'hwatkins.com', NULL);
INSERT INTO `bdl16`.`author` (`aut_id`, `aut_fname`, `aut_lname`, `aut_street`, `aut_city`, `aut_state`, `aut_zip`, `aut_phone`, `aut_email`, `aut_url`, `aut_notes`) VALUES (DEFAULT, 'Rachael', 'Martin', '452 Shadow Street', 'Pensacola', 'FL', 32845, 5486387965, 'rmartin@aol.com', 'rmartin.com', 'flaskj faosif jasofj asidof ');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`attribution`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`attribution` (`att_id`, `aut_id`, `bok_isbn`, `att_notes`) VALUES (DEFAULT, 4, '1234567891234', 'flaksjf aosifj asfo ijafoji sf');
INSERT INTO `bdl16`.`attribution` (`att_id`, `aut_id`, `bok_isbn`, `att_notes`) VALUES (DEFAULT, 4, '1234567891235', NULL);
INSERT INTO `bdl16`.`attribution` (`att_id`, `aut_id`, `bok_isbn`, `att_notes`) VALUES (DEFAULT, 1, '1234567891236', 'lkasjf ioasjf oiasjf dioj');
INSERT INTO `bdl16`.`attribution` (`att_id`, `aut_id`, `bok_isbn`, `att_notes`) VALUES (DEFAULT, 2, '1234567891237', 'alskdj fasoif jasiof ');
INSERT INTO `bdl16`.`attribution` (`att_id`, `aut_id`, `bok_isbn`, `att_notes`) VALUES (DEFAULT, 3, '1234567891238', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`category`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'Action', 'daslf aslkdfj asklf jas');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'Science Fiction', 'aslfd jasdkfl jasf');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'Romance', 'aslf jaslkfd jas');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'Comedy', 'sadlfjasfl jasldfkj asklfd');
INSERT INTO `bdl16`.`category` (`cat_id`, `cat_type`, `cat_notes`) VALUES (DEFAULT, 'Children\'s', 'aslkdf jasflk jsalkf jasklfj ');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`book_cat`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`book_cat` (`bct_id`, `bok_isbn`, `cat_id`, `bct_notes`) VALUES (DEFAULT, '1234567891234', 1, 'flaksj faklsdfj als');
INSERT INTO `bdl16`.`book_cat` (`bct_id`, `bok_isbn`, `cat_id`, `bct_notes`) VALUES (DEFAULT, '1234567891235', 5, 'salkfdj aslkf');
INSERT INTO `bdl16`.`book_cat` (`bct_id`, `bok_isbn`, `cat_id`, `bct_notes`) VALUES (DEFAULT, '1234567891236', 5, NULL);
INSERT INTO `bdl16`.`book_cat` (`bct_id`, `bok_isbn`, `cat_id`, `bct_notes`) VALUES (DEFAULT, '1234567891237', 3, 'aslfdj aklsdjf akls');
INSERT INTO `bdl16`.`book_cat` (`bct_id`, `bok_isbn`, `cat_id`, `bct_notes`) VALUES (DEFAULT, '1234567891238', 2, 'laksdjf asklfdj aosfd ji');

COMMIT;

