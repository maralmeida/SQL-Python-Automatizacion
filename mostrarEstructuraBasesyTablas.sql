
-- muestra todas las bases de datos donde el sid no sea oxo1 (creo que son las creadas por el usuario)
SELECT * FROM sys.databases
WHERE owner_sid NOT LIKE 0x01;

---------------

SELECT * FROM sys.databases WHERE name = 'TechHealthDb';  -- ver que hay en la bd  (opcional)
GO

SELECT TABLE_NAME   -- muestra todas las tablas o dbo de una base
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo';

---------------
-- SP para mostrar todas las db's existentes y sus tablas, se puede finalizar con un select especifico para ver que tiene una tabla

DECLARE @sql NVARCHAR(MAX) = N'';

-- Construir una consulta dinámica para recorrer todas las bases de datos
SELECT @sql += 
    'USE [' + name + ']; 
    SELECT ''' + name + ''' AS DatabaseName, s.name AS SchemaName, t.name AS TableName 
    FROM sys.schemas s 
    INNER JOIN sys.tables t ON s.schema_id = t.schema_id 
    WHERE s.name = ''dbo''; 
    '
FROM sys.databases
WHERE state_desc = 'ONLINE' -- Solo bases de datos en línea
  AND name NOT IN ('master', 'tempdb', 'model', 'msdb'); -- Excluir bases de datos del sistema

-- Ejecutar la consulta dinámica
EXEC sp_executesql @sql;

----ejecuto tabla a usar de bd a usar
SELECT * FROM  Customers;