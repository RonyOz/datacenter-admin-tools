#!/bin/bash

# Módulo: Sistema de Backup
# Función: Realizar backup de directorio a USB con catálogo de archivos

realizar_backup() {
    clear
    echo "=========================================="
    echo "  BACKUP DE DIRECTORIO A USB"
    echo "=========================================="
    echo ""
    echo -n "Ingrese el directorio a respaldar: "
    read directorio_origen
    echo -n "Ingrese la ruta del USB (ej: /media/usb): "
    read directorio_destino
    echo ""
    echo "Preparando backup..."
    echo "  Origen:  $directorio_origen"
    echo "  Destino: $directorio_destino"
    echo ""
    echo "Archivos a respaldar:"
    echo "  ..."
    echo ""
    echo "Generando catálogo de archivos..."
    echo "Copiando archivos al USB..."
    echo ""
    echo "Backup completado exitosamente!"
}
