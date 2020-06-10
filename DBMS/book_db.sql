CREATE DATABASE BOOK_DB;
USE BOOK_DB;

CREATE TABLE PUBLISHER(PNAME VARCHAR(20),PHONE_NO REAL,ADDRESS VARCHAR(20),PRIMARY KEY(PNAME));

CREATE TABLE LIB_BRANCH(BRANCH_ID INT,ADDRESS VARCHAR(20),BNAME VARCHAR(20),PRIMARY KEY(BRANCH_ID));

CREATE TABLE BOOK(BOOK_ID INT,TITLE VARCHAR(20),PNAME VARCHAR(20),PUB_YEAR YEAR,PRIMARY KEY(BOOK_ID),FOREIGN KEY(PNAME) REFERENCES PUBLISHER(PNAME) ON DELETE CASCADE);

CREATE TABLE BOOK_AUTHOR(BOOK_ID INT,ANAME VARCHAR(20),PRIMARY KEY(BOOK_ID,ANAME),FOREIGN KEY(BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE);

CREATE TABLE BOOK_COPIES(BOOK_ID INT,BRANCH_ID INT,NO_OF_COPIES INT,PRIMARY KEY(BOOK_ID,BRANCH_ID),FOREIGN KEY(BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,FOREIGN KEY(BRANCH_ID) REFERENCES LIB_BRANCH(BRANCH_ID) ON DELETE CASCADE);

CREATE TABLE BOOK_LENDING(BOOK_ID INT,BRANCH_ID INT,CARD_NO INT,DATE_OUT DATE,DUE_DATE DATE,PRIMARY KEY(BOOK_ID,BRANCH_ID,CARD_NO),FOREIGN KEY(BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,FOREIGN KEY(BRANCH_ID) REFERENCES LIB_BRANCH(BRANCH_ID) ON DELETE CASCADE);

INSERT INTO PUBLISHER VALUES ('MCGRAW-HILL', 9989076587, 'BANGALORE'); 
INSERT INTO PUBLISHER VALUES ('PEARSON', 9889076565, 'NEWDELHI'); 
INSERT INTO PUBLISHER VALUES ('RANDOM HOUSE', 7455679345, 'HYDRABAD'); 
INSERT INTO PUBLISHER VALUES ('HACHETTE LIVRE', 8970862340, 'CHENNAI'); 
INSERT INTO PUBLISHER VALUES ('GRUPO PLANETA', 7756120238, 'BANGALORE'); 
SELECT * FROM PUBLISHER;

INSERT INTO BOOK VALUES (1,'DBMS','MCGRAW-HILL','2017'); 
INSERT INTO BOOK VALUES (2,'ADBMS', 'MCGRAW-HILL','2016'); 
INSERT INTO BOOK VALUES (3,'CN', 'PEARSON','2016'); 
INSERT INTO BOOK VALUES (4,'CG','GRUPO PLANETA','2015'); 
INSERT INTO BOOK VALUES (5,'OS','PEARSON','2016'); 
SELECT * FROM BOOK;

INSERT INTO BOOK_AUTHOR VALUES (1,'NAVATHE'); 
INSERT INTO BOOK_AUTHOR VALUES (2,'NAVATHE'); 
INSERT INTO BOOK_AUTHOR VALUES (3,'TANENBAUM'); 
INSERT INTO BOOK_AUTHOR VALUES (4,'EDWARD ANGEL'); 
INSERT INTO BOOK_AUTHOR VALUES (5,'GALVIN'); 
SELECT * FROM BOOK_AUTHOR;

INSERT INTO LIB_BRANCH VALUES (10,'BANGALORE','RR NAGAR'); 
INSERT INTO LIB_BRANCH VALUES (11,'BANGALORE','RNSIT'); 
INSERT INTO LIB_BRANCH VALUES (12, 'BANGALORE','RAJAJI NAGAR'); 
INSERT INTO LIB_BRANCH VALUES (13,'MANGALORE','NITTE'); 
INSERT INTO LIB_BRANCH VALUES (14,'UDUPI','MANIPAL'); 
SELECT * FROM LIB_BRANCH;

INSERT INTO BOOK_COPIES VALUES ( 1, 10,10); 
INSERT INTO BOOK_COPIES VALUES (1, 11,5); 
INSERT INTO BOOK_COPIES VALUES (2, 12,2); 
INSERT INTO BOOK_COPIES VALUES (2, 13,5); 
INSERT INTO BOOK_COPIES VALUES (3, 14,7); 
INSERT INTO BOOK_COPIES VALUES (5, 10,1); 
INSERT INTO BOOK_COPIES VALUES (4, 11,3); 
SELECT * FROM BOOK_COPIES;

INSERT INTO BOOK_LENDING VALUES ( 1, 10, 101,'2017-01-01','2017-06-01'); 
INSERT INTO BOOK_LENDING VALUES ( 3, 14, 101,'2017-01-11','2017-03-11'); 
INSERT INTO BOOK_LENDING VALUES ( 2, 13, 101,'2017-02-21','2017-04-21'); 
INSERT INTO BOOK_LENDING VALUES ( 4, 11, 101,'2017-03-15','2017-07-15'); 
INSERT INTO BOOK_LENDING VALUES ( 1, 11, 104,'2017-04-12','2017-05-12'); 
SELECT * FROM BOOK_LENDING;

/*1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each branch, etc. */
SELECT BC.BOOK_ID,B.TITLE,B.PNAME,BA.ANAME,BC.NO_OF_COPIES,BC.BRANCH_ID FROM BOOK B,BOOK_AUTHOR BA,BOOK_COPIES BC WHERE BC.BOOK_ID=B.BOOK_ID AND BC.BOOK_ID=BA.BOOK_ID;

/*2.	Get the particulars of borrowers who have borrowed more than 2 books, but from Jan 2017 to Jun 2017*/
SELECT CARD_NO FROM BOOK_LENDING WHERE DATE_OUT BETWEEN '2017-01-01' AND '2017-06-30' GROUP BY CARD_NO HAVING COUNT(*)>2;

/*3. Delete a book in BOOK table. Update the contents of other tables to reflect this data manipulation operation. */
DELETE FROM BOOK WHERE BOOK_ID=3;
SELECT * FROM BOOK;
SELECT * FROM BOOK_AUTHOR;
SELECT * FROM BOOK_COPIES;
SELECT * FROM BOOK_LENDING;

/*4. Partition the BOOK table based on year of publication. Demonstrate its working with a simple query. */
/*NOT UNDERSTOOD*/
CREATE VIEW PUB_YEAR AS SELECT DISTINCT PUB_YEAR FROM BOOK;
SELECT * FROM PUB_YEAR;

/*5.Create a view of all books and its number of copies that are currently available in the Library. */
CREATE VIEW TITLE_COPIES AS SELECT B.TITLE,BC.NO_OF_COPIES FROM BOOK B,BOOK_COPIES BC WHERE B.BOOK_ID=BC.BOOK_ID;
SELECT * FROM TITLE_COPIES;

SELECT LB.BNAME, COUNT(BL.BOOK_ID) AS NO_OF_BOOK_LOANED FROM LIB_BRANCH LB,BOOK_LENDING BL WHERE LB.BRANCH_ID=BL.BRANCH_ID GROUP BY BL.BRANCH_ID;

SELECT B.TITLE,BC.NO_OF_COPIES FROM BOOK B,BOOK_COPIES BC,BOOK_AUTHOR BA,LIB_BRANCH LB WHERE B.BOOK_ID=BA.BOOK_ID AND B.BOOK_ID=BC.BOOK_ID AND BC.BRANCH_ID=LB.BRANCH_ID AND BA.ANAME="NAVATHE" AND LB.BNAME="NITTE";

SELECT LB.BNAME,LB.ADDRESS,COUNT(BL.BOOK_ID) AS NO_OF_BOOKS_CHECKED_OUT FROM LIB_BRANCH LB,BOOK_LENDING BL WHERE BL.BRANCH_ID=LB.BRANCH_ID GROUP BY BL.BRANCH_ID HAVING COUNT(BL.BOOK_ID)>5;

select lib_branch.branch_id,due_date from lib_branch left outer join book_lending on lib_branch.branch_id=book_lending.branch_id;

SELECT TITLE,ANAME,PNAME FROM BOOK NATURAL JOIN BOOK_AUTHOR;