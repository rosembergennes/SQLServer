/*
  Finalidade: reduzir saltos grandes em IDENTITY apos reinicio ou failover.
  Observacao: lacunas ainda podem ocorrer; IDENTITY garante unicidade, nao sequencia sem falhas.
  Execucao: no primario atual; a configuracao pertence ao banco e sera replicada.
*/
USE [BancoTeste];
GO

ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = OFF;
GO

SELECT name, value, value_for_secondary
FROM sys.database_scoped_configurations
WHERE name = N'IDENTITY_CACHE';
GO

