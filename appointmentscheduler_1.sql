-- Create database
CREATE DATABASE IF NOT EXISTS `appointmentschedular`;
USE `appointmentschedular`;

-- Create table roles
CREATE TABLE IF NOT EXISTS `roles`(
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY(`ID`)
    )
    ENGINE = InnoDB
    AUTO_INCREMENT = 1
    DEFAULT CHARSET = UTF8;
    
-- Create table users
CREATE TABLE IF NOT EXISTS `users`(
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
    `UserName` VARCHAR(50) NOT NULL,
    `Password` CHAR(80) NOT NULL,
    `FirstName` VARCHAR(50),
    `LastName` VARCHAR(50),
    `Email` VARCHAR(50),
    `Mobile` VARCHAR(50),
    `Street` VARCHAR(50),
    `City` VARCHAR(50),
    `PostCode` VARCHAR(50),
PRIMARY KEY(`ID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = UTF8;

-- Create table users_roles
CREATE TABLE IF NOT EXISTS `users_roles`(
	`UserID` INT(11) NOT NULL,
    `RoleID` INT(11) NOT NULL,
    PRIMARY KEY(`UserID`,`RoleID`),
    KEY `FK_ROLE_idx` (`RoleID`),
    
    CONSTRAINT `FK_users_user` FOREIGN KEY(`UserID`)
    REFERENCES `users` (`ID`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    
    CONSTRAINT `FK_roles_role` FOREIGN KEY (`RoleID`)
    REFERENCES `Roles` (`ID`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
    ENGINE = InnoDB
	DEFAULT CHARSET = UTF8;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE IF NOT EXISTS `works` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(256),
  `Duration` INT(11),
  `Price` DECIMAL(10, 2),
  `Editable` BOOLEAN,
  `Target` VARCHAR(256),
  `Description` TEXT,
  PRIMARY KEY (`ID`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table invoices
CREATE TABLE IF NOT EXISTS `invoices` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Number` VARCHAR(256),
	`Status` VARCHAR(256),
	`TotalAmount` DECIMAL(10, 2),
	`Issued` DATETIME,
  PRIMARY KEY (`ID`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table appointments
CREATE TABLE IF NOT EXISTS `appointments` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Start` DATETIME,
  `End` DATETIME,
  `CanceledAt` DATETIME,
  `Status` VARCHAR(20),
  `IDCanceler` INT(11),
  `IDProvider` INT(11),
  `IDCustomer` INT(11),
  `IDWork` INT(11),
  `IDInvoice` INT(11),
  PRIMARY KEY (`ID`),
  KEY `IDCanceler` (`IDCanceler`),
  KEY `IDProvider` (`IDProvider`),
  KEY `IDCustomer` (`IDCustomer`),
  KEY `IDWork` (`IDWork`),
  KEY `IDInvoice` (`IDInvoice`),
  CONSTRAINT `appointments_users_canceler` FOREIGN KEY (`IDCanceler`) REFERENCES `users` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `appointments_users_customer` FOREIGN KEY (`IDCustomer`) REFERENCES `users` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `appointments_works` FOREIGN KEY (`IDWork`) REFERENCES `works` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `appointments_users_provider` FOREIGN KEY (`IDProvider`) REFERENCES `users` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `appointments_invoices` FOREIGN KEY (`IDInvoice`) REFERENCES `invoices` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table works_providers
CREATE TABLE IF NOT EXISTS `works_providers` (
  `IDUser` INT(11) NOT NULL,
  `IDWork` INT(11) NOT NULL,
  PRIMARY KEY (`IDUser`, `IDWork`),
  KEY `IDWork` (`IDWork`),
  CONSTRAINT `works_providers_users_provider` FOREIGN KEY (`IDUser`) REFERENCES `users` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `works_providers_works` FOREIGN KEY (`IDWork`) REFERENCES `works` (`ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table working_plans
CREATE TABLE IF NOT EXISTS `working_plans` (
	`IDProvider` int(11) NOT NULL,
    `Monday` TEXT,
	`Tuesday` TEXT,
	`Wednesday` TEXT,
	`Thursday` TEXT,
	`Friday` TEXT,
	`Saturday` TEXT,
	`Sunday` TEXT,

  PRIMARY KEY (`IDProvider`),
  KEY `IDProvider` (`IDProvider`),
  CONSTRAINT `FK_appointments_provider` FOREIGN KEY (`IDProvider`)
  REFERENCES `users` (`ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;

-- Create table messages
CREATE TABLE IF NOT EXISTS `messages` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`CreatedAt` DATETIME,
	`Message` TEXT,
	`IDAuthor` INT(11),
    `IDAppointment` INT(11),
    PRIMARY KEY (`ID`),
	KEY `IDAuthor` (`IDAuthor`),
	KEY `IDAppointment` (`IDAppointment`),
	CONSTRAINT `FK_notes_author` FOREIGN KEY (`IDAuthor`)
    REFERENCES `users` (`ID`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT `FK_notes_appointment` FOREIGN KEY (`IDAppointment`)
	REFERENCES `appointments` (`ID`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table corporate_customers
CREATE TABLE IF NOT EXISTS `corporate_customers` (
	`IDCustomer` int(11) NOT NULL,
	`VAT_number` VARCHAR(256),
	`CompanyName` VARCHAR(256),
    PRIMARY KEY (`IDCustomer`),
	KEY `IDCustomer` (`IDCustomer`),
	CONSTRAINT `FK_corporate_customer_user` FOREIGN KEY (`IDCustomer`)
	REFERENCES `users` (`ID`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;

-- Create table providers  
CREATE TABLE IF NOT EXISTS `providers` (
	`IDProvider` int(11) NOT NULL,
    PRIMARY KEY (`IDProvider`),
	KEY `IDProvider` (`IDProvider`),
	CONSTRAINT `FK_provider_user` FOREIGN KEY (`IDProvider`)
	REFERENCES `users` (`ID`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- Create table retail_customers
CREATE TABLE IF NOT EXISTS  `retail_customers` (
	`IDCustomer` int(11) NOT NULL,
    PRIMARY KEY (`IDCustomer`),
	KEY `IDCustomer` (`IDCustomer`),
	CONSTRAINT `FK_retail_customer_user` FOREIGN KEY (`IDCustomer`)
	REFERENCES `users` (`ID`)
)
	ENGINE = InnoDB
    DEFAULT CHARSET = UTF8;
   
-- Create table customers
CREATE TABLE IF NOT EXISTS `customers` (
	`IDCustomer` int(11) NOT NULL,
    PRIMARY KEY (`IDCustomer`),
	KEY `IDCustomer` (`IDCustomer`),
	CONSTRAINT `FK_customer_user` FOREIGN KEY (`IDCustomer`)
	REFERENCES `users` (`ID`)
)
	ENGINE = InnoDB
    DEFAULT CHARSET = UTF8;
 
-- Create table notifications
CREATE TABLE IF NOT EXISTS `notifications` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Title` VARCHAR(256),
	`Message` TEXT,
    `CreatedAt` DATETIME,
    `URL` VARCHAR(256),
	`IsRead` BOOLEAN,
    `IDUser` INT(11),
    PRIMARY KEY (`ID`),
	KEY `IDUser` (`IDUser`),
	CONSTRAINT `FK_notification_user` FOREIGN KEY (`IDUser`)
    REFERENCES `users` (`ID`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
 
-- Create table exchanges
CREATE TABLE IF NOT EXISTS `exchanges` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`ExchangeStatus` VARCHAR(256),
    `IDAppointmentRequestor` INT(11),
    `IDAppointmentRequested` INT(11),
    PRIMARY KEY (`ID`),
	KEY `id_appointment_requestor` (`IDAppointmentRequestor`),
    KEY `id_appointment_requested` (`IDAppointmentRequested`),
	CONSTRAINT `FK_exchange_appointment_requestor` FOREIGN KEY (`IDAppointmentRequestor`)
    REFERENCES `appointments` (`ID`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  	CONSTRAINT `FK_exchange_appointment_requested` FOREIGN KEY (`IDAppointmentRequested`)
    REFERENCES `appointments` (`ID`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB
  DEFAULT CHARSET = UTF8;
  
-- INSERT available roles
INSERT INTO `roles` (ID, Name) VALUES
  (1,'ROLE_ADMIN'),
  (2,'ROLE_PROVIDER'),
  (3,'ROLE_CUSTOMER'),
  (4,'ROLE_CUSTOMER_CORPORATE'),
  (5,'ROLE_CUSTOMER_RETAIL');

-- INSERT admin account with username: 'admin' and password 'qwerty123'
INSERT INTO `users` (ID, UserName, Password)
VALUES (1, 'admin', '$2a$10$EqKcp1WFKVQISheBxkQJoOqFbsWDzGJXRz/tjkGq85IZKJJ1IipYi');
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (1, 1);

-- INSERT provider account with username: 'provider' and password 'qwerty123'
INSERT INTO `users` (ID, UserName, Password)
VALUES (2, 'provider', '$2a$10$EqKcp1WFKVQISheBxkQJoOqFbsWDzGJXRz/tjkGq85IZKJJ1IipYi');
INSERT INTO `providers` (IDProvider)
VALUES (2);
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (2, 2);


-- INSERT retail customer account with username: 'customer_r' and password 'qwerty123'
INSERT INTO `users` (ID, UserName, Password)
VALUES (3, 'customer_r', '$2a$10$EqKcp1WFKVQISheBxkQJoOqFbsWDzGJXRz/tjkGq85IZKJJ1IipYi');
INSERT INTO `customers` (IDCustomer)
VALUES (3);
INSERT INTO `retail_customers` (IDCustomer)
VALUES (3);
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (3, 3);
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (3, 5);

-- INSERT corporate customer account with username: 'customer_c' and password 'qwerty123'
INSERT INTO `users` (ID, UserName, Password)
VALUES (4, 'customer_c', '$2a$10$EqKcp1WFKVQISheBxkQJoOqFbsWDzGJXRz/tjkGq85IZKJJ1IipYi');
INSERT INTO `customers` (IDCustomer)
VALUES (4);
INSERT INTO `corporate_customers` (IDCustomer, VAT_number, CompanyName)
VALUES (4, '123456789', 'Company name');
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (4, 3);
INSERT INTO `users_roles` (UserID, RoleID)
VALUES (4, 4);

INSERT INTO `works` (ID, Name, Duration, Price, Editable, Target, Description)
VALUES (1, 'English lesson', 60, 100.00, true, 'retail',
        'This is english lesson with duration 60 minutes and price 100 pln');

INSERT INTO works_providers
VALUES (2, 1);
INSERT INTO working_plans
VALUES (2,
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}',
        '{"workingHours":{"start":[6,0],"end":[18,0]},"breaks":[],"timePeroidsWithBreaksExcluded":[{"start":[6,0],"end":[18,0]}]}');
        
SELECT *
FROM appointments;

SELECT *
FROM corporate_customers;

SELECT *
FROM customers;

SELECT *
FROM exchanges;

SELECT *
FROM invoices;

SELECT *
FROM messages;

SELECT *
FROM notifications;

SELECT *
FROM providers;

SELECT *
FROM retail_customers;

SELECT *
FROM roles;

SELECT *
FROM users;

SELECT *
FROM users_roles;

SELECT *
FROM working_plans;

SELECT *
FROM works;

SELECT *
FROM works_providers;