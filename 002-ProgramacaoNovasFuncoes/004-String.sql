SELECT 
	CONCAT('HOJE � ', GETDATE(), ' E EU SOU O USU�RIO ', SUSER_SNAME())

SELECT 
	CONCAT('O VALOR DE PI � ', PI())

SELECT 
	CONCAT(123, 456.789)

SELECT
	FORMAT(10.345, 'C', 'pt-BR'), 
	FORMAT(10.456, 'N', 'pt-BR'), 
	FORMAT(10.345, 'C', 'en-US'), 
	FORMAT(10.456, 'N', 'en-US'), 
	FORMAT(10.345, 'C', 'es-ES'), 
	FORMAT(10.456, 'N', 'es-ES')

SELECT
	FORMAT(GETDATE(), 'd', 'pt-BR'), 
	FORMAT(GETDATE(), 'd', 'en-US'), 
	FORMAT(GETDATE(), 'd', 'es-ES'), 
	FORMAT(GETDATE(), 'D', 'pt-BR'), 
	FORMAT(GETDATE(), 'D', 'en-US'), 
	FORMAT(GETDATE(), 'D', 'es-ES')

SELECT 
	FORMAT(4010100, '00000-000'), 
	FORMAT(123432.236, '000,000,000.00'),
	FORMAT(123432.236, '#,##0.00'), 
	FORMAT(123432.236, '#,##0.00', 'pt-BR') 
