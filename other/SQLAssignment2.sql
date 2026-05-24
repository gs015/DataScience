use intrain
GO
IF OBJECT_ID('dbo.Restaurant',N'U') IS NOT NULL
	DROP TABLE dbo.Restaurant;

CREATE TABLE dbo.Restaurant (
			Id INT,
			Name VARCHAR(100) NOT NULL,
			Address VARCHAR(200),
			Rating  NUMERIC(5,4),
			Type VARCHAR(50),
			BranchCode VARCHAR(10),
			CONSTRAINT PK_Resturant_Id PRIMARY KEY(Id)
	);

GO

IF OBJECT_ID(N'dbo.Cuisine', N'U') IS NOT NULL
	DROP TABLE dbo.Cuisine;

CREATE TABLE dbo.Cuisine(
        Id INT NOT NULL IDENTITY(1,1),
		CuisineType VARCHAR(10) NOT NULL,
		Cuisine VARCHAR(100) NOT NULL,
		Rating NUMERIC(5,4) NULL,
		RestaurantId INT NOT NULL,
		Price  NUMERIC(10,4) NULL,
		CONSTRAINT PK_cusine_id PRIMARY KEY(Id),
		CONSTRAINT FK_Restaurant FOREIGN KEY(RestaurantId) REFERENCES dbo.Restaurant(Id)
   )

IF OBJECT_ID('dbo.udf_QuickBites', N'FN') IS NOT NULL
	DROP FUNCTION dbo.udf_QuickBites;
GO

CREATE FUNCTION udf_QuickBites(
        @item VARCHAR(50),
		@slogan VARCHAR(100) = 'Quick Bites',
		@add_single_quotes CHAR(1) ='0'
		)
RETURNS VARCHAR(150)
AS
BEGIN
	 DECLARE @space_pos SMALLINT,
	         @modified_slogan VARCHAR(150)
	--using stuff function
	SET @space_pos = CHARINDEX(' ', @slogan)

	IF @space_pos > 0 AND @item IS NOT NULL
		SET @modified_slogan = STUFF(@slogan, @space_pos, 0, ' ' + @item)
	ELSE
	    SET @modified_slogan = @slogan

	RETURN @modified_slogan
END;

--select * from sys.objects where NAME LIKE 'UDF%' 

--SELECT dbo.udf_QuickBites('Chicken','Quick Bites','0')
GO

IF OBJECT_ID(N'dbo.usp_get_best_cuisine',N'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_get_best_cuisine;
GO

CREATE PROCEDURE dbo.usp_get_best_cuisine
AS
BEGIN
	SELECT Name, CuisineType 
		   FROM dbo.Restaurant r
		   INNER JOIN dbo.Cuisine c
		   ON r.Id = c.RestaurantId
	 WHERE c.id = (SELECT TOP 1 c2.id FROM cuisine c2 ORDER BY c2.Rating DESC)

END;


EXEC usp_get_best_cuisine

GO

IF OBJECT_ID(N'dbo.udf_best_cuisine', N'FN') IS NOT NULL
   DROP FUNCTION dbo.udf_best_cuisine;

GO

CREATE FUNCTION dbo.udf_best_cuisine()
RETURNS VARCHAR(150)
AS
BEGIN

	DECLARE @slogan VARCHAR(150) = '',
			@item   VARCHAR(100),
			@Restaurant VARCHAR(100)

	SELECT @Restaurant = r.Name, @item = c.CuisineType 
		FROM dbo.Restaurant r
		INNER JOIN dbo.Cuisine c
		ON r.Id = c.RestaurantId
	WHERE c.id = (SELECT TOP 1 c2.id FROM cuisine c2 ORDER BY c2.Rating DESC)

	IF @Restaurant IS NOT NULL AND @item IS NOT NULL
	 SET  @slogan = dbo.udf_QuickBites(@item, 'Yummy Varities', '0') + ' at ' + @Restaurant

	RETURN @slogan

END;

GO

SELECT dbo.udf_best_cuisine();

GO

ALTER TABLE dbo.Restaurant ADD RatingStatus AS (CASE WHEN Rating >= 4 THEN 'Excellent' 
													 WHEN Rating < 4 AND Rating <= 3.5 THEN 'Good' 
													 WHEN Rating < 3.5 AND Rating <= 3 THEN 'Average' 
 													 ELSE 'Bad' END) ; --PERSISTED;
GO

SELECT * FROM dbo.Restaurant

GO

SELECT 
   GETDATE()  AS CurrDate,
   YEAR(GETDATE()) AS CurrYear,
   DATENAME(MONTH, GETDATE()) AS Month_Name,
   CEILING(r.Rating) AS CeilRating,
   FLOOR(r.Rating) AS FloorRating,
   ABS(r.Rating) AS AbsRating
 FROM dbo.Restaurant r ;


SELECT r.Type AS RestaurantType,
       AVG(c.Price) AS AvgPrice
 FROM dbo.Restaurant r INNER JOIN dbo.Cuisine c
   ON r.Id = c.RestaurantId 
 GROUP BY ROLLUP(r.Type);

