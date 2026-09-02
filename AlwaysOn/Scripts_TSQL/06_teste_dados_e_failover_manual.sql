/*
  Parte A: execute pelo listener para inserir e identificar o primario.
  Parte B: execute diretamente na replica SECONDARY sincronizada para realizar failover planejado.
*/
USE [BancoTeste];
GO

INSERT dbo.TesteAlwaysOn (descricao)
VALUES (CONCAT(N'Teste executado no primario ', @@SERVERNAME));
GO

SELECT @@SERVERNAME AS servidor_atual, DB_NAME() AS banco_atual;
SELECT TOP (100) id, descricao, data_cadastro
FROM dbo.TesteAlwaysOn
ORDER BY id DESC;
GO

/*
  FAILOVER PLANEJADO:
  Descomente somente quando conectado diretamente ao SECONDARY e ele estiver SYNCHRONIZED.
*/
-- USE [master];
-- GO
-- ALTER AVAILABILITY GROUP [AG-SQLLAB] FAILOVER;
-- GO

