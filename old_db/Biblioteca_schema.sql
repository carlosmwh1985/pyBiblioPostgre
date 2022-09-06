-- ----------------------------------------------------------
-- MDB Tools - A library for reading MS Access database files
-- Copyright (C) 2000-2011 Brian Bruns and others.
-- Files in libmdb are licensed under LGPL and the utilities under
-- the GPL, see COPYING.LIB and COPYING files respectively.
-- Check out http://mdbtools.sourceforge.net
-- ----------------------------------------------------------

-- That file uses encoding UTF-8

CREATE TABLE IF NOT EXISTS ClasificacionDewey
 (
	Id			TEXT (100), 
	Nombre			TEXT (300)
);

CREATE TABLE IF NOT EXISTS ClasificacionLitHispanoamericana_860
 (
	Id			TEXT (4), 
	Pais			TEXT (50)
);

CREATE TABLE IF NOT EXISTS DeterminantesForma
 (
	Id			TEXT (4), 
	Determinante		TEXT (124)
);

CREATE TABLE IF NOT EXISTS DeterminantesLengua_400_800
 (
	Id			TEXT (4), 
	Determinante		TEXT (30)
);

CREATE TABLE IF NOT EXISTS DeterminantesHistoriaGeografia_900
 (
	Id			TEXT (4), 
	Determinante		TEXT (70)
);

CREATE TABLE IF NOT EXISTS DeterminantesAutor
 (
	No			TEXT (4), 
	Letras			TEXT (36)
);

CREATE TABLE IF NOT EXISTS DeterminatesLiterario_800
 (
	Id			TEXT (4), 
	Determinante		TEXT (50)
);

CREATE TABLE IF NOT EXISTS Libros
 (
	Id			TEXT (100), 
	Titulo			TEXT (510), 
	Autor			TEXT (100), 
	Editorial		TEXT (100), 
	Pags			INT, 
	ISBN			TEXT (100), 
	Ejemplares		INT, 
	Leido			BOOL NOT NULL, 
	Observaciones		TEXT (510)
);

CREATE TABLE IF NOT EXISTS Nuevos
 (
	Id			TEXT (100), 
	Titulo			TEXT (510), 
	Autor			TEXT (100), 
	Editorial		TEXT (100), 
	Pags			INT, 
	ISBN			TEXT (100), 
	Ejemplares		INT
);

CREATE TABLE IF NOT EXISTS Prestamos
 (
	Id			TEXT (100), 
	Titulo			TEXT (510), 
	PrestadoA		TEXT (100), 
	FechaPrestamo		DATETIME, 
	FechaEntrega		DATETIME, 
	Observaciones		TEXT (510)
);

CREATE TABLE IF NOT EXISTS LibrosPapiDaniel
 (
	Id			TEXT (100), 
	Titulo			TEXT (510), 
	Autor			TEXT (100), 
	Editorial		TEXT (100), 
	Pags			INT, 
	ISBN			TEXT (100), 
	Ejemplares		INT, 
	Leido			BOOL NOT NULL, 
	Num			TEXT (8)
);


