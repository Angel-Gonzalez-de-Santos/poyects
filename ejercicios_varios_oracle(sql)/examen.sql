-- Eliminaci�n de tablas en caso de ejecuci�n m�ltiple
DROP TABLE COLABORACION CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIDAD_EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE FREELANCE CASCADE CONSTRAINTS;
DROP TABLE CONTRATADO CASCADE CONSTRAINTS;
DROP TABLE ARTICULO CASCADE CONSTRAINTS;
DROP TABLE NUMERO CASCADE CONSTRAINTS;
DROP TABLE REVISTA CASCADE CONSTRAINTS;

-- Tabla REVISTA
CREATE TABLE REVISTA (
    id_revista CHAR(3) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    web VARCHAR2(100),
    tema VARCHAR2(30) NOT NULL,
    periodicidad VARCHAR2(10) NOT NULL,
    coordinador CHAR(9) NOT NULL,
    CONSTRAINT revista_pk PRIMARY KEY (id_revista),
    CONSTRAINT revista_ak UNIQUE (nombre),
    CONSTRAINT revista_periodicidad_ck CHECK (periodicidad IN ('Semanal', 'Quincenal', 'Mensual', 'Bimestral', 'Trimestral', 'Anual'))
);

-- Tabla CONTRATADO
CREATE TABLE CONTRATADO (
    dni CHAR(9) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    sueldo NUMBER(10,2) NOT NULL CHECK (sueldo > 0),
    fecha_contrato DATE NOT NULL,
    email VARCHAR2(100),
    idrev CHAR(3),
    tutor CHAR(9),
    CONSTRAINT contratado_pk PRIMARY KEY (dni),
    CONSTRAINT contratado_fk_revista FOREIGN KEY (idrev) REFERENCES REVISTA(id_revista)
    ON DELETE SET NULL,
    CONSTRAINT contratado_tutor_ck CHECK (tutor <> dni)
);

-- Clave for�nea de coordinador en REVISTA
ALTER TABLE REVISTA 
ADD CONSTRAINT revista_fk_coordinador 
FOREIGN KEY (coordinador) REFERENCES CONTRATADO(dni);

-- Tabla FREELANCE
CREATE TABLE FREELANCE (
    dni CHAR(9) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    CONSTRAINT freelance_pk PRIMARY KEY (dni)
);

-- Tabla NUMERO
CREATE TABLE NUMERO (
    idrev CHAR(3) NOT NULL,
    numero NUMBER(3) NOT NULL,
    fecha DATE NOT NULL,
    num_articulos NUMBER(3),
    CONSTRAINT numero_pk PRIMARY KEY (idrev, numero),
    CONSTRAINT numero_fk_revista FOREIGN KEY (idrev) REFERENCES REVISTA(id_revista)
);

-- Tabla ARTICULO
CREATE TABLE ARTICULO (
    id_art CHAR(5) NOT NULL,
    titulo VARCHAR2(100) NOT NULL,
    tipo VARCHAR2(20) NOT NULL,
    contratado CHAR(9),
    freelance CHAR(9),
    numero NUMBER(3),
    idrev CHAR(3),
    CONSTRAINT articulo_pk PRIMARY KEY (id_art),
    CONSTRAINT articulo_tipo_ck CHECK (tipo IN ('informacion', 'opinion', 'analisis')),
    CONSTRAINT articulo_contrato_xor CHECK ((freelance IS NOT NULL AND contratado IS NULL) OR (freelance IS NULL AND contratado IS NOT NULL)),
    CONSTRAINT articulo_numero_ck CHECK ((idrev IS NOT NULL AND numero IS NOT NULL) OR (idrev IS NULL AND numero IS NULL)),
    CONSTRAINT articulo_fk_freelance FOREIGN KEY (freelance) REFERENCES FREELANCE(dni),
    CONSTRAINT articulo_fk_contratado FOREIGN KEY (contratado) REFERENCES CONTRATADO(dni),
    CONSTRAINT articulo_fk_numero FOREIGN KEY (idrev, numero) REFERENCES NUMERO(idrev, numero)
);
DROP TABLE CONTRATADO
-- Tabla ESPECIALIDAD_EMPLEADO
CREATE TABLE ESPECIALIDAD_EMPLEADO (
    freelance CHAR(9) NOT NULL,
    especialidad VARCHAR2(50) NOT NULL,
    CONSTRAINT especialidad_empleado_pk PRIMARY KEY (freelance, especialidad),
    CONSTRAINT especialidad_empleado_fk_freelance FOREIGN KEY (freelance) REFERENCES FREELANCE(dni)
);

-- Tabla COLABORACION
CREATE TABLE COLABORACION (
    freelance CHAR(9) NOT NULL,
    revista CHAR(3) NOT NULL,
    pago_articulo NUMBER(10,2) NOT NULL CHECK (pago_articulo > 0),
    CONSTRAINT colaboracion_pk PRIMARY KEY (freelance, revista),
    CONSTRAINT colaboracion_fk_freelance FOREIGN KEY (freelance) REFERENCES FREELANCE(dni),
    CONSTRAINT colaboracion_fk_revista FOREIGN KEY (revista) REFERENCES REVISTA(id_revista)
);
