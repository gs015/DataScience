

CREATE OR ALTER PROCEDURE usp_AvailableRestaurant
AS
BEGIN
SELECT 
 RestaurantName,
 RestaurantType,
 CuisinesType
FROM dbo.Jomato
WHERE TableBooking = 1;
END;

GO

EXEC usp_AvailableRestaurant

go

BEGIN TRANSACTION

GO

SELECT count(*) FROM dbo.Jomato WHERE RestaurantType = 'Cafe';

UPDATE dbo.Jomato
  SET RestaurantType = 'Cafeteria'
  WHERE RestaurantType = 'Cafe';

SELECT count(*) FROM dbo.Jomato WHERE RestaurantType = 'Cafe';
SELECT count(*) FROM dbo.Jomato WHERE RestaurantType = 'Cafeteria';

ROLLBACK TRAN;

SELECT count(*) FROM dbo.Jomato WHERE RestaurantType = 'Cafe';
SELECT count(*) FROM dbo.Jomato WHERE RestaurantType = 'Cafeteria';

GO

--- Problem : 3
SELECT TOP 5
  Area,
  COUNT(iif(Rating >= 3.7, 1, null)) as GoodRestsCount,
  ROW_NUMBER() OVER(ORDER BY COUNT(iif(Rating >= 3.7, 1, null)) DESC) as RN
  FROM dbo.Jomato
GROUP BY Area
--ORDER BY GoodRestsCount DESC 

GO

SELECT dt.*,
       ROW_NUMBER() OVER(ORDER BY GoodRestsCount DESC) as Rn
 FROM (
SELECT TOP 5
  Area,
  COUNT(iif(Rating >= 3.7, 1, null)) as GoodRestsCount
  FROM dbo.Jomato
GROUP BY Area
ORDER BY 2 DESC
) as dt

GO

;WITH cte_GoodRests
AS
(
 SELECT Area,
  COUNT(iif(Rating >= 3.7, 1, null)) OVER(PARTITION BY Area) as GoodRestCount,
  ROW_NUMBER() OVER(PARTITION BY Area ORDER BY Area) as AreaRn
 FROM dbo.Jomato 

)
SELECT TOP 5 Area, 
       GoodRestCount, 
	   ROW_NUMBER() over( ORDER BY GoodRestCount DESC) as Rn
FROM cte_GoodRests as gr
WHERE gr.AreaRn = 1
ORDER  BY GoodRestCount DESC;

GO

--problem -4
DECLARE @l1 int 
SET @l1 = 1
WHILE(@l1 <= 50)
BEGIN
 PRINT(@l1)
 SET @l1 = @l1 + 1
END;

GO

--Top 5 highest rating restaurant
--create view with stored data
CREATE VIEW dbo.v_TopRestaurants
WITH SCHEMABINDING
AS
SELECT TOP 5 
	RestaurantName,
	RestaurantType,
	Rating,
	AverageCost,
	Area
FROM dbo.Jomato
ORDER BY Rating DESC
;

GO

SELECT * FROM  dbo.v_TopRestaurants

GO

--problem 6
CREATE OR ALTER TRIGGER dbo.t_NewRestaurantMsg
ON dbo.Jomato --WITH SCHEMABINDING
AFTER INSERT
AS
BEGIN
	DECLARE @RestName VARCHAR(500)

	SELECT @RestName = RestaurantName
	FROM inserted

	PRINT 'New Retaurant '+@RestName+ ' added'
END;

GO
--inserted, deleted, update(column), columns_updated()

INSERT INTO dbo.Jomato
(OrderId,
RestaurantName,
RestaurantType,
Rating,
No_of_Rating,
AverageCost,
OnlineOrder,
TableBooking,
CuisinesType,
Area,
LocalAddress,
Delivery_time)
VALUES
(
9998,
'The Restaurant',
'Cuisine',
4.67,
300,
120,
1,
1,
'QB',
'Hyderabad',
'Gachibowli',
30
);

delete from dbo.Jomato where orderid in (9998);

Go

