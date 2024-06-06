#'''1. Retrieve the top 5 customers who have made the highest average order amounts in the last 6 months.'''

SELECT c.FirstName, c.LastName, AVG(o.TotalAmount) AS AvgOrderAmount
FROM FactOrders o
JOIN DimCustomers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDateID >= (SELECT MAX(DateID) FROM DimDate WHERE Date >= DATE('now', '-6 months'))
GROUP BY c.CustomerID
ORDER BY AvgOrderAmount DESC
LIMIT 5;

#2. Retrieve the list of customers whose order value is lower this year as compared to the previous year.

SELECT c.FirstName, c.LastName
FROM FactOrders o
JOIN DimCustomers c ON o.CustomerID = c.CustomerID
JOIN DimDate d ON o.OrderDateID = d.DateID
WHERE strftime('%Y', d.Date) = strftime('%Y', DATE('now'))
GROUP BY c.CustomerID
HAVING SUM(CASE WHEN strftime('%Y', d.Date) = strftime('%Y', DATE('now')) THEN o.TotalAmount ELSE 0 END) <
       SUM(CASE WHEN strftime('%Y', d.Date) = strftime('%Y', DATE('now', '-1 year')) THEN o.TotalAmount ELSE 0 END);


#'''3. Create a table showing cumulative purchases by a particular customer. Show the breakup of cumulative purchases by product category.'''

SELECT c.FirstName, c.LastName, p.CategoryID, SUM(o.TotalAmount) AS CumulativePurchase
FROM FactOrders o
JOIN DimCustomers c ON o.CustomerID = c.CustomerID
JOIN FactOrderDetails od ON o.OrderID = od.OrderID
JOIN DimProductVariants pv ON od.VariantID = pv.VariantID
JOIN DimProducts p ON pv.ProductID = p.ProductID
GROUP BY c.CustomerID, p.CategoryID
ORDER BY c.FirstName, c.LastName, p.CategoryID;


#'''4. Retrieve the list of top 5 selling products. Further bifurcate the sales by product variants.'''

-- WITH ProductSales AS (
--     SELECT pv.ProductID, pv.VariantID, SUM(od.Quantity) AS TotalSales
--     FROM FactOrderDetails od
--     JOIN DimProductVariants pv ON od.VariantID = pv.VariantID
--     GROUP BY pv.ProductID, pv.VariantID
-- )
-- SELECT p.ProductID, p.ProductName, pv.VariantID, ps.TotalSales
-- FROM ProductSales ps
-- JOIN DimProducts p ON ps.ProductID = p.ProductID
-- JOIN DimProductVariants pv ON ps.VariantID = pv.VariantID
-- ORDER BY ps.TotalSales DESC
-- LIMIT 5;

