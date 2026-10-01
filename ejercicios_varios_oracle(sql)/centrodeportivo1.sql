-- EJERCICIO 1
SELECT nombre, telefono, salario
from monitor
WHERE salario > 1200;

-- ejercicio 2
SELECT nombre, responsable, nivel
FROM actividad
WHERE nivel > 0 AND nivel < 4
order by responsable;

-- ejercicio 3
SELECT distinct I.instalacion_id
FROM instalacion I
    JOIN actividad A ON I.instalacion_id = A.instalacion_id
WHERE A.nivel = 3 AND A.precio < 10
order by instalacion_id DESC;

-- EJERCICIO 4
SELECT actividad_id, diasemana, hora
FROM sesion
WHERE ((diasemana = 'L') OR (diasemana = 'S' AND hora BETWEEN 9 AND 11.3))
order by diasemana,hora;

-- ejercicio 5
SELECT nombre, telefono, TO_CHAR(TO_DATE(EXTRACT(Month FROM fcontrato), 'mm'), 'Month') mes_contrato
FROM monitor
WHERE nombre LIKE'%cia%';

--EJERCICIO 6
SELECT actividad_id act, diasemana||' '||hora dia_hora, monitor_id
FROM sesion
WHERE (diasemana in ('J', 'M') AND hora < 19.00)
order by dia_hora;

-- ejercicio 7
SELECT actividad_id, precio, 0.93*precio nuevo_precio
FROM actividad
WHERE nivel = 5 AND precio > 12
order by actividad_id;

-- ejercicio 8
SELECT dni, nombre, salario, (2024 - EXTRACT(YEAR FROM fcontrato)) experiencia
FROM monitor
WHERE (2024 - EXTRACT(YEAR FROM fcontrato)) > 15;

-- ejercicio 9
SELECT actividad_id, hora, monitor_id
FROM sesion
WHERE diasemana = 'V' AND actividad_id IN ('A02', 'A05', 'A09', 'A19')
order by monitor_id;

-- ejercicio 10
SELECT distinct instalacion_id
FROM actividad
WHERE nivel = 1 OR nivel = 2
order by instalacion_id ASC;

-- ejercicio 11
SELECT A.nombre nombre_actividad, I.nombre nombre_instalacion, I.m2
FROM actividad A
    JOIN instalacion I ON A.instalacion_id = I.instalacion_id
WHERE A.nombre IN ('Pilates', 'Balonmano');

-- ejercicio 12
SELECT S.actividad_id, S.hora, M.nombre nombre_monitor
FROM monitor M
    JOIN sesion S ON M.dni = S.monitor_id
WHERE S.diasemana = 'V' AND S.hora > 15 AND S.actividad_id IN ('A02', 'A05', 'A09', 'A19')
order by S.hora;

-- ejercicio 13
SELECT A.nombre nombre_actividad, A.precio, A.nivel, I.nombre nombre_instalacion
FROM Actividad A
    JOIN Instalacion I ON A.instalacion_id = I.instalacion_id
WHERE I.tipo = 'Exterior'
order by A.nombre;

--EJERCICIO 14
SELECT distinct M.nombre nombre_monitor, A.nombre nombre_actividad
FROM sesion S
    JOIN actividad A ON S.actividad_id = A.actividad_id 
    JOIN monitor M ON S.monitor_id = M.dni
WHERE hora >= 19 AND nivel in (4, 5);

-- ejercicio 15
SELECT distinct I.tipo, A.nombre nombre_actividad, A.nivel, S.diasemana
FROM sesion S
    JOIN actividad A ON S.actividad_id = A.actividad_id
    JOIN instalacion I ON A.instalacion_id = I.instalacion_id
WHERE S.diasemana IN ('V', 'S')
order by diasemana, nivel DESC, nombre_actividad;

-- ejercicio 16
SELECT M.nombre nombre_monitor, A.nombre nombre_actividad
FROM especialista E
    JOIN  monitor M ON E.monitor_id = M.dni
    JOIN actividad A ON E.actividad_id = A.actividad_id
order by nombre_monitor;

-- ejercicio 17
SELECT distinct I.nombre nombre_instalacion, A.nombre tipo, M.nombre nombre_monitor
FROM instalacion I
    JOIN actividad A ON I.instalacion_id = A.instalacion_id
    JOIN especialista E ON A.actividad_id = E.actividad_id
    JOIN monitor M ON A.responsable = M.dni
WHERE A.nombre IN ('Yoga', 'Body combat', 'Hapkido')
order by I.nombre;

-- ejercicio 18
SELECT diasemana, hora, A.nombre nombre_actividad, M.nombre nombre_monitor
FROM sesion S
    JOIN actividad A ON S.actividad_id = A.actividad_id
    JOIN monitor M ON S.monitor_id = M.dni
WHERE diasemana IN ('L', 'X')
order by diasemana, hora, nombre_actividad;

--EJERCICIO 19
SELECT diasemana, hora, A.nombre nombre_actividad, R.nombre nombre_responsable
FROM monitor M 
    JOIN sesion S ON S.monitor_id = M.dni
    JOIN actividad A ON S.actividad_id = A.actividad_id 
    JOIN monitor R ON R.dni = A.responsable
WHERE M.nombre = 'Belinda';

-- EJERCICIO 20
SELECT COALESCE (A.nombre, '...') nombre_actividad, M.nombre nombre_responsable
FROM actividad A
    RIGHT JOIN monitor M ON A.responsable = M.dni
ORDER BY M.nombre;

-- ejercicio 21
SELECT  I.nombre nombre_instalacion, COALESCE (A.nombre, '----') nombre_actividad
FROM actividad A
    RIGHT JOIN instalacion I ON A.instalacion_id = I.instalacion_id
order by I.nombre;

--ejercicio 22
SELECT monitor_id
FROM sesion
MINUS
SELECT responsable 
FROM actividad;



-- EJERCICIO 23
SELECT responsable 
FROM actividad
WHERE nivel = 5
UNION
SELECT monitor_id
FROM especialista E
    JOIN actividad A ON A.actividad_id = E.actividad_id
WHERE A.nivel = 2;


