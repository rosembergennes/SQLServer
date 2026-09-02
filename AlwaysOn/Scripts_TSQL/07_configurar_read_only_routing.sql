/*
  Finalidade: habilitar secundarios legiveis e roteamento de conexoes ReadOnly pelo listener.
  Execucao: no primario atual, banco master.
*/
USE [master];
GO

ALTER AVAILABILITY GROUP [AG-SQLLAB]
MODIFY REPLICA ON N'LAB-SQL01'
WITH
(
    SECONDARY_ROLE
    (
        ALLOW_CONNECTIONS = READ_ONLY,
        READ_ONLY_ROUTING_URL = N'TCP://LAB-SQL01.ALWAYSON.LOCAL:1433'
    )
);
GO

ALTER AVAILABILITY GROUP [AG-SQLLAB]
MODIFY REPLICA ON N'LAB-SQL02'
WITH
(
    SECONDARY_ROLE
    (
        ALLOW_CONNECTIONS = READ_ONLY,
        READ_ONLY_ROUTING_URL = N'TCP://LAB-SQL02.ALWAYSON.LOCAL:1433'
    )
);
GO

ALTER AVAILABILITY GROUP [AG-SQLLAB]
MODIFY REPLICA ON N'LAB-SQL01'
WITH (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST = (N'LAB-SQL02', N'LAB-SQL01')));
GO

ALTER AVAILABILITY GROUP [AG-SQLLAB]
MODIFY REPLICA ON N'LAB-SQL02'
WITH (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST = (N'LAB-SQL01', N'LAB-SQL02')));
GO

SELECT
    ar.replica_server_name,
    ar.secondary_role_allow_connections_desc,
    ar.read_only_routing_url,
    rl.routing_priority,
    ar2.replica_server_name AS destino
FROM sys.availability_replicas AS ar
LEFT JOIN sys.availability_read_only_routing_lists AS rl
    ON ar.replica_id = rl.replica_id
LEFT JOIN sys.availability_replicas AS ar2
    ON rl.read_only_replica_id = ar2.replica_id
WHERE ar.group_id = (SELECT group_id FROM sys.availability_groups WHERE name = N'AG-SQLLAB')
ORDER BY ar.replica_server_name, rl.routing_priority;
GO

