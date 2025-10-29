---ddl (estructura base tablas) / dml (manipula datos insertupdatedelete) / dql (select) / dcl (administrar la base grantrevokedeny)
---etl (extract, transform, load) / EDA (exploratory data anaylisis)



select * from sys.databases where name = 'TechHealthDb'; -- opcional: muestra todos los campos de info referente a la bd llamada TechHealthDb


use TechHealthDb; -- indica base de datos a usar en adelante
go

select name from sys.tables; -- muestra las tablas de la bd en uso



Select * from Customers, Devices, Sales; -- muestra info de las tablas cliente, dispositivos y ventas

select c.age, c.gender, d.device_type, d.purchase_date from Customers c Join Devices d on c.user_id=d.user_id; -- con join uno los campos de diferentes tablas en una sola tabla a usar

Select * from dbo.Sales; -- muestro info de tabla ventas para ver campos y así poder crear las vistas necesarias para el analisis




-- creo vista ventas por region
create view RegionVentas as 
	select c.age, c.gender, d.device_type, d.purchase_date, s.total_amount, s.sales_channel, s.region, s.payment_method
	from Customers c join Devices d on c.user_id = d.user_id join Sales s on d.user_id = s.user_id;

-- creo vista cliente por país
create view ClientePais as
select c.age, c.gender, c.city, c.country, c.occupation, d.device_type, d.purchase_date from Customers c join Devices d on c.user_id = d.user_id join Sales s on d.user_id = s.user_id

--creo vista tipo de compra más realizada
create view ProductoMasVentas as
	select s.product_id, s.product_category, s.product_name, s.payment_method, s.subscription_plan, s.sales_channel, c.occupation, d.device_type 
	from Customers c join Devices d on c.user_id = d.user_id join Sales s on d.user_id = s.user_id;

alter view RegionVentas as 
	select c.age, c.gender, d.purchase_date, s.total_amount, s.sales_channel, s.region, s.payment_method
	from Customers c join Devices d on c.user_id = d.user_id join Sales s on d.user_id = s.user_id;

alter view RegionVentas as 
	select c.age, c.gender, d.device_type, d.purchase_date, s.total_amount, s.sales_channel, s.region, s.payment_method
	from Customers c join Devices d on c.user_id = d.user_id join Sales s on d.user_id = s.user_id;
--drop view ___ si quiero eliminar alguna vista uso drop view nombre_vista


select * from RegionVentas; --selecciono vista creada, a partir de aqui puedo ingestar la vista con los campos a usar en PowerBI