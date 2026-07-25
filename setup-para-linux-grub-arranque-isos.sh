#!/bin/bash
#pensado para que incluso principiantes puedan usarlo, sin miedo a perder datos de otros discos

#loguica para que el script se ejecute con privilegios de root
# asi mismo si ocurre el mas minimo error, el script se detiene y no sigue ejecutando comandos que puedan dañar el sistema

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
	echo "ERROR: corre esto con sudo."
	exit 1
fi

# Pide que el usuario escriba EXACTAMENTE la palabra indicada.
# Cualquier otra cosa cancela. No acepta "y", "yes", "si" corto:
# tiene que ser la palabra completa que se le pide, a proposito,
# para que no sea un reflejo de apretar Enter/escribir rapido.
confirmar() {
	local palabra="$1"
	local respuesta
	echo 
	echo ">>> Para continuar, escribe exactamente: $palabra"
	read -rp ">>> " respuesta
	if [ "$respuesta" != "$palabra" ]; then
		echo "Cancelado (no coincidio la palabra de confirmacion)."
		exit 1
	fi
}

echo "############################################################"
echo "te ayudaremos a guiarte no te preocupes las instrucciones estan abajo"
echo "PASO 1: Elegir el disco"
echo "vista general de discos:"
echo 
echo 
echo 
echo 
echo "tu disco talvez se vea asi"
echo "nvme0n1     238,5G disk  KBG60ZNT256G LS KIOXIA c7596940-bcb0-46f1-9308-1c94aa7fd1ab gpt"
echo "├─nvme0n1p1   600M part EFI System Partition    c7596940-bcb0-46f1-9308-1c94aa7fd1ab gpt         2048   600M EFI System Partition"
echo "├─nvme0n1p2     2G part                         c7596940-bcb0-46f1-9308-1c94aa7fd1ab gpt      1230848     2G Linux filesystem"
echo "├─nvme0n1p3   175G part                         c7596940-bcb0-46f1-9308-1c94aa7fd1ab gpt      5425152   175G Linux filesystem"
echo "├─nvme0n1p4   8,1G part                         c7596940-bcb0-46f1-9308-1c94aa7fd1ab gpt    483133440   8,1G Linux swap"
echo 
echo 
echo 
echo 
echo 
echo "############################################################"
#lsbk imprime la bista de los discos
lsblk -o NAME,SIZE,TYPE,PARTLABEL,MODEL,PTUUID,PTTYPE,START,SIZE,PARTTYPENAME,PARTFLAGS


