DROP DATABASE IF EXISTS Zepto_SQL_Project;


CREATE DATABASE Zepto_SQL_Project;
USE Zepto_SQL_Project;

CREATE TABLE zepto (
  sku_id INT AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp DECIMAL(8,2),
  discountPercent DECIMAL(5,2),
  availableQuantity INT,
  discountedSellingPrice DECIMAL(8,2),
  weightInGms INT,
  outOfStock TINYINT,
  quantity INT
);

-- Count of all the rows 
SELECT COUNT(*) 
FROM zepto;

-- Sample data
SELECT * 
FROM zepto
LIMIT 10;

-- Null values
SELECT * FROM zepto
WHERE category IS NULL
OR 
name IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
availableQuantity IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL;

-- Different product category
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

-- Out of stock products
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- Product names that are present multiple times (SKU = Stock Keeping Unit)
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Data cleaning: Products with mrp as 0
SELECT * 
FROM zepto
WHERE mrp = 0 or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;
DELETE
FROM zepto
WHERE mrp = 0;

-- Changing mrp from paise to rupees
UPDATE zepto
SET mrp = mrp/100.0, 
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice
FROM zepto;

-- Top 10 best-value products based on discount percentage
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- High-MRP products that are currently out of stock
SELECT DISTINCT name, mrp, outOfStock
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

-- Estimated potential revenue for each product category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS Total_Revenue
FROM zepto
GROUP BY category
ORDER BY Total_Revenue;

-- Expensive products (MRP > ₹500) with minimal discounts
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10 
ORDER BY mrp DESC;

-- Top 5 categories offering highest average discounts
SELECT category, ROUND(AVG(discountPercent),2) AS Average_discount
FROM zepto
GROUP BY category
ORDER BY Average_discount DESC
LIMIT 5;

-- Price per gram analysis to identify value-for-money products for products with weight above 100g
SELECT name, discountedSellingPrice, weightInGms, ROUND((discountedSellingPrice/weightInGms),2) AS Price_Per_Gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY Price_Per_Gram DESC;

-- Product grouping by weight: Low, Medium, and Bulk categories
SELECT name, weightInGms,
CASE
	WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms BETWEEN 1000 AND 5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS Weight_Bracket
FROM zepto;

-- Total inventory weight per product category
SELECT category, SUM(weightInGms*availableQuantity) AS Weight
FROM zepto
GROUP BY category
ORDER BY Weight DESC;


