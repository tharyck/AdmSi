#!/bin/bash

EXERCICIO=$1
ALUNO=$2

	> temp.txt #salva todos os arquivos do diret�rio
	> temp2.txt # salva todas as entradas a serem executadas pelos exerc�cios dos alunos
	> temp3.txt # salva todos os exerc�cios do usu�rio
	> saida.txt # salva as sa�das resultantes das entradas executadas nos exerc�cios dos alunos

if [ -z "$EXERCICIO" ] && [ -z "$ALUNO" ]; then # Caso o nome do aluno e o n�mero do exerc�cio n�o seja informado pelo usu�rio

	ls >> temp.txt
	grep '[0123456789]_[0123456789].in$' temp.txt >> temp2.txt 
	grep '.sh$' temp.txt >> temp3.txt
	
	while read line1; do
		
		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno
		EXNUM=$(echo $line1 | cut -d'_' -f2) # Salvar o n�mero do exerc�cio
		echo "EXERCICIO_"$EXNUM$NOMEALUNO

		while read line2; do # Passar por cada entrada a ser executada em cada exerc�cio
			NUMEROEXERCICIO=$(cut -d'_' -f2 <<< $line2)
			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1)

			if [ "$EXNUM" = "$NUMEROEXERCICIO" ]; then # Verifica se a entrada a ser executada � do mesmo exerc�cio a ser testado no momento

				while read line3 ; do 
					bash "EXERCICIO_"$EXNUM$NOMEALUNO".sh" $line3 >> saida.txt
				done < $line2

				echo "- SAIDA PARA A ENTRADA" $NUMTEST

				while read line4; do
					echo $line4
				done < saida.txt

				echo "- DIFERENCA PARA A SAIDA ESPERADA:"

				diff saida.txt EXERCICIO_"$EXNUM"_"$NUMTEST".out
			fi
		done < temp2.txt
	done < temp3.txt

elif [[ ! -z "$EXERCICIO" ]] && [ -z "$ALUNO" ]; then

	ls >> temp.txt 
	grep $EXERCICIO'_[0123456789].in$' temp.txt >> temp2.txt
	grep '.sh$' temp.txt >> temp3.txt

	while read line1; do # Passar por cada exerc�cio

		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno em uma vari�vel
		echo "EXERCICIO_"$EXERCICIO$NOMEALUNO

		while read line2; do # Passar por cada arquivo com entradas a serem executadas
			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1) # Salvar o n�mero do teste em uma vari�vel.

			while read line3; do
    			bash "EXERCICIO_"$EXERCICIO$NOMEALUNO".sh" $line3 >> saida.txt # Salva cada execu��o no file saida.txt
    		done < "EXERCICIO_"$EXERCICIO"_"$NUMTEST".in"

			echo "- SAIDA PARA A ENTRADA" $NUMTEST

			while read line4; do # Passa por cada linha da sa�da
				echo $line4
			done < saida.txt

			echo "- DIFERENCA PARA A SAIDA ESPERADA:"

    		diff saida.txt EXERCICIO_"$EXERCICIO"_"$NUMTEST".out
		done < temp2.txt
	done < temp3.txt

elif [[ ! -z "$EXERCICIO" ]] && [[ ! -z "$ALUNO" ]]; then

	echo "EXERCICIO_"$EXERCICIO"_"$ALUNO":"

    ls >> temp.txt 
    grep $EXERCICIO'_[0123456789].in$' temp.txt >> temp2.txt

    while read line1; do
    	NUMTEST=$(cut -d'_' -f3 <<< $line1 | cut -d'.' -f1)
    	
    	while read line2; do
    		bash "EXERCICIO_"$EXERCICIO"_"$ALUNO".sh" $line2 >> saida.txt
    	done < "EXERCICIO_"$EXERCICIO"_"$NUMTEST".in"

    	echo "- SAIDA PARA A ENTRADA" $NUMTEST

    	while read line3; do # Passa por cada linha da sa�da
    		echo $line3
    	done < saida.txt

    	echo "- DIFERENCA PARA A SAIDA ESPERADA:"

    	diff saida.txt EXERCICIO_"$EXERCICIO"_"$NUMTEST".out 
    done < temp2.txt    
fi

rm temp.txt
rm temp2.txt
rm saida.txt