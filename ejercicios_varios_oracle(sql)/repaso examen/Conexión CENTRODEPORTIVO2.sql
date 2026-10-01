--26
SELECT instalacion_id, nombre, tipo
FROM instalacion
WHERE instalacion_id NOT IN (SELECT instalacion_id
                                FROM actividad);

--27
SELECT dni, nombre, TO_CHAR(TO_DATE(fcontrato, 'dd/mm/yy'), 'dd/month/yyyy') fcontrato
FROM monitor
WHERE dni NOT IN (SELECT responsable
                    FROM actividad)
order by fcontrato;

--28
SELECT dni, nombre
FROM monitor
WHERE dni IN (SELECT responsable
                FROM actividad
                WHERE nivel < 4 AND instalacion_id IN (SELECT instalacion_id
                                                        FROM instalacion
                                                        WHERE m2 > 50 AND m2 < 200));

--29
SELECT nombre
FROM monitor
WHERE dni IN (SELECT monitor_id
                FROM sesion
                WHERE hora > 16 AND diasemana = 'M' AND actividad_id IN (SELECT actividad_id
                                                                            FROM actividad
                                                                            WHERE nivel IN ('4', '5')));

--30
SELECT nombre, tipo
FROM instalacion
WHERE instalacion_id IN (SELECT instalacion_id
                            FROM actividad
                            WHERE nivel IN ('1', '2')) 
AND instalacion_id NOT IN (SELECT instalacion_id
                            FROM actividad
                            WHERE nivel > 2);

--31
SELECT nombre, fcontrato
FROM monitor
WHERE dni IN (SELECT monitor_id
                FROM sesion
                WHERE (monitor_id,actividad_id) NOT IN (SELECT monitor_id, actividad_id
                                                            FROM especialista));
                                                            
--32
SELECT nombre
FROM monitor
WHERE dni IN (SELECT responsable
                    FROM actividad
                    WHERE (responsable, actividad_id) NOT IN (SELECT monitor_id, actividad_id
                                                                FROM sesion));

--33
SELECT nombre nombre_monitor, nombre_actividad
FROM monitor M
JOIN (SELECT nombre nombre_actividad, responsable
        FROM actividad
        WHERE instalacion_id IN (SELECT instalacion_id
                                    FROM instalacion
                                    WHERE m2 > 500)) A
ON M.dni = A.responsable
order by nombre;

--34
SELECT nombre
FROM instalacion
WHERE instalacion_id IN (SELECT instalacion_id
                            FROM actividad
                            WHERE nivel  = 3 AND responsable IN (SELECT dni
                                                                    FROM monitor
                                                                    WHERE EXTRACT(year from fcontrato) < 2019 AND dni IN(SELECT monitor_id
                                                                                                                            FROM sesion
                                                                                                                            WHERE diasemana = 'S')));

--35
SELECT ROUND(AVG(COUNT(*)), 1) numero_medio_sesiones
FROM sesion
GROUP BY monitor_id;

--36
SELECT nombre, fcontrato, salario
FROM monitor
WHERE salario IN (SELECT MIN(salario)
                    FROM monitor);

--37
SELECT actividad_id, COUNT(*) cuantos_monitores
FROM especialista
GROUP BY actividad_id
order by actividad_id;

--38
SELECT diasemana, COUNT(*) cuantas_sesiones
FROM sesion
GROUP BY diasemana
order by cuantas_sesiones DESC;

--39
SELECT hora, COUNT(*) cuantas_sesiones
FROM sesion
WHERE hora <= 13.3
GROUP BY hora
order by hora;

--40
SELECT monitor_id, diasemana, COUNT(*) cuantas_sesiones
FROM sesion
GROUP BY monitor_id, diasemana
order by monitor_id;

--41
select instalacion_id, count(*) cuantas_actividades
from actividad
group by instalacion_id
order by instalacion_id;

--42
select monitor_id, count(*) cuantas_sesiones
from sesion
where monitor_id in (select dni
                        from monitor
                        where salario > 950 and salario < 1500)
group by monitor_id;
                        
--43
select dni, nombre, count(*) cuantas_sesiones
from sesion S
join (select dni, nombre
        from monitor
        where dni in (select monitor_id
                        from sesion)) M
on M.dni = S.monitor_id
group by dni, nombre
order by nombre;

--44
select actividad_id, nombre, count(*) cuantas_sesiones
from sesion S
join (select nombre, actividad_id actividad_id2
        from actividad
        where actividad_id in (select actividad_id
                                from sesion)) A
on A.actividad_id2 = S.actividad_id
group by actividad_id, nombre
order by actividad_id;

--45
select instalacion_id
from actividad
group by instalacion_id
having count(*)  = 1;

--Ampliación
select instalacion_id, tipo, m2
from actividad A
join (select instalacion_id instalacion_id2, tipo, m2
        from instalacion)I
on A.instalacion_id = I.instalacion_id2
group by instalacion_id, tipo, m2
having count(*)  = 1;

--46
select nombre, nivel, precio
from actividad
where responsable in (select dni
                        from monitor
                        where nombre = 'Auspicia')
and actividad_id in (select actividad_id
                        from sesion
                        group by actividad_id
                        having count(*) > 2)
order by nombre;

--47
select nombre, fcontrato
from monitor
where dni in (select monitor_id
                from sesion
                group by monitor_id
                having count(*) > 6)
order by nombre;

--48
select diasemana
from sesion
where actividad_id in (select actividad_id
                        from actividad
                        where instalacion_id in (select instalacion_id
                                                    from instalacion
                                                    where tipo = 'Exterior'))
group by diasemana
having count(*) > 3;

--49
select dni, nombre, coalesce(cuantas_sesiones, 0)
from monitor M
left join (select monitor_id, count(*) cuantas_sesiones
        from sesion
        group by monitor_id) S
on S.monitor_id = M.dni
order by dni;
        
--50
select dni, nombre, coalesce(cuantas_actividades, 0) cuantas_actividades
from monitor M
left join (select monitor_id, count(*) cuantas_actividades
            from especialista
            group by monitor_id) E
on E.monitor_id = M.dni
order by cuantas_actividades;

--51
select I.instalacion_id, coalesce(cuantas_actividades, 0) cuantas_actividades
from instalacion I
left join (select instalacion_id, count(*) cuantas_actividades
            from actividad
            group by instalacion_id) A
on I.instalacion_id = A.instalacion_id
order by instalacion_id;

--52
select monitor_id responsable, actividad_id, count(*)cuantas_sesiones
from sesion
where (monitor_id,actividad_id) in (select responsable, actividad_id
                                    from actividad)
group by monitor_id, actividad_id
order by actividad_id;

--53
select nombre, responsable, count(*) cuantas_sesiones
from sesion S
join (select nombre, actividad_id, responsable
        from actividad
        where instalacion_id in (select instalacion_id
                                    from instalacion
                                    where tipo = 'Interior')) A
on S.actividad_id = A.actividad_id
group by nombre, responsable;






