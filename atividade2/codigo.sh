#!/bin/bash

#1. Utilizamos o sed pra editar por causa da quantidade de arquivos
#a serem editados.
#2. A diferença entre os 2 é que sem o g, apenas ocorrerá uma modificação
#em cada linha. O g garante que todas as ocorrências sejam modificadas
#3. o formato geral é: sed -i.bkp 's/old/new/g' arquivo.txt

sed 's/localhost/192.168.1.1/' config.txt
echo 
sed '/^#/d' config.txt
echo
sed -n '5,10p' config.txt
echo
sed 's/^/LOG: /' config.txt
