---ddl (estructura base tablas) / dml (manipula datos insertupdatedelete) / dql (select) / dcl (administrar la base grantrevokedeny)


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

select * from dbo.Usuarios;

ALTER TABLE dbo.Usuarios DROP COLUMN state; --select para ver cambios

INSERT INTO dbo.Usuarios (nombre,edad,genero,país,profesion) values ('ana',12,'M','ecuador','doctor');

UPDATE dbo.Usuarios SET nombre = 'maria' where nombre = 'ana';

--delete  from dbo.usuarios where nombre = 'maria': probar esto


select * from dbo.Usuarios;

Insert into dbo.Usuarios (nombre,edad,genero,país,profesion)
values ('Josefa',34,'M','ecuador','ingeniero'),
	   ('Pablo',24,'M','ecuador','ingeniero'),
	   ('Camilo',44,'M','ecuador','ingeniero'),
	   ('Federico',56,'M','ecuador','ingeniero'),
	   ('Ernesto',28,'M','ecuador','ingeniero'),
	   ('felipe',34,'M','ecuador','ingeniero'),
	   ('Cordero',29,'M','ecuador','ingeniero'),
	   ('Vita',18,'M','ecuador','ingeniero'),
	   ('Amanda',19,'M','ecuador','ingeniero');


	   --

select * from sys.databases where name = 'TechHealthDb';

select name from sys.tables;

Select * from Customers;

