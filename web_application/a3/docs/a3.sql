-- MySQL Workbench Forward Engineering

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
-- Table `bdl16`.`petstore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`petstore` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`petstore` (
  `pst_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pst_name` VARCHAR(30) NOT NULL,
  `pst_street` VARCHAR(30) NOT NULL,
  `pst_city` VARCHAR(30) NOT NULL,
  `pst_state` CHAR(2) NOT NULL,
  `pst_zip` INT(9) UNSIGNED NOT NULL,
  `pst_phone` BIGINT UNSIGNED NOT NULL,
  `pst_email` VARCHAR(100) NOT NULL,
  `pst_url` VARCHAR(100) NOT NULL,
  `pst_ytd_sales` DECIMAL(10,2) NOT NULL,
  `pst_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`pst_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`customer` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`customer` (
  `cus_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cus_fname` VARCHAR(15) NOT NULL,
  `cus_lname` VARCHAR(30) NOT NULL,
  `cus_street` VARCHAR(30) NOT NULL,
  `cus_city` VARCHAR(30) NOT NULL,
  `cus_state` CHAR(2) NOT NULL,
  `cus_zip` INT UNSIGNED NOT NULL,
  `cus_phone` BIGINT UNSIGNED NOT NULL,
  `cus_email` VARCHAR(100) NOT NULL,
  `cus_balance` DECIMAL(6,2) NOT NULL,
  `cus_total_sales` DECIMAL(6,2) NOT NULL,
  `cus_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`cus_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bdl16`.`pet`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bdl16`.`pet` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `bdl16`.`pet` (
  `pet_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pst_id` SMALLINT UNSIGNED NOT NULL,
  `cus_id` SMALLINT UNSIGNED NULL,
  `pet_type` VARCHAR(45) NOT NULL,
  `pet_sex` ENUM('m', 'f') NOT NULL,
  `pet_cost` DECIMAL(6,2) NOT NULL,
  `pet_price` DECIMAL(6,2) NOT NULL,
  `pet_age` TINYINT NOT NULL,
  `pet_color` VARCHAR(30) NOT NULL,
  `pet_sale_date` DATE NULL,
  `pet_vaccine` ENUM('y', 'n') NOT NULL,
  `pet_neuter` ENUM('y', 'n') NOT NULL,
  `pet_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`pet_id`),
  INDEX `fk_pet_petstore_idx` (`pst_id` ASC),
  INDEX `fk_pet_customer1_idx` (`cus_id` ASC),
  CONSTRAINT `fk_pet_petstore`
    FOREIGN KEY (`pst_id`)
    REFERENCES `bdl16`.`petstore` (`pst_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pet_customer1`
    FOREIGN KEY (`cus_id`)
    REFERENCES `bdl16`.`customer` (`cus_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `bdl16`.`petstore`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Pet Land', '124 Corner Street', 'Orlando', 'FL', 652168795, 1025485425, 'petland@gmail.com', 'petland.com', 12365478.65, 'ldkjaf skljf oas');
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Petco', '4587 South Road', 'Tallahassee', 'FL', 458755554, 2013665854, 'petco@aol.com', 'petco.com', 24587958.22, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Pets R Here', '564 Red Avenue', 'Winter Park', 'FL', 231546875, 5854548525, 'petsrhere@yahoo.com', 'petsrhere.com', 13254786.95, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Pet Core', '982 Blue Street', 'Maitland', 'FL', 215632168, 2354856956, 'petcore@gmail.com', 'petcore.com', 36578941.22, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'We Love Pets', '124 White Creek', 'Timber Creek', 'FL', 123468745, 2547851245, 'welovepets@yahoo.com', 'welovepets.com', 12456985.85, 'aslkf jslkfd jalskf ');
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Petsmart', '321 South Bend Road', 'Tallahassee', 'FL', 213584621, 2145875632, 'petsmart@gmail.com', 'petsmart.com', 35412684.22, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Dogs and Cats', '789 Purple Court', 'Orlando', 'FL', 456872135, 6896587453, 'dogsandcats@aol.com', 'dogsandcats.com', 54289654.34, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'We Have Pets', '7458 Orange Hollow', 'Naples', 'FL', 212125489, 6589654122, 'wehavepets@yahoo.com', 'wehavepets.com', 85236547.22, 'aslfkj salkf j');
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Pets 101', '412 North Street', 'Pensacola', 'FL', 313546879, 5478552358, 'pets101@gmail.com', 'pets101.com', 32541256.95, NULL);
INSERT INTO `bdl16`.`petstore` (`pst_id`, `pst_name`, `pst_street`, `pst_city`, `pst_state`, `pst_zip`, `pst_phone`, `pst_email`, `pst_url`, `pst_ytd_sales`, `pst_notes`) VALUES (DEFAULT, 'Animal House', '112 Yellow Road', 'Lakeland', 'FL', 123574596, 2158887456, 'animalhouse@aol.com', 'animalhouse.com', 74125478.85, 'aslkfjaslkfjldkfjslf jasljfd klasfdlj');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`customer`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'John', 'Smith', '215 Live Road', 'Orlando', 'FL', 321456875, 2546995412, 'jsmith@gmail.com', 0132.36, 1231.35, 'lajf klsajf lasjfd kl');
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Rebecca', 'Glatz', '8795 Rock Street', 'Tallahassee', 'FL', 124587459, 3250125547, 'rglatz@aol.com', 1256.35, 1852.45, 'asljf akls jdlaksfd j');
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Rachael', 'Stephenson', '741 Charcoal Avenue', 'Tallahassee', 'FL', 325469874, 2222225856, 'rsteph@yahoo.com', 0035.21, 0125.85, NULL);
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Sam', 'Watkins', '101 Pet Court', 'Naples', 'FL', 125896547, 1245874563, 'swatkins@gmail.com', 1258.25, 1856.36, 'laksjfd lksjf alksfd lkj');
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Jared', 'Pierce', '874 6th Street', 'Pensacola', 'FL', 325468541, 2589654714, 'jpierce@aol.com', 0085.35, 0153.74, NULL);
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Ron', 'Goldenberg', '321 South Avenue', 'Destin', 'FL', 236541258, 3251224569, 'rgoldenberg@yahoo.com', 1230.24, 1865.24, NULL);
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Robert', 'Care', '2456 Soft Road', 'Maitland', 'FL', 324875698, 1258885236, 'rcare@gmail.com', 1425.63, 1853.24, NULL);
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Elizabeth', 'Bloom', '875 Sing Road', 'Lakeland', 'FL', 123654741, 2145856963, 'ebloom@aol.com', 1536.85, 2156.11, 'afls jalk falskf jalskfj ');
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Ellie', 'Earl', '369 Guitar Street', 'Deland', 'FL', 123658965, 3256988565, 'eearl@gmail.com', 1742.36, 2001.01, NULL);
INSERT INTO `bdl16`.`customer` (`cus_id`, `cus_fname`, `cus_lname`, `cus_street`, `cus_city`, `cus_state`, `cus_zip`, `cus_phone`, `cus_email`, `cus_balance`, `cus_total_sales`, `cus_notes`) VALUES (DEFAULT, 'Grace', 'Kivett', '1352 Jazz Court', 'Winter Park', 'FL', 358965478, 3258456965, 'gkivett@yahoo.com', 1258.36, 1536.85, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bdl16`.`pet`
-- -----------------------------------------------------
START TRANSACTION;
USE `bdl16`;
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 1, 6, 'Dog', 'm', 0125.35, 0150.85, 1, 'Black', '2018-12-22', 'y', 'y', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 5, 5, 'Dog', 'f', 0088.95, 0123.54, 2, 'White', NULL, 'y', 'y', 'alkjdf lkasj f');
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 6, 4, 'Cat', 'f', 0145.24, 0184.25, 4, 'Grey', '2009-05-21', 'y', 'y', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 9, 2, 'Bird', 'f', 0136.45, 0176.32, 8, 'Brown', '2019-01-08', 'y', 'n', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 4, 8, 'Fish', 'm', 0012.38, 0035.64, 1, 'Orange', '2017-05-14', 'n', 'n', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 5, NULL, 'Cat', 'm', 0113.84, 0145.88, 1, 'Black', NULL, 'y', 'y', 'as lkfajs l');
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 7, 6, 'Cat', 'f', 0234.44, 0285.36, 3, 'Orange', NULL, 'y', 'y', 'lsakf jalskfj aslf ');
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 8, NULL, 'Dog', 'm', 1123.96, 1340.12, 3, 'Golden', '2018-10-24', 'y', 'y', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 3, 3, 'Bird', 'f', 0148.96, 0172.35, 10, 'White', '2017-12-22', 'y', 'n', NULL);
INSERT INTO `bdl16`.`pet` (`pet_id`, `pst_id`, `cus_id`, `pet_type`, `pet_sex`, `pet_cost`, `pet_price`, `pet_age`, `pet_color`, `pet_sale_date`, `pet_vaccine`, `pet_neuter`, `pet_notes`) VALUES (DEFAULT, 10, 10, 'Fish', 'm', 0018.35, 0032.38, 1, 'Blue', '2019-02-10', 'n', 'n', 'al skfjasl kfjls jfalksdfj ');

COMMIT;

