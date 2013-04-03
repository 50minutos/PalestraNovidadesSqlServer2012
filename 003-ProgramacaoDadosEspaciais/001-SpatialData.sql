--------------------------------------
--CIRCULARSTRING
--------------------------------------

DECLARE @g1 GEOGRAPHY;
DECLARE @g2 GEOGRAPHY;

DECLARE @g3 GEOGRAPHY;
DECLARE @g4 GEOGRAPHY;

SET @g1 = GEOGRAPHY::STGeomFromText('LINESTRING(0 0, 2 1, 4 0)', 4326);
SET @g2 = GEOGRAPHY::STGeomFromText('CIRCULARSTRING(0 0, 2 1, 4 0)', 4326);
SET @g3 = GEOGRAPHY::STGeomFromText('LINESTRING(0 0, 2 1, 4 0, 2 -2, 0 0)', 4326);
SET @g4 = GEOGRAPHY::STGeomFromText('CIRCULARSTRING(0 0, 2 1, 4 0, 2 -2, 0 0)', 4326);

SELECT @g1 as 'g1', 
	@g2 as 'g2', 
	@g3 as 'g3', 
	@g4 as 'g4';

GO

--------------------------------------
--COMPOUNDCURVE
--------------------------------------

DECLARE @g1 GEOMETRY;
DECLARE @g2 GEOMETRY;
DECLARE @g3 GEOMETRY;

SET @g1 = GEOMETRY::Parse('LINESTRING(2 2, 4 2, 4 4, 2 4, 2 2)');
SET @g2 = GEOMETRY::Parse('COMPOUNDCURVE(CIRCULARSTRING(2 1, 2 2, 4 2), (4 2, 4 4), (4 4, 2 1))');
SET @g3 = GEOMETRY::Parse('COMPOUNDCURVE((2 2, 4 2, 4 4, 2 4, 2 2))');

SELECT 
	@g1 AS 'g1', 
	@g2 AS 'g2', 
	@g3 AS 'g3'

GO

--------------------------------------
--CURVEPOLYGON
--------------------------------------

DECLARE @GEOM TABLE 
( 
	SHAPE GEOMETRY, 
	SHAPETYPE NVARCHAR(50) 
) 

INSERT 
	@Geom(shape,shapeType) 
VALUES
	('CURVEPOLYGON(CIRCULARSTRING(2 3, 4 1, 6 3, 4 5, 2 3))', 'Circle'), 
	('POLYGON((1 1, 4 1, 4 5, 1 5, 1 1))', 'Rectangle')

SELECT 
	*,
	shape.STIsValid() 
FROM @GEOM

--------------------------------------
--FULLGLOBE
--------------------------------------

DECLARE @Globe GEOGRAPHY = GEOGRAPHY::STGeomFromText('FULLGLOBE',4326);
SELECT @Globe As Shape, @Globe.STArea()/1000000 as 'Area (Km2)';  

--------------------------------------
--BUSCAR POR LOCALIZAÇÃO
--------------------------------------

USE AdventureWorks2012;

IF EXISTS(SELECT * FROM SYS.OBJECTS WHERE NAME = 'EMPLOYEELOCATIONS')
	DROP TABLE EMPLOYEELOCATIONS

WITH EmployeeAddresses AS
( 
	SELECT 
		e.BusinessEntityID,
		p.LastName + ', ' + p.FirstName AS FullName,
		a.SpatialLocation,
		addt.Name AS AddressTypeName
	FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
		ON e.BusinessEntityID = p.BusinessEntityID
	INNER JOIN Person.BusinessEntityAddress AS bea
		ON p.BusinessEntityID = bea.BusinessEntityID
	INNER JOIN Person.Address AS a
		ON bea.AddressID = a.AddressID
	INNER JOIN Person.AddressType AS addt
		ON bea.AddressTypeID = addt.AddressTypeID
)
SELECT 
	BusinessEntityID, 
	FullName, 
    SpatialLocation, 
	AddressTypeName
INTO dbo.EmployeeLocations
FROM EmployeeAddresses;

SELECT 
	TOP(10) * 
FROM 
	dbo.EmployeeLocations;

ALTER TABLE dbo.EmployeeLocations 
  ADD CONSTRAINT PK_EmployeeLocations PRIMARY KEY (BusinessEntityID);

CREATE SPATIAL INDEX IX_EmployeeLocations_SpatialLocation
ON dbo.EmployeeLocations (SpatialLocation)
USING GEOGRAPHY_GRID
WITH ( DATA_COMPRESSION = PAGE );

DECLARE @LOCAL geography
  = geography::Point(47.7573717899841,-122.107041842112,4326);

SELECT 
	TOP(5) * 
FROM 
	dbo.EmployeeLocations AS el WITH (INDEX = IX_EmployeeLocations_SpatialLocation)
WHERE 
	el.AddressTypeName = 'Home'
		AND el.SpatialLocation.STDistance(@LOCAL) IS NOT NULL
ORDER BY 
	el.SpatialLocation.STDistance(@LOCAL);

GO

DECLARE @LOCAL geography
  = geography::Point(47.7573717899841,-122.107041842112,4326);

SELECT 
	TOP(5) *
FROM 
	EmployeeLocations AS el WITH (INDEX = IX_EmployeeLocations_SpatialLocation)
WHERE 
	el.AddressTypeName = 'Home'
		AND el.SpatialLocation.STDistance(@LOCAL) < 5000
ORDER BY 
	el.SpatialLocation.STDistance(@LOCAL);
                  