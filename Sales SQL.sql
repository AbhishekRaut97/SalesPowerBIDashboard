-- Finding the total number of customers 
select distinct(count(customerNumber)) from customers;

-- Finding the total sales 
SELECT sum(priceEach * quantityOrdered) AS total
FROM OrderDetails;

-- Total sales and total orders by year
SELECT YEAR(o.orderDate) AS orderYear, 
       COUNT(o.orderNumber) AS orderCount, 
       SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM Orders o
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY orderYear;

-- Top 5 Customers who made the most number of orders
SELECT c.customerNumber, c.customerName, COUNT(ods.orderNumber) AS orderCount
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
join orderdetails ods on o.orderNumber=ods.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY orderCount DESC
LIMIT 5;

-- Bottom 5 customers who made the least number of orders 
SELECT c.customerNumber, c.customerName, COUNT(ods.orderNumber) AS orderCount
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN OrderDetails ods ON o.orderNumber = ods.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY orderCount ASC
LIMIT 5;

-- Top 5 customers with the most sales 
SELECT c.customerNumber, c.customerName, SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY totalSales DESC
LIMIT 5;

-- Bottom 5 customers with least sales
SELECT c.customerNumber, c.customerName, SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY totalSales
LIMIT 5;

-- Count of orders by status 
SELECT status, COUNT(*) AS order_count
FROM Orders
GROUP BY status;

-- Customers who cancel the orders 
SELECT 
    c.customerName,
    o.orderNumber,
    o.status
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
WHERE o.status = 'Cancelled';

-- Transaction Analysis by year 
SELECT 
    YEAR(o.orderDate) AS orderYear, 
    COUNT(DISTINCT od.orderNumber) AS customerTransactions,
    COUNT(od.orderNumber) AS totalTransactions
FROM OrderDetails od 
JOIN Orders o ON od.orderNumber = o.orderNumber
GROUP BY orderYear WITH ROLLUP;

-- Total amount paid by customers 
SELECT 
    SUM(amount) AS 'Total Amount Paid'
FROM payments;

-- Total payment by year 
SELECT 
    YEAR(paymentDate) AS 'Payment Year', 
    SUM(amount) AS 'Total Amount Paid'
FROM payments
GROUP BY YEAR(paymentDate);

-- Top 5 customer who paid the most amount 
SELECT 
    customerNumber,
    SUM(amount) AS total_payment
FROM payments
GROUP BY customerNumber
ORDER BY total_payment DESC
LIMIT 5;

-- Bottom 5 customer who paid the least amount 
SELECT 
    customerNumber,
    SUM(amount) AS total_payment
FROM payments
GROUP BY customerNumber
ORDER BY total_payment 
LIMIT 5;

-- Count of prducts by product line 
SELECT 
    pl.productLine, 
    COUNT(p.productCode) AS totalProductCount
FROM ProductLines pl
JOIN Products p ON pl.productLine = p.productLine
GROUP BY pl.productLine;

-- Total sales by product line each year 
SELECT YEAR(o.orderDate) AS orderYear, 
       p.productLine AS subCategory,
       SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM Orders o
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode
GROUP BY orderYear, subCategory;

-- Total profit 
SELECT 
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode;

-- Total profit by year 
SELECT 
    YEAR(o.orderDate) AS orderYear,
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
GROUP BY orderYear;

-- Top 5 selling products with their total quantity
SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS totalQuantityOrdered,
    SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalQuantityOrdered DESC
LIMIT 5;

-- Bottom 5 selling products 
SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS totalQuantityOrdered,
    SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalQuantityOrdered ASC
LIMIT 5;

-- Top 5 Profit making products 
SELECT 
    p.productCode,
    p.productName,
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalProfit DESC
LIMIT 5;

-- Bottom 5 products in making profits 
SELECT 
    p.productCode,
    p.productName,
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalProfit
LIMIT 5;

-- Sales by year and product and order count 
CREATE VIEW total_sales_by_year_product_view AS
SELECT 
    YEAR(o.orderDate) AS orderYear, 
    p.productCode, 
    p.productName,
    COUNT(o.orderNumber) AS orderCount, 
    SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM Orders o
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode
GROUP BY orderYear, p.productCode, p.productName;

SELECT * FROM total_sales_by_year_product_view;
