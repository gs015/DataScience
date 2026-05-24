
SELECT * FROM DBO.Restaurant

SELECT * FROM DBO.Cuisine

sp_helptext 'dbo.usp_get_best_cuisine'

INSERT INTO dbo.Restaurant VALUES(1,'Udupi Urpan', 'Gachibowli,Hyderabad', 3.4992,'Cafe', '101');

INSERT INTO dbo.Restaurant VALUES(2, 'Udupi Upahar', 'Gachibowli,Hyderabad', 4.2344, 'Mall','1');

INSERT INTO dbo.Restaurant VALUES(3, 'balaji daba', 'Gachibowli,Hyderabad', 4.6234, 'Cafe', '1');

INSERT INTO dbo.Cuisine VALUES ('meals', 'Limitted meals', 3.2122, 1, 233);

INSERT INTO dbo.Cuisine VALUES ('meals', 'full meals', 3.2122, 1, 345);


INSERT INTO dbo.Cuisine VALUES ('meals', 'Limitted meals', 4.5122, 2, 100);

INSERT INTO dbo.Cuisine VALUES ('meals', 'full meals', 4.3122, 2,389.67);


INSERT INTO dbo.Cuisine VALUES ('Biriyani', 'Veg. Biriyani', 4.2122, 3, 239.67);

INSERT INTO dbo.Cuisine VALUES ('Biriyani', 'Cashew Biriyani', 4.6122, 3, 342.12);



SELECT Name, CuisineType 
	FROM dbo.Restaurant r
	INNER JOIN dbo.Cuisine c
	ON r.Id = c.RestaurantId
WHERE c.id = (SELECT TOP 1 c2.id FROM cuisine c2 ORDER BY c2.Rating DESC)


GO

CREATE FUNCTION udf_functionname()
RETURNS TABLE
AS
RETURN
(
 SELECT * FROM Restaurant
)

CREATE FUNCTION udf_functionname()
RETURNS TABLE
AS
RETURN
(
SELECT * FROM dbo.Restaurant
);

CREATE FUNCTION udf_functionname (@InParam int)
RETURNS @tv_restaurant TABLE
(
Name varchar(100),
Address varchar(100)
)
AS
BEGIN
INSERT INTO @tv_restaurant 
SELECT TOP 1 Name, Address FROM dbo.Restaurant

RETURN
END;

