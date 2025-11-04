#!/bin/bash

# Módulo: Búsqueda de Archivos
# Función: Encontrar los 10 archivos más grandes en un filesystem

buscar_archivos_grandes() {
    clear
    echo "=========================================="
    echo "  ARCHIVOS MÁS GRANDES"
    echo "=========================================="
    echo ""
    echo -n "Ingrese el filesystem a analizar (ej: /home): "
    read filesystem
    echo ""
    echo "Analizando filesystem: $filesystem"
    echo ""
    echo "Tamaño (bytes)    Archivo"
    echo "--------------------------------------------------------------"
    echo "..."
}
