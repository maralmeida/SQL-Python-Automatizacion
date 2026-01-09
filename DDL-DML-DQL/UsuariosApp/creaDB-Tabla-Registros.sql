---DDL (estructura base tablas) Arquitctura de BD
-- DML (manipula datos insertupdatedelete) operadores de BD
-- DQL (consulta datos) analistas de datos 


Create database UsuariosApp;

USE UsuariosApp;
GO

CREATE TABLE [dbo].[Usuarios](
    nombre VARCHAR(50) NOT NULL PRIMARY KEY,
    edad INT NOT NULL CHECK (edad BETWEEN 0 AND 120),  -- Age constraint
    genero CHAR(1) NOT NULL,
    state VARCHAR(50),
    país VARCHAR(50) NOT NULL,
    profesion VARCHAR(100)
);
GO

-- saldrá vacío porque no se ha poblado la tabla aún
select * from dbo.Usuarios;

--tarea1 : borrar variable sate
ALTER TABLE dbo.Usuarios DROP COLUMN state; --select para ver cambios

-- tarea2: ingresar valores en tabla Usuarios, continuar poblando la tabla
INSERT INTO dbo.Usuarios (nombre,edad,genero,país,profesion) values ('ana',12,'M','ecuador','doctor');
/*Insert into dbo.Usuarios (nombre,edad,genero,país,profesion)
values ('Josefa',34,'M','ecuador','ingeniero'),
	   ('Pablo',24,'M','ecuador','ingeniero'),
	   ('Camilo',44,'M','ecuador','ingeniero'),
	   ('Federico',56,'M','ecuador','ingeniero'),
	   ('Ernesto',28,'M','ecuador','ingeniero'),
	   ('felipe',34,'M','ecuador','ingeniero'),
	   ('Cordero',29,'M','ecuador','ingeniero'),
	   ('Vita',18,'M','ecuador','ingeniero'),
	   ('Amanda',19,'M','ecuador','ingeniero'); */

-- tarea3: actualizar el valor del registro nombre, ana por maria
UPDATE dbo.Usuarios SET nombre = 'maria' where nombre = 'ana';

--tarea4: eliminar registro
--delete  from dbo.usuarios where nombre = 'maria'


-- tabla Usuarios mostrará los datos ingresados
select * from dbo.Usuarios;




	  
