#!/bin/bash

#1. O ext4 é o sistema de arquivos mais comum no Linux. Ele é estável, rápido e muito usado em desktops e servidores. O btrfs é mais moderno e possui 
#recursos avançados como snapshots, compressão e recuperação de dados. Já o xfs é otimizado para alto desempenho e manipulação de arquivos grandes, 
#sendo muito usado em servidores e armazenamento corporativo.
#2. Um loop device permite montar um arquivo comum como se fosse um disco real.
#3. O arquivo /etc/fstab guarda as configurações de montagem automática dos sistemas de arquivos no Linux. É importante porque automatiza montagens 
#e garante que os dispositivos sejam carregados corretamente no boot.



echo "=== FILESYSTEMS MONTADOS ==="
mount

echo
echo "=== USO DE DISCO ==="
df -h

echo
echo "=== CRIANDO ARQUIVO DE IMAGEM ==="

dd if=/dev/zero of=disco.img bs=1M count=100

echo
echo "=== FORMATANDO COMO EXT4 ==="

mkfs.ext4 disco.img

echo
echo "=== CRIANDO DIRETÓRIO DE MONTAGEM ==="

mkdir -p /mnt/meudisco

echo
echo "=== MONTANDO IMAGEM ==="

sudo mount -o loop disco.img /mnt/meudisco

echo
echo "=== COPIANDO ARQUIVOS ==="

cp -r ~/Documentos/* /mnt/meudisco/ 2>/dev/null

echo
echo "=== ARQUIVOS COPIADOS ==="

ls /mnt/meudisco

echo
echo "=== DESMONTANDO ==="

sudo umount /mnt/meudisco

echo
echo "=== FINALIZADO ==="
