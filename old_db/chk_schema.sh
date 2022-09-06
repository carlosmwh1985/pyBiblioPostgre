#!/bin/bash

FILE_SCHEMA='Biblioteca_schema.sql'

sed -i 's/Id Libro/Id/' $FILE_SCHEMA
sed -i 's/Id Obra/Id/' $FILE_SCHEMA
sed -i 's/País/Pais/' $FILE_SCHEMA
sed -i 's/Nº/No/' $FILE_SCHEMA
sed -i 's/Nombre Libro/Titulo/' $FILE_SCHEMA
sed -i 's/L?/Leido/' $FILE_SCHEMA
sed -i 's/Id Libro/Id/' $FILE_SCHEMA
sed -i 's/Prestado a/PrestadoA/' $FILE_SCHEMA
sed -i 's/# de pág/Pags/' $FILE_SCHEMA
sed -i 's/Fecha Préstamo/FechaPrestamo/' $FILE_SCHEMA
sed -i 's/Fecha Entrega/FechaEntrega/' $FILE_SCHEMA
sed -i 's/#/Num/' $FILE_SCHEMA
sed -i 's/Ej/Ejemplares/' $FILE_SCHEMA
sed -i 's/Clasificación Dewey/ClasificacionDewey/' $FILE_SCHEMA
sed -i 's/Clasificación Literatura Hispanoaméricana (860)/ClasificacionLitHispanoamericana_860/' $FILE_SCHEMA
sed -i 's/Determinantes de Forma/DeterminantesForma/' $FILE_SCHEMA
sed -i 's/Determinantes de Lengua (sólo para la 400 y la 800)/DeterminantesLengua_400_800/' $FILE_SCHEMA
sed -i 's/Determinantes Historia y Geografía (900)/DeterminantesHistoriaGeografia_900/' $FILE_SCHEMA
sed -i 's/Determinantes para nombre del autor/DeterminantesAutor/' $FILE_SCHEMA
sed -i 's/Determinates de género Literario (800)/DeterminatesLiterario_800/' $FILE_SCHEMA
sed -i 's/Préstamos/Prestamos/' $FILE_SCHEMA
sed -i 's/Libros de papi Daniel/LibrosPapiDaniel/' $FILE_SCHEMA
