-- Active: 1670401223911@@127.0.0.1@3307@org
-- Disscussion 13

--STORED FUNCTION
------------------------

/* -- 1
Write a stored function called computeTax that calculates income
tax based on the salary for every worker in the Worker table as follows:

10% - salary <= 75000
20% - 75000 < salary <= 150000
30% - salary > 150000
Write a query that displays all the details of a worker 
including their computedTax.
*/
DELIMITER %

ALTER FUNCTION computeTax(
    salary DECIMAL
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE tax DECIMAL(10,2);
    IF salary<=75000 THEN 
        SET tax = 0.1*salary;
    ELSEIF salary>75000 AND salary<=150000 THEN
        SET tax = 0.2*salary;
    ELSEIF salary>100000 THEN 
        SET tax = 0.3*salary; 
    END IF;
    RETURN tax;
END % 

DELIMITER ;

SELECT w.*, computeTax(w.salary) 
FROM worker w;


-- 2
/*
Define a stored procedure that takes a salary as input and 
returns the calculated income tax amount for the input salary. 
Print the computed tax for an input salary from a calling program. 
(Hint - Use the computeTax stored function inside the stored procedure)
*/

DELIMITER $
CREATE PROCEDURE computeIncomeTax(
    IN salary DECIMAL(10,2),
    OUT tax DECIMAL(10,2)
)
BEGIN
    set tax = computeTax(salary);
    
END $

DELIMITER ;

CALL computeIncomeTax(10000,@tax);
SELECT @tax as Tax;

-- drop Function `computeTax`;

-- drop PROCEDURE computeIncomeTax;
