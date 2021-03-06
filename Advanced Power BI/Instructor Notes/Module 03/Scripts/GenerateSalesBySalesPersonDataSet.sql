/****** Script for SelectTopNRows command from SSMS  ******/
WITH TEST AS(

SELECT 
	   [EmployeeKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
	  ,1 AS Allocation
  FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
  WHERE 
	[SalesAmount] > 1000

UNION ALL

SELECT 
	   290
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
	  ,.7 as Allocation
  FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
  WHERE 
	[SalesAmount] > 10000 

UNION ALL

SELECT 
	   294
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
	  ,.7 as Allocation
  FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
  WHERE 
	[SalesAmount] < 10000 AND 
	[SalesAmount] > 9000 AND
	[SalesOrderNumber] NOT IN
	(
		SELECT DISTINCT
			[SalesOrderNumber]
		FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
		WHERE 
			[SalesAmount] > 10000 
	)

UNION ALL

SELECT 
	   272
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
	  ,.7 as Allocation
  FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
  WHERE 
	[SalesAmount] > 8600 AND 
	[SalesAmount] < 9000 AND
	[SalesOrderNumber] NOT IN
	(
		SELECT DISTINCT
			[SalesOrderNumber]
		FROM [AdventureworksDW2016].[dbo].[FactResellerSales]
		WHERE 
			[SalesAmount] > 9000 
	)),
	
test1 AS (

	SELECT 
		*, 
		ROW_NUMBER() OVER (PARTITION BY SalesOrderNumber, SalesOrderLineNumber ORDER BY allocation) RN FROM TEST
		)
		,
		test2 as (
SELECT 
	   [EmployeeKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
	  ,CASE WHEN RN = 2 THEN .3 ELSE Allocation END AS ALLOCATION
FROM test1
)
SELECT 
	*
   ,CASE WHEN Allocation = 1 THEN 0 ELSE 1 END AS Shared
FROM test2



