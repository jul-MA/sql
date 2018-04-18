/*
SQL Grid: how to build a (x,y) grid with SQL

	0		1		2
	-----------------
0	A1	|	A2	|	A3
	-----------------
1	B1	|	B2	|	B3
	-----------------
2	C1	|	C2	|	C3


@nbcolumns: user defined variable. Number of columns you want to output. Number of rows is dynamic.
Each (x,y) coordinate contains a value.
Values are ordered in a descending order.

*/

-- Example 1

CREATE TABLE MyTable (
	Field1 VARCHAR(20) NOT NULL
	,Metric1 INT NOT NULL
)

INSERT INTO MyTable (Field1,Metric1)
VALUES	 ('ValueA',2053),('ValueA',403),('ValueA',9874)
		,('ValueB',874),('ValueB',2053),('ValueB',8854)
		,('ValueC',1047),('ValueC',53),('ValueC',78)
		,('ValueD',1986),('ValueD',567),('ValueD',1478)
		,('ValueE',358),('ValueE',4587),('ValueE',658)
		,('ValueF',602),('ValueF',783),('ValueF',10257)
		,('ValueG',4897),('ValueG',147),('ValueG',235)
		,('ValueH',3577),('ValueH',2678),('ValueH',964)
		,('ValueI',4021),('ValueI',5674),('ValueI',2497)

DECLARE @nbcolumns INT = 3;

SELECT	Field1
		,SUM(Metric1) as sum_Metric1
		,1 + ((ROW_NUMBER() over (ORDER BY SUM(Metric1) DESC) - 1) % @nbcolumns) as x
		,ROUND((CAST(ROW_NUMBER() OVER (ORDER BY SUM(Metric1) DESC)as float) / @nbcolumns) - 0.01,0,1)  as y 
FROM MyTable
GROUP BY Field1;


-- Example 2 - using Microsoft SQL Server AdventureWorksDW2012 Database

DECLARE @nbcolumns INT = 3;

SELECT	F.SalesTerritoryKey
		,D.SalesTerritoryRegion
		,SUM(F.SalesAmount) as SumSalesAmount
		,1 + ((ROW_NUMBER() over (ORDER BY SUM(F.SalesAmount) DESC) - 1) % @nbcolumns) as x
		,ROUND((CAST(ROW_NUMBER() OVER (ORDER BY SUM(F.SalesAmount) DESC)as float) / @nbcolumns) - 0.01,0,1)  as y 
FROM AdventureWorksDW2012.dbo.FactInternetSales F
INNER JOIN AdventureWorksDW2012.dbo.DimSalesTerritory D ON D.SalesTerritoryKey = F.SalesTerritoryKey
GROUP BY F.SalesTerritoryKey,D.SalesTerritoryRegion;

