USE BluePrint

GO

--1) La cantidad de colaboradores

select count(*) as 'Cantidad de colaboradores' from Colaboradores



--2) La cantidad de colaboradores nacidos entre 1990 y 2000.

select 
	count(*) as 'Colaboradores nacidos entre 1990 y 2000'
from Colaboradores as CB
where FechaNacimiento BETWEEN '1990/1/1' and '2000/12/31'



--3) El promedio de precio hora base de los tipos de tareas

select
	AVG(PrecioHoraBase) as 'Promedio'
from TiposTarea as TT



--4) El promedio de costo de los proyectos iniciados en el año 2019.

select
	AVG(CostoEstimado) as 'Promedio costo estimado'
from Proyectos as P
where YEAR(FechaInicio) like '2019'



--5) El costo más alto entre los proyectos de clientes de tipo 'Unicornio'

select
	MAX(CostoEstimado) as 'Costo maximo'
from Proyectos as P
	inner join Clientes as CL on CL.ID = P.IDCliente
	inner join TiposCliente as TC on TC.ID = CL.IDTipo
where TC.Nombre like 'Unicornio'



--6) El costo más bajo entre los proyectos de clientes del país 'Argentina'

select
	MIN(CostoEstimado) as 'Costo Minimo'
from Proyectos as PR
	inner join Clientes as CL on CL.ID = PR.IDCliente
	inner join Ciudades as C on C.ID = CL.IDCiudad
	inner join Paises as P on P.ID = C.IDPais
where P.Nombre like 'Argentina'



--7) La suma total de los costos estimados entre todos los proyectos.

select SUM(CostoEstimado) as 'Total costo estimado en proyectos'
from Proyectos as PR



--8) Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.

select
	C.Nombre as Ciudad,
	COUNT(CL.IDCiudad) as 'Cantidad de clientes'
from Ciudades as C
	left join Clientes as CL on CL.IDCiudad = C.ID
group by C.Nombre
order by 'Cantidad de clientes' desc



--9) Por cada país, listar el nombre del país y la cantidad de clientes.

select
	P.Nombre as Pais,
	COUNT(CL.IDCiudad) as Cantidad
from Paises as P
	left join Ciudades as C on C.IDPais = P.ID
	left join Clientes as CL on CL.IDCiudad = c.ID
group by P.Nombre
order by P.Nombre asc



--10) Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada.

select 
	TT.Nombre as 'Tipo de tarea',
	COUNT(CB.IDTarea) as 'Cantidad de colaboraciones'
from TiposTarea as TT
	left join Tareas as T on T.IDTipo = TT.ID
	left join Colaboraciones as CB on CB.IDTarea = T.ID
group by TT.Nombre
order by TT.Nombre asc



--11) Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.

select 
	TT.Nombre as 'Tipo de tarea',
	COUNT(distinct CO.ID) as 'Cantidad de colaboradores distintos'
from TiposTarea as TT
	left join Tareas as T on T.IDTipo = TT.ID
	left join Colaboraciones as CB on CB.IDTarea = T.ID
	left join Colaboradores as CO on CO.ID = CB.IDColaborador
group by TT.Nombre
order by TT.Nombre asc



--12) Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad totalizada. 
--    Mostrar los módulos sin horas registradas con 0.
	
-- COMO HACER PARA QUE SI LA CANTIDAD DE HORAS ES NULL, SE MUESTRE "NO REGISTRA HORAS" ???
select 
	M.ID,
	M.Nombre as 'Nombre del Modulo',
	SUM(CB.Tiempo) as 'Cantidad de horas'
/*case
	when CB.Tiempo is null then 'No registra horas'
end as 'Cantidad de horas'*/
from Modulos as M
	left join Tareas as T on T.IDModulo = M.ID
	left join Colaboraciones as CB on CB.IDTarea = T.ID
--where CB.TIEMPO is not null
group by M.ID, M.Nombre
order by M.ID



--13) Por cada módulo y tipo de tarea, el promedio de horas trabajadas. Indicar el ID y nombre del módulo, 
--    el nombre del tipo de tarea y el total calculado.

select 
	M.ID,
	M.Nombre as 'Modulo',
	TT.Nombre as 'Tipo de Tarea',
	AVG(CO.Tiempo *1.0) as 'Promedio horas'
from modulos as M
	left join Tareas as T on T.IDModulo = M.ID
	left join TiposTarea as TT on TT.ID = T.IDTipo
	left join Colaboraciones as CO on CO.IDTarea = T.ID
group by M.ID, M.Nombre, TT.Nombre
order by M.Nombre asc



--14) Por cada módulo, indicar su ID, apellido y nombre del colaborador y total que se le debe abonar en 
--    concepto de colaboraciones realizadas en dicho módulo.

select
	M.ID as 'ID de Modulo',
	CONCAT(CB.nombre,' ',CB.Apellido) as Colaborador,
	SUM(CO.PrecioHora * CO.Tiempo) as 'Total a abonar'
from Modulos as M
	left join Tareas as T on T.IDModulo = M.ID
	left join TiposTarea as TT on TT.ID = T.IDTipo
	left join Colaboraciones as CO on CO.IDTarea = T.ID
	left join Colaboradores as CB on CB.ID = CO.IDColaborador
group by M.ID, CONCAT(CB.nombre,' ',CB.Apellido) 
order by M.ID



--15) Por cada proyecto indicar el nombre del proyecto y la cantidad de horas registradas en concepto de 
--    colaboraciones y el total que debe abonar en concepto de colaboraciones.

select
	P.Nombre as Proyecto,
	SUM(CO.Tiempo) as Horas,
	SUM(CO.Tiempo * CO.PrecioHora) as 'Total a pagar'
from Proyectos as P
	left join Modulos as M on M.IDProyecto = P.ID
	left join Tareas as T on T.IDModulo = M.ID
	left join TiposTarea as TT on TT.ID = T.IDTipo
	left join Colaboraciones as CO on CO.IDTarea = T.ID
group by P.Nombre
order by P.Nombre asc



--16) Listar los nombres de los proyectos que hayan registrado menos de cinco colaboradores distintos y 
--    más de 100 horas total de trabajo.

select
	P.Nombre as Proyecto,
	COUNT(distinct CO.IDColaborador) as 'Colaboradores distintos',
	SUM(CO.Tiempo) as 'Horas de trabajo'
from Proyectos as P
	inner join Modulos as M on M.IDProyecto = P.ID
	inner join Tareas as T on T.IDModulo = M.ID
	inner join TiposTarea as TT on TT.ID = T.IDTipo
	inner join Colaboraciones as CO on CO.IDTarea = T.ID
group by P.Nombre
having COUNT('Colaboradores distintos') < 5 --and SUM('Horas de trabajo') > 100
order by P.Nombre



--17) Listar los nombres de los proyectos que hayan comenzado en el año 2020 que hayan registrado más de tres módulos.

select
	P.Nombre as Proyecto,
	COUNT(M.IDProyecto) as 'Cantidad de Modulos'
from Proyectos as P
	inner join Modulos as M on M.IDProyecto = P.ID
where YEAR(P.FechaInicio) like '2020'
group by P.Nombre
having COUNT('Cantidad de Modulos') > 3 
order by P.Nombre asc



--18) Listar para cada colaborador externo, el apellido y nombres y el tiempo máximo de horas que ha trabajo en una colaboración. 

select
	CONCAT(CO.Nombre,' ',CO.Apellido) as Colaborador,
	MAX(CB.Tiempo) as 'Tiempo maximo en colaboracion'
from Colaboradores as CO
	inner join Colaboraciones as CB on CB.IDColaborador = CO.ID
where CO.Tipo like 'E'
group by CONCAT(CO.Nombre,' ',CO.Apellido)
order by 'Colaborador' asc



--19) Listar para cada colaborador interno, el apellido y nombres y el promedio percibido en concepto de colaboraciones.

select 
	CONCAT(CO.Nombre,' ',CO.Apellido) as Colaborador,
	AVG(CB.Tiempo * CB.PrecioHora) as 'Promedio de colaboraciones'
from Colaboradores as CO
	left join Colaboraciones as CB on CB.IDColaborador = CO.ID
where CO.Tipo like 'I'
group by CONCAT(CO.Nombre,' ',CO.Apellido)
order by 'Colaborador' asc



--20) Listar el promedio percibido en concepto de colaboraciones para colaboradores internos y el promedio percibido 
--    en concepto de colaboraciones para colaboradores externos.

select 
	case when CO.Tipo like 'I' then 'Internos' else 'Externos' end as 'Tipos de colaboradores',
	AVG(CB.PrecioHora * CB.Tiempo) as 'Promedio de colaboraciones'
from Colaboraciones as CB
	inner join Colaboradores as CO on CO.ID = CB.IDColaborador
group by CO.Tipo
order by CO.Tipo asc



--21) Listar el nombre del proyecto y el total neto estimado. Este último valor surge del costo estimado
--    menos los pagos que requiera hacer en concepto de colaboraciones.

select
	P.Nombre as Proyecto,
	AVG(P.CostoEstimado) - SUM(CB.PrecioHora * CB.Tiempo) as 'Total neto estimado'
from Proyectos as P
	left join Modulos as M on M.IDProyecto = P.ID
	left join Tareas as T on T.IDModulo = M.ID
	left join Colaboraciones as CB on CB.IDTarea = T.ID
--where CB.Estado like '1'
group by P.Nombre 
having AVG(P.CostoEstimado) - SUM(CB.PrecioHora * CB.Tiempo) is not null
order by P.Nombre asc



--22) Listar la cantidad de colaboradores distintos que hayan colaborado en alguna tarea que correspondan
--    a proyectos de clientes de tipo 'Unicornio'.

-- VER SI SE PUEDE HACER PERO POR COLABORACIONES > COLABORADORES > CIUDADES > CLIENTES > TIPOCLIENTES
select 
	COUNT(distinct CB.IDColaborador) as Cantidad
from Colaboraciones as CB
	inner join Tareas as T on T.ID = CB.IDTarea
	inner join Modulos as M on M.ID = T.IDModulo
	inner join Proyectos as P on P.ID = M.IDProyecto
	inner join Clientes as C on C.ID = P.IDCliente
	inner join TiposCliente as TC on TC.ID = C.IDTipo
where TC.Nombre like 'Unicornio' 



--23) La cantidad de tareas realizadas por colaboradores del país 'Argentina'.

select
	--QUE ESTOY BUSCANDO EN ESTE CASO??
	--COUNT(distinct CB.IDColaborador) as Cantidad
	COUNT(distinct CB.IDTarea) as Cantidad
from Colaboraciones as CB
	inner join Colaboradores as CO on CO.ID = CB.IDColaborador
	inner join Ciudades as C on C.ID = CO.IDCiudad
	inner join Paises as P on P.ID = C.IDPais
where P.Nombre like 'Argentina'



--24) Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha de fin. 
--    Es decir, que se haya finalizado antes o después que la fecha estimada. Indicar el nombre del proyecto y la cantidad calculada.

select
	P.Nombre as Proyecto,
	COUNT(distinct M.ID) as 'Cantidad de modulos'
from Proyectos as P
	left join Modulos as M on M.IDProyecto = P.ID
Where M.FechaEstimadaFin != M.FechaFin
group by P.Nombre
order by P.Nombre asc
