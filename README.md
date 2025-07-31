# Zepto Inventory SQL Analysis

This project analyzes a grocery product inventory dataset inspired by Zepto, using SQL to clean, transform, and extract business insights. The analysis focuses on pricing efficiency, discount strategies, stock levels, and category-wise trends.

## Dataset Overview

- Source: Cleaned CSV file with ~3700 rows
- Columns:
  - `sku_id` (auto-generated)
  - `name` (product name)
  - `category`
  - `mrp` (in ₹)
  - `discountPercent`
  - `discountedSellingPrice`
  - `availableQuantity`
  - `weightInGms`
  - `outOfStock` (boolean)
  - `quantity`

## Tools Used

- MySQL Workbench
- SQL (DDL, DML, Aggregate Queries, CASE, Joins)
- Excel (for initial cleanup)

## Project Structure

| File                     | Description                                 |
|--------------------------|---------------------------------------------|
| `zepto_schema.sql`       | SQL table creation (DDL)                    |
| `zepto_cleaning.sql`     | Data validation and cleanup queries         |
| `zepto_data.csv`         | Cleaned dataset (without `sku_id`)          |

## Data Cleaning Highlights

- Removed rows with `mrp = 0` or `discountedSellingPrice = 0`
- Converted price fields from paise to rupees
- Mapped boolean and numeric values cleanly

## Key Insights Extracted

- **Top 10 best-value products** based on discount percentage
- **High-MRP items currently out of stock**
- **Estimated potential revenue** for each product category
- **Expensive products with minimal discounts**
- **Top 5 categories** offering the **highest average discounts**
- **Price per gram analysis** to evaluate value-for-money
- **Weight-based product classification**: Low, Medium, Bulk
- **Total inventory weight** grouped by product category

## Example Queries

```sql
-- Calculate average discount by category
SELECT category, AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
HAVING AVG(discountPercent) > 20
ORDER BY avg_discount DESC;

-- Weight bracket classification
SELECT name, weightInGms,
  CASE
    WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms BETWEEN 1000 AND 5000 THEN 'MEDIUM'
    ELSE 'BULK'
  END AS Weight_Bracket
FROM zepto;
