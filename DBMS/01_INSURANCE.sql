CREATE DATABASE INSURANCE;
USE INSURANCE;

CREATE TABLE DRIVER(DID INT,NAME VARCHAR(10),ADDRESS VARCHAR(20),PRIMARY KEY(DID));

CREATE TABLE CAR(REG_NUM INT,MODEL VARCHAR(10),CYEAR INT,PRIMARY KEY(REG_NUM));

CREATE TABLE OWNS(DID INT,REG_NUM INT,PRIMARY KEY(DID,REG_NUM),FOREIGN KEY(DID) REFERENCES DRIVER(DID),FOREIGN KEY(REG_NUM) REFERENCES CAR(REG_NUM));

CREATE TABLE ACCIDENT(REP_NUM INT,LOCATION VARCHAR(10),ACC_DATE DATE,PRIMARY KEY(REP_NUM));

CREATE TABLE PARTICIPATED(REP_NUM INT,REG_NUM INT,DID INT,D_AMT REAL,PRIMARY KEY(REP_NUM,REG_NUM,DID),FOREIGN KEY(DID) REFERENCES DRIVER(DID),FOREIGN KEY(REP_NUM) REFERENCES ACCIDENT(REP_NUM),FOREIGN KEY(REG_NUM) REFERENCES CAR(REG_NUM));

INSERT INTO DRIVER VALUES(1,'SAM','BLORE');
INSERT INTO DRIVER VALUES(2,'RAJATH','MYSORE');
INSERT INTO DRIVER VALUES(3,'AYMAN','MUMBAI');
INSERT INTO DRIVER VALUES(4,'TANYA','DELHI');
INSERT INTO DRIVER VALUES(5,'SHAAN','COORG');
SELECT * FROM DRIVER;

INSERT INTO CAR VALUES(1111,'INDICA',1990);
INSERT INTO CAR VALUES(2222,'LANCER',1957);
INSERT INTO CAR VALUES(3333,'TOYOTA',1998);
INSERT INTO CAR VALUES(4444,'HONDA',2008);
INSERT INTO CAR VALUES(5555,'AUDI',2005);
SELECT * FROM CAR;

INSERT INTO OWNS VALUES(1,1111);
INSERT INTO OWNS VALUES(2,4444);
INSERT INTO OWNS VALUES(3,2222);
INSERT INTO OWNS VALUES(4,3333);
INSERT INTO OWNS VALUES(5,5555);
SELECT * FROM OWNS;

INSERT INTO ACCIDENT VALUES(11,'MYSORE','03-01-01');
INSERT INTO ACCIDENT VALUES(12,'COORG','04-03-02');
INSERT INTO ACCIDENT VALUES(13,'BLORE','03-01-21');
INSERT INTO ACCIDENT VALUES(14,'DELHI','08-02-17');
INSERT INTO ACCIDENT VALUES(15,'MUMBAI','05-03-04');
SELECT * FROM ACCIDENT;

INSERT INTO PARTICIPATED VALUES(11,1111,1,10000);
INSERT INTO PARTICIPATED VALUES(12,4444,2,3000);
INSERT INTO PARTICIPATED VALUES(13,3333,3,60000);
INSERT INTO PARTICIPATED VALUES(14,2222,4,20000);
INSERT INTO PARTICIPATED VALUES(15,5555,5,13000);
SELECT * FROM PARTICIPATED;

/*Update the damage amount to 25000 for the car with a specific reg_num (example  'K A053408'  ) for which the accident report number was 12.*/
UPDATE PARTICIPATED SET D_AMT=250000 WHERE REP_NUM=12 AND REG_NUM=4444;
SELECT * FROM PARTICIPATED;

/*Add a new accident to the database.*/
INSERT INTO ACCIDENT VALUES(16,'KOLKATA','08-03-15');
SELECT * FROM ACCIDENT;

/*Find the total number of people who owned cars that were involved in accidents in 2008.*/
SELECT COUNT(DISTINCT P.DID) FROM ACCIDENT A,PARTICIPATED P WHERE 
A.REP_NUM=P.REP_NUM AND A.ACC_DATE LIKE '2008%';

/*Find the number of accidents in which cars belonging to a specific model (example 'Lancer')  were involved.*/
SELECT COUNT(DISTINCT P.REP_NUM) FROM CAR C,PARTICIPATED P WHERE 
C.REG_NUM=P.REG_NUM AND C.MODEL='LANCER';

/*LIST THE ENTIRE PARTICIPATED RELATION IN THE DESCENDING ORDER OF DAMAGE AMOUNT.*/
SELECT * FROM PARTICIPATED ORDER BY D_AMT DESC;

/*FIND THE AVERAGE DAMAGE AMOUNT*/
SELECT AVG(D_AMT) FROM PARTICIPATED;

/*DELETE THE TUPLE WHOSE DAMAGE AMOUNT IS BELOW THE AVERAGE DAMAGE AMOUNT*/
DELETE FROM PARTICIPATED WHERE D_AMT<(SELECT 
  AVERAGE FROM (SELECT AVG(D_AMT) AS AVERAGE FROM PARTICIPATED) AS TEMP);
SELECT * FROM PARTICIPATED;

/*LIST THE NAME OF DRIVERS WHOSE DAMAGE IS GREATER THAN THE AVERAGE DAMAGE AMOUNT.*/
SELECT D.NAME FROM PARTICIPATED P,DRIVER D WHERE D.DID=P.DID AND
P.D_AMT>(SELECT AVG(D_AMT) FROM PARTICIPATED);

/*FIND MAXIMUM DAMAGE AMOUNT.*/
SELECT MAX(D_AMT) FROM PARTICIPATED;
