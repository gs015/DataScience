use intrain;

INSERT INTO dbo.Salesman VALUES (111, 'Harihara subu', 96.5,'Chennai',50), (110, 'Govind', 97.34, 'Chennai', 100);

INSERT INTO dbo.Customer(SalesmanId, CustomerId, CustomerName, PurchaseAmount) VALUES(110, 100, 'Arunan', 720)

ALTER TABLE dbo.Salesman ALTER COLUMN SalesmanId INT NOT NULL;

ALTER TABLE dbo.Salesman ADD CONSTRAINT pk_salesman PRIMARY KEY(SalesmanId);

ALTER TABLE dbo.Salesman ADD CONSTRAINT df_city_name DEFAULT 'Hyderabad' FOR City;

ALTER TABLE dbo.Customer ADD CONSTRAINT fk_Customer_Salesman FOREIGN KEY(SalesmanId) REFERENCES dbo.Salesman(SalesmanId);

ALTER TABLE dbo.Customer ALTER COLUMN CustomerName VARCHAR(255) NOT NULL;

select * from dbo.Customer where CustomerName like '%N';

select * from dbo.Customer where PurchaseAmount > 500;

select * from dbo.Customer where CustomerName like '%N' and PurchaseAmount > 500;

select SalesmanId from dbo.Customer EXCEPT select SalesmanId from dbo.Salesman

select SalesmanId from dbo.Salesman UNION select SalesmanId from dbo.Customer

--select SalesmanId from dbo.Salesman UNION ALL select SalesmanId from dbo.Customer

SELECT o.Orderdate, s.Name, c.CustomerName, s.Commission, s.City  
FROM Salesman s INNER JOIN Customer C
  ON s.SalesmanId = c.SalesmanId
  INNER JOIN Orders o
  ON o.CustomerId = c.CustomerId
  AND o.SalesmanId = c.SalesmanId
WHERE c.PurchaseAmount BETWEEN 500 AND 1500


SELECT o.Orderdate, s.Name, c.CustomerName, s.Commission, s.City , s.*,o.*
FROM Customer C RIGHT JOIN Salesman s
  ON s.SalesmanId = c.SalesmanId
  RIGHT JOIN Orders o
  ON o.CustomerId = c.CustomerId
  AND o.SalesmanId = c.SalesmanId
WHERE c.PurchaseAmount BETWEEN 500 AND 1500

--ALTER TABLE dbo.Customer ADD CONSTRAINT FK_customer_salesman2 FOREIGN KEY(SalesmanId) REFERENCES dbo.Salesman(SalesmanId);


--ALTER TABLE dbo.Salesman ADD CONSTRAINT DF_city DEFAULT 'Hyderabad' FOR city;

--ALTER TABLE dbo.Salesman ADD CONSTRAINT CK_city CHECK(LEN(city) > 0);


