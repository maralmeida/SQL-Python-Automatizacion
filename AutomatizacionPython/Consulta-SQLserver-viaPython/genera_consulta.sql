-- Bloque 1: Ver metadatos (Nombres de todas tus tablas)
SELECT name, create_date FROM sys.tables;

-- Bloque 2: Ver los datos de tu tabla real
-- Nota: Usamos 'pais' sin tilde como aparece en tu imagen
SELECT id, nombre, edad, genero, pais, profesion FROM dbo.registros;

-- Bloque 3: Ver cuantos registros tienes hoy
SELECT COUNT(*) AS total_registros FROM dbo.registros;

-- Bloque 4: Ver los mas recientes (usando tu columna fecha_registro)
SELECT TOP 5 nombre, fecha_registro 
FROM dbo.registros 
ORDER BY fecha_registro DESC;