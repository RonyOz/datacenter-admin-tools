#!/bin/bash

# Script de demostración completa - Todas las funcionalidades
# Herramienta de Administración para Data Center

# Cargar todos los módulos
source ./modules/usuarios.sh
source ./modules/discos.sh
source ./modules/memoria.sh

clear
echo "============================================="
echo "  DEMOSTRACIÓN COMPLETA"
echo "  Herramienta de Administración Data Center"
echo "  Versión BASH"
echo "============================================="
echo ""
echo "Esta demostración mostrará las siguientes funcionalidades:"
echo ""
echo "  1. Usuarios y último login"
echo "  2. Filesystems y espacio disponible"
echo "  3. Información de memoria y swap"
echo ""
echo "Nota: La funcionalidad de archivos grandes requiere"
echo "      selección interactiva y puede tardar varios minutos."
echo ""
echo "Presione Enter para comenzar la demostración..."
read

# ===================================
# 1. USUARIOS Y ÚLTIMO LOGIN
# ===================================
clear
echo "============================================="
echo "  FUNCIONALIDAD 1: USUARIOS Y ÚLTIMO LOGIN"
echo "============================================="
echo ""
echo "Presione Enter para ver los usuarios del sistema..."
read

listar_usuarios

echo "Presione Enter para continuar..."
read

# ===================================
# 2. FILESYSTEMS Y ESPACIO DISPONIBLE
# ===================================
clear
echo "============================================="
echo "  FUNCIONALIDAD 2: FILESYSTEMS Y ESPACIO"
echo "============================================="
echo ""
echo "Presione Enter para ver los filesystems..."
read

listar_discos

echo "Presione Enter para continuar..."
read

# ===================================
# 3. INFORMACIÓN DE MEMORIA Y SWAP
# ===================================
clear
echo "============================================="
echo "  FUNCIONALIDAD 3: MEMORIA Y SWAP"
echo "============================================="
echo ""
echo "Presione Enter para ver información de memoria..."
read

mostrar_memoria

echo "Presione Enter para continuar..."
read

# ===================================
# RESUMEN FINAL
# ===================================
clear
echo "============================================="
echo "  DEMOSTRACIÓN COMPLETADA ✓"
echo "============================================="
echo ""
echo "Funcionalidades demostradas:"
echo "  ✓ Usuarios y último login"
echo "  ✓ Filesystems y espacio disponible"
echo "  ✓ Información de memoria y swap"
echo ""
echo "-------------------------------------------"
echo "  INFORMACIÓN DEL SISTEMA"
echo "-------------------------------------------"
echo ""
echo "Sistema operativo:"
uname -a
echo ""
echo "Distribución:"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "  $PRETTY_NAME"
else
    echo "  Desconocida"
fi
echo ""
echo "Usuario actual:"
echo "  $(whoami)"
echo ""
echo "Fecha y hora:"
echo "  $(date)"
echo ""
echo "============================================="
echo "  Para usar el menú interactivo ejecute:"
echo "  ./menu.sh"
echo "============================================="
echo ""
