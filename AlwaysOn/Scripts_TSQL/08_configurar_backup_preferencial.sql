/*
  Finalidade: preferir backup na replica secundaria e executar somente na replica indicada pelo AG.
  Execucao: configuracao no primario; bloco de backup em job identico nos dois SQL Server Agents.
*/
USE [master];
GO

ALTER AVAILABILITY GROUP [AG-SQLLAB]
SET (AUTOMATED_BACKUP_PREFERENCE = SECONDARY);
GO

SELECT name, automated_backup_preference_desc
FROM sys.availability_groups
WHERE name = N'AG-SQLLAB';
GO

IF sys.fn_hadr_backup_is_preferred_replica(N'BancoTeste') <> 1
BEGIN
    PRINT N'Esta replica nao e a preferencial para backup.';
    RETURN;
END;
GO

BACKUP DATABASE [BancoTeste]
TO DISK = N'C:\Backup\BancoTeste_COPYONLY.bak'
WITH COPY_ONLY, INIT, COMPRESSION, CHECKSUM, STATS = 10;
GO

BACKUP LOG [BancoTeste]
TO DISK = N'C:\Backup\BancoTeste_LOG.trn'
WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;
GO

