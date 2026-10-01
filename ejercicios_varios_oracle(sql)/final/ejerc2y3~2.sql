
--(Bases de Datos I)
--Curso acad�mico (2024/25) y convocatoria (enero).
--(P3. Definici�n y modificaci�n de datos en SQL).
-- fichero bd1-p3-revistas-esquema.sql
-- �?ngel Gonzalez De Santos y Víctor Sigüenza Torres

-- EJERCICIO 2. Modificar valores de una columna
--------------------------------------------------------------------------------------

-- a)
SELECT C.freelance, F.nombre, C.revista, C.pago_articulo
FROM freelance F JOIN (SELECT C1.freelance, C1.revista, C1.pago_articulo
                        FROM colaboracion C1 
                        JOIN (SELECT freelance, COUNT(*)
                                FROM colaboracion
                                GROUP BY freelance
                                HAVING COUNT(*) > 2) C2 ON C1.freelance = C2.freelance) 
                                    C ON F.DNI = C.freelance
ORDER BY DNI;                                    

-- b)
UPDATE colaboracion
SET pago_articulo = pago_articulo * 1.03
WHERE freelance IN (SELECT C.freelance
                FROM freelance F JOIN (SELECT C1.freelance, C1.revista, C1.pago_articulo
                        FROM colaboracion C1 
                        JOIN (SELECT freelance, COUNT(*)
                                FROM colaboracion
                                GROUP BY freelance
                                HAVING COUNT(*) > 2) C2 ON C1.freelance = C2.freelance) 
                                    C ON F.DNI = C.freelance);
                                    
SELECT C.freelance, F.nombre, C.revista, C.pago_articulo
FROM freelance F JOIN (SELECT C1.freelance, C1.revista, C1.pago_articulo
                        FROM colaboracion C1 
                        JOIN (SELECT freelance, COUNT(*)
                                FROM colaboracion
                                GROUP BY freelance
                                HAVING COUNT(*) > 2) C2 ON C1.freelance = C2.freelance) 
                                    C ON F.DNI = C.freelance
ORDER BY DNI;   

-- c)
ROLLBACK;
SELECT C.freelance, F.nombre, C.revista, C.pago_articulo
FROM freelance F JOIN (SELECT C1.freelance, C1.revista, C1.pago_articulo
                        FROM colaboracion C1 
                        JOIN (SELECT freelance, COUNT(*)
                                FROM colaboracion
                                GROUP BY freelance
                                HAVING COUNT(*) > 2) C2 ON C1.freelance = C2.freelance) 
                                    C ON F.DNI = C.freelance
ORDER BY DNI;


-- EJERCICIO 3. Modificar el valor de una clave primaria 
--------------------------------------------------------------------------------------

-- a)
ALTER TABLE revista 
    DISABLE CONSTRAINT revista_fk_coordinador;
ALTER TABLE contratado 
    DISABLE CONSTRAINT contratado_fk_contratado;
ALTER TABLE articulo 
    DISABLE CONSTRAINT articulo_fk_contratado;

UPDATE contratado
SET DNI = '99001122P'
WHERE DNI = '11223344P';
UPDATE contratado
SET tutor = '99001122P'
WHERE tutor = '11223344P';
UPDATE revista
SET coordinador = '99001122P'
WHERE coordinador = '11223344P';
UPDATE ARTICULO 
SET contratado = '99001122P'
WHERE contratado = '11223344P';

ALTER TABLE revista 
    ENABLE CONSTRAINT revista_fk_coordinador;
ALTER TABLE contratado 
    ENABLE CONSTRAINT contratado_fk_contratado;
ALTER TABLE articulo 
    ENABLE CONSTRAINT articulo_fk_contratado;

SELECT *
FROM contratado
WHERE DNI = '99001122P' or tutor = '99001122P';

SELECT *
FROM revista
WHERE coordinador = '99001122P';

SELECT *
FROM articulo
WHERE contratado = '99001122P';

-- b)
COMMIT;