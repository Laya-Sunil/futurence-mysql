
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('IDG Books','Carol','Oracle Bible','Database');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('TMH','James','Information Systems','I.Science');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('SPD','Shah','Java EB 5','Java');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('BPB','Deshpande','P.T.Olap','Database');


Insert into MEMBER (MNAME,MPHONE,JOINDATE) 
values ('rahul',9343438641,(curdate()-3));
Insert into MEMBER (MNAME,MPHONE,joindate)
 values ('raj',9880138898,(curdate()-2));
Insert into MEMBER (MNAME,MPHONE,joindate) 
values ('mahesh',9900780859,curdate());



Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,3,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,4,'available');
