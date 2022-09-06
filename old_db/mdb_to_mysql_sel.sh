#!/bin/bash
IFS=$'\n'
TABLES=$(mdb-tables -1 $1)

#for t in $TABLES
#do
#	echo "DROP TABLE IF EXISTS $t;"
#done

#mdb-schema $1 mysql

FILE_DB='export.sql'
i=0
for t in $TABLES
do
	echo "Exporting Table $t"
	OUTFILE='TABLE_'$i'.sql'
	mdb-export -I mysql $1 $t > $OUTFILE
	sed -i 's/Id Libro/Id/' $OUTFILE
	sed -i 's/Id Obra/Id/' $OUTFILE
	sed -i 's/País/Pais/' $OUTFILE
	sed -i 's/Nº/No/' $OUTFILE
	sed -i 's/Nombre Libro/Titulo/' $OUTFILE
	sed -i 's/L?/Leido/' $OUTFILE
	sed -i 's/Id Libro/Id/' $OUTFILE
	sed -i 's/Prestado a/PrestadoA/' $OUTFILE
	sed -i 's/# de pág/Pags/' $OUTFILE
	sed -i 's/Fecha Préstamo/FechaPrestamo/' $OUTFILE
	sed -i 's/Fecha Entrega/FechaEntrega/' $OUTFILE
	sed -i 's/#/Num/' $OUTFILE
	sed -i 's/Ej/Ejemplares/' $OUTFILE
	sed -i 's/Clasificación Dewey/ClasificacionDewey/' $OUTFILE
	sed -i 's/Clasificación Literatura Hispanoaméricana (860)/ClasificacionLitHispanoamericana_860/' $OUTFILE
	sed -i 's/Determinantes de Forma/DeterminantesForma/' $OUTFILE
	sed -i 's/Determinantes de Lengua (sólo para la 400 y la 800)/DeterminantesLengua_400_800/' $OUTFILE
	sed -i 's/Determinantes Historia y Geografía (900)/DeterminantesHistoriaGeografia_900/' $OUTFILE
	sed -i 's/Determinantes para nombre del autor/DeterminantesAutor/' $OUTFILE
	sed -i 's/Determinates de género Literario (800)/DeterminatesLiterario_800/' $OUTFILE
	sed -i 's/Préstamos/Prestamos/' $OUTFILE
	sed -i 's/Libros de papi Daniel/LibrosPapiDaniel/' $OUTFILE
	#mysql -u carlos -p BibliotecaPersonal < $FILE_DB
	echo
done
