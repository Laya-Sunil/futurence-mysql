create database if not exists library_case;
-- drop database library_case;
use library_case;



CREATE TABLE BOOK 
   (	BOOKID int  PRIMARY KEY auto_increment, 
	BPUB varchar(20), 
	BAUTH varchar(20), 
	BTITLE varchar(25), 
	BSUB varchar(25)
   ) ;


  CREATE TABLE MEMBER 
   (	MID int   PRIMARY KEY auto_increment, 
	MNAME varchar(20), 
	MPHONE numeric(10,0),
        JOINDATE DATE
   ) ;



  CREATE TABLE BCOPY 
   (	C_ID int, 
	BOOKID int, 
	STATUS varchar(20) CHECK (status in('available','rented','reserved')),
        PRIMARY KEY (C_ID,BOOKID)
   ); 



  CREATE TABLE BRES 
   (	MID int , 
	BOOKID int REFERENCES BOOK, 
	RESDATE DATE,PRIMARY KEY (MID, BOOKID, RESDATE),
        foreign key(mid) references member(mid)
   ) ;




  CREATE TABLE BLOAN 
   (	BOOKID int, 
	LDATE DATE, 
	FINE numeric(11,2), 
	MID int, 
	EXP_DATE DATE DEFAULT (curdate()+2), 
	ACT_DATE DATE, 
	C_ID int,
  FOREIGN KEY (C_ID, BOOKID)
	  REFERENCES BCOPY (C_ID, BOOKID),
 foreign key(mid) references member(mid)
   ) ;
