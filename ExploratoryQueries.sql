use lesionesdb ;

-- 1. Visualizar los datos de todos los jugadores
select * from lesionesdb.jugador j ;

-- 2. Obtener todos los datos de todas las lesiones registradas
select * from lesionesdb.lesion l ;

-- 3. Listar los nombres de los tratamientos disponibles
select nombre_tratamiento from lesionesdb.tratamiento t ;

-- 4. Mostrar el nombre y especialidad de los especialistas
select nombre_especialista, especialidad
from lesionesdb.especialista e ;

-- 5. Obtener todas las especialidades distintas de los especialistas
select distinct especialidad
from lesionesdb.especialista e ;

-- 6. Obtener los nombres de las lesiones sin repeticiones
select distinct nombre_lesion 
from lesionesdb.lesion l ;

-- 7. Obtener los DNI únicos de jugadores que han sufrido lesiones
select distinct dni_jugador 
from lesionesdb.jugador_lesion jl ;

-- 8. Contar el número total de jugadores registrados
select count(*) as total_jugadores
from lesionesdb.jugador j ;

-- 9. Calcular el número total de lesiones registradas
select count(distinct id_lesion) as total_lesiones
from lesionesdb.lesion l ;

-- 10. Obtener el número total de tratamientos disponibles
select count(distinct id_tratamiento) as total_tratamientos_disponibles
from lesionesdb.tratamiento t ;

-- 11. Obtener los jugadores nacidos a partir del año 2000
select * 
from lesionesdb.jugador j 
where fecha_nacimiento_jugador >= '2000-01-01' ;

-- 12. Obtener las lesiones ocurridas antes de 2024
select *
from lesionesdb.jugador_lesion jl 
where fecha_lesion < '2024-01-01' ;

-- 13. Obtener los tratamientos cuyo nombre contiene 'terapia' en cualquier zona del nombre
select *
from lesionesdb.tratamiento t 
where nombre_tratamiento like '%terapia%' ;

-- 14. Obtener jugadores nacidos entre 1980 y 1990
select *
from lesionesdb.jugador j 
where fecha_nacimiento_jugador between '1980-01-01' and '1990-12-31' ;

-- 15. Obtener especialistas con especialidad 'Fisioterapeuta' o 'Podólogo'
select *
from lesionesdb.especialista e 
where especialidad in ('Fisioterapeuta', 'Podólogo') ;

-- 16. Obtener lesiones que no contengan 'fractura' en el nombre
select *
from lesionesdb.lesion l 
where nombre_lesion not like '%fractura%' ;

-- 17. Obtener lesiones cuyo nombre tenga más de 20 caracteres
select *
from lesionesdb.lesion l 
where length(nombre_lesion) > 20 ; 

-- 18. Obtener jugadores que nacieron a partir de 1990 y tienen un nombre de menos de 10 caracteres
select *
from lesionesdb.jugador j 
where fecha_nacimiento_jugador >= '1990-01-01'
and length(nombre_jugador) < 10 ;

-- 19. Obtener tratamientos cuyo nombre contenga 'terapia' y tengan más de 50 caracteres en su descripción
select *
from lesionesdb.tratamiento t 
where nombre_tratamiento like '%terapia%'
and length(explicacion_tratamiento) > 50 ;

-- 20. Listar todos los jugadores ordenados por su fecha de nacimiento (ascendente)
select *
from lesionesdb.jugador j 
order by fecha_nacimiento_jugador asc ;

-- 21. Mostrar las lesiones ordenadas alfabéticamente
select *
from lesionesdb.lesion l 
order by nombre_lesion asc ;

-- 22. Mostrar los primeros 5 jugadores registrados
select *
from lesionesdb.jugador j 
limit 5 ;

-- 23. Obtener los siguientes 5 tratamientos después de los primeros 10 registros
select *
from lesionesdb.tratamiento t 
limit 5 offset 10 ;

-- 24. Número de tratamientos realizados por cada tratamiento
select id_tratamiento, count(*) as numero_tratamientos_realizados
from lesionesdb.jugador_lesion_tratamiento_especialista jlte 
group by id_tratamiento ;

-- 25. Contar cuántos especialistas hay por cada especialidad
select especialidad, count(*) as numero_especialistas 
from lesionesdb.especialista e 
group by especialidad ;

-- 26. Cantidad de lesiones registradas por jugador
select dni_jugador , count(*) as cantidad_lesiones 
from lesionesdb.jugador_lesion jl 
group by dni_jugador ;

-- 27. Número de registros por combinación específica de lesión y tratamiento
select id_lesion, id_tratamiento,  count(*) as numero_de_registros
from lesionesdb.lesion_tratamiento lt 
group by id_lesion, id_tratamiento ;

-- 28. Obtener especialidades con más de 2 especialistas registrados
select especialidad, count(*) as numero_de_especialistas 
from lesionesdb.especialista e 
group by especialidad 
having numero_de_especialistas > 2 ;

-- 29. Obtener los años con más de 15 lesiones registradas
select year(fecha_lesion) as año, count(*) as lesiones_registradas 
from lesionesdb.jugador_lesion jl 
group by año
having lesiones_registradas > 15 ; 

-- 30. Crear una vista con jugadores nacidos a partir del año 2000
create view jugadores_nacidos_a_partir_2000 as 
select *
from lesionesdb.jugador j 
where fecha_nacimiento_jugador > '2000-01-01'

-- 31. Crear una vista con lesiones ocurridas antes del año 2024
create view lesiones_ocurridas_antes_2024 as 
select * 
from lesionesdb.jugador_lesion jl 
where fecha_lesion < '2024-01-01'

-- 32. Obtener jugadores que han sufrido la lesión más frecuente
select j.* 
from lesionesdb.jugador j
join lesionesdb.jugador_lesion jl on j.dni_jugador = jl.dni_jugador 
where jl.id_lesion = ( select id_lesion 
					from (select id_lesion , count(*) as numero_lesiones 
					from lesionesdb.jugador_lesion jl 
					group by id_lesion 
					order by numero_lesiones desc
					limit 1) as lesion_frecuente
					);

-- 33. Mostrar tratamientos que son utilizados para la lesión menos frecuente
select t.* 
from lesionesdb.tratamiento t 
join lesionesdb.lesion_tratamiento lt on t.id_tratamiento = lt.id_tratamiento 
where lt.id_lesion = ( select id_lesion 
					from (select id_lesion , count(*) as numero_lesiones 
					from lesionesdb.jugador_lesion jl 
					group by id_lesion 
					order by numero_lesiones asc
					limit 1) as lesion_menos_frecuente
					);

-- 34. Obtener los nombres de los jugadores y las lesiones que han sufrido
select j.nombre_jugador, l.nombre_lesion 
from lesionesdb.jugador j 
join lesionesdb.jugador_lesion jl 
	on j.dni_jugador = jl.dni_jugador 
join lesionesdb.lesion l 
	on l.id_lesion = jl.id_lesion ;

-- 35. Listar los tratamientos y los nombres de los especialistas que los realizan
select t.nombre_tratamiento, e.nombre_especialista 
from lesionesdb.tratamiento t 
join lesionesdb.tratamiento_especialista te 
	on t.id_tratamiento = te.id_tratamiento 
join lesionesdb.especialista e 
	on e.dni_especialista = te.dni_especialista ;

-- 36. Listar jugadores con sus respectivas fechas de lesión y tratamientos aplicados, ordenados por jugador y fecha de lesión
select j.nombre_jugador, jl.fecha_lesion, t.nombre_tratamiento 
from lesionesdb.jugador j 
join lesionesdb.jugador_lesion jl 
	on j.dni_jugador = jl.dni_jugador 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on jl.dni_jugador = jlte.dni_jugador
	and jl.id_lesion = jlte.id_lesion 
	and jl.fecha_lesion = jlte.fecha_lesion 
join lesionesdb.tratamiento t 
	on t.id_tratamiento = jlte.id_tratamiento 
order by j.nombre_jugador, jlte.fecha_lesion ;

-- 37. Obtener lesiones y los especialistas que trabajaron en su tratamiento
select l.nombre_lesion, jlte.fecha_lesion, e.nombre_especialista 
from lesionesdb.lesion l 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on l.id_lesion = jlte.id_lesion 
join lesionesdb.especialista e 
	on e.dni_especialista = jlte.dni_especialista ;

-- 38. Obtener los tratamientos para cada lesión y el número de veces aplicados en cada lesión distinta, ordenados de mayor a menor
select l.nombre_lesion, t.nombre_tratamiento, count(jlte.fecha_lesion) as numero_aplicaciones 
from lesionesdb.lesion l 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on l.id_lesion = jlte.id_lesion 
join lesionesdb.tratamiento t 
	on t.id_tratamiento = jlte.id_tratamiento 
group by l.nombre_lesion, t.nombre_tratamiento
order by numero_aplicaciones desc ;

-- 39. Obtener el nombre del jugador con más lesiones registradas
select j.nombre_jugador
from lesionesdb.jugador j 
join lesionesdb.jugador_lesion jl 
	on j.dni_jugador = jl.dni_jugador 
group by j.nombre_jugador 
order by count(jl.fecha_lesion) desc 
limit 1 ;

-- 40. Obtener el especialista más activo (con más tratamientos realizados)
select e.nombre_especialista 
from lesionesdb.especialista e 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on e.dni_especialista = jlte.dni_especialista 
group by e.nombre_especialista 
order by count(*) desc 
limit 1 ;

-- 41. Listar los tratamientos aplicados exclusivamente a jugadores con más de una lesión
select distinct t.nombre_tratamiento
from lesionesdb.tratamiento t 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on t.id_tratamiento = jlte.id_tratamiento 
where jlte.dni_jugador in ( select jl.dni_jugador
							from lesionesdb.jugador_lesion jl 
							group by jl.dni_jugador
							having count(*) > 1) ;

-- 42. Mostrar las lesiones que no tienen ningún tratamiento asignado
select distinct l.nombre_lesion
from lesionesdb.lesion l 
where l.id_lesion not in (  select lt.id_lesion 
							from lesionesdb.lesion_tratamiento lt) ;

-- 43. Obtener jugadores que hayan recibido más de un tratamiento para la misma lesión
select j.nombre_jugador, l.nombre_lesion, count(*) as numero_tratamientos_recibidos 
from lesionesdb.jugador j 
join lesionesdb.jugador_lesion jl 
	on j.dni_jugador = jl.dni_jugador 
join lesionesdb.lesion l 
	on l.id_lesion = jl.id_lesion 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on jl.dni_jugador = jlte.dni_jugador 
group by jl.dni_jugador, jl.id_lesion 
having count(distinct jlte.id_tratamiento) > 1 ;

-- 44. Obtener lesiones con más de 3 tratamientos asociados
select l.nombre_lesion, count(*) as numero_tratamientos_asociados 
from lesionesdb.lesion l 
join lesionesdb.lesion_tratamiento lt 
	on l.id_lesion = lt.id_lesion
group by lt.id_lesion 
having count(distinct lt.id_tratamiento) > 3 
order by count(distinct lt.id_tratamiento) desc; 

-- 45. Obtener especialistas que hayan trabajado en al menos 3 tratamientos distintos
select e.nombre_especialista, count(distinct jlte.id_tratamiento) as distintos_tratamientos_efectuados 
from lesionesdb.especialista e 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on e.dni_especialista = jlte.dni_especialista
group by jlte.dni_especialista 
having count(distinct jlte.id_tratamiento) >= 3 ; 

-- 46. Obtener el jugador más joven que haya sufrido una lesión y recibido el tratamiento de 'Rehabilitación'
select j.nombre_jugador, j.fecha_nacimiento_jugador, t.nombre_tratamiento
from lesionesdb.jugador j
join lesionesdb.jugador_lesion jl 
	on j.dni_jugador = jl.dni_jugador 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on jl.dni_jugador = jlte.dni_jugador 
	and jl.id_lesion = jlte.id_lesion 
	and jl.fecha_lesion = jlte.fecha_lesion 
join lesionesdb.tratamiento t
	on t.id_tratamiento = jlte.id_tratamiento 
where t.nombre_tratamiento like '%Rehabilitación%'
order by j.fecha_nacimiento_jugador desc
limit 3 ;

-- 47. Obtener lesiones con tratamientos que puedan realizar más de 3 especialistas
select l.nombre_lesion, count(distinct te.dni_especialista) as numero_especialistas
from lesionesdb.lesion l 
join lesionesdb.lesion_tratamiento lt 
	on l.id_lesion = lt.id_lesion 
join lesionesdb.tratamiento_especialista te 
	on lt.id_tratamiento = te.id_tratamiento 
group by l.id_lesion
having numero_especialistas > 3 
order by numero_especialistas desc ;

-- 48. Listado de lesiones únicas que han sido tratadas por especialistas con especialidad "Fisioterapeuta"
select distinct l.nombre_lesion
from lesionesdb.lesion l
join lesionesdb.jugador_lesion jl 
	on l.id_lesion = jl.id_lesion 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on jl.dni_jugador = jlte.dni_jugador 
	and jl.id_lesion = jlte.id_lesion 
	and jl.fecha_lesion = jlte.fecha_lesion 
join lesionesdb.especialista e 
	on jlte.dni_especialista = e.dni_especialista 
where e.especialidad like '%Fisioterapeuta%'

-- 49. Jugadores que no tienen lesiones registradas (usando una subconsulta)
select *
from lesionesdb.jugador j 
where j.dni_jugador not in ( 
	select jl.dni_jugador
	from lesionesdb.jugador_lesion jl
) ;

-- 50. Nombre y fecha de lesiones que ocurrieron antes de 2025 y tratamientos aplicados
select l.nombre_lesion, jlte.fecha_lesion, t.nombre_tratamiento 
from lesionesdb.lesion l
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on l.id_lesion = jlte.id_lesion 
join lesionesdb.tratamiento t 
	on t.id_tratamiento = jlte.id_tratamiento 
where jlte.fecha_lesion < '2025-01-01' 
order by jlte.fecha_lesion desc ;

-- 51. Tratamientos distintos aplicados a lesiones de jugadores nacidos a partir de 1990
select distinct t.nombre_tratamiento
from lesionesdb.tratamiento t 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on t.id_tratamiento = jlte.id_tratamiento 
join lesionesdb.jugador j 
	on j.dni_jugador = jlte.dni_jugador 
where j.fecha_nacimiento_jugador >= '1990-01-01'
order by t.nombre_tratamiento asc ;

-- 52. Promedio redondeado de lesiones por jugador
select round(avg(numero_lesiones_cada_jugador),0) as promedio_redondeado_lesiones
from (
select count(*) as numero_lesiones_cada_jugador
from lesionesdb.jugador_lesion jl 
group by jl.dni_jugador 
) as subconsulta ;

-- 53. Listado de especialistas y cuántos tratamientos distintos administraron
select e.nombre_especialista, count(distinct jlte.id_tratamiento) as tratamientos_distintos_administrados 
from lesionesdb.especialista e
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on e.dni_especialista = jlte.dni_especialista 
group by e.dni_especialista 
order by tratamientos_distintos_administrados desc ;

-- 54. Lesión más común y cuántas veces ha ocurrido
select l.nombre_lesion, count(jl.id_lesion) as frecuencia 
from lesionesdb.lesion l 
join lesionesdb.jugador_lesion jl 
	on l.id_lesion = jl.id_lesion 
group by l.id_lesion 
order by frecuencia desc 
limit 1 ;

-- 55. Fecha más antigua en la que un especialista administró un tratamiento
select e.nombre_especialista, min(jlte.fecha_lesion) as fecha_mas_antigua, t.nombre_tratamiento 
from lesionesdb.especialista e 
join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	on e.dni_especialista = jlte.dni_especialista
join lesionesdb.tratamiento t 
	on t.id_tratamiento = jlte.id_tratamiento 
group by jlte.dni_especialista 
order by fecha_mas_antigua asc ;






	