-- Active: 1670401223911@@127.0.0.1@3307@classicmodels
--- discussion 10
-- stored procedure 

-- 1 Create a stored procedure named getEmployees() to display the 
-- following employee and their office info: name, city, state, and country. 
DELIMITER %%
CREATE PROCEDURE getEmployees()
BEGIN
    SELECT e.firstname, e.lastname, o.city, o.state, o.country
    FROM employees e INNER JOIN offices o 
    ON e.officeCode = o.officeCode;

END %%


DELIMITER ;

CALL `getEmployees`();



-- 2 Create a stored procedure named getPayments() that prints the following 
--customer and payment info:customerName, checkNumber, paymentDate, and amount.

DELIMITER *
CREATE PROCEDURE getPayments()
BEGIN 
    SELECT c.customerName, p.checkNumber, p.paymentDate, p.amount
    FROM customers c INNER JOIN payments p 
    ON c.`customerNumber` = p.`customerNumber`; 
END *

DELIMITER ;

CALL `getPayments`();

select * from employees;