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
DROP TABLE IF EXISTS `sets`;
CREATE TABLE IF NOT EXISTS `sets` (
    `set_id` INT NOT NULL AUTO_INCREMENT,
    `set_name` VARCHAR(50) NOT NULL,
    `release_date` DATE NOT NULL,
    PRIMARY KEY(`set_id`)
);

INSERT INTO `sets` (`set_name`, `release_date`) VALUES
('Base Set', '1999-01-09'),
('Team Rocket', '2000-04-24'),
('Jungle', '1999-06-16'),
('Fossil', '1999-10-10');