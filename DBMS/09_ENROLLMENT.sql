CREATE DATABASE ENROLLMENT;
USE ENROLLMENT;

CREATE TABLE STUDENT(SNUM INT(10),SNAME VARCHAR(20),MAJOR VARCHAR(20),LVL VARCHAR(3),AGE INT(2),PRIMARY KEY(SNUM));

CREATE TABLE FACULTY(FID INT(10),FNAME VARCHAR(20),DEPTID INT(1),PRIMARY KEY(FID)); 

CREATE TABLE CLASS(CNAME VARCHAR(5),MEETS_AT TIMESTAMP,ROOM INT(3),FID INT(10),PRIMARY KEY(CNAME),FOREIGN KEY(FID) REFERENCES FACULTY(FID));

CREATE TABLE ENROLLED(SNUM INT(10),CNAME VARCHAR(5),PRIMARY KEY(SNUM,CNAME),FOREIGN KEY(SNUM) REFERENCES STUDENT(SNUM),FOREIGN KEY(CNAME) REFERENCES CLASS(CNAME));

INSERT INTO STUDENT VALUES(1,'RAHUL','CSE','SR',20);
INSERT INTO STUDENT VALUES(2,'LOHITH','ISE','JR',19);
INSERT INTO STUDENT VALUES(3,'KEERTHAN','ETE','JR',19);
INSERT INTO STUDENT VALUES(4,'PATIL','CSE','SR',20);
INSERT INTO STUDENT VALUES(5,'PRIYANKA','ISE','SR',20);
INSERT INTO STUDENT VALUES(6,'HEMANTH','CSE','FR',20);
INSERT INTO STUDENT VALUES(7,'YAMINI','ISE','SO',19);
INSERT INTO STUDENT VALUES(8,'SNEHA','ETE','SO',19);
INSERT INTO STUDENT VALUES(9,'SARANYA','CSE','FR',20);
INSERT INTO STUDENT VALUES(10,'ANIL','ISE','FR',20);
SELECT * FROM STUDENT;

INSERT INTO FACULTY VALUES(10,'PROF. MURTHY',10);
INSERT INTO FACULTY VALUES(20,'PROF. SUDHA',20);
INSERT INTO FACULTY VALUES(30,'PROF. LATHA',30);
SELECT * FROM FACULTY;

INSERT INTO CLASS VALUES('4A','2011-10-20 09:50:00',301,10);
INSERT INTO CLASS VALUES('4B','2013-11-02 10:45:30',302,20);
INSERT INTO CLASS VALUES('4C','2014-11-22 11:15:02',303,10);
INSERT INTO CLASS VALUES('3A','2015-10-11 12:50:01',304,10);
INSERT INTO CLASS VALUES('3B','2016-10-16 01:05:05',305,10);
INSERT INTO CLASS VALUES('3C','2016-10-16 01:05:05',306,20);
SELECT * FROM CLASS;

INSERT INTO ENROLLED VALUES(1,'4B');
INSERT INTO ENROLLED VALUES(2,'4A');
INSERT INTO ENROLLED VALUES(3,'4C');
INSERT INTO ENROLLED VALUES(4,'4B');
INSERT INTO ENROLLED VALUES(5,'4A');
INSERT INTO ENROLLED VALUES(6,'4B');
INSERT INTO ENROLLED VALUES(7,'3B');
INSERT INTO ENROLLED VALUES(8,'3B');
INSERT INTO ENROLLED VALUES(9,'3B');
INSERT INTO ENROLLED VALUES(10,'3A');
INSERT INTO ENROLLED VALUES(10,'3C');
SELECT * FROM ENROLLED;

/*Find the names of all Juniors (level(lvl) = Jr) who are enrolled in a class taught by PROF. MURTHY.*/
SELECT S.SNAME FROM STUDENT S,FACULTY F,CLASS C,ENROLLED E WHERE
S.SNUM=E.SNUM AND E.CNAME=C.CNAME AND C.FID=F.FID AND F.FNAME="PROF. MURTHY"
AND S.LVL="JR";

/*Find the names of all classes that either meet in room 303 or have five or more Students enrolled.*/
(SELECT CNAME FROM CLASS WHERE ROOM=303) UNION (SELECT CNAME FROM
 ENROLLED GROUP BY CNAME HAVING COUNT(SNUM)>=3);

/*Find the names of all students who are enrolled in two classes that meet at the same time.*/
/*NOT DONE*/
SELECT DISTINCT S.SNAME FROM STUDENT S WHERE S.SNUM IN (SELECT
DISTINCT E1.SNUM FROM ENROLLED E1,ENROLLED E2,CLASS C1,CLASS C2 WHERE
E1.SNUM=E2.SNUM AND E1.CNAME!=E2.CNAME AND E1.CNAME=C1.CNAME AND
               E2.CNAME=C2.CNAME AND C1.MEETS_AT=C2.MEETS_AT); 

/*Find the names of faculty members who teach in every room in which some class is taught*/
/*NOT DONE*/
SELECT DISTINCT F.FNAME
FROM FACULTY F
WHERE NOT EXISTS (SELECT *
FROM CLASS C WHERE C.ROOM NOT IN
(SELECT C1.ROOM
FROM CLASS C1
WHERE C1.FID = F.FID ))

/*Find the names of faculty members for whom the combined enrollment of the courses that they teach is less than five*/
SELECT DISTINCT F.FNAME FROM FACULTY F WHERE (SELECT COUNT(E.SNUM)
FROM ENROLLED E,CLASS C WHERE E.CNAME=C.CNAME AND C.FID=F.FID)>5;

/*Find the names of students who are not enrolled in any class. */
SELECT DISTINCT SNAME FROM STUDENT WHERE SNUM NOT
 IN(SELECT SNUM FROM ENROLLED);

/*For each age value that appears in Students, find the level value that appears most often. For example, if there are more FR level students aged 18 than SR, JR, or SO students aged 18, you should print the pair (18, FR).*/
SELECT S.AGE,S.LVL FROM STUDENT S GROUP BY S.AGE,S.LVL HAVING 
 S.LVL IN (SELECT S1.LVL FROM STUDENT S1 WHERE S1.AGE=S.AGE GROUP
 BY S1.LVL,S1.AGE HAVING COUNT(*)>=ALL(SELECT COUNT(*) FROM STUDENT
                  S2 WHERE S1.AGE=S2.AGE GROUP BY S2.LVL,S2.AGE));

/*For each level, print the level and the average age of students for that level*/
SELECT LVL,AVG(AGE) FROM STUDENT GROUP BY LVL;

/*For all levels except JR, print the level and the average age of students for that level.*/
SELECT LVL,AVG(AGE) FROM STUDENT WHERE LVL!='JR' GROUP BY LVL;

/*Find the names of students enrolled in the maximum number of classes.*/
SELECT DISTINCT SNAME FROM STUDENT WHERE SNUM IN(SELECT E.SNUM FROM ENROLLED E 
GROUP BY E.SNUM HAVING COUNT(E.CNAME)>=ALL(SELECT COUNT(E1.CNAME) FROM
                              ENROLLED E1 GROUP BY E1.SNUM));

/*Find the age of the oldest student who is either a History major or enrolled in a course taught by I. Teach.*/
SELECT MAX(AGE) FROM STUDENT WHERE MAJOR="ISE" OR SNUM IN(SELECT E.SNUM FROM ENROLLED E,FACULTY F,CLASS C WHERE F.FID=C.FID AND C.CNAME=E.CNAME AND F.FNAME="PROF. SUDHA");
