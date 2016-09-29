#!/bin/bash

N=$1 # Numero de observa��es
S=$2 # Intervalo de tempo
P_USER=$3 # Come�o do nome de um usu�rio

if  [ -z "$N" ] && [ -z "$S" ] && [ -z "$P_USER" ]; then # Verifica se todas as entradas sao vazias
    echo Digite o n�mero de observa��es a serem feitas:
    read N;
    echo Digite um intervalo de tempo em segundos:
    read S;
    echo Digite o come�o de nome de um usu�rio:
    read P_USER
fi  

if  [ -z "$N" ] || [ -z "$S" ] || [ -z "$P_USER" ] || [ "$N" -le 0 ] || [ "$S" -le 0 ]; then # Verifica se alguma das entradas � vazia ou se o valor de N ou S � menor ou igual a zero.
    exit 1 # o programa sai com a sa�da 1
fi

> temp1.txt; # Cria��o do arquivo temp1.txt
> temp2.txt; # Cria��o do arquivo temp2.txt
counter=0 # Inicializa��o do contador

while test $counter -ne $N; do # Repete o loop N vezes

    ps -eo user,pid,pcpu,pmem > temp1.txt 
    cat temp1.txt | grep ^"$P_USER" >> temp2.txt 
    sleep $S; # Pausa o programa em S segundos
    counter=$((counter+1)); # Incrementa��o do contador
    
    if [ `cat temp2.txt | wc -l` -eq 0 ]; then
        rm temp1.txt 
        rm temp2.txt
        exit 2 # Encerra programa com a sa�da 2
    else 
    
        echo "-----Execution " $((counter)) "-----" 
        echo "USER - PID - %CPU - %MEM" 
    
        totalCPU=0 
        totalMEM=0 
        menorCPU=100.0 
        maiorMEM=0.0 
        menorMEM=100.0 
        numProcesses=0 

        while read line; do # Ler cada linha do arquivo temp2.txt
            IFS=' ' read -r -a array <<< "$line" # Transforma a linha em um array utilizando o separador ' '
            
            if [ "$(echo $maiorCPU '<' ${array[2]} | bc -l)" -eq 1 ]; then # Verifica se foi achado um valor de porcentagem de CPU maior
                maiorCPU=${array[2]} 
                idMaiorCPU=${array[1]} 
            fi
            
            if [ "$(echo $menorCPU '>' ${array[2]} | bc -l)" -eq 1 ]; then # Verifica se foi achado um valor de porcentagem de CPU menor
                menorCPU=${array[2]}
                idMenorCPU=${array[1]}
            fi
            
            if [ "$(echo $maiorMEM '<' ${array[3]} | bc -l)" -eq 1 ]; then # Verifica se foi achado um valor de porcentagem de mem�ria maior
                maiorMEM=${array[3]} 
                idMaiorMEM=${array[1]}
            fi
            
            if [ "$(echo $menorMEM '>' ${array[3]} | bc -l)" -eq 1 ]; then # Verifica se foi achado um valor de porcentagem de mem�ria menor
                menorMEM=${array[3]} 
                idMenorMEM=${array[1]} 
            fi                
            
            totalCPU=$(echo "$totalCPU + ${array[2]}" | bc) # Vari�vel de porcentagem total de utiliza��o da CPU atualizada
            totalMEM=$(echo "$totalMEM + ${array[3]}" | bc) # Vari�vel de porcentagem total de utiliza��o da mem�ria atualizada
            echo ${array[0]} ${array[1]} ${array[2]} ${array[3]} # Informa��es a cerca do processo printados para o usu�rio
            
            numProcesses=$((numProcesses+1)); # Vari�vel de n�mero total de processos incrementada
    done < temp2.txt
    fi
    
    mediaCPU=$(echo $totalCPU/$numProcesses | bc -l) 
    mediaMEM=$(echo $totalMEM/$numProcesses | bc -l) 
    
    echo "" 
    echo "Numero total de processos analisados: " $numProcesses # N�mero 
    echo ""
    echo "Total %CPU: " $totalCPU 
    echo "ID do processo com maior %CPU, %CPU do processo: " $idMaiorCPU "," $maiorCPU 
    echo "ID do processo com menor %CPU, %CPU do processo: " $idMenorCPU "," $menorCPU
    echo "Media %CPU: " $mediaCPU
    echo "" 
    echo "Total %MEM: " $totalMEM
    echo "Media %MEM: " $mediaMEM
    echo "ID do processo com maior %MEM, %MEM do processo: " $idMaiorMEM "," $maiorMEM 
    echo "ID do processo com menor %MEM, %MEM do processo: " $idMenorMEM "," $menorMEM
    > temp1.txt; # Arquivo temp1.txt zerado
    > temp2.txt; # Arquivo temp2.txt zerado
done

rm temp1.txt # Remove arquivo temp1.txt
rm temp2.txt # Remove arquivo temp2.txt