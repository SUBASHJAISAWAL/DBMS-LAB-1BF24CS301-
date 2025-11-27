DROP DATABASE IF EXISTS supplier;
create database supplier;
use supplier;
-- CREATE TABLES

CREATE TABLE SUPPLIERS(
    sid INTEGER(5) PRIMARY KEY,
    sname VARCHAR(20),
    city VARCHAR(20)
);

CREATE TABLE PARTS(
    pid INTEGER(5) PRIMARY KEY,
    pname VARCHAR(20),
    color VARCHAR(10)
);

CREATE TABLE CATALOG(
    sid integer(5),
    pid integer(5),
    cost FLOAT(6),
    PRIMARY KEY(sid, pid),
    FOREIGN KEY(sid) REFERENCES SUPPLIERS(sid),
    FOREIGN KEY(pid) REFERENCES PARTS(pid)
);

-- INSERT DATA INTO SUPPLIERS

INSERT INTO SUPPLIERS VALUES
(10001, ' Acme Widget', 'Bangalore'),
(10002, ' Johns', 'Kolkata'),
(10003, ' Vimal', 'Mumbai'),
(10004, ' Reliance', 'Delhi'),
(10005, ' Mahindra', 'Mumbai');

-- INSERT DATA INTO PARTS

INSERT INTO PARTS VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

-- INSERT DATA INTO CATALOG

INSERT INTO CATALOG VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

-- 1. Find the most expensive part overall and the supplier who supplies it.
SELECT s.sid, s.sname, p.pid, p.pname, c.cost
FROM catalog c
JOIN suppliers s ON c.sid = s.sid
JOIN parts p ON c.pid = p.pid
WHERE c.cost = (SELECT MAX(cost) FROM catalog);

-- 2. Find suppliers who do NOT supply any red parts.
SELECT sid, sname
FROM suppliers
WHERE sid NOT IN (
    SELECT c.sid
    FROM catalog c
    JOIN parts p ON c.pid = p.pid
    WHERE p.color = 'Red'
);

-- 3. Show each supplier and total value of all parts they supply.
SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM suppliers s
JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;

-- 4. Find suppliers who supply at least 2 parts cheaper than ₹20.
SELECT s.sid, s.sname
FROM suppliers s
JOIN catalog c ON s.sid = c.sid
WHERE c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(c.pid) >= 2;

-- 5. List suppliers who offer the cheapest cost for each part.
SELECT s.sname, p.pname, c.cost
FROM catalog c
JOIN suppliers s ON c.sid = s.sid
JOIN parts p ON c.pid = p.pid
WHERE c.cost = (SELECT MIN(cost) FROM catalog WHERE pid = c.pid);

-- 6. Create a view showing suppliers and the total number of parts they supply
CREATE VIEW SupplierPartCount AS
SELECT s.sid, s.sname, COUNT(c.pid) AS total_parts
FROM suppliers s
LEFT JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;
select * from SupplierPartCount;

-- 7. Create a view of the most expensive supplier for each part.
CREATE VIEW MostExpensiveSupplierPerPart AS
SELECT c.sid, c.pid, c.cost
FROM catalog c
WHERE c.cost = (SELECT MAX(cost) FROM catalog WHERE pid = c.pid);
select * from MostExpensiveSupplierPerPart;

-- 8. Create a Trigger to prevent inserting a Catalog cost below 1.
DELIMITER //

CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SET NEW.cost = 1;
    END IF;
END;
//

DELIMITER ;

-- 9. Create a trigger to set to default cost if not provided.
delimiter //
 create trigger t1
 before insert
 on catalog
 for each row
 begin
 if
 cost is NULL then set new.cost=20;
 end if ;
 end
 //