/*
  Finalidade: rotina operacional para saude, filas de envio/redo e historico de backup.
  Execucao: preferencialmente no primario atual.
*/
USE [master];
GO

SELECT
    ar.replica_server_name,
    ars.role_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc AS replica_health,
    DB_NAME(drs.database_id) AS banco,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc AS database_health,
    drs.is_suspended,
    drs.log_send_queue_size,
    drs.redo_queue_size,
    drs.last_sent_time,
    drs.last_received_time,
    drs.last_hardened_time,
    drs.last_redone_time
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS ars
    ON ars.replica_id = ar.replica_id
LEFT JOIN sys.dm_hadr_database_replica_states AS drs
    ON drs.replica_id = ar.replica_id
WHERE ar.group_id = (SELECT group_id FROM sys.availability_groups WHERE name = N'AG-SQLLAB')
ORDER BY ar.replica_server_name;
GO

SELECT
    database_name,
    MAX(CASE WHEN type = 'D' THEN backup_finish_date END) AS ultimo_full,
    MAX(CASE WHEN type = 'I' THEN backup_finish_date END) AS ultimo_diferencial,
    MAX(CASE WHEN type = 'L' THEN backup_finish_date END) AS ultimo_log
FROM msdb.dbo.backupset
WHERE database_name = N'BancoTeste'
GROUP BY database_name;
GO

