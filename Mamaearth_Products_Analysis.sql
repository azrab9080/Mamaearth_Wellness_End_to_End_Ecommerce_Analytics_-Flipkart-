CREATE TABLE Wellness_Products (
    Product_Name VARCHAR(500),
	Reviews int,
	Actual_Prices DECIMAL(10,2),
	Offered_Prices DECIMAL(10,2),
	Flipkart_Assured VARCHAR(50),
    Ratings DECIMAL(2,1)
);

select * from Wellness_Products

--Average Discount rate
SELECT ROUND(AVG(((Actual_Prices - Offered_Prices) / Actual_Prices) * 100), 2) AS Avg_Discount_Percent
FROM Wellness_Products;


--Highest Discounted Products
SELECT Product_Name, Actual_Prices, Offered_Prices, 
       ROUND(((Actual_Prices - Offered_Prices) / Actual_Prices) * 100, 2) AS Discount_Percent
FROM Wellness_Products
ORDER BY Discount_Percent DESC
LIMIT 10;


--Price Segment Distribution
SELECT 
    CASE 
        WHEN Offered_Prices < 200 THEN 'Budget'
        WHEN Offered_Prices BETWEEN 200 AND 500 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS Price_Segment,
    COUNT(*) AS Product_Count
FROM Wellness_Products
GROUP BY Price_Segment;


--Top 10 Most Reviewed Products
SELECT Product_Name, Reviews, Ratings
FROM Wellness_Products
ORDER BY Reviews DESC
LIMIT 10;


--Rating vs. Volume (Correlation)
SELECT Ratings, round(AVG(Reviews),2) AS Avg_Reviews_Per_Rating
FROM Wellness_Products
GROUP BY Ratings
ORDER BY Ratings DESC;


--Underperformers 
SELECT Product_Name, Reviews, Ratings
FROM Wellness_Products
WHERE Ratings < 3 AND Reviews > 100
ORDER BY Reviews DESC;


--The "Assured" Advantage
SELECT Flipkart_Assured, 
       COUNT(*) AS Total_Products,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Wellness_Products), 2) AS Percentage_of_Catalog
FROM Wellness_Products
GROUP BY Flipkart_Assured;


--Trust Impact(Ratings)
SELECT Flipkart_Assured, ROUND(AVG(Ratings), 2) AS Avg_Rating
FROM Wellness_Products
GROUP BY Flipkart_Assured;


--Price Premium for Assured Products
SELECT Flipkart_Assured, ROUND(AVG(Offered_Prices), 2) AS Avg_Price
FROM Wellness_Products
GROUP BY Flipkart_Assured;


--Key Ingredient Success
SELECT 
    CASE 
        WHEN Product_Name LIKE '%Vitamin C%' THEN 'Vitamin C'
        WHEN Product_Name LIKE '%Ubtan%' THEN 'Ubtan'
        WHEN Product_Name LIKE '%Onion%' THEN 'Onion'
        WHEN Product_Name LIKE '%Rosemary%' THEN 'Rosemary'
        WHEN Product_Name LIKE '%Rice Water%' THEN 'Rice Water'
        ELSE 'Other'
    END AS Ingredient_Range,
    COUNT(*) AS Total_Products,
    ROUND(AVG(Ratings), 2) AS Avg_Rating
FROM Wellness_Products
GROUP BY Ingredient_Range
ORDER BY Total_Products DESC;


--Category Performance
SELECT 
    CASE 
        WHEN Product_Name LIKE '%Face Wash%' THEN 'Face Wash'
        WHEN Product_Name LIKE '%Hair Oil%' THEN 'Hair Oil'
        WHEN Product_Name LIKE '%Lotion%' THEN 'Body Lotion'
        WHEN Product_Name LIKE '%Shampoo%' THEN 'Shampoo'
        WHEN Product_Name LIKE '%Sunscreen%' THEN 'Sunscreen'
        ELSE 'Others'
    END AS Category,
    COUNT(*) AS Product_Count,
    SUM(Reviews) AS Total_Reviews
FROM Wellness_Products
GROUP BY Category
ORDER BY Total_Reviews DESC;






