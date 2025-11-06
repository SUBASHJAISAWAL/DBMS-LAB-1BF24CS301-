-- insurance database
DROP DATABASE IF EXISTS insurance;
CREATE DATABASE insurance;
USE insurance;

-- creating tables
CREATE TABLE person(
    driver_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(20),
    address VARCHAR(30)
);

CREATE TABLE car(
    reg_num VARCHAR(10) PRIMARY KEY,
    model VARCHAR(10),
    year INT
);

CREATE TABLE accident(
    report_num INT PRIMARY KEY,
    accident_date DATE,
    location VARCHAR(20)
);

CREATE TABLE owns(
    driver_id VARCHAR(10),
    reg_num VARCHAR(10),
    PRIMARY KEY(driver_id, reg_num),
    FOREIGN KEY(driver_id) REFERENCES person(driver_id),
    FOREIGN KEY(reg_num) REFERENCES car(reg_num)
);

CREATE TABLE participated (
    driver_id VARCHAR(10),
    reg_num VARCHAR(10),
    report_num INT,
    damage_amount INT,
    PRIMARY KEY(driver_id, reg_num, report_num),
    FOREIGN KEY(driver_id) REFERENCES person(driver_id),
    FOREIGN KEY(reg_num) REFERENCES car(reg_num),
    FOREIGN KEY(report_num) REFERENCES accident(report_num)
);

-- inserting data into the tables
INSERT INTO person VALUES 
('A01','Richard','Shrinivas Nagar'),
('A02','Pradeep','Rajaji Nagar'),
('A03','Smith','Ashok Nagar'),
('A04','Venu','Nr colony'),
('A05','John','Hanumanth Nagar');

INSERT INTO car VALUES
('KA052250','Indica',1990),
('KA031181','Lancer',1957),
('KA095477','Toyota',1990),
('KA053408','Honda',2008),
('KA041702','Audi',2005);

INSERT INTO accident VALUES
(11,'2003-01-01','Mysore Road'),
(12,'2004-02-02','South end circle'),
(13,'2003-01-21','Bull-temple road'),
(14,'2003-02-17','Mysore Road'),
(15,'2005-03-04','Kanakpura Road');

INSERT INTO owns VALUES
('A01','KA052250'),
('A02','KA053408'),
('A03','KA095477'),
('A04','KA031181'),
('A05','KA041702');

INSERT INTO participated VALUES
('A01','KA052250',11,10000),
('A02','KA053408',12,50000),
('A03','KA095477',13,25000),
('A04','KA031181',14,3000),
('A05','KA041702',15,5000);

-- ADDITIONAL QUERIES

--      LIST THE ENTIRE PARTICIPATED RELATION IN THE DESCENDING ORDER OF DAMAGE AMOUNT.
 SELECT * FROM PARTICIPATED ORDER BY damage_amount DESC;

--  FIND THE AVERAGE DAMAGE AMOUNT
 SELECT AVG(damage_amount) FROM participated;
 
--  DELETE THE TUPLE FROM PARTICIPATED RELATION WHOSE DAMAGE AMOUNT IS BELOW THE AVERAGE DAMAGE AMOUNT
 DELETE FROM participated WHERE damage_amount<(SELECT AVG (damage_amount) FROM participated); 

-- LIST THE NAME OF DRIVERS WHOSE DAMAGE IS GREATER THAN THE AVERAGE DAMAGE AMOUNT.
 SELECT NAME FROM person A, participated B WHERE A.driver_id = B.driver_id AND damage_amount>(SELECT AVG(damage_amount) FROM participated);

--    FIND MAXIMUM DAMAGE AMOUNT.
SELECT MAX(damage_amount) FROM participated;