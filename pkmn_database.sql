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

-- locations table
DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
    `location_id` INT NOT NULL AUTO_INCREMENT,
    `city` VARCHAR(50) NOT NULL,
    `address` VARCHAR(100) NOT NULL,
    `zip_code` CHAR(5) NOT NULL,
    `venue_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`location_id`),
    CONSTRAINT `zip_len` CHECK (zip_code REGEXP '^[0-9]{5}$')
);

INSERT INTO `location` (`city`, `address`, `zip_code`, `venue_name`) VALUES
('Seattle', '800 Convention Place', '98101', 'Washington State Convention Center'),
('Las Vegas', '3150 Paradise Road', '89109', 'Las Vegas Convention Center'),
('Orlando', '9800 International Drive', '32819', 'Orange County Convention Center'),
('Chicago', '2301 S Lake Shore Drive', '60616', 'McCormick Place'),
('Boston', '415 Summer Street', '02210', 'Boston Convention Center');

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
('Fossil', '1999-10-10'),
('Gym Heroes', '2000-08-14'),
('Gym Challenge', '2000-10-16'),
('Neo Genesis', '2000-12-16'),
('Neo Discovery', '2001-06-01'),
('Neo Revelation', '2001-09-21'),
('Neo Destiny', '2002-02-28'),
('Legendary Collection', '2002-05-24'),
('Expedition Base Set', '2002-09-15'),
('Aquapolis', '2003-01-15'),
('Skyridge', '2003-05-12'),
('EX Ruby & Sapphire', '2003-07-01'),
('EX Sandstorm', '2003-09-18'),
('EX Dragon', '2003-11-24'),
('EX Team Magma vs Team Aqua', '2004-03-01'),
('EX Hidden Legends', '2004-06-14'),
('EX FireRed & LeafGreen', '2004-08-30'),
('EX Team Rocket Returns', '2004-11-08'),
('EX Deoxys', '2005-02-14'),
('EX Emerald', '2005-05-09'),
('EX Unseen Forces', '2005-08-22'),
('EX Delta Species', '2005-10-31'),
('EX Legend Maker', '2006-02-13'),
('EX Holon Phantoms', '2006-05-03'),
('EX Crystal Guardians', '2006-08-30'),
('EX Dragon Frontiers', '2006-11-08'),
('EX Power Keepers', '2007-02-02');

-- grading company table
DROP TABLE IF EXISTS `grading_company`;
CREATE TABLE IF NOT EXISTS `grading_company` (
    `grading_company_id` INT NOT NULL AUTO_INCREMENT,
    `company_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`grading_company_id`)
);

INSERT INTO `grading_company` (`company_name`) VALUES
('BGS'),
('CGC'),
('PSA');

-- vendor table
-- TODO: add constraint to enforce unique booth_no if feasible
-- mind that duplicates across diff events isn't a problem
DROP TABLE IF EXISTS `vendor`;
CREATE TABLE IF NOT EXISTS `vendor` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `last_managed_by` INT,
    `first_name` VARCHAR(35) NOT NULL,
    `last_name` VARCHAR(35) NOT NULL,
    `email` VARCHAR(320) NOT NULL,
    `booth_no` INT NOT NULL,
    PRIMARY KEY(`user_id`),
    -- auto update if admin user id is changed, auto delete if admin is deleted
    FOREIGN KEY(`last_managed_by`) REFERENCES `administrator`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO `vendor` (`first_name`, `last_name`, `email`, `booth_no`) VALUES
('John', 'Example', 'email@emailaddress.com', '5'),
('Bill', 'WhoIsThis', 'bill@gmail.com', '9'),
('Tim', 'Brown', 'address@hotmail.com', '7'),
('Alice', 'Smith', 'alice.smith@example.com', '10'),
('Bob', 'Johnson', 'bob.johnson@example.com', '15'),
('Charlie', 'Williams', 'charlie.williams@example.com', '20'),
('Diana', 'Jones', 'diana.jones@example.com', '25'),
('Eve', 'Taylor', 'eve.taylor@example.com', '30'),
('Frank', 'Anderson', 'frank.anderson@example.com', '35'),
('Grace', 'Thomas', 'grace.thomas@example.com', '40'),
('Hank', 'Moore', 'hank.moore@example.com', '45'),
('Ivy', 'Martin', 'ivy.martin@example.com', '52'),
('Jack', 'Lee', 'jack.lee@example.com', '55'),
('Karen', 'Perez', 'karen.perez@example.com', '60'),
('Leo', 'Clark', 'leo.clark@example.com', '65'),
('Mia', 'Lewis', 'mia.lewis@example.com', '73'),
('Nina', 'Walker', 'nina.walker@example.com', '75'),
('Oscar', 'Hall', 'oscar.hall@example.com', '80'),
('Paul', 'Allen', 'paul.allen@example.com', '85'),
('Quinn', 'Young', 'quinn.young@example.com', '90'),
('Rachel', 'King', 'rachel.king@example.com', '98'),
('Steve', 'Scott', 'steve.scott@example.com', '100'),
('Tina', 'Green', 'tina.green@example.com', '105');


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
    PRIMARY KEY(`listing_no`),
    FOREIGN KEY (`vendor_id`) REFERENCES `vendor`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`grading_company_id`) REFERENCES `grading_company`(`grading_company_id`),
    FOREIGN KEY (`set_id`) REFERENCES `set`(`set_id`)
);

INSERT INTO `card` (`vendor_id`, `grading_company_id`, `card_name`, `grade`, `quantity`, `set_id`, `price`) VALUES
(1, 1, 'Charizard', 9.5, 10, 1, 100.00),
(1, 2, 'Blastoise', 9.0, 8, 2, 90.00),
(2, 3, 'Venusaur', 8.5, 12, 3, 80.00),
(2, 1, 'Pikachu', 10.0, 5, 4, 50.00),
(3, 2, 'Eevee', 9.8, 7, 5, 60.00),
(3, 3, 'Snorlax', 9.2, 6, 6, 70.00),
(4, 1, 'Gengar', 9.7, 9, 7, 85.00),
(4, 2, 'Mewtwo', 9.9, 4, 8, 120.00),
(5, 3, 'Dragonite', 9.3, 7, 9, 95.00),
(5, 1, 'Lapras', 8.7, 11, 10, 45.00),
(6, 2, 'Machamp', 9.1, 14, 11, 55.00),
(6, 3, 'Alakazam', 9.4, 10, 12, 70.00),
(7, 1, 'Articuno', 9.8, 5, 13, 110.00),
(7, 2, 'Zapdos', 9.6, 8, 14, 95.00),
(8, 3, 'Moltres', 9.0, 12, 15, 85.00),
(8, 1, 'Vaporeon', 8.9, 16, 16, 50.00),
(9, 2, 'Jolteon', 9.2, 9, 17, 65.00),
(9, 3, 'Flareon', 9.3, 7, 18, 75.00),
(10, 1, 'Charmander', 8.5, 20, 19, 25.00),
(10, 2, 'Squirtle', 9.0, 15, 20, 30.00),
(11, 3, 'Bulbasaur', 8.0, 20, 21, 25.00),
(11, 1, 'Jigglypuff', 8.5, 12, 22, 20.00),
(12, 2, 'Meowth', 9.2, 8, 23, 40.00),
(12, 3, 'Psyduck', 9.0, 10, 24, 35.00),
(13, 1, 'Cubone', 8.8, 18, 25, 30.00),
(13, 2, 'Rattata', 8.5, 14, 26, 15.00),
(14, 3, 'Sandshrew', 9.1, 11, 27, 20.00),
(14, 1, 'Oddish', 8.7, 13, 28, 18.00),
(15, 2, 'Poliwag', 9.0, 9, 29, 22.00),
(15, 3, 'Magnemite', 9.3, 6, 30, 28.00),
(16, 1, 'Ditto', 9.5, 7, 1, 50.00),
(16, 2, 'Dratini', 9.4, 8, 2, 45.00),
(17, 3, 'Abra', 8.9, 10, 3, 35.00),
(17, 1, 'Kadabra', 9.1, 12, 4, 40.00),
(18, 2, 'Gastly', 8.8, 14, 5, 25.00),
(18, 3, 'Haunter', 9.0, 9, 6, 30.00),
(19, 1, 'Onix', 8.7, 11, 7, 20.00),
(19, 2, 'Geodude', 8.5, 13, 8, 15.00),
(20, 3, 'Graveler', 9.2, 8, 9, 25.00),
(20, 1, 'Golem', 9.4, 6, 10, 35.00),
(21, 2, 'Slowpoke', 8.9, 10, 11, 20.00),
(21, 3, 'Slowbro', 9.1, 12, 12, 30.00),
(22, 1, 'Seel', 8.8, 14, 13, 25.00),
(22, 2, 'Dewgong', 9.0, 9, 14, 30.00),
(23, 3, 'Shellder', 8.7, 11, 15, 20.00),
(23, 1, 'Cloyster', 9.3, 13, 16, 40.00),
(1, 2, 'Krabby', 8.5, 14, 17, 15.00),
(1, 3, 'Kingler', 9.2, 8, 18, 25.00),
(2, 1, 'Horsea', 8.9, 10, 19, 20.00),
(2, 2, 'Seadra', 9.1, 12, 20, 30.00),
(3, 3, 'Goldeen', 8.8, 14, 21, 25.00),
(3, 1, 'Seaking', 9.0, 9, 22, 30.00),
(4, 2, 'Staryu', 8.7, 11, 23, 20.00),
(4, 3, 'Starmie', 9.3, 13, 24, 40.00),
(5, 1, 'Magikarp', 8.5, 14, 25, 15.00),
(5, 2, 'Gyarados', 9.2, 8, 26, 25.00),
(6, 3, 'Lapras', 8.9, 10, 27, 20.00),
(6, 1, 'Ditto', 9.1, 12, 28, 30.00),
(7, 2, 'Eevee', 8.8, 14, 29, 25.00),
(7, 3, 'Vaporeon', 9.0, 9, 30, 30.00),
(8, 1, 'Jolteon', 8.7, 11, 1, 20.00),
(8, 2, 'Flareon', 9.3, 13, 2, 40.00),
(9, 3, 'Porygon', 8.5, 14, 3, 15.00),
(9, 1, 'Omanyte', 9.2, 8, 4, 25.00),
(10, 2, 'Omastar', 8.9, 10, 5, 20.00),
(10, 3, 'Kabuto', 9.1, 12, 6, 30.00),
(11, 1, 'Kabutops', 8.8, 14, 7, 25.00),
(11, 2, 'Aerodactyl', 9.0, 9, 8, 30.00),
(12, 3, 'Snorlax', 8.7, 11, 9, 20.00),
(12, 1, 'Articuno', 9.3, 13, 10, 40.00),
(13, 2, 'Zapdos', 8.5, 14, 11, 15.00),
(13, 3, 'Moltres', 9.2, 8, 12, 25.00),
(14, 1, 'Dratini', 8.9, 10, 13, 20.00),
(14, 2, 'Dragonair', 9.1, 12, 14, 30.00),
(15, 3, 'Dragonite', 8.8, 14, 15, 25.00),
(15, 1, 'Mewtwo', 9.0, 9, 16, 30.00),
(16, 2, 'Mew', 8.7, 11, 17, 20.00),
(16, 3, 'Charizard', 9.3, 13, 18, 40.00);