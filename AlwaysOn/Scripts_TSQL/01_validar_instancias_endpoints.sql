/*
  Finalidade: validar identidade das instancias, Always On e endpoint HADR.
  Execucao: executar separadamente em LAB-SQL01 e LAB-SQL02, no banco master.
*/
USE [master];
GO

SELECT
    @@SERVERNAME AS servidor_configurado,
    CAST(SERVERPROPERTY('MachineName') AS nvarchar(128)) AS nome_windows,
    CAST(SERVERPROPERTY('InstanceName') AS nvarchar(128)) AS instancia,
    CAST(SERVERPROPERTY('Edition') AS nvarchar(128)) AS edicao,
    CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(128)) AS versao,
    CAST(SERVERPROPERTY('IsHadrEnabled') AS int) AS always_on_habilitado;
GO

SELECT
    dme.name AS endpoint_name,
    dme.state_desc,
    dme.role_desc,
    dme.connection_auth_desc,
    dme.encryption_algorithm_desc,
    te.port,
    te.ip_address
FROM sys.database_mirroring_endpoints AS dme
INNER JOIN sys.tcp_endpoints AS te
    ON dme.endpoint_id = te.endpoint_id;
GO

