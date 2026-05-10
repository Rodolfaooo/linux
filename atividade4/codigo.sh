#!bin/bash
> relatorio_erros.txt

grep "ERROR" log.txt >> relatorio_erros.txt
awk '{print $3}' log.txt | sort | uniq -c >> relatorio_erros.txt
echo "">> relatorio_erros.txt
awk '{print $3}' log.txt | sort | uniq -c| sort -nr | head -5 >> relatorio_erros.txt

#1. O kernel gerencia pipes usando um buffer na memória para armazenar temporariamente os dados enviados entre processos. Ele controla o fluxo
#para que um processo possa escrever enquanto outro lê sem perder informações.
#2. O uso de sort junto com uniq é mais eficiente porque o sort organiza os dados iguais próximos uns dos outros, permitindo que o uniq identifique
#e remova as duplicatas corretamente.
#3. Para redirecionar stderr e stdout para arquivos diferentes, utiliza-se os descritores do shell. O stdout (saída normal) é representado por 1 e o
#stderr (mensagens de erro) por 2. Um exemplo é: comando >saida.txt 2>erro.txt, Nesse caso, a saída normal vai para saida.txt e os erros vão para erro.txt.
