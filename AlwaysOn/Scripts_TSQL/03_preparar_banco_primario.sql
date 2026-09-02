/*
  Finalidade: criar o BancoTeste, tabela de verificacao, recovery FULL e cadeia inicial de backup.
  Execucao: somente no primario inicial (LAB-SQL01), antes de criar o AG.
  Pre-requisito: a pasta C:\Backup deve existir e a conta do servico SQL deve poder grava-la.
*/
USE [master];
GO

IF DB_ID(N'BancoTeste') IS NULL
    CREATE DATABASE [BancoTeste];
GO

ALTER DATABASE [BancoTeste] SET RECOVERY FULL;
GO

USE [BancoTeste];
GO

IF OBJECT_ID(N'dbo.TesteAlwaysOn', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TesteAlwaysOn
    (
        id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_TesteAlwaysOn PRIMARY KEY,
        descricao nvarchar(250) NOT NULL,
        data_cadastro datetime2(3) NOT NULL
            CONSTRAINT DF_TesteAlwaysOn_data_cadastro DEFAULT SYSDATETIME()
    );
END;
GO

INSERT dbo.TesteAlwaysOn (descricao)
VALUES (N'Registro inicial criado antes do Availability Group');
GO

BACKUP DATABASE [BancoTeste]
TO DISK = N'C:\Backup\BancoTeste_FULL.bak'
WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;
GO

BACKUP LOG [BancoTeste]
TO DISK = N'C:\Backup\BancoTeste_LOG.trn'
WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;
GO

RESTORE VERIFYONLY FROM DISK = N'C:\Backup\BancoTeste_FULL.bak' WITH CHECKSUM;
RESTORE VERIFYONLY FROM DISK = N'C:\Backup\BancoTeste_LOG.trn' WITH CHECKSUM;
GO

