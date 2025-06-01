-- This script can be ran from the PhpMyAdmin import tab
-- or from the mysql command line interface on the vergil server.
-- I personally prefer CLI because it does not require any copy and pasting 
-- or clicking around in the web interface.

-- For reference on writing the SQL script,
-- refer to point_of_sale.sql from the example.

-- all tuples in this script are ai generated. While they are sound within 
-- the constraints and logic of the database, they may not represent reality
-- i.e incorrect info attached to card sets, wrong addresses, etc.
-- This data is for demonstration purposes only

-- Create and use database
CREATE DATABASE IF NOT EXISTS `pkmn_database`; -- remember to use backticks for identifiers
USE `pkmn_database`;

DROP TABLE IF EXISTS `ticket`;
DROP TABLE IF EXISTS `card`;
DROP TABLE IF EXISTS `vendor`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `event`;
DROP TABLE IF EXISTS `grading_company`;
DROP TABLE IF EXISTS `administrator`;
DROP TABLE IF EXISTS `location`;
DROP TABLE IF EXISTS `set`;

-- drop existing and create administrator table
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
CREATE TABLE IF NOT EXISTS `location` (
    `location_id` INT NOT NULL AUTO_INCREMENT,
    `city` VARCHAR(50) NOT NULL,
    `address` VARCHAR(100) NOT NULL,
    `zip_code` CHAR(5) NOT NULL,
    `venue_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`location_id`)
);

INSERT INTO `location` (`city`, `address`, `zip_code`, `venue_name`) VALUES
('Seattle', '800 Convention Place', '98101', 'Washington State Convention Center'),
('Las Vegas', '3150 Paradise Road', '89109', 'Las Vegas Convention Center'),
('Orlando', '9800 International Drive', '32819', 'Orange County Convention Center'),
('Chicago', '2301 S Lake Shore Drive', '60616', 'McCormick Place'),
('Boston', '415 Summer Street', '02210', 'Boston Convention Center');

CREATE TABLE IF NOT EXISTS `event` (
    `event_id` INT NOT NULL AUTO_INCREMENT,
    `location_id` INT NOT NULL, -- CONSTRAINT: No 2 events at same location with overlapping time
    `event_start_date` DATETIME NOT NULL,
    `event_end_date` DATETIME NOT NULL,
    PRIMARY KEY(`event_id`),
    FOREIGN KEY(`location_id`) REFERENCES `location`(`location_id`)
);

INSERT INTO `event` (`location_id`, `event_start_date`, `event_end_date`) VALUES
(1, '2024-01-15 09:00:00', '2024-01-17 18:00:00'),  -- Seattle 3-day convention
(2, '2024-03-22 10:00:00', '2024-03-23 19:00:00'),  -- Las Vegas 2-day event
(3, '2024-06-05 09:00:00', '2024-06-07 17:00:00'),  -- Orlando summer convention
(4, '2024-09-10 08:00:00', '2024-09-12 18:00:00'),  -- Chicago fall showcase
(5, '2024-11-30 10:00:00', '2024-12-01 17:00:00');  -- Boston winter event


-- sets table
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

-- customer table
CREATE TABLE IF NOT EXISTS `customer` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `last_managed_by` INT,
    `first_name` VARCHAR(35) NOT NULL,
    `last_name` VARCHAR(35) NOT NULL,
    `email` VARCHAR(320) NOT NULL,
    `phone` CHAR(10), -- be sure to strip all non-numeric chars from input.
    PRIMARY KEY(`user_id`),
    FOREIGN KEY(`last_managed_by`) REFERENCES `administrator`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO `customer` (`first_name`, `last_name`, `email`, `phone`, `last_managed_by`) VALUES
('James', 'Smith', 'james.smith@email.com', '2065551234', 1),
('Maria', 'Garcia', 'maria.g@email.com', NULL, NULL),
('Robert', 'Johnson', 'rob.johnson@email.com', '4255557890', 1),
('Lisa', 'Brown', 'lisa.brown@email.com', NULL, NULL),
('Michael', 'Davis', 'mdavis@email.com', NULL, 2),
('Jennifer', 'Wilson', 'jwilson@email.com', '2065559876', NULL),
('William', 'Taylor', 'wtaylor@email.com', NULL, 2),
('Elizabeth', 'Anderson', 'eanderson@email.com', NULL, NULL),
('David', 'Thomas', 'dthomas@email.com', NULL, 1),
('Sarah', 'Moore', 'smoore@email.com', '2065554321', NULL),
('Richard', 'Jackson', 'rjackson@email.com', NULL, 3),
('Patricia', 'White', 'pwhite@email.com', NULL, NULL),
('Joseph', 'Harris', 'jharris@email.com', '4255552345', 2),
('Linda', 'Martin', 'lmartin@email.com', NULL, NULL),
('Thomas', 'Thompson', 'tthompson@email.com', NULL, 1),
('Jessica', 'Lee', 'jlee@email.com', NULL, NULL),
('Charles', 'Clark', 'cclark@email.com', '2065557777', 3),
('Margaret', 'Rodriguez', 'mrodriguez@email.com', NULL, NULL),
('Christopher', 'Lewis', 'clewis@email.com', NULL, 2),
('Sandra', 'Walker', 'swalker@email.com', '4255558888', NULL),
('Daniel', 'Hall', 'dhall@email.com', NULL, 1),
('Ashley', 'Allen', 'aallen@email.com', NULL, NULL),
('Paul', 'Young', 'pyoung@email.com', '2065553333', 3),
('Michelle', 'King', 'mking@email.com', NULL, NULL),
('Kenneth', 'Wright', 'kwright@email.com', '4255559999', NULL);

-- grading company table
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
CREATE TABLE IF NOT EXISTS `vendor` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `last_managed_by` INT,
    `first_name` VARCHAR(35) NOT NULL,
    `last_name` VARCHAR(35) NOT NULL,
    `email` VARCHAR(320) NOT NULL,
    `phone` CHAR(10), -- be sure to strip all non-numeric chars from input.
    PRIMARY KEY(`user_id`),
    -- auto update if admin user id is changed, auto delete if admin is deleted
    FOREIGN KEY(`last_managed_by`) REFERENCES `administrator`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO `vendor` (`first_name`, `last_name`, `email`) VALUES
('John', 'Example', 'email@emailaddress.com'),
('Bill', 'WhoIsThis', 'bill@gmail.com'),
('Tim', 'Brown', 'address@hotmail.com'),
('Alice', 'Smith', 'alice.smith@example.com'),
('Bob', 'Johnson', 'bob.johnson@example.com'),
('Charlie', 'Williams', 'charlie.williams@example.com'),
('Diana', 'Jones', 'diana.jones@example.com'),
('Eve', 'Taylor', 'eve.taylor@example.com'),
('Frank', 'Anderson', 'frank.anderson@example.com'),
('Grace', 'Thomas', 'grace.thomas@example.com'),
('Hank', 'Moore', 'hank.moore@example.com'),
('Ivy', 'Martin', 'ivy.martin@example.com'),
('Jack', 'Lee', 'jack.lee@example.com'),
('Karen', 'Perez', 'karen.perez@example.com'),
('Leo', 'Clark', 'leo.clark@example.com'),
('Mia', 'Lewis', 'mia.lewis@example.com'),
('Nina', 'Walker', 'nina.walker@example.com'),
('Oscar', 'Hall', 'oscar.hall@example.com'),
('Paul', 'Allen', 'paul.allen@example.com'),
('Quinn', 'Young', 'quinn.young@example.com'),
('Rachel', 'King', 'rachel.king@example.com'),
('Steve', 'Scott', 'steve.scott@example.com'),
('Tina', 'Green', 'tina.green@example.com');

-- card table
-- TODO: add image functionality (if possible/practical)
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

CREATE TABLE IF NOT EXISTS `ticket` (
    `ticket_id` INT NOT NULL AUTO_INCREMENT,
    `customer_id` INT,
    `vendor_id` INT,
    `event_id` INT NOT NULL,
    `date_of_purchase` DATE NOT NULL,
    `ticket_type` CHAR(1) NOT NULL, 
    `checked_in` BOOLEAN NOT NULL DEFAULT 0,
    `booth_no` INT, 
    PRIMARY KEY(`ticket_id`),
    FOREIGN KEY(`vendor_id`) REFERENCES `vendor`(`user_id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`user_id`),
    FOREIGN KEY(`event_id`) REFERENCES `event`(`event_id`),
    CONSTRAINT one_user_id CHECK ( -- ensure exactly one user id is attached to this ticket
        (vendor_id IS NULL AND customer_id IS NOT NULL) OR 
        (vendor_id IS NOT NULL AND customer_id IS NULL)  
    ),
    -- CONSTRAINT; EITHER 'v' or 'c'
    CONSTRAINT valid_ticket_type CHECK ((ticket_type = 'v') OR (ticket_type = 'c')),
    --  CONSTRAINT: IF TICKET TYPE = V, CAN'T BE NULL, IF C, MUST BE NULL
    CONSTRAINT valid_booth_no CHECK (
        (ticket_type = 'v' AND booth_no != NULL) OR
        (ticket_type = 'c' AND booth_no = NULL)
    ),
    -- for a given event_id, not repeat booth #
    CONSTRAINT no_dup_booth_no UNIQUE(event_id, booth_no), 
    -- CONSTRAINT: CANT PURCHASE AFTER EVENT DATE
    CONSTRAINT valid_purchase_date CHECK (date_of_purchase < (
        SELECT event_end_date FROM event WHERE event.event_id = ticket.event_id
        )
    )
);

INSERT INTO `ticket` (`customer_id`, `vendor_id`, `event_id`, `date_of_purchase`, `ticket_type`, `checked_in`, `booth_no` ) VALUES
-- Event 1 (Seattle, Jan 15-17, 2024)
(1, NULL, 1, '2023-11-15', 'c', 0, NULL),
(2, NULL, 1, '2023-12-01', 'c', 0, NULL),
(3, NULL, 1, '2023-12-15', 'c', 0, NULL),
(4, NULL, 1, '2024-01-01', 'c', 0, NULL),
(5, NULL, 1, '2024-01-10', 'c', 0, NULL),
(NULL, 1, 1, '2023-10-01', 'v', 0, 101),
(NULL, 2, 1, '2023-10-01', 'v', 0, 102),
(NULL, 3, 1, '2023-10-01', 'v', 0, 103),
(NULL, 4, 1, '2023-10-02', 'v', 0, 104),
(NULL, 5, 1, '2023-10-02', 'v', 0, 105),

-- Event 2 (Las Vegas, Mar 22-23, 2024)
(6, NULL, 2, '2024-01-15', 'c', 0, NULL),
(7, NULL, 2, '2024-02-01', 'c', 0, NULL),
(8, NULL, 2, '2024-02-15', 'c', 0, NULL),
(9, NULL, 2, '2024-03-01', 'c', 0, NULL),
(10, NULL, 2, '2024-03-10', 'c', 0, NULL),
(NULL, 6, 2, '2024-01-02', 'v', 0, 201),
(NULL, 7, 2, '2024-01-02', 'v', 0, 202),
(NULL, 8, 2, '2024-01-03', 'v', 0, 203),
(NULL, 9, 2, '2024-01-03', 'v', 0, 204),
(NULL, 10, 2, '2024-01-04', 'v', 0, 205),

-- Event 3 (Orlando, Jun 5-7, 2024)
(11, NULL, 3, '2024-03-01', 'c', 0, NULL),
(12, NULL, 3, '2024-03-15', 'c', 0, NULL),
(13, NULL, 3, '2024-04-01', 'c', 0, NULL),
(14, NULL, 3, '2024-04-15', 'c', 0, NULL),
(15, NULL, 3, '2024-05-01', 'c', 0, NULL),
(NULL, 11, 3, '2024-02-01', 'v', 0, 301),
(NULL, 12, 3, '2024-02-01', 'v', 0, 302),
(NULL, 13, 3, '2024-02-02', 'v', 0, 303),
(NULL, 14, 3, '2024-02-02', 'v', 0, 304),
(NULL, 15, 3, '2024-02-03', 'v', 0, 305),

-- Event 4 (Chicago, Sep 10-12, 2024)
(16, NULL, 4, '2024-06-01', 'c', 0, NULL),
(17, NULL, 4, '2024-06-15', 'c', 0, NULL),
(18, NULL, 4, '2024-07-01', 'c', 0, NULL),
(19, NULL, 4, '2024-07-15', 'c', 0, NULL),
(20, NULL, 4, '2024-08-01', 'c', 0, NULL),
(NULL, 16, 4, '2024-05-01', 'v', 0, 401),
(NULL, 17, 4, '2024-05-01', 'v', 0, 402),
(NULL, 18, 4, '2024-05-02', 'v', 0, 403),
(NULL, 19, 4, '2024-05-02', 'v', 0, 404),
(NULL, 20, 4, '2024-05-03', 'v', 0, 405),

-- Event 5 (Boston, Nov 30-Dec 1, 2024)
(21, NULL, 5, '2024-09-01', 'c', 0, NULL),
(22, NULL, 5, '2024-09-15', 'c', 0, NULL),
(23, NULL, 5, '2024-10-01', 'c', 0, NULL),
(24, NULL, 5, '2024-10-15', 'c', 0, NULL),
(25, NULL, 5, '2024-11-01', 'c', 0, NULL),
(NULL, 21, 5, '2024-08-01', 'v', 0, 501),
(NULL, 22, 5, '2024-08-01', 'v', 0, 502),
(NULL, 23, 5, '2024-08-02', 'v', 0, 503),
(NULL, 1, 5, '2024-08-02', 'v', 0, 504),  -- Some vendors attending multiple events
(NULL, 2, 5, '2024-08-03', 'v', 0, 505);