-- Crear tabla FREELANCE
CREATE TABLE FREELANCE (
   DNI              CHAR(9)         PRIMARY KEY,
   nombre           VARCHAR2(50)    NOT NULL,
   email            VARCHAR2(100)   UNIQUE NOT NULL
);

-- Crear tabla ESPECIALIDAD_FREELANCE
CREATE TABLE ESPECIALIDAD_FREELANCE (
   freelance        CHAR(9),    
   especialidad     VARCHAR2(50)    NOT NULL,
   PRIMARY KEY (freelance, especialidad),
   FOREIGN KEY (freelance) REFERENCES FREELANCE(DNI)
      ON DELETE CASCADE
);

-- Crear tabla CONTRATADO
CREATE TABLE CONTRATADO (
   DNI              CHAR(9)         PRIMARY KEY,
   nombre           VARCHAR2(50)    NOT NULL,
   email            VARCHAR2(100)   UNIQUE NOT NULL,
   sueldo           NUMBER(9,2)     CHECK (sueldo > 0),
   fecha_contrato   DATE            NOT NULL,
   revista          CHAR(5),
   tutor            CHAR(9),
   FOREIGN KEY (tutor) REFERENCES CONTRATADO(DNI), 
   CHECK (DNI <> tutor)
);

-- Crear tabla REVISTA
CREATE TABLE REVISTA (
   idrev         CHAR(5)         PRIMARY KEY,
   nombre        VARCHAR2(50)    UNIQUE NOT NULL,
   web           VARCHAR2(100),
   tema          VARCHAR2(50)    NOT NULL,
   periodicidad  VARCHAR2(15)    CHECK (periodicidad IN ('Semanal', 'Quincenal', 'Mensual', 'Bimestral', 'Trimestral', 'Anual')),
   coordinador   CHAR(9)         UNIQUE,
   FOREIGN KEY (coordinador) REFERENCES CONTRATADO(DNI)
);

-- Añadir clave foránea a CONTRATADO para revista
ALTER TABLE CONTRATADO
ADD CONSTRAINT contratado_fk_revista
FOREIGN KEY (revista) REFERENCES REVISTA(idrev);

-- Crear tabla NUMERO
CREATE TABLE NUMERO (
   numero           NUMBER(5)          NOT NULL CHECK (numero > 0),
   fecha            DATE               NOT NULL,
   num_articulos    NUMBER(3)          CHECK (num_articulos >= 0),
   revista          CHAR(5)            NOT NULL,
   PRIMARY KEY (revista, numero),
   FOREIGN KEY (revista) REFERENCES REVISTA(idrev)
      ON DELETE CASCADE
);

-- Crear tabla ARTICULO
CREATE TABLE ARTICULO (
   idart               NUMBER(7)         PRIMARY KEY,
   titulo              VARCHAR2(100)     NOT NULL,
   tipo                VARCHAR2(15)      CHECK (tipo IN ('opinión', 'información', 'analisis')),
   revista             CHAR(5),
   numero              NUMBER(5),
   periodista_contratado CHAR(9),
   periodista_freelance CHAR(9),
   FOREIGN KEY (revista, numero) REFERENCES NUMERO(revista, numero),
   FOREIGN KEY (periodista_contratado) REFERENCES CONTRATADO(DNI),
   FOREIGN KEY (periodista_freelance) REFERENCES FREELANCE(DNI),
   CHECK ((periodista_contratado IS NOT NULL AND periodista_freelance IS NULL) OR 
          (periodista_contratado IS NULL AND periodista_freelance IS NOT NULL)),
   CHECK ((revista IS NULL AND numero IS NULL) OR (revista IS NOT NULL AND numero IS NOT NULL))
);

-- Crear tabla COLABORACION
CREATE TABLE COLABORACION (
   revista          CHAR(5),
   freelance        CHAR(9),
   pago_articulo    NUMBER(7,2)     CHECK (pago_articulo > 0),
   PRIMARY KEY (revista, freelance),
   FOREIGN KEY (revista) REFERENCES REVISTA(idrev),
   FOREIGN KEY (freelance) REFERENCES FREELANCE(DNI)
);