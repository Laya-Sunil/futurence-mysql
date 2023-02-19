-- Active: 1670401223911@@127.0.0.1@3307@classicmodels
DELIMITER //

CREATE PROCEDURE getProducts()
BEGIN
    SELECT * FROM products limit 3;
END //

DELIMITER ;

SHOW PROCEDURE STATUS LIKE 'getProducts';

CALL `getProducts`();

SHOW CREATE PROCEDURE getProducts;

DROP PROCEDURE `getProducts`;
-- meta data about stored procedure is stored in routines table of information_schema
show tables;

CREATE FUNCTION customerLoanEligibility(
    credit DECIMAL
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF credit>50000 THEN
        set 
    END IF;
END


--------------------------------

CREATE TRIGGER after_worker_insert
   AFTER INSERT
   ON worker
   FOR EACH ROW 
BEGIN
        INSERT INTO title VALUES(NEW.worker_id, 'New joinee', now());
END

DROP TRIGGER if EXISTS after_worker_insert


--
SOFT
========
https://www.rarlab.com/rar/winrar-x64-611.exe


VMWEAR
=======
https://www.vmware.com/go/getworkstation-win
YF390-0HF8P-M81RQ-2DXQE-M2UT6

DATASTAGE8.7
=============
https://drive.google.com/file/d/12XViCIx7mBchidaikHdaz0iPIGQ8M8Hz/view?usp=sharing
https://drive.google.com/file/d/1Eid2LEufE2iLT9XTDWtiP6ROlXR7DfB8/view?usp=sharing
https://drive.google.com/file/d/1OPH7NZBY_e0wSHyqgcfs0BtPs92sZgTu/view?usp=sharing
https://drive.google.com/file/d/1fpgmvMHq8BfbJzNRv0EgJECyR4kxF1R_/view?usp=sharing
https://drive.google.com/file/d/1l9Y9vsQMAM-iLzhHMJfygxFcBy1smERu/view?usp=sharing
downlaod all files


;


