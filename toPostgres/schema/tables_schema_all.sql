-- Drop all tables, if any

DROP TABLE IF EXISTS tblLinks CASCADE;
DROP TABLE IF EXISTS tblAutores CASCADE;
DROP TABLE IF EXISTS tblEditoriales CASCADE;
DROP TABLE IF EXISTS tblDeterminantes CASCADE;
DROP TABLE IF EXISTS tblBookFields CASCADE;
DROP TABLE IF EXISTS tblClasificacionDewey CASCADE;
DROP TABLE IF EXISTS tblLiteraturaHispanoamericana_860 CASCADE;
DROP TABLE IF EXISTS tblDetForma CASCADE;
DROP TABLE IF EXISTS tblDetLengua CASCADE;
DROP TABLE IF EXISTS tblDetHistoria CASCADE;
DROP TABLE IF EXISTS tblDetLiteratura CASCADE;
DROP TABLE IF EXISTS tblDetNombreAutor CASCADE;
DROP TABLE IF EXISTS tblLibros CASCADE;
DROP TABLE IF EXISTS tblLibrosNuevos CASCADE;
DROP TABLE IF EXISTS tblLibrosPapiDaniel CASCADE;
DROP TABLE IF EXISTS tblPrestamos CASCADE;



-- Table to be used to create several foreign keys

CREATE TABLE tblLinks (
    id              SERIAL PRIMARY KEY,
    name            varchar(255) NOT NULL
);



-- Base tables

CREATE TABLE tblAutores (
    id              SERIAL PRIMARY KEY,
    nombre          varchar(255) NOT NULL,
    apellido        varchar(255) NOT NULL,
    nacionalidad    varchar(100)
);

CREATE TABLE tblEditoriales (
    id              SERIAL PRIMARY KEY,
    nombre          varchar(255)
);



-- Base table for all determinants
CREATE TABLE tblDeterminantes (
    id              SERIAL NOT NULL PRIMARY KEY,
    num             varchar(10) NOT NULL,
    determinante    varchar(100) NOT NULL
);


CREATE TABLE tblBookFields (
    id              SERIAL PRIMARY KEY UNIQUE,
    libro_id        varchar(20),
    titulo          text,
    autor_id        int,
    editorial_id    int,
    pags            int,
    isbn            varchar(21),    -- Based on the present standard + Extras, some have very large values
    ejemplares      int,
    FOREIGN KEY (autor_id)
        REFERENCES tblAutores(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (editorial_id)
        REFERENCES tblEditoriales(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);



-- Table to save all the codes of the classification system
CREATE TABLE tblClasificacionDewey ( 	--IF NOT EXISTS ClasificacionDewey
    id		        varchar(20),
    nombre          text
);

CREATE TABLE tblLiteraturaHispanoamericana_860 (  --IF NOT EXISTS ClasificacionLitHispanoamericana_860
    id              varchar(4),
    pais            varchar(50)
);



-- Tables with all determinants

CREATE TABLE tblDetForma ()
    INHERITS (tblDeterminantes);

CREATE TABLE tblDetLengua ()
    INHERITS (tblDeterminantes);

CREATE TABLE tblDetHistoria ()
    INHERITS (tblDeterminantes);

CREATE TABLE tblDetLiteratura ()
    INHERITS (tblDeterminantes);

CREATE TABLE tblDetNombreAutor (
    id              SERIAL PRIMARY KEY NOT NULL,
	numero          varchar(1) NOT NULL,
	letras          varchar(18) NOT NULL
);



-- Tables with the actual books
CREATE TABLE tblLibros (
    leido           boolean,
    observaciones   text
) INHERITS (tblBookFields);

CREATE TABLE tblLibrosNuevos ()      -- It should be deprecated
    INHERITS (tblBookFields);

CREATE TABLE tblLibrosPapiDaniel (
    leido           boolean,
    num             varchar(8)
) INHERITS (tblBookFields);



-- Table with given away books... :(
CREATE TABLE tblPrestamos (
    id              SERIAL PRIMARY KEY,
    id_libro        varchar(20),
    titulo_libro    text,
    prestadoA       varchar(255),
    fechaPrestamo   date,
    fechaEntrega    date,
    observaciones   text,
    FOREIGN KEY (id_libro)
        REFERENCES tblLibros(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
