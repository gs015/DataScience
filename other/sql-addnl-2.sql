CREATE TABLE Customer (
    SalesmanId INT,
    CustomerId INT,
    CustomerName VARCHAR(255),
    PurchaseAmount INT,
    );


	INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);


	CREATE TABLE Orders (OrderId int, CustomerId int, SalesmanId int, Orderdate Date, Amount money)

INSERT INTO Orders Values 
(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500)


select * from dbo.Salesman;

set rowcount 2;

update dbo.salesman 
 set Name = 'Mr.'+Name;

select * from dbo.Salesman;

set rowcount 0;
 --dbo - db owner --this is user
 --db_owner --this db role

 --Alter table tabname alter column colname int not null primary key(sid);

 ALTER TABLE table_name ADD CONSTRAINT cons_name PRIMARY KEY(column_name);

 --ALTER TABLE TABLE_NAME ADD CONSTRAINT cons_name DEFAULT 'value-Hydrapad' FOR coulmn_name; 

--select @@rowcount
