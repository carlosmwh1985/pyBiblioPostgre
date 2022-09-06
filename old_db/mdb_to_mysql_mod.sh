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
	FILE_DB='data_'$t'.sql'
	mdb-export -I mysql $1 $t > $FILE_DB
	sed -i 's/Id Libro/id/' $FILE_DB
	sed -i 's/Id Obra/id/' $FILE_DB
	sed -i 's/País/pais/' $FILE_DB
	sed -i 's/Nº/numero/' $FILE_DB
	sed -i 's/Nombre Libro/titulo/' $FILE_DB
	sed -i 's/L?/leido/' $FILE_DB
	sed -i 's/Id Libro/id/' $FILE_DB
	sed -i 's/Prestado a/prestadoA/' $FILE_DB
	sed -i 's/# de pág/pags/' $FILE_DB
	sed -i 's/Fecha Préstamo/fechaPrestamo/' $FILE_DB
	sed -i 's/Fecha Entrega/fechaEntrega/' $FILE_DB
	sed -i 's/#/num/' $FILE_DB
	sed -i 's/Ej/ejemplares/' $FILE_DB
	sed -i 's/Clasificación Dewey/clasificacionDewey/' $FILE_DB
	sed -i 's/Clasificación Literatura Hispanoaméricana (860)/clasificacionLitHispanoamericana_860/' $FILE_DB
	sed -i 's/Determinantes de Forma/determinantesForma/' $FILE_DB
	sed -i 's/Determinantes de Lengua (sólo para la 400 y la 800)/determinantesLengua_400_800/' $FILE_DB
	sed -i 's/Determinantes Historia y Geografía (900)/determinantesHistoriaGeografia_900/' $FILE_DB
	sed -i 's/Determinantes para nombre del autor/determinantesAutor/' $FILE_DB
	sed -i 's/Determinates de género Literario (800)/determinatesLiterario_800/' $FILE_DB
	sed -i 's/Préstamos/prestamos/' $FILE_DB
	sed -i 's/Libros de papi Daniel/librosPapiDaniel/' $FILE_DB
	#mysql -u carlos -pA0051t4920! BibliotecaPersonal < $FILE_DB
	echo
done
