-- Angel Gonzalez de Santos y Victor Siguenza Torres

-- 4.

-- a) Elimina los artículos cuya publicación haya sido anterior al 31 de diciembre de 2023, y estén
-- escritos por un periodista contratado no coordinador de revista.
-- Antes de redactar el DELETE, te ayudará redactar una SELECT que muestre los artículos que se
-- desea eliminar. Son 5 artículos, por cierto.

select *
from articulo A
JOIN contratado C ON A.contratado = C.dni
JOIN numero N ON A.numero = N.numero
WHERE N.fecha < TO_DATE ( '31-12-2023', 'DD-MM-YYYY') AND
A.contratado NOT IN (select coordinador
                    from revista) AND C.revista = N.revista;

DELETE FROM articulo A
where A.idart IN(
select A.idart
from articulo A
JOIN contratado C ON A.contratado = C.dni
JOIN numero N ON A.numero = N.numero
WHERE N.fecha < TO_DATE ( '31-12-2023', 'DD-MM-YYYY') AND
A.contratado NOT IN (select coordinador
                    from revista) AND C.revista = N.revista);
                    
-- b)
COMMIT;

-- 5. ELIMINAR FILAS

ALTER TABLE revista
DISABLE CONSTRAINT revista_fk_coordinador;

delete from colaboracion
where revista = 'R01';

DELETE FROM articulo
where revista = 'R01';

DELETE FROM contratado
where revista = 'R01';

DELETE FROM numero
where revista = 'R01';


DELETE FROM revista
where idrev = 'R01';

ALTER TABLE revista
ENABLE CONSTRAINT revista_fk_coordinador;

COMMIT;


-- 6.
-- a) Elimina, una a una, las columnas que contienen la web y la periodicidad de las revistas.
ALTER TABLE revista
DROP COLUMN web;

ALTER TABLE revista
DROP COLUMN periodicidad;

-- b)
-- SI, podríamos hacer:
-- ALTER TABLE revista
-- DROP (web, periodicidad);

-- Para eliminar dos columnas a la ve, empleamos el DROP.

-- 7. 
--a)
CREATE VIEW contrato
    AS SELECT R.nombre revista, C.nombre periodista, C.sueldo, C.fecha_contrato contrato, ROUND((SYSDATE - C.fecha_contrato)/365,1) annos, COALESCE(articulos,0) articulos
        FROM contratado C
            JOIN revista R ON C.revista = R.idrev
            LEFT JOIN (SELECT COUNT(*) articulos, contratado
                    FROM articulo
                    GROUP BY contratado) A ON C.dni = A.contratado;
    
--b)        
SELECT *
FROM contrato
order by revista, periodista;

-- c)

CREATE OR REPLACE VIEW contrato
    AS SELECT R.nombre revista, C.nombre periodista, C.sueldo*0.79 sueldo, ROUND((SYSDATE - C.fecha_contrato)/365,1) annos, COALESCE(articulos,0) articulos
        FROM contratado C
            JOIN revista R ON C.revista = R.idrev
            LEFT JOIN (SELECT COUNT(*) articulos, contratado
                    FROM articulo
                    GROUP BY contratado) A ON C.dni = A.contratado;
                    
                    
    
-- d)
INSERT INTO 
 CONTRATADO (DNI, nombre, email, sueldo, revista, fecha_contrato, tutor) 
 VALUES ('33478566M', 'MAMEN MENDI', 'mmendi@mail.com', 2300, 'R03', 
         TO_DATE('20/05/2018', 'dd/mm/yyyy'), NULL);

-- e)
SELECT *
FROM contrato
order by revista, periodista;
-- La representación de la tabla contrato, tras insertar el contratado, nos muestra el nuevo contratado, con una reducción del 21% sobre su sueldo.


-- 8.
SELECT *
FROM revista R
WHERE R.coordinador NOT IN(SELECT C.dni
                        FROM contratado C
                        WHERE C.revista = R.idrev);

-- 9.

SELECT C.nombre periodista, R.nombre revista, C.sueldo
FROM CONTRATADO C
    JOIN REVISTA R ON C.revista = R.idrev
WHERE C.sueldo = (SELECT MAX(sueldo)
                    FROM CONTRATADO CC
                    WHERE CC.revista = C.revista);

--a)
-- El primer valor de la columna COST es 11

--b)
CREATE INDEX idx_contratado_revista ON CONTRATADO(revista);

--c)
SELECT C.nombre periodista, R.nombre revista, C.sueldo
FROM CONTRATADO C
    JOIN REVISTA R ON C.revista = R.idrev
WHERE C.sueldo = (SELECT MAX(sueldo)
                    FROM CONTRATADO CC
                    WHERE CC.revista = C.revista);
-- Efectivamente ha utilizado el índice que hemos creado en el apartado b
-- El nuevo valor de COST es 8, por lo que ha disminuido mejorandose respecto de la ejecución anterior