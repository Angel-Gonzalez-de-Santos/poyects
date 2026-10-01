-- Q1.

-- TRUCO: 
-- 1: QUÉ TABLAS NECESITAS, 
-- 2: CÓMO LAS RELACIONO,
-- 3: HACER FILTROS EN EL WHERE, 
-- 4: SELECT ESTABLECER LAS COLUMNOS CORRECTAS

-- Q1.
select I.nombre nombre_instalacion, A.nombre nombre_actividad, M.nombre nombre_responsable
from actividad A
JOIN instalacion I ON A.instalacion_id = I.instalacion_id
JOIN monitor M ON A.responsable = M.dni
WHERE (I.m2 between 400 and 1500) AND
A.precio < 10 AND M.salario > 1000
order by A.nombre

-- Q2. VER LO DE RIGHT O LEFT
select I.nombre nombre_instalacion, COALESCE(A.nombre, '***') nombre_actividad, COALESCE(M.nombre, '###') nombre_responsable
from actividad A
RIGHT JOIN monitor M ON A.responsable = M.dni
RIGHT JOIN instalacion I ON A.instalacion_id = I.instalacion_id
order by I.nombre, A.nombre

-- Q3. OPERADORES CONJUNTOS
select M.nombre, M.telefono
from actividad A
JOIN monitor M ON A.responsable = M.dni
WHERE A.nivel IN ('4')
UNION
select M.nombre, M.telefono
from sesion S
JOIN monitor M ON S.monitor_id = M.dni
JOIN actividad A ON A.actividad_id = S.actividad_id -- EL ORDEN PUEDE CAMBIAR ENTRE ON *** = *** 
WHERE A.nivel IN ('5')
order by Telefono

-- ejercicio 26
SELECT I.instalacion_id, I.nombre, I.tipo
FROM instalacion I
MINUS
SELECT I.instalacion_id, I.nombre, I.tipo
FROM instalacion I
    JOIN actividad A ON I.instalacion_id = A.instalacion_id;
    
-- ejercicio 27
SELECT M.dni, M.nombre, TO_CHAR(fcontrato, 'dd/month/yyyy')
FROM monitor M
MINUS
SELECT M.dni, M.nombre, TO_CHAR(fcontrato, 'dd/month/yyyy')
FROM monitor M
    JOIN actividad A ON M.dni = A.responsable
order by (TO_DATE(fcontrato, 'dd/mm/yyyy')) ;

-- ejercicio 28
SELECT M.dni, M.nombre
FROM monitor M
    JOIN actividad A ON M.dni = A.responsable
    JOIN instalacion I ON A.instalacion_id = I.instalacion_id
WHERE A.nivel < 4 AND 50 < I.m2  AND I.m2 < 200;

-- ejercicio 29
SELECT distinct M.nombre 
FROM monitor M
    JOIN sesion S ON M.dni = S.monitor_id
    JOIN actividad A ON M.dni = A.responsable
WHERE S.hora > 16 AND S.diasemana = 'M' AND A.nivel > 3;

-- ejercicio 30
SELECT nombre, tipo
FROM instalacion
WHERE instalacion_id IN (SELECT instalacion_id
                        FROM actividad
                        WHERE nivel < 3) AND instalacion_id NOT IN
                        (SELECT instalacion_id
                        FROM actividad
                        WHERE nivel >2);

-- ejercicio 32
SELECT distinct M.nombre
FROM monitor M
JOIN actividad A ON M.dni = A.responsable
WHERE A.actividad_id NOT IN(SELECT S.actividad_id
                            FROM sesion S
                            WHERE S.monitor_id = A.responsable);

-- ejercicio 33
SELECT distinct M.nombre nombre_monitor, A.nombre nombre_actividad
FROM monitor M
JOIN actividad A ON M.dni = A.responsable
WHERE A.instalacion_id IN (SELECT I.instalacion_id
                        FROM instalacion I
                        WHERE I.m2 > 500)
order by nombre_monitor;

--ejercicio 34
SELECT nombre
FROM instalacion
WHERE instalacion_id IN (SELECT instalacion_id
                            FROM actividad
                            WHERE nivel = 3 AND responsable IN(SELECT dni
                                                                FROM monitor
                                                                WHERE EXTRACT(YEAR FROM fcontrato) < 2019 AND dni IN (SELECT monitor_id
                                                                                                                            FROM sesion
                                                            WHERE diasemana = 'S')));


-- ejercicio 35
SELECT ROUND(AVG(sesiones), 1) AS numero_medio_sesiones
FROM (
    SELECT monitor_id, COUNT(*) AS sesiones
    FROM sesion
    GROUP BY monitor_id
) ;


-- ejercicio 36
SELECT nombre, fcontrato, salario
FROM monitor
WHERE salario = (SELECT MIN(salario) FROM monitor)

;

--ejercicio 37
SELECT A.actividad_id, COUNT(M.dni) cuantos_monitores
FROM actividad A
JOIN monitor M ON A.responsable = M.dni
GROUP BY A.actividad_id
order by A.actividad_id;


-- ejercicio 38
SELECT diasemana, COUNT(*) cuantas_sesiones
FROM sesion
GROUP BY diasemana
order by cuantas_sesiones DESC;


--ejercicio 39
SELECT hora, COUNT(*) cuantas_sesiones
FROM sesion
WHERE hora < 13.5
GROUP BY hora
order by hora;

-- ejercicio 40
SELECT M.dni monitor_id
FROM monitor M
JOIN sesion S ON
WHERE M.dni IN (SELECT diasemana, COUNT(*) cuantas_sesiones
                FROM sesion S
                GROUP BY S.diasemana);





