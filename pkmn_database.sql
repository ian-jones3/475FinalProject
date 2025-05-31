-- This script can be ran from the PhpMyAdmin import tab
-- or from the mysql command line interface on the vergil server.
-- I personally prefer CLI because it does not require any copy and pasting 
-- or clicking around in the web interface.

-- For reference on writing the SQL script,
-- refer to point_of_sale.sql from the example.

-- Create and use database
CREATE DATABASE IF NOT EXISTS `pkmn_database`; -- remember to use backticks for identifiers
USE `pkmn_database`;

-- drop existing and create administrator table
DROP TABLE IF EXISTS `administrator`;
CREATE TABLE IF NOT EXISTS `administrator` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(35) NOT NULL,
    `last_name` VARCHAR(35) NOT NULL,
    `email` VARCHAR(320) NOT NULL,
    PRIMARY KEY(`user_id`)
);

-- generic insertions for administrator
INSERT INTO `administrator` (`first_name`, `last_name`, `email`) VALUES
('Jim', 'Boberts', 'jim.boberts@yahoo.com'), -- remember to use single quotes for strings
('Bill', 'Roberts', 'bill.roberts@hotmail.com'),
('Tom', 'Hoberts', 'tom.hoberts@gmail.com');

-- sets table
DROP TABLE IF EXISTS `set`;
CREATE TABLE IF NOT EXISTS `set` (
    `set_id` INT NOT NULL AUTO_INCREMENT,
    `set_name` VARCHAR(50) NOT NULL,
    `release_date` DATE NOT NULL,
    PRIMARY KEY(`set_id`)
);

INSERT INTO `set` (`set_name`, `release_date`) VALUES
('Base Set', '1999-01-09'),
('Team Rocket', '2000-04-24'),
('Jungle', '1999-06-16'),
('Fossil', '1999-10-10');

-- grading company table
DROP TABLE IF EXISTS `grading_company`;
CREATE TABLE IF NOT EXISTS `grading_company` (
    `grading_company_id` INT NOT NULL AUTO_INCREMENT,
    `company_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`grading_company_id`)
);

INSERT INTO `grading_company` (`company_name`) VALUES
('PSA');

-- vendor table
-- TODO: add constraint to enforce unique booth_no if feasible
-- mind that duplicates across diff events isn't a problem
DROP TABLE IF EXISTS `vendor`;
CREATE TABLE IF NOT EXISTS `vendor` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(35) NOT NULL,
    `last_name` VARCHAR(35) NOT NULL,
    `email` VARCHAR(320) NOT NULL,
    `booth_no` INT NOT NULL,
    `checked_in` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY(`user_id`)
);

INSERT INTO `vendor` (`first_name`, `last_name`, `email`, `booth_no`) VALUES
('John', 'Example', 'email@emailaddress.com', '5'),
('Bill', 'WhoIsThis', 'bill@gmail.com', '9'),
('tim', 'brown', 'address@hotmail.com', '7');


-- card table
-- TODO: add image functionality (if possible/practical)
DROP TABLE IF EXISTS `card`;
CREATE TABLE IF NOT EXISTS `card` (
    `listing_no` INT NOT NULL AUTO_INCREMENT,
    `vendor_id` INT NOT NULL,
    `grading_company_id` INT NOT NULL,
    `card_name` VARCHAR(50) NOT NULL,
    `grade` DECIMAL(3, 1) NOT NULL,
    `quantity` INT NOT NULL,
    `set_id` INT NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY(`listing_no`)
);

INSERT INTO `card` (`vendor_id`, `grading_company_id`, `card_name`, `grade`, `quantity`, `set_id`, `price`) VALUES
(1, 1, 'Charizard', 9.5, 10, 1, 100.00),
(1, 1, 'Pikachu', 10.0, 5, 2, 50.00),
(1, 1, 'Bulbasaur', 8.0, 20, 3, 25.00);