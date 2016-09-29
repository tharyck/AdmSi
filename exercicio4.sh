#!/bin/bash

strace -T $1 > SAIDA 2>&1 # Passa o resultado de Strace para um arquivo
TIMES=()

#arquivo para salvar as chamadas mais realizadas
> chamadas.txt

while read line; do
	IFS='<' read -r -a TEMPOCHAMADA <<< "$line"
	TIME=$(echo ${TEMPOCHAMADA[1]} | sed "s,>,,g")
	TIMES+=("$TIME")
done < SAIDA

#Ordenacao do array com os tempos
Ordenado=( $(for el in "${TIMES[@]}" 
do
	echo "$el"
done | sort -r) )

echo Chamadas:
egrep ${Ordenado[0]} SAIDA >> chamadas.txt
egrep ${Ordenado[1]} SAIDA >> chamadas.txt
egrep ${Ordenado[2]} SAIDA >> chamadas.txt

#imprime as 3 maiores chamadas 
CONTADOR=0
while read line2; do 
	if [ $CONTADOR -eq 3 ]; then
		break
	fi
	echo $line2
	CONTADOR=$((counter+1));
done < chamadas.txt

Erros=0
while read line3; do
	exit=$(echo $line3 | cut -d')' -f2 | cut -d'=' -f2 | cut -d' ' -f2) # Retira a saída da chamada
	if [[ "$exit" =~ ^[-+]?([1-9][[:digit:]]*|0)$ && "$exit" -le -1 ]] # Confere se o número retirado é menor ou igual a -1
	then
		Erros=$((Erros+1))
	fi
done < SAIDA

rm chamadas.txt # Remove chamadas
rm SAIDA # Remove temporario
echo Numero de syscall com erro: $Erros
