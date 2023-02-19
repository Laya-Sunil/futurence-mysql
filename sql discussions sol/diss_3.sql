-- Active: 1670401223911@@127.0.0.1@3307@classicmodels
-- discussion 3
show tables;
-- 1. Write a query to display a list of customers who locate in the same city by joining the customers table to itself.
select c1.`city`, c1.`customerName`,c2.`customerName`
from customers c1 cross join customers c2
on c1.`city`=c2.`city` 
where c1.`customerName` > c2.`customerName`;

select * from orderdetails;

-- 2.Write a query to get:
-- The productCode and productName from the products table.
-- The textDescription of product lines from the productlines table.
SELECT p.`productCode`, p.`productName`, pl.`textDescription`
FROM products p INNER JOIN productlines pl USING(`productLine`);

-- 3. Write a query that returns order number, order status, and total sales from the orders and orderdetails tables as follows:
SELECT  o.`orderNumber`, o.status, sum(od.`priceEach` * od.`quantityOrdered`)as total_sales
from orders o INNER JOIN orderdetails od 
ON o.`orderNumber`=od.`orderNumber`
group by o.`orderNumber`,o.status;

-- 4.Write a query to fetch the complete details of orders from the orders, orderDetails, and products table, 
-- and sort them by orderNumber and orderLineNumber as follows:
SELECT o.`orderNumber`,o.`orderDate`,od.`orderLineNumber`,p.`productName`, od.`quantityOrdered`,od.`priceEach`
from products p INNER JOIN orderdetails od 
on p.`productCode`=od.`productCode` 
INNER JOIN orders o on od.`orderNumber`=o.`orderNumber`
order BY o.`orderNumber`,od.`orderLineNumber`;
-- OR
SELECT o.`orderNumber`,o.`orderDate`,od.`orderLineNumber`,p.`productName`, od.`quantityOrdered`,od.`priceEach`
from products p INNER JOIN orderdetails od 
USING(`productCode`)
INNER JOIN orders o USING(`orderNumber`)
ORDER BY `orderNumber`, `orderLineNumber`;

-- 5.Write a query to perform INNER JOIN of four tables:
-- Display the details sorted by orderNumber, orderLineNumber as per the following
SELECT o.`orderNumber`,o.`orderDate`,c.`customerName`,od.`orderLineNumber`,p.`productName`,od.`quantityOrdered`,od.`priceEach`
from products p INNER JOIN orderdetails od USING(`productCode`)
INNER JOIN orders o USING(`orderNumber`)
INNER JOIN customers c USING(`customerNumber`)
order by `orderNumber`, `orderLineNumber`;

-- 6. Write a query to find the sales price of the product whose code is S10_1678 that is less than the manufacturer’s 
-- suggested retail price (MSRP) for that product as follows:
SELECT od.`orderNumber`,p.`productName`,p.`MSRP`,od.`priceEach`
from products p INNER JOIN orderdetails od 
on p.`productCode`=od.`productCode` 
WHERE p.`productCode`='S10_1678'
and od.`priceEach`<p.`MSRP`;
-- and p.`buyPrice`<p.`MSRP`
SELECT od.`orderNumber`,p.`productName`,p.`MSRP`,od.`priceEach`
from products p INNER JOIN orderdetails od 
on p.`productCode`=od.`productCode` 
where od.`quantityOrdered` in (select od.`quantityOrdered`-1 from orderdetails od 
WHERE `productCode`='S18_2248');



select od.`quantityOrdered`-1 from orderdetails od 
WHERE `productCode`='S10_1678';
-- 7. Each customer can have zero or more orders while each order must belong to one customer. 
-- Write a query to find all the customers and their orders as follows:
SELECT c.`customerNumber`,c.`customerName`,o.`orderNumber`,o.status
from customers c left JOIN orders o on c.`customerNumber`=o.`customerNumber`;
-- where c.`customerNumber` in (168,169);

-- 8. Write a query that uses the LEFT JOIN to find customers who have no order:
SELECT c.`customerNumber`,c.`customerName`,o.`orderNumber`,o.status
from customers c left JOIN orders o on c.`customerNumber`=o.`customerNumber` 
where o.`orderNumber` is NULL;


-------------OR------------
SELECT c.`customerNumber`, c.`customerName`
from customers c 
where c.`customerNumber` not IN
        (SELECT DISTINCT o.`customerNumber`
        from orders o);


-- tottal purchase value of an ORDER
SELECT `customerNumber`, `customerName`,totat_amt
from customers INNER JOIN orders USING (`customerNumber`)

(
SELECT od.`orderNumber`, sum(od.`quantityOrdered`* od.`priceEach`)total_amt
from orderdetails od 
GROUP BY od.`orderNumber`
order by `orderNumber`;
