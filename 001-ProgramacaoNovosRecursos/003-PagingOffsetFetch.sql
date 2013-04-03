USE AdventureWorks2012

-------------------------------------------
--SEM PAGINA��O
-------------------------------------------

SELECT 
	* 
FROM 
	PERSON.PERSON 
ORDER BY 
	BUSINESSENTITYID

-------------------------------------------
--PRIMEIRA P�GINA
-------------------------------------------

DECLARE @CURRENT_OFFSET INT = 0
DECLARE @OFFSET_INCREMENT INT = 10

SELECT 
	* 
FROM 
	PERSON.PERSON 
ORDER BY 
	BUSINESSENTITYID
OFFSET
    @CURRENT_OFFSET ROWS
FETCH NEXT
    @OFFSET_INCREMENT ROWS ONLY

-------------------------------------------
--PR�XIMA P�GINA
-------------------------------------------

SET @CURRENT_OFFSET += @OFFSET_INCREMENT

SELECT 
	* 
FROM 
	PERSON.PERSON 
ORDER BY 
	BUSINESSENTITYID
OFFSET
    @CURRENT_OFFSET ROWS
FETCH NEXT
    @OFFSET_INCREMENT ROWS ONLY

-------------------------------------------
--PAGINA��O TRADICIONAL USANDO SP
-------------------------------------------

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME = 'GETPAGEDPRODUCTS_TRADITIONAL')
	DROP PROC PRODUCTION.GETPAGEDPRODUCTS_TRADITIONAL

GO

CREATE PROC PRODUCTION.GETPAGEDPRODUCTS_TRADITIONAL
	@PAGENUMBER INT,
	@NUMBEROFROWSPERPAGE INT
AS
	WITH ORDEREDROWS AS
	( 
		SELECT 
			ROW_NUMBER() OVER(ORDER BY PRODUCTID) AS ROWNUMBER,
			PRODUCTID,
			NAME,
			SIZE,
			COLOR 
		FROM PRODUCTION.PRODUCT 
	)
	SELECT 
		PRODUCTID, 
		NAME, 
		SIZE, 
		COLOR 
	FROM ORDEREDROWS
	WHERE ROWNUMBER BETWEEN (((@PAGENUMBER - 1) * @NUMBEROFROWSPERPAGE) + 1)
		AND (@PAGENUMBER * @NUMBEROFROWSPERPAGE)
	ORDER BY PRODUCTID
GO

-------------------------------------------
--PAGINA��O USANDO SP COM OFFSET E FETCH
-------------------------------------------

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME = 'GETPAGEDPRODUCTS_NEW')
	DROP PROC PRODUCTION.GETPAGEDPRODUCTS_NEW

GO

CREATE PROC PRODUCTION.GETPAGEDPRODUCTS_NEW
	@PAGENUMBER INT,
	@NUMBEROFROWSPERPAGE INT
AS
	SELECT PRODUCTID, 
		NAME, 
		SIZE, 
		COLOR 
	FROM PRODUCTION.PRODUCT 
	ORDER BY PRODUCTID
	OFFSET ((@PAGENUMBER - 1) * @NUMBEROFROWSPERPAGE) ROWS
	FETCH NEXT @NUMBEROFROWSPERPAGE ROWS ONLY
GO

EXEC PRODUCTION.GETPAGEDPRODUCTS_TRADITIONAL 3,12 --81%
EXEC PRODUCTION.GETPAGEDPRODUCTS_NEW 3,12 --19%