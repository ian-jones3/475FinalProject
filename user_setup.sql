-- This script sets up the permissions for the 3 user types, customer, vendor, and admin.
-- USERS MAY NOT SHOW UP IN THE LIST OF USERS WITH ACCESS TO THE DATABASE IN PHPMYADMIN.
-- to test functionality just log out of phpmyadmin and log in with the desired user,
-- password is set to 'password'
-- because these are basic simulated views, users are able to take some actions they wouldn't
-- be able to in a completed setup (i.e, users can potentially update other users tickets)

USE `mysql`;

-- Privileges for `administrator`@`%`
DROP USER IF EXISTS 'administrator'@'%';
CREATE USER 'administrator'@'%' IDENTIFIED BY 'password';

GRANT USAGE ON *.* TO 'administrator'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE ON `pkmn_database`.* TO 'administrator'@'%';

FLUSH PRIVILEGES;

-- Privileges for `customer`@`%`
DROP USER IF EXISTS 'customer'@'%';
CREATE USER 'customer'@'%' IDENTIFIED BY 'password';

GRANT USAGE ON *.* TO 'customer'@'%';

GRANT SELECT ON `pkmn_database`.card TO 'customer'@'%';
GRANT SELECT ON `pkmn_database`.set TO 'customer'@'%';
GRANT SELECT ON `pkmn_database`.vendor TO 'customer'@'%';
GRANT SELECT ON `pkmn_database`.event TO 'customer'@'%';
GRANT SELECT ON `pkmn_database`.location TO 'customer'@'%';
GRANT SELECT ON `pkmn_database`.grading_company TO 'customer'@'%';
GRANT SELECT, UPDATE ON `pkmn_database`.ticket TO 'customer'@'%';

FLUSH PRIVILEGES;

-- Privileges for `vendor`@`%`
DROP USER IF EXISTS 'vendor'@'%';
CREATE USER 'vendor'@'%' IDENTIFIED BY 'password';

GRANT USAGE ON *.* TO 'vendor'@'%';

GRANT SELECT ON `pkmn_database`.set TO 'vendor'@'%';
GRANT SELECT ON `pkmn_database`.event TO 'vendor'@'%';
GRANT SELECT ON `pkmn_database`.location TO 'vendor'@'%';
GRANT SELECT, UPDATE ON `pkmn_database`.ticket TO 'vendor'@'%';
GRANT SELECT ON `pkmn_database`.vendor TO 'vendor'@'%';
GRANT SELECT ON `pkmn_database`.grading_company TO 'vendor'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `pkmn_database`.card TO 'vendor'@'%';

FLUSH PRIVILEGES;