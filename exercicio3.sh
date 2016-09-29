#!/bin/bash

EXERCICIO=$1
ALUNO=$2

	> temp.txt #salva todos os arquivos do diretório
	> temp2.txt # salva todas as entradas a serem executadas pelos exercícios dos alunos
	> temp3.txt # salva todos os exercícios do usuário
	> saida.txt # salva as saídas resultantes das entradas executadas nos exercícios dos alunos

if [ -z "$EXERCICIO" ] && [ -z "$ALUNO" ]; then # Caso o nome do aluno e o número do exercício não seja informado pelo usuário

	ls >> temp.txt
	grep '[0123456789]_[0123456789].in$' temp.txt >> temp2.txt 
	grep '.sh$' temp.txt >> temp3.txt
	
	while read line1; do
		
		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno
		EXNUM=$(echo $line1 | cut -d'_' -f2) # Salvar o número do exercício
		echo "EXERCICIO_"$EXNUM$NOMEALUNO

		while read line2; do # Passar por cada entrada a ser executada em cada exercício
			NUMEROEXERCICIO=$(cut -d'_' -f2 <<< $line2)
			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1)

			if [ "$EXNUM" = "$NUMEROEXERCICIO" ]; then # Verifica se a entrada a ser executada é do mesmo exercício a ser testado no momento

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

	while read line1; do # Passar por cada exercício

		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno em uma variável
		echo "EXERCICIO_"$EXERCICIO$NOMEALUNO

		while read line2; do # Passar por cada arquivo com entradas a serem executadas
			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1) # Salvar o número do teste em uma variável.

			while read line3; do
    			bash "EXERCICIO_"$EXERCICIO$NOMEALUNO".sh" $line3 >> saida.txt # Salva cada execução no file saida.txt
    		done < "EXERCICIO_"$EXERCICIO"_"$NUMTEST".in"

			echo "- SAIDA PARA A ENTRADA" $NUMTEST

			while read line4; do # Passa por cada linha da saída
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

    	while read line3; do # Passa por cada linha da saída
    		echo $line3
    	done < saida.txt

    	echo "- DIFERENCA PARA A SAIDA ESPERADA:"

    	diff saida.txt EXERCICIO_"$EXERCICIO"_"$NUMTEST".out 
    done < temp2.txt    
fi

rm temp.txt
rm temp2.txt
rm saida.txt