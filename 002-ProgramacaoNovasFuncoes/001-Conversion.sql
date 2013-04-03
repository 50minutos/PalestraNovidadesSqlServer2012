-------------------------------------------
--PARSE
-------------------------------------------

SELECT 
	PARSE('102.243' AS DEC(9,2)),
	PARSE('102.247' AS DEC(9,2))

SELECT 
	PARSE('2/20/13' AS DATE), 
	PARSE('2/20/13' AS DATETIME), 
	PARSE('20/FEB/2013 09:10:20' AS DATETIME)

SELECT
	PARSE('ERRO' AS INT)

DECLARE @I INT = PARSE('1209' AS INT)
SELECT @I

-------------------------------------------
--TRYPARSE
-------------------------------------------

SELECT 
	TRY_PARSE('102.243' AS DEC(9,2)),
	TRY_PARSE('102.247' AS DEC(9,2))

SELECT 
	TRY_PARSE('2/20/13' AS DATE), 
	TRY_PARSE('2/20/13' AS DATETIME), 
	TRY_PARSE('20/FEB/2013 09:10:20' AS DATETIME)

SELECT
	TRY_PARSE('AGORA É NULL' AS INT)

DECLARE @J INT = TRY_PARSE('1209' AS INT)
SELECT @J

-------------------------------------------
--TRYCONVERT
-------------------------------------------

SELECT
	TRY_CONVERT(INT, '435'), 
	TRY_CONVERT(INT, '435.35'), 
	TRY_CONVERT(VARCHAR, 435.35), 
	TRY_CONVERT(DATETIME, '3/20/2013 09:10:20'), 
	TRY_CONVERT(XML, '<numero>435.35</numero>'), 
	TRY_CONVERT(XML, 'QUALQUER COISA')
	
SELECT
	TRY_CONVERT(XML, GETDATE()) 

SELECT
	TRY_CONVERT(XML, 1)