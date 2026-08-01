#!/bin/bash
set -x
#version 0.2.1
	#pensado para que incluso principiantes puedan usarlo, sin miedo a perder datos de otros discos
	#loguica para que el script se ejecute con privilegios de root
	echo "recuerda formatear un particion como sin formato y que sea de unos 7 8gib como minimo en gpared o otro gestor de particiones"
	echo "en la tabla de particiones de mas adelante en este script deberia aparecerte como "dos" en la columna PTTYPE"
	echo "por ahora si haces todo tal cual no hara nada mal"
if [ "$(id -u)" -ne 0 ]; then
	echo "ERROR: corre esto con sudo."
	exit 1
fi
read -rp "presiona enter para continuar"
#paso 1
	echo "############################################################"
	echo "te ayudaremos a guiarte no te preocupes las instrucciones estan abajo"
	echo "PASO 1: Elegir el disco"
	echo "vista general de discos:"
	echo 
	read -rp "presiona enter para continuar"
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
	read -rp "presiona enter para continuar"
	echo 

#comprobar que elijio el ususario
	echo "############################################################"
	#lsbk imprime la bista de los discos
	lsblk -o NAME,PATH,SIZE,TYPE,PARTTYPENAME,PTTYPE,PARTLABEL,MODEL,START,PARTFLAGS
	read -rp "ingrese la particion que sera usado (ejemplo: /dev/sda): " discoSelecionado
NombreDiscoSelecionado=$(lsblk -J -b -o NAME "$discoSelecionado" );
InicioDiscoSelecionado=$(lsblk -J -b -o START "$discoSelecionado" );
TamanoDiscoSelecionado=$(lsblk -J -b -o SIZE "$discoSelecionado" );

IFS='|' read -r nombreDepurado inicioDepurado finalDiscoDepurado TamanoDiscoDepuradoMIb < <(python3 - "$NombreDiscoSelecionado" "$InicioDiscoSelecionado" "$TamanoDiscoSelecionado" <<'EOF_PYTHON'
import sys
import json
nombreParticionRaw = json.loads(sys.argv[1])
InicioDiscoSelecionadoPY = json.loads(sys.argv[2])
TamañoDiscoSelecionadoPY = json.loads(sys.argv[3])
nombreDepurado = nombreParticionRaw["blockdevices"][0]["name"]
InicioDiscoSelecionadoDepuradoPY = int(InicioDiscoSelecionadoPY["blockdevices"][0]["start"])
TamañoDiscoSelecionadoDepuradoPY = int(TamañoDiscoSelecionadoPY["blockdevices"][0]["size"])

finalDiscoselecionadoPY = int(InicioDiscoSelecionadoDepuradoPY + (TamañoDiscoSelecionadoDepuradoPY // 512) -1)
TamanoDiscoSelecionadoDepuradoPYMIb = int(TamañoDiscoSelecionadoDepuradoPY // (1024 * 1024))

find
numeroParticionDecimal

print(f"{nombreDepurado}|{InicioDiscoSelecionadoDepuradoPY}|{finalDiscoselecionadoPY}|{TamanoDiscoSelecionadoDepuradoPYMIb}")

EOF_PYTHON
)

echo "$nombreDepurado"
echo "$inicioDepurado"
echo "$finalDiscoDepurado"
echo "$TamanoDiscoDepuradoMIb"
if [ "$TamanoDiscoDepuradoMIb" -le 4096 ]; then
	echo "la cantidad de mib es muy baja, se recomienda 10240mib, minimo 4096mib"
	exit 1
fi
parted -s select "$discoSelecionado"
parted
parted -s mkpart primary fat32 "$inicioDepurado"s