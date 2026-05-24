select * from dbo.Salesman;

set rowcount 2;

update dbo.salesman 
 set Name = 'Mr.'+Name;

select * from dbo.Salesman;

set rowcount 0;
 --dbo - db owner --this is user
 --db_owner --this db role

 --Alter table tabname alter column colname int not null primary key(sid);

 use WAMEMO

 -- other rdbms ALTER TABLE dbo.jobs RENAME COLUMN run_date TO run_datetime

 --mssql -- sp_rename
EXEC sp_RENAME 'TableName.OldColumnName' , 'NewColumnName', 'COLUMN'

------

SELECT r.session_id, r.status, t.text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t;

-- This only returns customers who have at least one order.
SELECT C.CustomerName, O.OrderDate
FROM Customers C
CROSS APPLY (
    SELECT TOP 1 OrderDate 
    FROM Orders 
    WHERE CustomerID = C.CustomerID 
    ORDER BY OrderDate DESC
) O;


-- This returns ALL customers, even those with zero orders (OrderDate will be NULL).
SELECT C.CustomerName, O.OrderDate
FROM Customers C
OUTER APPLY (
    SELECT TOP 1 OrderDate 
    FROM Orders 
    WHERE CustomerID = C.CustomerID 
    ORDER BY OrderDate DESC
) O;

---

--XML Datatype , XML, JSON
--FOR XML AUTO; FOR XML PATH;

CREATE TABLE T (
    IntCol INT IDENTITY(1,1),
    XmlCol XML
    );
INSERT INTO T (XmlCol)
SELECT *
FROM OPENROWSET(
    BULK 'C:\SampleFolder\SampleData3.txt',
    SINGLE_BLOB)
AS x;

----------
--from linked server
SELECT d.* FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Seattle1;Trusted_Connection=yes;',
    AdventureWorks2022.HumanResources.Department --or query
) AS d;

--from files openrowset bulk
SELECT a.* FROM OPENROWSET(
    BULK 'C:\test\values.txt',
   FORMATFILE = 'C:\test\values.fmt'
) AS a;

--cmd tool
--bcp DatabaseName.dbo.TableName in "C:\data\import.csv" -c -t, -S ServerName -U UserName -P Password
--( -t, for csv)

-----------
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

EXEC xp_cmdshell 'C:\Tools\MyUtility.exe -param1';

------
SELECT [object_name], [counter_name], [cntr_value]
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Page life expectancy'; --how long a page (in an avg) stays in ram


/*
+------------+------------------------------+----------------------------------+
| Category   | Counter Name                 | Significance                     |
+------------+------------------------------+----------------------------------+
| Memory     | Buffer Manager:              | Measures how long a page stays   |
|            | Page Life Expectancy         | in memory. Sharp drops indicate  |
|            |                              | memory pressure.                 |
+------------+------------------------------+----------------------------------+
| Throughput | SQL Statistics:              | Indicates overall workload       |
|            | Batch Requests/sec           | volume and server activity.      |
+------------+------------------------------+----------------------------------+
| CPU        | Processor:                   | High values (>80-85%) suggest    |
|            | % Processor Time             | CPU bottlenecks.                 |
+------------+------------------------------+----------------------------------+
| Disk I/O   | Physical Disk:               | Measures disk latency. Values    |
|            | Avg. Disk sec/Read           | above 20ms indicate slow disks.  |
+------------+------------------------------+----------------------------------+
| Efficiency | SQL Statistics:              | High values may indicate         |
|            | SQL Compilations/sec         | excessive query recompilation.   |
+------------+------------------------------+----------------------------------+
| Wait State | Memory Manager:              | Greater than 0 means queries     |
|            | Memory Grants Pending        | are waiting for memory.          |
+------------+------------------------------+----------------------------------+
*/

/*
--
--READ_COMMITTED_SNAPSHOT  -- azure sql default
---
https://www.sqlshack.com/sql-server-wait-types/
CXPACKET -  A lot of the long running queries are being parallelize
 pachanging default MAXDOP and parallelism settings

LCK_M_BU - bulk update lock may due to ssis, bcp, bulk inserts.

LAZY_WRITER

internals
*/

/*

change data capture (CDC)

SELECT * 
FROM cdc.dbo_Employees_CT; 
columns  __$operation , __$start_lsn, __$update_mask

sys.fn_cdc_map_time_to_lsn

-- Syntax: cdc.fn_cdc_get_all_changes_<capture_instance_name>
SELECT * 
FROM cdc.fn_cdc_get_all_changes_dbo_Employees(@from_lsn, @to_lsn, 'all');

*/


/*

The equivalent to SQL Server’s Read Committed Snapshot Isolation (RCSI) 
in Oracle is simply its default Read Committed level
*/

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

--------------

left join and group of inner join (or nested joins):

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    o.OrderID, 
    p.ProductName
FROM Customers c
LEFT JOIN (
    Orders o 
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
) ON c.CustomerID = o.CustomerID;



-- easy read ; recommended
WITH ProductOrders AS (
    SELECT 
        o.CustomerID,
        o.OrderID, 
        p.ProductName
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
)
SELECT 
    c.CustomerID, 
    c.CustomerName, 
    po.OrderID, 
    po.ProductName
FROM Customers c
LEFT JOIN ProductOrders po ON c.CustomerID = po.CustomerID;

----
