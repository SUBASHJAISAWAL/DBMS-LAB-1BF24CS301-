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

INSERT INTO SUPPLIERS VALUES(10001, ' Acme Widget', 'Bangalore');
INSERT INTO SUPPLIERS VALUES(10002, ' Johns', 'Kolkata');
INSERT INTO SUPPLIERS VALUES(10003, ' Vimal', 'Mumbai');
INSERT INTO SUPPLIERS VALUES(10004, ' Reliance', 'Delhi');
INSERT INTO SUPPLIERS VALUES(10005, ' Mahindra', 'Mumbai');

-- INSERT DATA INTO PARTS

INSERT INTO PARTS VALUES(20001, 'Book', 'Red');
INSERT INTO PARTS VALUES(20002, 'Pen', 'Red');
INSERT INTO PARTS VALUES(20003, 'Pencil', 'Green');
INSERT INTO PARTS VALUES(20004, 'Mobile', 'Green');
INSERT INTO PARTS VALUES(20005, 'Charger', 'Black');

-- INSERT DATA INTO CATALOG

INSERT INTO CATALOG VALUES(10001, 20001, 10);
INSERT INTO CATALOG VALUES(10001, 20002, 10);
INSERT INTO CATALOG VALUES(10001, 20003, 30);
INSERT INTO CATALOG VALUES(10001, 20004, 10);
INSERT INTO CATALOG VALUES(10001, 20005, 10);

INSERT INTO CATALOG VALUES(10002, 20001, 10);
INSERT INTO CATALOG VALUES(10002, 20002, 20);
INSERT INTO CATALOG VALUES(10003, 20003, 30);
INSERT INTO CATALOG VALUES(10004, 20003, 40);

-- QUERY 1: Find pnames of parts for which there is some supplier

SELECT DISTINCT P.pname
FROM Parts P, Catalog C
WHERE P.pid = C.pid;

-- QUERY 2: Find snames of suppliers who supply every part

SELECT S.sname
FROM Suppliers S
WHERE (SELECT COUNT(P.pid) FROM Parts P) =
      (SELECT COUNT(C.pid)
       FROM Catalog C
       WHERE C.sid = S.sid);

-- QUERY 3: Find snames of suppliers who supply every red part

SELECT S.sname
FROM Suppliers S
WHERE (SELECT COUNT(P.pid)
       FROM Parts P WHERE color='Red') =
      (SELECT COUNT(C.pid)
       FROM Catalog C, Parts P
       WHERE C.sid = S.sid
         AND C.pid = P.pid
         AND P.color = 'Red');

-- QUERY 4: Find pnames supplied only by 'Acme Widget'

SELECT P.pname
FROM Parts P, Catalog C, Suppliers S
WHERE P.pid = C.pid
  AND C.sid = S.sid
  AND S.sname = ' Acme Widget'
  AND NOT EXISTS(
        SELECT *
        FROM Catalog C1, Suppliers S1
        WHERE P.pid = C1.pid
          AND C1.sid = S1.sid
          AND S1.sname <> ' Acme Widget'
      );

-- QUERY 5: Find sids of suppliers who charge more than average cost

SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost > (
        SELECT AVG(C1.cost)
        FROM Catalog C1
        WHERE C1.pid = C.pid
      );

-- QUERY 6: For each part, find supplier who charges maximum cost

SELECT P.pid, S.sname
FROM Parts P, Suppliers S, Catalog C
WHERE C.pid = P.pid
  AND C.sid = S.sid
  AND C.cost = (
        SELECT MAX(C1.cost)
        FROM Catalog C1
        WHERE C1.pid = P.pid
      );
