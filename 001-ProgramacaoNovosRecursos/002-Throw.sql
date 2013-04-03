USE MASTER

IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME='DEMO')
	DROP DATABASE DEMO

CREATE DATABASE DEMO
GO

USE DEMO

CREATE TABLE DBO.PESSOA
(
    ID INT PRIMARY KEY, 
	NOME VARCHAR(50)
)

BEGIN TRY
   INSERT DBO.PESSOA VALUES(1, 'AD�O')
   INSERT DBO.PESSOA VALUES(1, 'EVA')
END TRY
BEGIN CATCH
    PRINT 'CAPTUREI A EXCEPTION'
END CATCH

BEGIN TRY
   INSERT DBO.PESSOA VALUES(1, 'CAIM')
END TRY
BEGIN CATCH
    PRINT 'CAPTUREI A EXCEPTION'
    ;THROW
END CATCH
