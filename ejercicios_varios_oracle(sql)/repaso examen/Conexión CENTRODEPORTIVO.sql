--1
SELECT nombre, telefono, salario
FROM  monitor
WHERE salario > 1200;

--2
SELECT nombre, responsable, nivel
FROM actividad
WHERE nivel < 4
order by responsable;

--3
SELECT instalacion_id
FROM instalacion
WHERE instalacion_id IN (SELECT instalacion_id
                        FROM actividad
                        WHERE (nivel = 3) AND precio < 10)
ORDER by instalacion_id DESC;

--4
SELECT actividad_id, diasemana, hora
FROM sesion
where ((diasemana = 'S') AND (hora > '9') AND (hora < '11,3')) OR diasemana = 'L'
order by diasemana, hora;

--5
SELECT nombre, telefono, TO_CHAR(TO_DATE(EXTRACT(Month FROM fcontrato), 'mm'), 'Month') mes_contrato
FROM monitor
WHERE nombre LIKE '%cia';

--6
SELECT actividad_id, diasemana ||' '|| hora dia_hora, monitor_id
FROM sesion
WHERE diasemana IN ('J', 'M') AND hora < 19
order by dia_hora;

--7
SELECT actividad_id, precio, precio*0.93 nuevo_precio
FROM actividad
WHERE nivel = 5 AND precio > 12
order by actividad_id;

--8
SELECT dni, nombre, salario, ROUND((SYSDATE - fcontrato)/365, 1) experiencia
FROM monitor
WHERE  ROUND(SYSDATE - fcontrato, 1)/365 > 15;

--9
SELECT actividad_id, hora, monitor_id
FROM sesion
WHERE diasemana = 'V' AND actividad_id IN ('A02', 'A05', 'A09', 'A19')
order by monitor_id;

--10 
SELECT  Distinct instalacion_id
FROM actividad
WHERE nivel IN ('1', '2')
order by instalacion_id ASC;

--11 
SELECT nombre_actividad, nombre nombre_instalacion, m2
FROM  instalacion I
JOIN (SELECT nombre nombre_actividad, instalacion_id
        FROM actividad
        WHERE nombre IN ('Pilates', 'Balonmano')) A
        ON A.instalacion_id = I.instalacion_id;

--12
SELECT actividad_id, hora,nombre_monitor
FROM sesion S
JOIN (SELECT nombre nombre_monitor, dni
        FROM monitor) M
        ON M.dni = S.monitor_id
WHERE diasemana = 'V' AND hora > 15 AND actividad_id IN ('A02', 'A05', 'A09', 'A19')
order by hora;

--13
SELECT nombre nombre_actividad, precio, nivel, nombre_instalacion
FROM actividad A
JOIN (SELECT nombre nombre_instalacion, instalacion_id
        FROM instalacion
        WHERE tipo = 'Exterior')
        I ON I.instalacion_id = A.instalacion_id
order by nombre;

--14
SELECT Distinct nombre_monitor, nombre_actividad
FROM sesion S
JOIN (SELECT nombre nombre_monitor, dni
        FROM monitor) M
        ON M.dni = S.monitor_id
JOIN (SELECT nombre nombre_actividad, actividad_id
        FROM actividad
        WHERE nivel IN ('4', '5')) A
        ON A.actividad_id = S.actividad_id
WHERE hora >= 19;

--15
SELECT Distinct tipo, nombre_actividad, nivel, diasemana
FROM sesion S
JOIN (SELECT actividad_id, nombre nombre_actividad, nivel, instalacion_id
        FROM actividad)
        A ON A.actividad_id = S.actividad_id
JOIN (SELECT instalacion_id, tipo
        FROM instalacion)
        I ON I.instalacion_id = A.instalacion_id
WHERE diasemana IN ('V', 'S')
order by diasemana, nivel DESC;

--16 
SELECT nombre_monitor, nombre_actividad
FROM especialista E
JOIN (SELECT nombre nombre_actividad, actividad_id
        FROM actividad)
        A ON A.actividad_id = E.actividad_id
JOIN (SELECT nombre nombre_monitor, dni
        FROM monitor)
        M ON M.dni = E.monitor_id
order by nombre_monitor;

--17
SELECT nombre nombre_instalacion, tipo, nombre_monitor
FROM instalacion I
JOIN (SELECT actividad_id, responsable, instalacion_id
        FROM actividad
        WHERE nombre IN ('Yoga', 'Body combat', 'Hapkido')) A
        ON A.instalacion_id = I.instalacion_id
JOIN (SELECT nombre nombre_monitor, dni
        FROM monitor) M
        ON M.dni = A.responsable
order by nombre;

--18
SELECT diasemana, hora, nombre_actividad, nombre_monitor
FROM sesion S
JOIN (SELECT nombre nombre_actividad, actividad_id
        FROM actividad) A
        ON A.actividad_id = S.actividad_id
JOIN (SELECT nombre nombre_monitor, dni
        FROM monitor) M
        ON M.dni = S.monitor_id
WHERE diasemana IN ('L', 'X')
order by diasemana, hora, nombre_actividad;

--19
SELECT diasemana, hora, nombre_actividad, nombre_responsable
FROM sesion S
JOIN (SELECT nombre nombre_actividad, responsable, actividad_id
        FROM actividad) A
        ON A.actividad_id = S.actividad_id
JOIN (SELECT nombre nombre_responsable, dni
        FROM monitor) M
        ON A.responsable = M.dni
WHERE monitor_id IN (SELECT dni
                        FROM monitor
                        WHERE nombre = 'Belinda');

--20
SELECT COALESCE(nombre, '···') nombre_actividad, nombre_responsable
FROM actividad A
RIGHT JOIN (SELECT nombre nombre_responsable, dni
            FROM monitor) M
            ON A.responsable = M.dni
order by nombre_responsable;
            
--21
SELECT nombre nombre_instalacion, COALESCE(nombre_actividad, '----')
FROM instalacion I
LEFT JOIN (SELECT nombre nombre_actividad, instalacion_id
            FROM actividad) A
            ON I.instalacion_id = A.instalacion_id
order by nombre;

--22
SELECT dni monitor_id
FROM monitor
WHERE dni IN (SELECT monitor_id
                FROM sesion)
MINUS 
SELECT dni monitor_id
FROM monitor
WHERE dni IN (SELECT responsable
                FROM actividad);

--23
SELECT dni responsable
FROM monitor
WHERE dni IN (SELECT responsable
                FROM actividad
                WHERE nivel = 5)
UNION
SELECT dni responsable
FROM monitor
WHERE dni IN (SELECT monitor_id
                FROM especialista
                WHERE actividad_id IN (SELECT actividad_id
                                        FROM actividad
                                        WHERE nivel = 2));

--24
SELECT actividad_id
FROM actividad
WHERE instalacion_id IN (SELECT instalacion_id
                            FROM instalacion
                            WHERE tipo = 'Exterior')
INTERSECT
SELECT actividad_id
FROM actividad
WHERE actividad_id IN (SELECT actividad_id
                        FROM sesion
                        WHERE diasemana = 'V');

--25
SELECT dni
FROM monitor
WHERE ROUND((SYSDATE - fcontrato)/365, 1) > 12
INTERSECT
SELECT dni
FROM monitor
WHERE dni IN (SELECT monitor_id
                FROM sesion)
MINUS
SELECT dni
FROM monitor
WHERE dni IN(SELECT monitor_id
            FROM sesion
            WHERE hora <= 16);








