#!/bin/bash
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_VERDE='\033[0;32m'
readonly COLOR_AMARILLO='\033[1;33m'
readonly COLOR_ROJO='\033[0;31m'
readonly COLOR_BLANCO='\033[1;37m'
readonly COLOR_GRIS='\033[0;90m'
readonly COLOR_RESET='\033[0m'

source ./modules/usuarios.sh
source ./modules/discos.sh
source ./modules/archivos_grandes.sh
source ./modules/memoria.sh
source ./modules/backup.sh

mostrar_menu() {
    clear
    echo ""
    echo -e "${COLOR_VERDE} /0000000   /000000        /000000        /00               /00           "
    echo -e "| 00__  00 /00__  00      /00__  00      | 00              |__/           "
    echo -e "| 00  \ 00| 00  \__/     | 00  \ 00  /0000000 /000000/0000  /00 /0000000  "
    echo -e "| 00  | 00| 00           | 00000000 /00__  00| 00_  00_  00| 00| 00__  00 "
    echo -e "| 00  | 00| 00           | 00__  00| 00  | 00| 00 \ 00 \ 00| 00| 00  \ 00 "
    echo -e "| 00  | 00| 00    00     | 00  | 00| 00  | 00| 00 | 00 | 00| 00| 00  | 00 "
    echo -e "| 0000000/|  000000/     | 00  | 00|  0000000| 00 | 00 | 00| 00| 00  | 00 "
    echo -e "|_______/  \______/      |__/  |__/ \_______/|__/ |__/ |__/|__/|__/  |__/${COLOR_RESET} .sh"
    echo ""
    echo -e "${COLOR_VERDE}[1]${COLOR_RESET} Usuarios y último login"
    echo -e "${COLOR_VERDE}[2]${COLOR_RESET} Filesystems y espacio disponible"
    echo -e "${COLOR_VERDE}[3]${COLOR_RESET} Archivos más grandes en un disco"
    echo -e "${COLOR_VERDE}[4]${COLOR_RESET} Información de memoria y swap"
    echo -e "${COLOR_VERDE}[5]${COLOR_RESET} Backup de directorio a USB"
    echo ""
    echo -e "${COLOR_ROJO}[6]${COLOR_RESET} Salir"
    echo ""
    echo -e -n "${COLOR_AMARILLO}>${COLOR_RESET} "
}

while true; do
    mostrar_menu
    read opcion
    
    case $opcion in
        1)
            listar_usuarios
            ;;
        2)
            listar_discos
            ;;
        3)
            buscar_archivos_grandes
            ;;
        4)
            mostrar_memoria
            ;;
        5)
            realizar_backup
            ;;
        6)
            echo ""
            echo -e "${COLOR_AMARILLO}Saliendo del programa...${COLOR_RESET}"
            exit 0
            ;;
        *)
            echo ""
            echo -e "${COLOR_ROJO}Opción inválida.${COLOR_RESET} Presione Enter para continuar..."
            read
            ;;
    esac
    
    echo ""
    echo -e "${COLOR_GRIS}Presione Enter para volver al menú...${COLOR_RESET}"
    read
done
