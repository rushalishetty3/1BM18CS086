CREATE DATABASE COLLEGE;
USE COLLEGE;

CREATE TABLE STUDENT(USN INT,S_NAME VARCHAR(10),ADDRESS VARCHAR(20),PHONE INT,GENDER VARCHAR(10),PRIMARY KEY(USN));

CREATE TABLE SEM_SEC(SSID INT,SEM INT,SEC VARCHAR(5),PRIMARY KEY(SSID));

CREATE TABLE CLASS(USN INT,SSID INT,PRIMARY KEY(USN,SSID),FOREIGN KEY(USN) REFERENCES STUDENT(USN),FOREIGN KEY(SSID) REFERENCES SEM_SEC(SSID));

CREATE TABLE SUBJECTS(SUBCODE INT,TITLE VARCHAR(20),SEM INT,CREDITS INT,PRIMARY KEY(SUBCODE));

CREATE TABLE MARKS(USN INT,SUBCODE INT,SSID INT,TEST1 INT,TEST2 INT,TEST3 INT,PRIMARY KEY(USN,SSID,SUBCODE),FOREIGN KEY(USN) REFERENCES STUDENT(USN),FOREIGN KEY(SSID) REFERENCES SEM_SEC(SSID),FOREIGN KEY(SUBCODE) REFERENCES SUBJECTS(SUBCODE));

INSERT INTO STUDENT VALUES(11,'SAM','INDIRANAGAR',231432,'FEMALE');
INSERT INTO STUDENT VALUES(22,'AYMAN','INDIRANAGAR',231232,'MALE');
INSERT INTO STUDENT VALUES(33,'TANYA','WHITE FIELD',231443,'FEMALE');
INSERT INTO STUDENT VALUES(44,'DISHA','RR NAGAR',231213,'FEMALE');
INSERT INTO STUDENT VALUES(55,'SHAAN','MG ROAD',212543,'MALE');
SELECT * FROM STUDENT;

INSERT INTO SEM_SEC VALUES(1,2,'B');
INSERT INTO SEM_SEC VALUES(2,6,'B');
INSERT INTO SEM_SEC VALUES(3,4,'A');
INSERT INTO SEM_SEC VALUES(4,4,'C');
INSERT INTO SEM_SEC VALUES(5,4,'B');
SELECT * FROM SEM_SEC;

INSERT INTO CLASS VALUES(11,4);
INSERT INTO CLASS VALUES(33,5);
INSERT INTO CLASS VALUES(44,4);
INSERT INTO CLASS VALUES(55,2);
INSERT INTO CLASS VALUES(22,4);
SELECT * FROM CLASS;

INSERT INTO SUBJECTS VALUES(10,'MP',4,4);
INSERT INTO SUBJECTS VALUES(20,'DBMS',2,4);
INSERT INTO SUBJECTS VALUES(30,'LD',5,3);
INSERT INTO SUBJECTS VALUES(40,'ADA',1,4);
INSERT INTO SUBJECTS VALUES(50,'COA',3,3);
SELECT * FROM SUBJECTS;

INSERT INTO MARKS VALUES(44,10,4,10,12,11);
INSERT INTO MARKS VALUES(22,50,4,16,15,12);
INSERT INTO MARKS VALUES(33,10,5,19,19,20);
INSERT INTO MARKS VALUES(11,20,4,15,14,13);
INSERT INTO MARKS VALUES(55,30,2,19,19,19);
INSERT INTO MARKS VALUES(22,40,4,12,18,16);
SELECT * FROM MARKS;

/*1. List all the student details studying in fourth semester ‘C’ section. */
SELECT * FROM STUDENT S WHERE S.USN IN (SELECT C.USN FROM CLASS C,SEM_SEC S WHERE S.SSID=C.SSID AND S.SEM=4 AND S.SEC='C');

/*2. Compute the total number of male and female students in each semester and in each section. */
SELECT SS.SEM,SS.SEC,S.GENDER,COUNT(*) FROM SEM_SEC SS,STUDENT S,CLASS C WHERE C.USN=S.USN AND C.SSID=SS.SSID GROUP BY SS.SEM,SS.SEC,S.GENDER;

/*TOTAL STUDENTS*/
SELECT SS.SEM,SS.SEC,COUNT(*) AS TOTAL_STUDENT FROM SEM_SEC SS,CLASS C WHERE C.SSID=SS.SSID GROUP BY SS.SSID;

/*TOTAL FEMALE STUDENT IN EACH CLASS*/
SELECT SEM,SEC,COUNT(GENDER) AS FEMALE FROM (STUDENT NATURAL JOIN CLASS) RIGHT OUTER JOIN SEM_SEC ON CLASS.SSID=SEM_SEC.SSID WHERE GENDER="FEMALE" GROUP BY (SEM_SEC.SSID);

/*TOTAL MALE STUDENT IN EACH CLASS*/
SELECT SEM,SEC,COUNT(GENDER) AS MALE FROM (STUDENT NATURAL JOIN CLASS) RIGHT OUTER JOIN SEM_SEC ON CLASS.SSID=SEM_SEC.SSID WHERE GENDER="MALE" GROUP BY (SEM_SEC.SSID);

/*3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all subjects. */
CREATE VIEW USN_22(USN,SUB,MARKS) AS SELECT M.USN,S.TITLE,M.TEST1 FROM MARKS M,SUBJECTS S WHERE M.SUBCODE=S.SUBCODE AND M.USN=22;
SELECT * FROM USN_22;

/*AVG OF BEST TWO OF THREE MRAKS*/
ALTER TABLE MARKS ADD COLUMN FINAL_ALL FLOAT;
UPDATE MARKS SET FINAL_ALL=((TEST1+TEST2+TEST3)-LEAST(TEST1,TEST2,TEST3))/2;
SELECT * FROM MARKS;

/*5. Categorize students based on the following criterion: */
ALTER TABLE MARKS ADD COLUMN CATEGORY VARCHAR(20);
UPDATE MARKS SET CATEGORY= 
				CASE
					WHEN FINAL_ALL>=17 AND FINAL_ALL<=20 THEN 'OUSTANDING'
                    WHEN FINAL_ALL>=12 AND FINAL_ALL<17 THEN 'AVERAGE'
                    WHEN FINAL_ALL<12 THEN 'WEAK'
				END;
SELECT * FROM MARKS;

CREATE VIEW FINAL_IA AS SELECT S.TITLE,M.TEST1,M.TEST2,M.TEST3,M.FINAL_ALL FROM SUBJECTS S,MARKS M,SEM_SEC SS WHERE M.SUBCODE=S.SUBCODE AND M.SSID=SS.SSID AND SS.SEM=4; 
SELECT * FROM FINAL_IA;

SELECT DISTINCT M.USN FROM MARKS M,SUBJECTS S WHERE M.FINAL_ALL>13 AND S.SUBCODE=M.SUBCODE AND S.CREDITS=4;

