#!/bin/bash

# Herramienta de Administración para Data Center
# Menu Principal

source ./modules/usuarios.sh
source ./modules/discos.sh
source ./modules/archivos_grandes.sh
source ./modules/memoria.sh
source ./modules/backup.sh

mostrar_menu() {
    clear
    echo "=========================================="
    echo "  HERRAMIENTAS DE ADMINISTRACIÓN"
    echo "  DATA CENTER - Versión BASH"
    echo "=========================================="
    echo ""
    echo "1. Usuarios y último login"
    echo "2. Filesystems y espacio disponible"
    echo "3. Archivos más grandes en un disco"
    echo "4. Información de memoria y swap"
    echo "5. Backup de directorio a USB"
    echo "6. Salir"
    echo ""
    echo -n "Seleccione una opción: "
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
            echo "Saliendo del programa..."
            exit 0
            ;;
        *)
            echo ""
            echo "Opción inválida. Presione Enter para continuar..."
            read
            ;;
    esac
    
    echo ""
    echo "Presione Enter para volver al menú..."
    read
done
