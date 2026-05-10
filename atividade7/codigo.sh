#!/bin/bash

> relatorio.txt

find /home -perm 777 >> relatorio.txt
find / -perm -4000 >> relatorio.txt
awk -F: '$3 == 0 {print $1}' /etc/passwd >> relatorio.txt

