-- ----------------------------------------------------------
-- MDB Tools - A library for reading MS Access database files
-- Copyright (C) 2000-2011 Brian Bruns and others.
-- Files in libmdb are licensed under LGPL and the utilities under
-- the GPL, see COPYING.LIB and COPYING files respectively.
-- Check out http://mdbtools.sourceforge.net
-- ----------------------------------------------------------

-- That file uses encoding UTF-8

CREATE TABLE [Clasificación Dewey]
 (
	[Id Obra]			Text (100), 
	[Nombre]			Text (300)
);

CREATE TABLE [Clasificación Literatura Hispanoaméricana (860)]
 (
	[Id]			Text (4), 
	[País]			Text (50)
);

CREATE TABLE [Determinantes de Forma]
 (
	[Id]			Text (4), 
	[Determinante]			Text (124)
);

CREATE TABLE [Determinantes de Lengua (sólo para la 400 y la 800)]
 (
	[Id]			Text (4), 
	[Determinante]			Text (30)
);

CREATE TABLE [Determinantes Historia y Geografía (900)]
 (
	[Id]			Text (4), 
	[Determinante]			Text (70)
);

CREATE TABLE [Determinantes para nombre del autor]
 (
	[Nº]			Text (4), 
	[Letras]			Text (36)
);

CREATE TABLE [Determinates de género Literario (800)]
 (
	[Id]			Text (4), 
	[Determinante]			Text (50)
);

CREATE TABLE [Libros]
 (
	[Id Libro]			Text (100), 
	[Nombre Libro]			Text (510), 
	[Autor]			Text (100), 
	[Editorial]			Text (100), 
	[# de pág]			Long Integer, 
	[ISBN]			Text (100), 
	[Ej]			Integer, 
	[L?]			Boolean NOT NULL, 
	[Observaciones]			Text (510)
);

CREATE TABLE [Nuevos]
 (
	[Id Libro]			Text (100), 
	[Nombre Libro]			Text (510), 
	[Autor]			Text (100), 
	[Editorial]			Text (100), 
	[# de pág]			Long Integer, 
	[ISBN]			Text (100), 
	[Ej]			Long Integer
);

CREATE TABLE [Préstamos]
 (
	[Id Libro]			Text (100), 
	[Nombre Libro]			Text (510), 
	[Prestado a]			Text (100), 
	[Fecha Préstamo]			DateTime, 
	[Fecha Entrega]			DateTime, 
	[Observaciones]			Text (510)
);

CREATE TABLE [Libros de papi Daniel]
 (
	[Id Libro]			Text (100), 
	[Nombre Libro]			Text (510), 
	[Autor]			Text (100), 
	[Editorial]			Text (100), 
	[# de pág]			Long Integer, 
	[ISBN]			Text (100), 
	[Ej]			Integer, 
	[L?]			Boolean NOT NULL, 
	[#]			Text (8)
);


