/*
  Finalidade: identificar PRIMARY/SECONDARY e validar replicas, banco e listener.
  Execucao: no banco master; para enxergar todas as replicas, prefira o primario atual.
*/
USE [master];
GO

SELECT
    ag.name AS availability_group,
    ar.replica_server_name AS servidor,
    ars.role_desc AS papel,
    ars.operational_state_desc AS estado_operacional,
    ars.connected_state_desc AS conexao,
    ars.synchronization_health_desc AS saude_replica,
    ar.availability_mode_desc,
    ar.failover_mode_desc,
    ar.secondary_role_allow_connections_desc
FROM sys.availability_groups AS ag
JOIN sys.availability_replicas AS ar
    ON ag.group_id = ar.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states AS ars
    ON ar.replica_id = ars.replica_id
ORDER BY ar.replica_server_name;
GO

SELECT
    ar.replica_server_name AS servidor,
    DB_NAME(drs.database_id) AS banco,
    drs.synchronization_state_desc AS sincronizacao,
    drs.synchronization_health_desc AS saude,
    drs.database_state_desc AS estado_banco,
    drs.is_suspended AS suspenso,
    drs.log_send_queue_size,
    drs.redo_queue_size
FROM sys.dm_hadr_database_replica_states AS drs
JOIN sys.availability_replicas AS ar
    ON drs.replica_id = ar.replica_id
WHERE DB_NAME(drs.database_id) = N'BancoTeste'
ORDER BY ar.replica_server_name;
GO

SELECT
    ag.name AS availability_group,
    agl.dns_name AS listener,
    agl.port,
    ip.ip_address,
    ip.state_desc
FROM sys.availability_groups AS ag
JOIN sys.availability_group_listeners AS agl
    ON ag.group_id = agl.group_id
LEFT JOIN sys.availability_group_listener_ip_addresses AS ip
    ON agl.listener_id = ip.listener_id
WHERE ag.name = N'AG-SQLLAB';
GO

