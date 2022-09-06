#!/bin/bash
IFS=$'\n'
TABLES=$(mdb-tables -1 $1)

#for t in $TABLES
#do
#	echo "DROP TABLE IF EXISTS $t;"
#done

#mdb-schema $1 mysql

FILE_DB='export.sql'
for t in $TABLES
do
	echo "Exporting Table $t"
	FILE_DB='data_' + $t + '.sql'
	mdb-export -I mysql $1 $t > $FILE_DB
	sed -i 's/Id Libro/Id/' $FILE_DB
	sed -i 's/Id Obra/Id/' $FILE_DB
	sed -i 's/País/Pais/' $FILE_DB
	sed -i 's/Nº/No/' $FILE_DB
	sed -i 's/Nombre Libro/Titulo/' $FILE_DB
	sed -i 's/L?/Leido/' $FILE_DB
	sed -i 's/Id Libro/Id/' $FILE_DB
	sed -i 's/Prestado a/PrestadoA/' $FILE_DB
	sed -i 's/# de pág/Pags/' $FILE_DB
	sed -i 's/Fecha Préstamo/FechaPrestamo/' $FILE_DB
	sed -i 's/Fecha Entrega/FechaEntrega/' $FILE_DB
	sed -i 's/#/Num/' $FILE_DB
	sed -i 's/Ej/Ejemplares/' $FILE_DB
	sed -i 's/Clasificación Dewey/ClasificacionDewey/' $FILE_DB
	sed -i 's/Clasificación Literatura Hispanoaméricana (860)/ClasificacionLitHispanoamericana_860/' $FILE_DB
	sed -i 's/Determinantes de Forma/DeterminantesForma/' $FILE_DB
	sed -i 's/Determinantes de Lengua (sólo para la 400 y la 800)/DeterminantesLengua_400_800/' $FILE_DB
	sed -i 's/Determinantes Historia y Geografía (900)/DeterminantesHistoriaGeografia_900/' $FILE_DB
	sed -i 's/Determinantes para nombre del autor/DeterminantesAutor/' $FILE_DB
	sed -i 's/Determinates de género Literario (800)/DeterminatesLiterario_800/' $FILE_DB
	sed -i 's/Préstamos/Prestamos/' $FILE_DB
	sed -i 's/Libros de papi Daniel/LibrosPapiDaniel/' $FILE_DB
	mysql -u carlos -pA0051t4920! BibliotecaPersonal < $FILE_DB
	echo
done
