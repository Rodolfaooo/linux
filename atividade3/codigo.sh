#!bin/bash

awk -F":" '$2>100 {print $1, "-", $2}' vendas.txt
echo ""
awk -F":" '{total=$2*$3; print $1,"- Quantidade:",$3, "- Preço total:", total}' vendas.txt
echo ""
awk -F":" '{sum += $2} END {print "total -", sum}' vendas.txt
echo ""
awk -F":" 'END {print NR}' vendas.txt

#1. awk permite filtrar, extrair colunas e fazer cálculos em um arquivo, coisa que grep só busca texto e cut só pega colunas.
#2. Basta definir o separador com -F"," e usar $1, $2, $3 para acessar campos
#3. sed edita texto (substitui, deleta, insere), awk processa dados estruturados (filtra, soma, conta, calcula).
