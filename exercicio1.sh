#!/bin/sh


# descartar as linhas que tem nenhum ou apenas um traço depois de remote ou de local, jogando o resultado da filtragem de ‘local - - ‘ e 
#‘remove - - ’em arquivos temporarios.

grep -i 'local - - ' calgary_access_log > saidaLocal && 
grep -i 'remote - - ' calgary_access_log > saidaRemoto

#Contagem da quantidade de requisicoes locais e imprime o resultado
local=$(awk 'END{print NR}' saidaLocal)
echo Quantidade de Requisicoes Locais: "$local"

#Contagem da quantidade de requisicoes remotas e imprime o resultado
remoto=$(awk 'END{print NR}' saidaRemoto)
echo Quantidade de Requisicoes Remotas: "$remoto"

#Imprime o total de requisicoes
total=$((local+remoto))
echo Total de Requisicoes: "$total"

#Horario medio das requisicoes Locais
LC_CTYPE=C && LANG=C && cut -d: -f 2 saidaLocal  > hora
LC_CTYPE=C && LANG=C && cut -d: -f 3 saidaLocal  > minuto

hora=$(awk '{ soma+=$1 } END{ print "\n", soma }' hora)
minuto=$(awk '{ soma+=$1 } END{ print "\n", soma }' minuto)
echo Horario medio mais acessado Localmente: "$((hora/local))" ':' "$((minuto/local))"


#hora media das requisicoes remotas
LC_CTYPE=C && LANG=C && cut -d: -f 2 saidaRemoto  > hora
LC_CTYPE=C && LANG=C && cut -d: -f 3 saidaRemoto  > minuto

hora=$(awk '{ soma+=$1 } END{ print "\n", soma }' hora)
minuto=$(awk '{ soma+=$1 } END{ print "\n", soma }' minuto)
echo Horario medio mais acessado Remotamente: "$((hora/remoto))" ':' "$((minuto/remoto))"

#hora media das requisicoes
LC_CTYPE=C && LANG=C && cut -d: -f 2 calgary_access_log  > hora
LC_CTYPE=C && LANG=C && cut -d: -f 3 calgary_access_log  > minuto

hora=$(awk '{ soma+=$1 } END{ print "\n", soma }' hora)
minuto=$(awk '{ soma+=$1 } END{ print "\n", soma }' minuto)
echo Horario medio mais acessado: "$((hora/total))" ':' "$((minuto/total))"

#tamanho medio das requisicoes
LC_CTYPE=C && LANG=C && cut -d' ' -f 10 calgary_access_log  > tamanho

tamanhoTotal=$(awk '{ soma+=$1 } END{ print "\n", soma }' tamanho)
echo Tamanho medio das requisicoes: "$((tamanhoTotal/total))"

#remove todos os arquivos temporarios
rm saidaLocal | rm saidaRemoto | rm hora |rm minuto | rm tamanho