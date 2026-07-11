/*
PROJECT: Retail Sales Analytics Case Study

AUTHOR: Olivier Ndarishize

TOOLS:
- Microsoft SQL Server
- SQL Server Management Studio
- Power BI

OBJECTIVE:

Analyze historical retail sales data to evaluate business performance,
identify growth opportunities, improve profitability,
and support strategic business decisions.
*/

USE RetailSalesAnalytics;
/*
Business Question

Are there any missing values
that could affect analysis accuracy?

Business Importance

Missing values may produce
incorrect KPIs,
wrong dashboard visuals,
and misleading business decisions.
*/
SELECT SUM(CASE WHEN [Order ID] IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_ID,
SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales,
SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS Missing_Discount,
SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Missing_Profit FROM [Orders$];
--The dataset contains no missing values in the critical business fields.

--Are there duplicate transaction records?
SELECT [Row ID], COUNT(*) AS DuplicateCount FROM [Orders$] GROUP BY [Row ID] HAVING COUNT(*) > 1;

--Are there transactions with negative sales values?
SELECT * FROM [Orders$] WHERE Sales < 0;

--Check Negative Quantity
SELECT * FROM [Orders$] WHERE Quantity <= 0;

--Check Invalid Discounts
SELECT * FROM [Orders$] WHERE Discount < 0 OR Discount > 1;

--Date Consistency
SELECT * FROM [Orders$] WHERE [Ship Date] < [Order Date];

--1 How many records exist in the Orders dataset?
SELECT COUNT(*) AS Total_Rows FROM [Orders$];

--2 What does the raw dataset look like?
SELECT TOP(5)* FROM [Orders$];

--3 How many unique customer orders exist?
select count(distinct("Order ID")) as Total_orders from [Orders$];

--4 How many unique customers have purchased?
select count(distinct("Customer ID")) as Total_customers from [Orders$];

--5 How many different products are sold?
select count(distinct("Product ID")) as Total_products from [Orders$];

--TOTAL QUANTITY SOLD
SELECT SUM(Quantity) AS TotalQuantitySold FROM [Orders$];
--6 What is the reporting period?
select min("Order Date") as FirstOrderDate, max("Order Date") as LastOrderDate from [Orders$];

--Shipping Days
SELECT "Order ID", DATEDIFF(DAY,"Order Date","Ship Date") AS ShippingDays FROM [Orders$];

--Total Sales
SELECT SUM(Sales) AS TotalSales FROM [Orders$];

--Total Profit
SELECT SUM(Profit) AS TotalProfit FROM [Orders$];

--Profit Margin
SELECT SUM(Profit) AS TotalProfit, SUM(Sales) AS TotalSales, ROUND((SUM(Profit)/SUM(Sales))*100,2) AS ProfitMarginPercentage FROM [Orders$];
select Sales, Profit from Orders$;

--AVERAGE ORDER VALUE (AOV)
--On average, how much money does a customer spend per order?
SELECT ROUND(SUM(Sales) / COUNT(DISTINCT [Order ID]), 2) AS AverageOrderValue FROM [Orders$];

--AVERAGE DISCOUNT
--On average, what discount does the company give to customers?
select round(AVG(Discount)*100, 2) as AVGDiscount_Percentage from Orders$;

--AVERAGE PROFIT PER ORDER
--On average, how much profit does each order generate?
select round(sum("Profit")/count(distinct("Order ID"))*100, 2) as AverageProfitPerOrder from Orders$;

--SALES PERFORMANCE ANALYSIS
/*
Objective:

Analyze sales performance from different business perspectives
to identify strengths,
weaknesses,
growth opportunities,
and support strategic decision-making.
*/

--Total Sales by Region
--Which region generates the highest sales revenue?
SELECT Region, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$] GROUP BY Region ORDER BY TotalSales DESC;

--Total Profit by Region
--Which region generates the highest profit?
SELECT Region, ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$] GROUP BY Region ORDER BY TotalProfit DESC;

--Profit Margin by Region
SELECT Region, ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit,
ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS ProfitMarginPercentage FROM [Orders$]
GROUP BY Region ORDER BY ProfitMarginPercentage DESC;

--Sales by State
SELECT [State/Province], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [State/Province] ORDER BY TotalSales DESC;

--Total Profit by State
SELECT [State/Province], ROUND(SUM(Profit),2) AS TotalProfit from Orders$
GROUP BY [State/Province] ORDER BY TotalProfit DESC;

--Profit Margin by State
SELECT [State/Province], ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit,
ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS ProfitMarginPercentage FROM [Orders$]
GROUP BY [State/Province] ORDER BY ProfitMarginPercentage DESC;

--Top 10 States by Sales
SELECT TOP (10) [State/Province], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [State/Province] ORDER BY TotalSales DESC;

--Bottom 10 States by Sales
SELECT TOP (10) [State/Province], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [State/Province] ORDER BY TotalSales ASC;

--Sales by City
SELECT TOP (20) City, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY City  ORDER BY TotalSales DESC;

--PRODUCT PERFORMANCE ANALYSIS

/*
Objective:

Analyze product performance to identify
high-performing,
low-performing,
and high-profit products
to support inventory and marketing decisions.
*/

--Sales by Category
--Which product category generates the highest sales?
SELECT Category, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY Category ORDER BY TotalSales DESC;

--Profit by Category
SELECT Category, ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY Category ORDER BY TotalProfit DESC;

--Profit Margin by Category
SELECT Category, ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit,
ROUND( (SUM(Profit)/SUM(Sales))*100, 2 ) AS ProfitMarginPercentage FROM [Orders$]
GROUP BY Category ORDER BY ProfitMarginPercentage DESC;

--Sales by Sub-Category
SELECT [Sub-Category], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [Sub-Category] ORDER BY TotalSales DESC;

--Profit by Sub-Category
SELECT [Sub-Category], ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Sub-Category] ORDER BY TotalProfit DESC;

--Top 10 Products by Sales
SELECT TOP (10) [Product Name], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [Product Name] ORDER BY TotalSales DESC;

--Top 10 Products by Profit
SELECT TOP (10) [Product Name], ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Product Name] ORDER BY TotalProfit DESC;

--Bottom 10 Products by Profit
SELECT TOP (10) [Product Name], ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Product Name] ORDER BY TotalProfit ASC;

--DISCOUNT & PROFIT ANALYSIS
/*
Objective:

Analyze the relationship between discounts and profitability
to determine whether current discount strategies
improve sales or reduce business profit.
*/

--Average Discount by Category
SELECT Category, ROUND(AVG(Discount)*100,2) AS AverageDiscountPercentage FROM [Orders$]
GROUP BY Category ORDER BY AverageDiscountPercentage DESC;

--Average Profit by Category
SELECT Category, ROUND(AVG(Profit),2) AS AverageProfit FROM [Orders$]
GROUP BY Category ORDER BY AverageProfit DESC;

--Average Discount by Sub-Category
SELECT [Sub-Category], ROUND(AVG(Discount)*100,2) AS AverageDiscountPercentage FROM [Orders$]
GROUP BY [Sub-Category] ORDER BY AverageDiscountPercentage DESC;

--Products with Negative Profit
SELECT [Product Name], ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Product Name] HAVING SUM(Profit) < 0 ORDER BY TotalProfit ASC;

--High Sales but Low Profit Products
SELECT TOP (15) [Product Name], ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit
FROM [Orders$] GROUP BY [Product Name] ORDER BY TotalSales DESC;

--Products with Highest Profit Margin
SELECT TOP (15) [Product Name], ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit,
ROUND((SUM(Profit)/SUM(Sales))*100,2) AS ProfitMarginPercentage FROM [Orders$]
GROUP BY [Product Name] HAVING SUM(Sales) > 0 ORDER BY ProfitMarginPercentage DESC;

--Discount vs Profit Summary
SELECT ROUND(AVG(Discount)*100,2) AS AverageDiscountPercentage, ROUND(AVG(Profit),2) AS AverageProfit FROM [Orders$];

--CUSTOMER ANALYSIS
/*
Objective:

Analyze customer purchasing behavior
to identify the most valuable customers,
their contribution to sales and profit,
and support customer retention strategies.
*/

--Top 10 Customers by Sales
SELECT TOP (10) [Customer Name], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [Customer Name] ORDER BY TotalSales DESC;

--Top 10 Customers by Profit
SELECT TOP (10) [Customer Name], ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Customer Name] ORDER BY TotalProfit DESC;

--Customer Order Frequency
SELECT TOP (10) [Customer Name], COUNT(DISTINCT [Order ID]) AS NumberOfOrders FROM [Orders$]
GROUP BY [Customer Name] ORDER BY NumberOfOrders DESC;

--Average Sales per Customer
SELECT ROUND(SUM(Sales)/COUNT(DISTINCT [Customer ID]), 2) AS AverageSalesPerCustomer FROM [Orders$];

--Customer Segment Analysis
SELECT Segment, ROUND(SUM(Sales),2) AS TotalSales, ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY Segment ORDER BY TotalSales DESC;

--Customer Distribution by Segment
SELECT Segment, COUNT(DISTINCT [Customer ID]) AS TotalCustomers FROM [Orders$]
GROUP BY Segment ORDER BY TotalCustomers DESC;

--TIME SERIES ANALYSIS


--Sales by Year
SELECT YEAR([Order Date]) AS OrderYear, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY YEAR([Order Date]) ORDER BY OrderYear;

--Profit by Year
SELECT YEAR([Order Date]) AS OrderYear, ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY YEAR([Order Date]) ORDER BY OrderYear;

--Monthly Sales Trend
SELECT DATENAME(MONTH,[Order Date]) AS MonthName,
ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY MONTH([Order Date]), DATENAME(MONTH,[Order Date]) ORDER BY TotalSales;

--Monthly Profit Trend
SELECT DATENAME(MONTH,[Order Date]) AS MonthName,
ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY MONTH([Order Date]), DATENAME(MONTH,[Order Date]) ORDER BY TotalProfit;

--Quarterly Sales
SELECT DATEPART(QUARTER,[Order Date]) AS Quarter, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY DATEPART(QUARTER,[Order Date]) ORDER BY Quarter;

--Best Sales Month
SELECT TOP 1 DATENAME(MONTH,[Order Date]) AS BestMonth, ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY DATENAME(MONTH,[Order Date]),MONTH([Order Date]) ORDER BY TotalSales DESC;

--SHIPPING & OPERATIONAL ANALYSIS

--Average Shipping Days
--How many days does shipping take on average?
SELECT ROUND(AVG(DATEDIFF(day,[Order Date],[Ship Date])), 2) AS AverageShippingDays FROM [Orders$];

--Shipping Mode Performance
SELECT [Ship Mode], ROUND(AVG(DATEDIFF(day,[Order Date],[Ship Date])),2) AS AverageShippingDays
FROM [Orders$]
GROUP BY [Ship Mode] ORDER BY AverageShippingDays;

--Sales by Ship Mode
SELECT [Ship Mode], ROUND(SUM(Sales),2) AS TotalSales FROM [Orders$]
GROUP BY [Ship Mode] ORDER BY TotalSales DESC;

--Profit by Ship Mode
SELECT [Ship Mode], ROUND(SUM(Profit),2) AS TotalProfit FROM [Orders$]
GROUP BY [Ship Mode] ORDER BY TotalProfit DESC;
