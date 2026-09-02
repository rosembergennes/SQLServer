/*
  Finalidade: criar o endpoint HADR quando ele nao existir e garantir que esteja iniciado.
  Execucao: executar separadamente em LAB-SQL01 e LAB-SQL02, no banco master.
*/
USE [master];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_mirroring_endpoints WHERE name = N'Hadr_endpoint')
BEGIN
    EXEC(N'
        CREATE ENDPOINT [Hadr_endpoint]
        STATE = STARTED
        AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
        FOR DATABASE_MIRRORING
        (
            AUTHENTICATION = WINDOWS NEGOTIATE,
            ENCRYPTION = REQUIRED ALGORITHM AES,
            ROLE = ALL
        );');
END;
GO

ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ALWAYSON\sqlservice];
GO

SELECT name, state_desc, role_desc, connection_auth_desc, encryption_algorithm_desc
FROM sys.database_mirroring_endpoints;
GO

