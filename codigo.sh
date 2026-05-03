#!/bin/bash

#1. O grep -E permite utilizar vários metacaracteres sem escapar com
# a barra, essa é a diferença entre eles.
#2. grep -E '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' arquivo.txt
#3. O grep -i ignora a diferença entre maiúsculas e minúsculas

>dados.txt

for i in {1..20}; do
	echo "agmail$i@gmail.com" >> dados.txt
	echo "Anome" >> dados.txt
	echo $i >> dados.txt

	linhas=$(wc -l < dados.txt)

	if [ $linhas -ge 20 ]; then
		break
	fi
done

grep "@gmail.com" dados.txt  > grep1
grep -v [0-9] dados.txt > grep2
grep -c "a" dados.txt > grep3
grep "^A" dados.txt > grep4
