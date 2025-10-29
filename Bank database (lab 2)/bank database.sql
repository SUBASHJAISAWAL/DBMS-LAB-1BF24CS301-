DROP DATABASE IF EXISTS bankloan;
CREATE DATABASE bankloan;
USE bankloan;

-- Creating tables
CREATE TABLE Branch (
    branch_name VARCHAR(30) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets REAL
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(30),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer (
    customer_name VARCHAR(30) PRIMARY KEY,
    customer_street VARCHAR(30),
    customer_city VARCHAR(30)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(30),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(30),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

-- Inserting data
INSERT INTO Branch (branch_name, branch_city, assets)
VALUES  
    ('sbi_chamrajpet', 'bangalore', 50000),
    ('sbi_residency road', 'bangalore', 10000),
    ('sbi_shivaji road', 'bombay', 20000),
    ('sbi_parliament road', 'delhi', 10000),
    ('sbi_jantarmantar', 'delhi', 20000);

INSERT INTO Loan (loan_number, branch_name, amount)
VALUES
    (1, 'sbi_chamrajpet', 1000),
    (2, 'sbi_residency road', 2000),
    (3, 'sbi_shivaji road', 4000),
    (4, 'sbi_parliament road', 4000),
    (5, 'sbi_jantarmantar', 5000);

INSERT INTO BankAccount (accno, branch_name, balance)
VALUES
    (1, 'sbi_chamrajpet', 2000),
    (2, 'sbi_residency road', 5000),
    (3, 'sbi_shivaji road', 6000),
    (4, 'sbi_parliament road', 9000),
    (5, 'sbi_jantarmantar', 8000),
    (6, 'sbi_shivaji road', 4000),
    (7, 'sbi_residency road', 4000),
    (8, 'sbi_parliament road', 3000),
    (9, 'sbi_residency road', 5000),
    (10, 'sbi_jantarmantar', 2000);

INSERT INTO BankCustomer (customer_name, customer_street, customer_city)
VALUES
    ('Avinash', 'bulltemple_road', 'bangalore'),
    ('Dinesh', 'bennergatta_road', 'bangalore'),
    ('Mohan', 'nationalcollege_road', 'bangalore'),
    ('Nikil', 'akbar_road', 'delhi'),
    ('Ravi', 'prithiviraj_road', 'delhi');

INSERT INTO Depositer (customer_name, accno)
VALUES
    ('Avinash', 1),
    ('Dinesh', 2),
    ('Nikil', 4),
    ('Nikil',5),
    ('Ravi', 5),
    ('Avinash', 8),
    ('Nikil', 9),
    ('Dinesh', 10),
    ('Nikil', 7);

-- finding all the customers who have at least two deposits at the same branch( ex. sbi_residency road)
SELECT 
    d.customer_name,
    b.branch_name,
    COUNT(*) AS num_accounts
FROM 
    Depositer d
    JOIN BankAccount b ON d.accno = b.accno
GROUP BY 
    d.customer_name, b.branch_name
HAVING 
    COUNT(*) >= 2;

-- customers who have an account at all the brances in a specific city (ex. dehli)
SELECT DISTINCT d.customer_name
FROM Depositer d
WHERE NOT EXISTS (
    SELECT b.branch_name
    FROM Branch b
    WHERE b.branch_city = 'delhi'
    AND b.branch_name NOT IN (
        SELECT ba.branch_name
        FROM BankAccount ba
        JOIN Depositer dd ON ba.accno = dd.accno
        WHERE dd.customer_name = d.customer_name
    )
);

-- deleting all account tuples at every branch located in a specific city(ex. bombay)
    DELETE FROM BankAccount
WHERE branch_name IN (
    SELECT branch_name
    FROM Branch
    WHERE branch_city = 'bombay'
);


