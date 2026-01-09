--codigo sql en postgre, crear en otros motores
create table Sitio(
	cod_Sitio varchar(20) primary key,
	nombre_sitio varchar(20) not null
);

create table Personas (
	userID serial primary key,
	nombre varchar(20) not null,
	ciudad varchar(20),
	correo varchar(100) unique,
	cod_Sitio varchar(20) references Sitio(cod_Sitio) not null,
	fechaRegistro timestamp with time zone default current_timestamp
);

create table Visitas (
	ID serial primary key,
	cod_Sitio varchar(20) references Sitio(cod_Sitio) not null,
	userID int references Personas(userID) not null,
	fechaInicio date not null,
	fechaFin date not null,
	horaInicio time,
	horaFin time	
);

Create table ventas (
	id serial primary key,
	persona_id INT REFERENCES personas(userID),
	cod_sitio varchar(20) references sitio(cod_sitio),
	fecha_compra timestamp with time zone default current_timestamp,
	cantidad int
);

--insert into Sitio (cod_sitio,nombre_sitio) values('S005','series')
--insert into Personas (nombre, ciudad,correo,cod_Sitio,edad) values ('Marin','','marin@correo.com','S003','13');
--insert into Visitas (cod_Sitio, userID,fechaInicio, fechaFin,horaInicio,horaFin) values ('S002','1','18/03/2025','18/03/2025','09:00:00','09:10:00');
--insert into ventas (persona_id,cod_sitio,cantidad) values('4','S005','4');
--insert into ventas (persona_id,cod_sitio,cantidad) values('12','E03','5');

select * from Visitas;


--preguntas

SELECT * from visitas;

--NUMERO DE VISITAS -> count
select cod_sitio, count(id) as visitas from visitas group by cod_sitio order by visitas desc
--VISITAS CON NOMBRE Y SITIO -> group, order by
select s.nombre_sitio, s.cod_sitio, count(v.id) as visitas from sitio s join visitas v on s.cod_sitio=v.cod_sitio 
	group by s.nombre_sitio, s.cod_sitio order by visitas desc
--VISITAS CON NOMBRE Y SITIO en sitio educacion con mas de 3 visitas --where y having
select s.nombre_sitio, s.cod_sitio, count(v.id) as visitas from  sitio s join visitas v on s.cod_sitio=v.cod_sitio 
	where s.nombre_sitio='educacion' group by s.nombre_sitio, s.cod_sitio having count(v.id) >=2 order by visitas desc

--VISITAS PROMEDIO DE ULTIMOs 11 MESes --> avg
with visitasXmes as
(	select s.nombre_sitio, s.cod_sitio, count(v.id) as cuentavisita, date_trunc('month',v.fechaInicio) as agrupaMes 
		from  sitio s join visitas v on s.cod_sitio=v.cod_sitio 
		where fechaInicio >= current_date -interval '11 month' group by s.nombre_sitio, s.cod_sitio, date_trunc('month',v.fechaInicio)
)
select nombre_sitio, cod_sitio, avg(cuentavisita) as promMensual from visitasXmes group by nombre_sitio, cod_sitio

--VISITAS MAXIMA Y MINIMA DEL utlimo año --> max, min
select cod_sitio, min(fechaInicio), max(fechaInicio) from visitas where fechaInicio between '2025/01/01' and '2025/12/31'
	group by cod_sitio	
 --SUSCRIPCIONES VENDIDAS DEL MES --> sum
		--forma1
select cod_sitio, sum(cantidad) as susVendidas from ventas 
	where fecha_compra between '2025/12/01' and '2025/12/31' group by cod_sitio order by sum(cantidad) desc
		--forma2
select cod_sitio, sum(cantidad) as susVendidas from ventas 
	where fecha_compra >= current_date -interval '1 month' group by cod_sitio order by sum(cantidad) desc
-- SUSCRIP VENDIDAS EN S001, S002 O E003, Mayores A 10 EN GYE SIN CIUDAD NULA --> condicionales
select s.cod_sitio, p.ciudad, sum(v.cantidad) as suscVendidas
	from ventas v join sitio s on v.cod_sitio=s.cod_sitio join personas p on v.cod_sitio=p.cod_sitio
	where s.cod_sitio in('S001','S002','E003') and p.ciudad='guayaquil' and p.ciudad is not null and p.ciudad <> ''
	group by s.cod_sitio, p.ciudad 
	having sum(v.cantidad) >=10
--SUSCRP VENDIDAS EN SERIES MENOS S003 MENORES A 10 en ciudad NO NULA o blnaco ENTRE DIC20 Y 31 -->codicionales, nulos, blancos
select s.cod_sitio, s.nombre_sitio, p.ciudad, v.fecha_compra, sum(v.cantidad)
	from ventas v join personas p on v.cod_sitio=p.cod_sitio join sitio s on s.cod_sitio=p.cod_sitio
	where s.nombre_sitio='series' and s.cod_sitio not like 'S003' 
	and v.fecha_compra between '2025/12/21' and '2025/12/31'
	and p.ciudad is not null and p.ciudad <> ''
	group by p.ciudad, s.nombre_sitio, v.fecha_compra, s.cod_sitio
	having sum(cantidad) <=10 order by sum(v.cantidad) desc

--Uso común: Reemplazar un vacío molesto por un "0" o un texto como "Sin nombre". sintaxis: COALESCE(valor, valor_si_es_nulo)
SELECT id,
    COALESCE(nombre_sitio, 'Nombre no registrado') AS sitio_validado,   -- COALESCE: Si el nombre es nulo, pone 'Sin Nombre'
    COALESCE(cantidad, 0) AS cantidad_ajustada,
    COALESCE(cod_sitio, nombre_sitio, 'Desconocido') AS identificador_final -- Ejemplo combinando varios: el primero que no sea nulo gana
FROM ventas;


-- ENUMERA VISITAS DE MAS RECIENTE A MAS ANTIGUA --> row number para top ranking turno
select fechaInicio, id, row_number() over(order by fechaInicio desc) as listaVisita from visitas
-- LO MISMO, POR SITIO -->partition by    --Numerar las visitas, pero que el conteo empiece en 1 para cada sitio diferente
select cod_sitio, id, fechaInicio, row_number() over(partition by cod_sitio order by fechaInicio desc) as listavisita from visitas
--ENUMERA O LISTA 1era  y ultima VISITA iniciada POR FECHA INICIO NAVEGACION -> 
		--enumera row_number() over ()
select cod_sitio, min(fechaInicio) as firstNav, max(fechaInicio) as lastNav, row_number() over(order by min(fechaInicio) asc) as lista 
	from visitas group by cod_sitio
		-- lista union all (mejor)
(select 'primeraNavegacion' as posicion, cod_sitio, fechaInicio from visitas order by fechaInicio asc limit 1) 
union all 
(select 'ultimaNavegacion' as posicion,  cod_sitio, fechaInicio from visitas order by fechaInicio desc limit 1)
--MAYOR NUMERO DE SUSCRIPCIONES POR SITIO --> 
select cod_sitio, max(cantidad) as MaxCantVendida from ventas group by cod_sitio order by MaxCantVendida desc;
--MENOR NUM SUSCRIPCIONES POR SITIO 
select cod_sitio, min(cantidad) as MinVendido from ventas group by cod_sitio order by MinVendido asc;





-- Clasificación de Edad (CASE WHEN) con Agrupación simple
select s.nombre_sitio, 
	case		when p.edad >= 18 then 'mayor edad' else 'menor de edad' end as rangoEdad,
count (p.userid) as TotalUsuarios from sitio s join personas p on s.cod_sitio = p.cod_sitio 
group by s.nombre_sitio, case when p.edad >= 18 then 'mayor edad' else 'menor de edad' end 


		--forma 2
WITH Segmentacion AS (
    SELECT 
        s.nombre_sitio,
        p.userid,
        CASE 
            WHEN p.edad >= 18 THEN 'mayor de edad'
            ELSE 'menor de edad'
        END AS rangoEdad,
        CASE 
            WHEN p.edad BETWEEN 0 AND 15 THEN 'grupo1menores'
            WHEN p.edad BETWEEN 16 AND 20 THEN 'grupo2mayores'
            WHEN p.edad BETWEEN 21 AND 31 THEN 'grupo3mayores'
            ELSE 'grupo4mayores'
        END AS grupocompradores
    FROM sitio s 
    JOIN personas p ON s.cod_sitio = p.cod_sitio
)
SELECT 
    nombre_sitio, 
    rangoEdad, 
    grupocompradores, 
    COUNT(userid) AS totalPersonas
FROM Segmentacion
GROUP BY nombre_sitio, rangoEdad, grupocompradores
ORDER BY totalPersonas DESC;

-- agrupa por sitio empieza con s00 series o e0 educacion

WITH Segmentacion AS (
    SELECT 
        s.nombre_sitio,
        p.userid,
        -- Clasificación por prefijo de código
        CASE 
            WHEN s.cod_sitio LIKE 's00%' THEN 'Series'
            WHEN s.cod_sitio LIKE 'e00%' THEN 'Educación'
            ELSE 'Otros'
        END AS categoria_sitio,
        -- Clasificación por edad
        CASE 
            WHEN p.edad >= 18 THEN 'mayor de edad'
            ELSE 'menor de edad'
        END AS rangoEdad
    FROM sitio s 
    JOIN personas p ON s.cod_sitio = p.cod_sitio
)
SELECT 
    categoria_sitio,
    nombre_sitio, 
    rangoEdad, 
    COUNT(userid) AS totalPersonas
FROM Segmentacion
GROUP BY categoria_sitio, nombre_sitio, rangoEdad
ORDER BY categoria_sitio, totalPersonas DESC;

	--condicionales: and or, like, not, in... etc
	--operadores de conjuntos: union all, minus, intersect, exists
--fechas: de cadena a fecha, extraccion partes, fecha a cadena, transposiciones 
	-- nulos: nvl, coalesce
--condicionales con mas de un ID





--ACUMULADO DE VISITANTES OVER

--AGREGAR COLUMNA IDENTIFICANDO SITIO VISITADO

--ENCUENTRA DUPLICADOS

--ELIMINA DUPLICADO Y MUESTRA RECIENTE

--REGISTROS DE MAYO

--REGISTROS DE MAYO 18 DEL SITIO EDUCACION FECHAS

--USUARIOS DE ABRIL 18 NO NULOS DE SERIES 

-----------------------------------Bloque 1: Condicionales y Operadores (AND, OR, LIKE, IN, NOT)

--1.1 El filtro de correos: Selecciona todas las personas cuyo email termine en @correo.com y que tengan el cod_sitio 'S002'.

select cod_sitio, nombre, correo from personas where correo like '%@correo.com' and cod_sitio = 'S002' 
	group by cod_sitio, nombre, correo

--1.2 Multiselección de Sitios: Busca todas las visitas que ocurrieron en los sitios 'S001', 'S003' o 'S004' (Usa IN).
select cod_sitio, id, userid, row_number() over(partition by cod_sitio) as visitassitio 
from visitas where cod_sitio in ('S001','S003','S004') 

--1.3 Exclusión de Clientes: Muestra las ventas de todos los clientes, excepto de los que tienen los IDs 4, 6 y 11 (Usa NOT IN).
select cod_sitio, id, persona_id, fecha_compra, cantidad from ventas
	where persona_id not in ('4','6','11') group by cod_sitio, persona_id, id, fecha_compra, cantidad order by cantidad desc

--1.4 Búsqueda parcial: Encuentra a las personas cuyo nombre empiece con la letra 'K' o termine con la letra 'n'.
select cod_sitio, nombre, edad from personas where nombre ilike 'a%' or nombre ilike '%n' group by cod_sitio, edad, nombre


------------------------------Bloque 2: Manejo de Nulos y Fechas (COALESCE, EXTRACT, TO_CHAR)

--2.1 Limpieza de datos: Selecciona el nombre y la ciudad de las personas. Si la ciudad está vacía o es nula, muestra el texto 'Ciudad No Registrada' (Usa COALESCE).
select ciudad, nombre, coalesce( nullif( ciudad,''),'Ciudad no regsitrada') as validaCiudad from personas

--2.2 Extracción de tiempo: De la tabla visitas, obtén el persona_id y solo el año de la fecha_inicio.
select cod_sitio, userid, fechainicio, extract(year from fechainicio) as añoinicio, extract( month from fechaInicio) as mes from visitas
--3.1 Duración en minutos: Calcula cuántos minutos duró cada visita. (Pista: Resta hora_fin - hora_inicio y multiplica por los segundos o usa EXTRACT).
select cod_sitio, userid, horainicio, horafin, extract(epoch from (horafin-horainicio)/60) as minutosvistos from visitas
-- Filtro de fin de semana: Selecciona todas las ventas que se realizaron en sábado o domingo. (Pista: Usa EXTRACT(DOW FROM fecha_compra) donde 0 es domingo y 6 es sábado).
select cod_sitio, cantidad, fecha_compra, to_char(fecha_compra,'day') as diacompra from ventas
where extract(dow from fecha_compra) in(6,0) 

--2.3 Formateo de fechas: Muestra la fecha_compra de la tabla ventas con el formato 'Día-Mes-Año' (ej. 19-03-2025) usando TO_CHAR.
select persona_id, fecha_compra, to_char(fecha_compra,'DD-MM-YYYY') as DMA from ventas
--3.4 Extracción de partes: De la tabla personas, muestra el nombre y el nombre del mes en que se registraron (ej: "March", "April").
select nombre, fecharegistro, to_char(fecharegistro,'month'), to_char(fecharegistro,'day') as mesregsitro from personas

--2.4 Diferencia de días: Calcula cuántos días duró cada visita (fecha_fin menos fecha_inicio).
select userid, fechainicio, fechafin, (fechafin-fechainicio) as duracionVisita from visitas order by duracionVisita desc

--proyección de fechas: Muestra la fecha de compra y una columna nueva llamada "fecha_vencimiento_pago" que sea exactamente 30 días después de la compra.
select cod_sitio, persona_id, fecha_compra, (fecha_compra +interval '30 days') as VencimientoPago from ventas





-----------------------------------Bloque 3: Operadores de Conjuntos y Existencia (UNION, INTERSECT, EXISTS)

--3.1 Unión de códigos: Obtén una lista única de todos los cod_sitio que aparecen en la tabla personas y todos los que aparecen en la tabla visitas (Usa UNION).

Clientes con actividad dual: Encuentra los persona_id que han realizado una visita y también han realizado una venta (Usa INTERSECT).

Validación de ventas: Muestra los nombres de las personas que tienen al menos una venta registrada (Usa WHERE EXISTS).



Bloque 4: Condicionales con más de un ID (Lógica avanzada)
Cruce de IDs específicos: Selecciona las visitas realizadas por el persona_id = 4, pero solo si fueron en el cod_sitio = 'S001'.

Ventas por múltiples criterios: Busca las ventas donde la cantidad sea mayor a 2 y el persona_id esté entre el 1 y el 10.



Bloque 6: Transposiciones y Pivot (Rows to Columns)
PostgreSQL no tiene una palabra clave PIVOT simple como SQL Server, por lo que solemos usar CASE WHEN con agregación, que es el estándar de la industria.

Pivot de Ventas por Sitio: Crea un reporte que muestre el persona_id y tres columnas llamadas S001, S004 y S005. En cada columna debe aparecer la suma de la cantidad vendida en ese sitio para ese usuario.

Pista: SUM(CASE WHEN cod_sitio = 'S001' THEN cantidad ELSE 0 END) AS S001.

Conteo de Visitas por Jornada: Transpón las visitas para saber cuántas hizo cada persona en la mañana (antes de las 12:00) vs. la tarde (después de las 12:00).

Pivot de Fechas: Queremos ver cuánto compró cada persona en el mes de 'Marzo' vs 'Abril' en dos columnas diferentes.