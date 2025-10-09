create database bankloan;
use bankloan;
-- CREATEING TABLES

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

-- inserting data
INSERT INTO Branch ( branch_name, branch_city, assets )
VALUES(('sbi_chamrahpet', 'banglore',50000),
		('sbi_residency','banglore',10000),
        ('sbi_shivajiroad','bombay',20000),
        ('sbi_parlimentroad','delhi',1000),
        ('sbi_jantarmantar','delhi,20000'));
	
INSERT INTO Loan (loan_number, branch_name, amout)
VALUES((2,'sbi_residencyroad',2000),
		(1,'sbi_chamrajpet',1000),
        (3,'sbi_shivajiroad',4000),
        (4,'sbi_parlimentroad',4000),
        (5,'sbi_jantarmantar',5000));
INSERT INTO BankAccount( accno,branch_name,balance)
VALUES ((1,'sbi_chamrajpet',2000),
		(2,'sbi_residencyroad',5000),
        (3,'sbi_shivajiroad',6000),
        (4,'sbi_parlimentroad',9000),
        (5,'sbi_jantarmantar',8000),
        (6,'sbi_shivajiroad',4000),
        (7,'sbi_residencyroad',4000),
        (8,'sbi_parlimentroad',3000),
        (9,'sbi_residencyroad',5000),
        (10,'sbi_jantarmanter',2000));
INSERT INTO BankCustomer (customer_name,customer_street,customer_city)
VALUES(('Avinash','bulltemple_road','banglore'),
		('Dinesh','bennergatta_road','banglore'),
        ('Mohan','nationalcollege_road','banglore'),
        ('Nikil','akbar_road','delhi'),
        ('Ravi','prithiviraj_road','delhi'));
  INSERT INTO Depositer(customer_name,balance)
  VALUES(('Avinash',1),
		('Dinesh',2),
        ('Nikil',4),
        ('Ravi',5),
        ('Avinash',8),
        ('Nikil',9),
        ('Dinesh',10),
        ('Nikil',11));
-- finding all the customers who have at least two deposits at the same branch
select customer_name
from BankCustomer ;
where exists(
	select d.customer_name, count(d.customer_name)
    from depositer d, BankAccount ba
    where 
			d.accno=ba.accno AND
            c.customer_name=d.customr_name AND
           ba. branch_name= 'sbi_residency_road'
		group by d.customer_name
        having count(d.customer_name)>=2
        );
	