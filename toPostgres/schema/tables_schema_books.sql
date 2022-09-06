-- Drop all tables, if any

DROP TABLE IF EXISTS tblLinks CASCADE;
DROP TABLE IF EXISTS tblAutores CASCADE;
DROP TABLE IF EXISTS tblEditoriales CASCADE;
DROP TABLE IF EXISTS tblBookFields CASCADE;
DROP TABLE IF EXISTS tblLibros CASCADE;
DROP TABLE IF EXISTS tblLibrosNuevos CASCADE;
DROP TABLE IF EXISTS tblLibrosPapiDaniel CASCADE;
DROP TABLE IF EXISTS tblPrestamos CASCADE;



-- Table to be used to create several foreign keys

CREATE TABLE tblLinks (
    id              SERIAL PRIMARY KEY,
    name            varchar(255) NOT NULL
);



-- Book related tables

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

GRANT SELECT ON 
    tbldeterminantes, tbldetlengua, tblclasificaciondewey, tblliteraturahispanoamericana_860,
    tbldetforma, tbldethistoria, tbldetliteratura, tbldetnombreautor
    TO py_test_db;

GRANT SELECT, INSERT, UPDATE ON
    tbllibros, tblautores, tbleditoriales, tbllibrosnuevos, tbllibrospapidaniel
    TO py_test_db;

GRANT SELECT, UPDATE ON
    tblautores_id_seq, tbleditoriales_id_seq, tblbookfields_id_seq
    TO py_test_db;