--54
select actividad_id
from especialista
having count(*) = (select max(count(*))
                    from especialista
                    group by actividad_id)
group by actividad_id;

--55
select actividad_id, count(*) cuantas_sesiones
from sesion
having count(*) = (select max(count(*))
                            from sesion
                            group by actividad_id)
group by actividad_id;

--56
select dni, nombre, salario
from monitor
where dni in (select monitor_id
                from sesion
                having count(*) = (select min(count(*))
                                    from sesion
                                    group by monitor_id)
                group by monitor_id);

--57
select instalacion_id, nombre, m2
from instalacion
where instalacion_id in (select instalacion_id
                            from actividad
                            having count(*) = (select max(count(*)) 
                                                from actividad
                                                group by instalacion_id)
                            group by instalacion_id);

--58
select nombre, precio
from actividad
where actividad_id in (select actividad_id
                        from sesion
                        having count(*) in (select min(count(*))
                                            from sesion
                                            group by actividad_id)
                        group by actividad_id)
order by nombre;

--59
select nombre, nivel, precio
from actividad
where responsable in (select dni
                        from monitor
                        where (sysdate - fcontrato) in (select max(sysdate - fcontrato)
                                                        from monitor))
and actividad_id in (select  actividad_id
                        from sesion
                        having count(*) > 2
                        group by actividad_id)
order by nombre;

--60
select monitor_id, count(*) sesiones_exteriores
from sesion
where actividad_id in(select actividad_id
                        from actividad
                        where instalacion_id in (select instalacion_id
                                                    from instalacion
                                                    where tipo = 'Exterior'))
having count(*) in (select round(avg(count(*)),0)
                    from sesion
                    group by monitor_id)
group by monitor_id;

--61
select distinct E.actividad_id, nombre_actividad, nombre_responsable
from especialista E
    join (select actividad_id, nombre nombre_actividad, nombre_responsable
            from actividad A
                join (select dni, nombre nombre_responsable
                        from monitor) M 
                on M.dni = A.responsable)A
    on A.actividad_id = E.actividad_id
where E.actividad_id in (select actividad_id
                            from especialista
                            having count(*) in (select max(count(*))
                                                from especialista
                                                group by actividad_id)
                            group by actividad_id);

--62
select nombre_monitor, nombre_actividad, count(*) sesiones_martes
from sesion S
    join (select dni, nombre nombre_monitor
            from monitor
            where salario in (select min(salario)
                                from monitor)) M
    on M.dni = S.monitor_id
    join (select actividad_id, nombre nombre_actividad
            from actividad) A
    on S.actividad_id = A.actividad_id
where diasemana = 'M'
group by nombre_monitor, nombre_actividad;

--63
select dni, nombre, count(*) cuantas_sesiones
from sesion S
join (select dni, nombre
        from monitor
        where dni in (select monitor_id
                        from sesion)) M
on M.dni = S.monitor_id
group by dni, nombre
order by nombre;

--64
select actividad_id, nombre, count(*) cuantas_sesiones
from sesion S
join (select nombre, actividad_id actividad_id2
        from actividad
        where actividad_id in (select actividad_id
                                from sesion)) A
on A.actividad_id2 = S.actividad_id
group by actividad_id, nombre
order by actividad_id;

--65
select nombre_monitor, nombre_actividad
from sesion S
    join (select nombre nombre_monitor, dni
            from monitor) M
    on M.dni = S.monitor_id
    join (select nombre nombre_actividad, actividad_id
            from actividad
            where nivel in ('4', '5')) A
    on S.actividad_id = A.actividad_id
where diasemana = 'M' and hora > 16;

--66
select nombre, responsable, count(*) cuantas_sesiones
from sesion S
join (select nombre, actividad_id, responsable
        from actividad
        where instalacion_id in (select instalacion_id
                                    from instalacion
                                    where tipo = 'Interior')) A
on S.actividad_id = A.actividad_id
group by nombre, responsable;

--67
select E.actividad_id, nombre, count(*) cuantos_especialistas
from especialista E
join (select actividad_id, nombre
        from actividad) A
on E.actividad_id = A.actividad_id
having count(*) in (select max(count(*)) 
                    from especialista
                    group by actividad_id)
group by E.actividad_id, nombre;

--68
select S.actividad_id, nombre, count(*) cuantas_sesiones
from sesion S
    join (select actividad_id, nombre
            from actividad
            having count(*) = (select max(count(*))
                                from sesion
                                group by actividad_id)
            group by actividad_id, nombre) A
    on S.actividad_id = A.actividad_id
;

--69

select nombre, coalesce(activ3,0) activ3, coalesce( activ5, 0) activ5
from instalacion I
    left join (select instalacion_id, count(*) activ3
            from actividad
            where nivel = 3
            group by instalacion_id) A1
    on I.instalacion_id = A1.instalacion_id
    left join (select instalacion_id, count(*) activ5
            from actividad
            where nivel = 5
            group by instalacion_id) A2
    on I.instalacion_id = A2.instalacion_id
order by I.instalacion_id;

--70
select nombre, coalesce(n_responsable, 0) n_responsable, coalesce(n_especialista,0) n_respecialista, coalesce(n_sesiones, 0) n_sesiones
from monitor M
    left join (select responsable, count(*) n_responsable
                from actividad
                group by responsable) A
    on M.dni = A.responsable
    left join (select monitor_id, count(*) n_especialista
                from especialista
                group by monitor_id) E
    on M.dni = E.monitor_id
    left join (select monitor_id, count(*) n_sesiones
                from sesion
                group by monitor_id) S
    on M.dni = S.monitor_id
order by nombre;

--71
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

--72
select nombre, m2
from instalacion I
where instalacion_id in (select instalacion_id
                        from actividad
                        where actividad_id in (select actividad_id
                                                from sesion
                                                where hora> = 15
                                                INTERSECT
                                                select actividad_id
                                                from sesion
                                                where hora < 13.30))
order by nombre ASC;

--73
select nombre_monitor, nombre_actividad, count(*) sesiones
from sesion S 
join( select nombre nombre_monitor, dni
        from monitor) M
on M.dni = S.monitor_id
join (select nombre nombre_actividad, actividad_id
        from actividad) A
on A.actividad_id = S.actividad_id
having count(*) = (select max(count(*)) sesiones
                    from sesion
                    group by monitor_id, actividad_id)
group by nombre_monitor, nombre_actividad;

--74
select nombre, cuantos_especialistas, cuantas_sesiones
from actividad A
    join (select actividad_id, count(*) cuantos_especialistas
            from especialista
            group by actividad_id) E
    on A.actividad_id = E.actividad_id
    join (select actividad_id, count(*) cuantas_sesiones
            from sesion
            having count (*) = (select min(count(*))
                                from sesion
                                group by actividad_id)
            group by actividad_id) S
    on A.actividad_id = S.actividad_id
order by nombre;

--75
select nombre, coalesce(cuantas_sesiones, 0) cuantas_sesiones
from instalacion I
    left join (select count(*) cuantas_sesiones, instalacion_id
            from sesion S
                join ( select actividad_id, instalacion_id
                        from actividad) A
                on S.actividad_id = A.actividad_id
            group by instalacion_id) S
    on I.instalacion_id = S.instalacion_id
order by nombre;

--76
select distinct nombre, coalesce(cuantas_sesiones, 0) cuantas_sesiones, coalesce(cuantas_actividades, 0) cuantas_actividades
from instalacion I
    left join (select count(*) cuantas_sesiones, instalacion_id
                from sesion S
                    join ( select actividad_id, instalacion_id
                            from actividad) A
                    on S.actividad_id = A.actividad_id
                group by instalacion_id) S
    on I.instalacion_id = S.instalacion_id
    left join (select count(*) cuantas_actividades, instalacion_id
                from actividad A
                    join (select dni
                            from monitor
                            where extract(year from fcontrato) > 2015) M
                    on A.responsable = M.dni
                group by instalacion_id) A
    on I.instalacion_id = A.instalacion_id
order by nombre;

--77
select nombre, actividades_especialistas, actividades_impartidas
from monitor M
    join(select count(*) actividades_especialistas, monitor_id
            from especialista
            group by monitor_id) E
    on M.dni = E.monitor_id
    join (select count(distinct actividad_id) actividades_impartidas, monitor_id
            from sesion
            group by monitor_id) S
    on M.dni = S.monitor_id
where actividades_especialistas = 2*actividades_impartidas
order by nombre;

--78
select nombre, sesiones_lx, sesiones_mj
from actividad A
    join (select count(*) sesiones_lx, actividad_id
            from sesion
            where diasemana in ('L', 'X')
            group by actividad_id) S1
    on A.actividad_id = S1.actividad_id
    join (select count(*) sesiones_mj, actividad_id
            from sesion
            where diasemana in ('M', 'J')
            group by actividad_id) S2
    on a.actividad_id = S2.actividad_id
where sesiones_lx > sesiones_mj
order by nombre;

--79
select nombre, monitores_especialistas, monitores_sesiones
from actividad A
    join (select actividad_id, count(distinct monitor_id) monitores_especialistas
            from especialista
            group by actividad_id) E
    on A.actividad_id = E.actividad_id
    join (select actividad_id, count(distinct monitor_id) monitores_sesiones
            from sesion
            group by actividad_id) S
    on A.actividad_id = S.actividad_id
where monitores_especialistas = 4*monitores_sesiones
order by nombre;

--80
select nombre, cuantos_especialistas, A.responsable, activ_responsable
from actividad A
    join (select actividad_id
            from sesion
            having count(distinct monitor_id) > 1
            group by actividad_id) S
    on A.actividad_id = S.actividad_id
    join (select responsable, count(*) activ_responsable
            from actividad
            group by responsable) A2
    on A2.responsable = A.responsable
    join (select actividad_id, count(*) cuantos_especialistas
            from especialista
            group by actividad_id) E
    on A.actividad_id = E.actividad_id;




