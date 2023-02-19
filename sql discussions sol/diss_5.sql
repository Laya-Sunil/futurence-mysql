-- Active: 1673683090785@@127.0.0.1@3307@classicmodels
-- Disscussion 5

-- 1.Write a query to find customers whose payments are 
-- greater than the average payment using a subquery.
SELECT  c.`customerNumber`,p.`checkNumber`,p.amount
from customers c INNER JOIN payments p 
ON c.`customerNumber`=p.`customerNumber`
where p.amount> (SELECT avg(amount) FROM payments);

-- 2.Use a subquery with NOT IN operator to find the customers 
-- who have not placed any orders.
SELECT c.`customerName`
FROM customers c 
WHERE c.`customerNumber` not in 
    (SELECT distinct `customerNumber` FROM orders);

-- 3.Write a subquery that finds the maximum, minimum, and 
-- average number of items in sale orders from orderdetails.

SELECT MAX(items), MIN(items),FLOOR(AVG(items))
FROM (
    SELECT COUNT(od.orderNumber)items
    FROM orderdetails od
    GROUP BY od.`orderNumber`)b;

-- 4. Use a correlated subquery to select products whose buy prices are greater 
-- than the average buy price of all products in each product line.
SELECT p1.`productName`, p1.`buyPrice`
FROM products p1 
WHERE p1.`buyPrice`>( 
                SELECT AVG(p2.`buyPrice`)
                FROM products p2
                WHERE p1.`productLine`=p2.`productLine`
                GROUP BY p2.`productLine`);

-- 5.Write a query that finds sales orders whose total values are greater than 60K 
SELECT od.`orderNumber`, sum(od.`priceEach` * od.`quantityOrdered`)amount
FROM orderdetails od
 GROUP BY od.`orderNumber`
 having sum(od.`priceEach`* od.`quantityOrdered`) > 60000;

-- 6.Use query in question no. 5 as a correlated subquery to find customers who placed at 
-- least one sales order with the total value greater than 60K by using the EXISTS operator:
SELECT c.`customerNumber`,c.`customerName`
FROM customers c
where exists
        (SELECT od.`orderNumber`, sum(od.`priceEach` * od.`quantityOrdered`)amount
        FROM orderdetails od INNER JOIN orders o 
        ON od.`orderNumber`=o.`orderNumber`
        WHERE o.`customerNumber`=c.`customerNumber` 
        GROUP BY od.`orderNumber`
        having sum(od.`priceEach`* od.`quantityOrdered`) > 60000);

-- 7.Write a query that gets the top five products by sales revenue in 2003 from the 
-- orders and orderdetails tables as follows:
SELECT od.`productCode`, sum(od.`priceEach`* od.`quantityOrdered`)sales
FROM (select orderNumber FROM orders  WHERE year(`orderDate`)=2003) as o INNER JOIN orderdetails od 
ON o.`orderNumber`=od.`orderNumber`
GROUP BY od.`productCode`
ORDER BY sales desc
limit 5;

-- 8.You can use the result of the previous query as a derived table called top5product2003
--  and join it with the products table using the productCode column.. Then, find out the 
-- productName and sales of the top 5 products in 2003.

SELECT p.`productName`, round(b.sales,0)
FROM products p INNER JOIN 
         (SELECT od.`productCode` as `productCode`, sum(od.`priceEach`* od.`quantityOrdered`)sales
            FROM (select orderNumber FROM orders  WHERE year(`orderDate`)=2003) as o 
            INNER JOIN orderdetails od 
            ON o.`orderNumber`=od.`orderNumber`
            GROUP BY od.`productCode`
            ORDER BY sales desc
            limit 5)b
ON p.`productCode` = b.`productCode`;

-- 9.Suppose you have to label the customers who bought products in 2003 into 3 groups: 
-- platinum, gold, and silver with the following conditions:
-- Platinum customers who have orders with the volume greater than 100K.
-- Gold customers who have orders with the volume between 10K and 100K.
-- Silver customers who have orders with the volume less than 10K.
-- To form this query, you first need to put each customer into the respective group using
-- CASE expression and GROUP BY to display the following:
SELECT b.customerNumber, b.sales,
			case 
            	when b.sales >100000 then "Platinum"
                when b.sales>10000 and b.sales<=100000 then "Gold"
                else "Silver"
            end customerGroup
FROM
(SELECT o.`customerNumber`, sum(od.`priceEach` * od.`quantityOrdered`)sales
FROM orderdetails od 
INNER JOIN (SELECT `customerNumber`,`orderNumber` FROM orders WHERE YEAR(orderDate)=2003)o
ON od.`orderNumber`=o.`orderNumber`
GROUP BY o.customerNumber
ORDER BY o.customerNumber)b;

-- OR
-- 10.Use the previous query as the derived table to know the number of customers in each 
-- group: platinum, gold, and silver
SELECT customerGroup, COUNT(*)
FROM (
        SELECT b.customerNumber, b.sales,
                    case 
                        when b.sales >100000 then "Platinum"
                        when b.sales>10000 and b.sales<=100000 then "Gold"
                        else "Silver"
                    end customerGroup
        FROM (
                SELECT o.`customerNumber`, sum(od.`priceEach` * od.`quantityOrdered`)sales
                FROM orderdetails od 
                INNER JOIN (
                                SELECT `customerNumber`,`orderNumber` FROM orders 
                                WHERE YEAR(orderDate)=2003
                            )o 
            ON od.`orderNumber`=o.`orderNumber`
            GROUP BY o.customerNumber
        )b
    )derivedTable GROUP BY customerGroup
;

-- OR
SELECT customerGroup, COUNT(customerGroup) AS groupCount 
FROM  (SELECT customerNumber, FLOOR(SUM(quantityOrdered*priceEach)) AS sales, 
(CASE 
    WHEN FLOOR(SUM(quantityOrdered*priceEach)) > 100000 THEN 'Platinum'
    WHEN FLOOR(SUM(quantityOrdered*priceEach)) BETWEEN 10000 AND 100000 THEN 'Gold'
    WHEN FLOOR(SUM(quantityOrdered*priceEach)) < 10000 THEN 'Silver'
 END) AS customerGroup
FROM orderdetails, orders
WHERE orderdetails.orderNumber = orders.orderNumber AND ( YEAR(orders.shippedDate) = 2003 
            -- OR YEAR(orders.requiredDate) = 2003
            )
GROUP BY customerNumber
ORDER BY customerNumber) AS derivedTable
GROUP BY customerGroup;

use classicmodels;
SELECT * FROM (select `customerName` as name
from customers) AS temp
where name like '%a%';

select `customerName` as name
from customers
where `customerName` like '%a%';

-- find the number of returned orders per customers
select c.customerName, 
o.`customerNumber`, COUNT(o.`orderNumber`)
from orders o  INNER JOIN customers c
ON o.customerNumber=c.customerNumber
where o.status in ('Disputed','Resolved') --and o.`customerNumber` = 452
GROUP BY o.`customerNumber`;
-- find the number of returned orders per year
select c.customerName, o.`customerNumber`, year(o.`orderDate`)year,COUNT(o.`orderNumber`)
from (
    select * from orders  where status in ('Disputed','Resolved')
    )o 
INNER JOIN customers c
ON o.customerNumber=c.customerNumber
GROUP BY o.`customerNumber`,year;

-- add total orders placed, returned order percent 

SELECT o.customerNumber, c.`customerName`, total, COUNT(o.`orderNumber`)Returned_order,
        (COUNT(o.`orderNumber`)/total)*100 as Returned_percent
FROM (
        select * from orders  where status in ('Disputed','Resolved')
    )o
INNER JOIN (
        SELECT `customerNumber`, count(*)total 
        FROM orders GROUP BY `customerNumber`
    )b
ON o.`customerNumber`= b.`customerNumber`
INNER JOIN customers c ON o.`customerNumber`= c.`customerNumber`
GROUP BY o.`customerNumber`; 
-- returned order percent per year
SELECT o.customerNumber, c.`customerName`, total, COUNT(o.`orderNumber`)Returned_order,
        year(o.orderDate)year, (COUNT(o.`orderNumber`)/total)*100 as Returned_percent
FROM (
        select * from orders  where status in ('Disputed','Resolved')
    )o
INNER JOIN (
        SELECT `customerNumber`, count(*)total 
        FROM orders GROUP BY `customerNumber`
    )b
ON o.`customerNumber`= b.`customerNumber`
INNER JOIN customers c ON o.`customerNumber`= c.`customerNumber`
GROUP BY o.`customerNumber`,year(o.orderDate)
having Returned_percent>20;

-- need also the customers who have not returned anythg

SELECT `customerNumber`, count(*)total 
        FROM orders GROUP BY `customerNumber`
        HAVING `customerNumber`=141;

SELECT o.`customerNumber`,c.`customerName`, SUM(o.Returned_Order)Returned_Count, b.total,
        (sum(o.Returned_Order)/total)*100 as Returned_percent

FROM   (
            SELECT o.`customerNumber` CustomerNumber, 
                CASE
                    WHEN o.status in ('Resolved','Disputed') THEN COUNT(o.`orderNumber`)
                    ELSE 0
                END  Returned_Order
            FROM orders o
            GROUP BY o.`customerNumber`,o.status
        ) o
INNER JOIN (
            SELECT `customerNumber`, count(*)total 
            FROM orders GROUP BY `customerNumber`
        )b
ON o.`customerNumber`= b.`customerNumber`
INNER JOIN customers c ON o.`customerNumber`= c.`customerNumber`
GROUP BY o.`customerNumber`;
--having o.`customerNumber`=141;
        

/*
SELECT o.`customerNumber` CustomerNumber, 
                        CASE
                            WHEN o.status in ('Resolved','Disputed') THEN COUNT(o.`orderNumber`)
                            ELSE 0
                        END  Returned_Order
FROM orders o
GROUP BY o.`customerNumber`,o.status
having `customerNumber`=141;
*/
--- testing
select count(*) from orders 
where `customerNumber`=145;

select count(*) from orders 
where `customerNumber`=145 AND status in ('Resolved','Disputed');

-- GROUP BY with Rollup
SELECT `orderNumber`, sum(od.`priceEach`), sum(od.`quantityOrdered`) 
from orderdetails od
GROUP BY `orderNumber` with rollup;