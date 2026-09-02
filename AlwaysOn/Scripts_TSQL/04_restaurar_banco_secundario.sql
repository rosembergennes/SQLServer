/*
  Finalidade: restaurar o BancoTeste no secundario em estado RESTORING para usar Join only.
  Execucao: somente no LAB-SQL02, antes de adiciona-lo ao AG.
  Pre-requisito: copiar os arquivos FULL e LOG para C:\Backup no LAB-SQL02.
*/
USE [master];
GO

RESTORE DATABASE [BancoTeste]
FROM DISK = N'C:\Backup\BancoTeste_FULL.bak'
WITH NORECOVERY, REPLACE, CHECKSUM, STATS = 10;
GO

RESTORE LOG [BancoTeste]
FROM DISK = N'C:\Backup\BancoTeste_LOG.trn'
WITH NORECOVERY, CHECKSUM, STATS = 10;
GO

SELECT name, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = N'BancoTeste';
GO

