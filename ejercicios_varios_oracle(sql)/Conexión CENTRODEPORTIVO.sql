-- ejercicio 54
SELECT actividad_id
FROM especialista
GROUP BY actividad_id
HAVING COUNT(*) =
(SELECT MAX(COUNT(*))
FROM especialista
GROUP BY actividad_id
)
;

-- ejercicio 55
SELECT actividad_id, COUNT(*) cuantas_sesiones
FROM sesion
GROUP BY actividad_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM sesion
                    GROUP BY actividad_id);
                    
-- ejercicio 56
SELECT dni, nombre, salario
FROM monitor
WHERE dni IN (SELECT monitor_id
              FROM sesion 
              GROUP BY monitor_id
              HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                                 FROM sesion 
                                 GROUP BY monitor_id));      

--ejercicio 57
SELECT I.instalacion_id, I.nombre, I.m2
FROM instalacion I
JOIN (SELECT instalacion_id
        FROM actividad
        GROUP BY instalacion_id
        HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                            FROM actividad
                            GROUP BY instalacion_id))
I_bn ON I.instalacion_id = I_bn.instalacion_id
order by instalacion_id;

-- ejercicio 58
SELECT nombre, precio
FROM actividad
WHERE actividad_id IN (SELECT actividad_id
                        FROM sesion
                        GROUP BY actividad_id
                        HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                                            FROM sesion
                                            GROUP BY actividad_id))
order by nombre;

-- ejercicio 59
SELECT nombre, nivel, precio
FROM actividad A
JOIN (SELECT dni
        FROM monitor
        WHERE (2024 - EXTRACT(YEAR FROM fcontrato)) = (SELECT MAX(2024 - EXTRACT(YEAR FROM fcontrato))
                                                        FROM monitor) ) M
ON A.responsable = M.dni
JOIN (SELECT actividad_id
        FROM sesion
        GROUP BY actividad_id
        HAVING COUNT(diasemana) > 2)
S ON S.actividad_id = A.actividad_id
order by nombre;

-- ejercicio 60
SELECT monitor_id, COUNT(*) sesiones_exteriores
FROM sesion
WHERE actividad_id IN (SELECT actividad_id
                       FROM actividad
                       WHERE instalacion_id IN (SELECT instalacion_id
                                                FROM instalacion
                                                WHERE tipo = 'Exterior'))
GROUP BY monitor_id
HAVING COUNT(*) = (SELECT ROUND(AVG(COUNT(*)), 0)
                   FROM sesion
                   GROUP BY monitor_id);

                                

-- ejercicio 61
SELECT actividad_id, A.nombre nombre_actividad, M.nombre nombre_responsable
FROM actividad A
JOIN monitor M ON A.responsable = M.dni
WHERE actividad_id IN(SELECT actividad_id
                        FROM especialista
                        GROUP BY actividad_id
                        HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                            FROM especialista
                                            GROUP BY actividad_id));

-- ejercicio 62
SELECT M.nombre nombre_monitor, A.nombre nombre_actividad, sesiones_martes
FROM actividad A
    JOIN (SELECT dni, nombre
            FROM monitor
            WHERE salario = (SELECT MIN(salario)
                                FROM monitor)) M
    ON A.responsable = M.dni
    JOIN (SELECT diasemana, actividad_id, COUNT(*) sesiones_martes
            FROM sesion
            GROUP BY actividad_id) S
    ON A.actividad_id = S.actividad_id
WHERE S.diasemana = 'M'
;




--ejercicio 63
SELECT dni, nombre, cuantas_sesiones
FROM monitor
JOIN (SELECT monitor_id,COUNT(*) cuantas_sesiones 
        FROM sesion
        GROUP BY monitor_id)
        ON dni = monitor_id
order by nombre;

-- ejercicio 64
SELECT A.actividad_id, nombre, cuantas_sesiones
FROM actividad A
JOIN (SELECT actividad_id, COUNT(*) cuantas_sesiones
        FROM sesion 
        GROUP BY actividad_id) S
        ON S.actividad_id = A.actividad_id
order by A.actividad_id;

-- ejercicio 65
SELECT M.nombre nombre_monitor, A.nombre nombre_actividad
FROM monitor M
     JOIN (SELECT monitor_id, actividad_id 
           FROM sesion
           WHERE diasemana = 'M'
             AND hora >= 16.00) S
       ON M.dni = S.monitor_id
     JOIN (SELECT actividad_id, nombre 
           FROM actividad 
           WHERE nivel IN (4,5)) A
       ON S.actividad_id = A.actividad_id
ORDER BY M.nombre;

-- ejercicio 66
SELECT nombre, responsable, cuantas_sesiones
FROM actividad A
    JOIN (SELECT actividad_id, monitor_id, COUNT(*) cuantas_sesiones
            FROM sesion
            GROUP BY actividad_id, monitor_id)
    S ON A.actividad_id = S.actividad_id
    WHERE A.responsable = S.monitor_id AND A.instalacion_id IN (SELECT instalacion_id
                                FROM instalacion
                                WHERE tipo ='Interior');

-- ejercicio 67
SELECT A.actividad_id, nombre, cuantos_especialistas
FROM actividad A
JOIN (SELECT actividad_id, COUNT(*) cuantos_especialistas
        FROM especialista
        GROUP BY actividad_id
        HAVING COUNT (*) = (SELECT MAX(COUNT(*))
                            FROM especialista
                            GROUP BY actividad_id))
        E ON A.actividad_id = E.actividad_id;

-- ejercicio 71
SELECT nombre, nivel
FROM actividad
INTERSECT
SELECT nombre, nivel
FROM actividad A
JOIN (SELECT actividad_id
        FROM especialista
        GROUP BY actividad_id
        HAVING COUNT(*) = (SELECT COUNT(nombre)
                            FROM monitor))
E ON A.actividad_id = E.actividad_id;
    
-- ejercicio 72
SELECT  nombre, m2
FROM instalacion 
WHERE instalacion_id IN (SELECT instalacion_id
                            FROM actividad
                            WHERE actividad_id IN (SELECT actividad_id
                                                    FROM sesion
                                                    WHERE hora < 13.30
                                                    INTERSECT
                                                  SELECT actividad_id
                                                    FROM sesion
                                                    WHERE hora >= 15.00));
    
-- ejercicio 73
SELECT M.nombre nombre_monitor, A.nombre nombre_actividad, sesiones
FROM monitor M
JOIN (SELECT actividad_id, monitor_id, COUNT(*) sesiones
        FROM sesion
        GROUP BY monitor_id, actividad_id
        HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                            FROM sesion
                            GROUP BY monitor_id, actividad_id)
        ) S
JOIN actividad A ON A.actividad_id = S.actividad_id
ON M.dni = S.monitor_id;
        
-- ejercicio 74
SELECT nombre, cuantos_especialistas, cuantas_sesiones
FROM actividad A
     JOIN (SELECT actividad_id, COUNT(*) cuantos_especialistas
           FROM especialista
           GROUP BY actividad_id) E
       ON A.actividad_id = E.actividad_id
     JOIN (SELECT actividad_id, COUNT(*) cuantas_sesiones
           FROM sesion
           GROUP BY actividad_id
           HAVING COUNT(*) =  (SELECT MIN(COUNT(*))
                               FROM sesion
                               GROUP BY actividad_id)) S
       ON A.actividad_id = S.actividad_id
ORDER BY nombre;

-- ejercicio 75
SELECT nombre, COALESCE(cuantas_sesiones,0) cuantas_sesiones
FROM instalacion I
     LEFT JOIN (SELECT instalacion_id, COUNT(*) cuantas_sesiones
                FROM sesion S JOIN actividad A
                              ON S.actividad_id = A.actividad_id
                GROUP BY instalacion_id) SA
     ON I.instalacion_id = SA.instalacion_id
ORDER BY nombre;



-- Q7
SELECT nombre, nivel, precio, cuantas_sesiones
FROM actividad A
    JOIN (SELECT actividad_id, COUNT(*) cuantas_sesiones
            FROM sesion S
            GROUP BY actividad_id
            HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                FROM sesion
                                GROUP BY actividad_id)) S
    ON A.actividad_id = S.actividad_id
order by nombre;



-- Q8
SELECT M.nombre, M.fcontrato
FROM monitor M
WHERE NOT EXISTS (SELECT A.actividad_id
                  FROM actividad A
                  WHERE NOT EXISTS (SELECT E.monitor_id
                                     FROM especialista E
                                     WHERE E.monitor_id = M.dni
                                     AND E.actividad_id = A.actividad_id));

-- Q9
--Parte 1
SELECT I.nombre, COALESCE(ROUND(AVG(A.precio), 2), -1) media_precio
FROM instalacion I 
    LEFT JOIN actividad A ON I.instalacion_id = A.instalacion_id
GROUP BY I.nombre
ORDER BY I.nombre DESC;

--Parte 2
SELECT nombre, COALESCE(ROUND(media_precio, 2), -1) media_precio, COALESCE(ROUND(cuantas_actividades, 2), 0) cuantas_actividades
FROM instalacion I
    LEFT JOIN(SELECT A.instalacion_id,  AVG(a.precio) media_precio
                FROM actividad A
                GROUP BY A.instalacion_id) A1
    ON I.instalacion_id = A1.instalacion_id
    LEFT JOIN(SELECT A.instalacion_id, COUNT(*) cuantas_actividades
                FROM actividad A
                WHERE A.actividad_id IN (SELECT S.actividad_id
                                            FROM sesion S
                                            WHERE S.monitor_id = A.responsable)
                GROUP BY A.instalacion_id) A2
    ON I.instalacion_id = A2.instalacion_id               
ORDER BY nombre DESC;












                    
    
    