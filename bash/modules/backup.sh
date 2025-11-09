#!/bin/bash

# Módulo: Sistema de Backup
# Función: Realizar backup de directorio a USB con catálogo de archivos

realizar_backup() {
    clear
    echo "=========================================="
    echo "  BACKUP DE DIRECTORIO A USB"
    echo "=========================================="
    echo ""
    
    # Solicitar directorio origen
    echo -n "Ingrese el directorio a respaldar: "
    read directorio_origen
    
    # Validar que el directorio origen existe
    if [ ! -d "$directorio_origen" ]; then
        echo ""
        echo "Error: El directorio '$directorio_origen' no existe."
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    # Solicitar directorio destino (USB)
    echo -n "Ingrese la ruta del USB (ej: /media/usb): "
    read directorio_destino
    
    # Validar que el directorio destino existe
    if [ ! -d "$directorio_destino" ]; then
        echo ""
        echo "Error: El directorio destino '$directorio_destino' no existe."
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    # Verificar permisos de escritura en el destino
    if [ ! -w "$directorio_destino" ]; then
        echo ""
        echo "Error: No tiene permisos de escritura en '$directorio_destino'."
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    echo ""
    echo "Preparando backup..."
    echo "  Origen:  $directorio_origen"
    echo "  Destino: $directorio_destino"
    echo ""
    
    # Crear nombre de carpeta de backup con fecha y hora
    nombre_backup="backup_$(date +%Y%m%d_%H%M%S)"
    ruta_backup="$directorio_destino/$nombre_backup"
    
    # Crear directorio de backup
    mkdir -p "$ruta_backup"
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo crear el directorio de backup."
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    echo "Directorio de backup: $nombre_backup"
    echo ""
    
    # Contar archivos a respaldar
    total_archivos=$(find "$directorio_origen" -type f | wc -l)
    echo "Total de archivos a respaldar: $total_archivos"
    echo ""
    
    # Mostrar algunos archivos de ejemplo
    echo "Archivos a respaldar (primeros 10):"
    find "$directorio_origen" -type f | head -n 10 | while read archivo; do
        echo "  - $(basename "$archivo")"
    done
    if [ $total_archivos -gt 10 ]; then
        echo "  ... y $((total_archivos - 10)) más"
    fi
    echo ""
    
    # Confirmación del usuario
    echo -n "¿Desea continuar con el backup? (s/n): "
    read confirmacion
    
    if [[ ! "$confirmacion" =~ ^[sS]$ ]]; then
        echo ""
        echo "Backup cancelado por el usuario."
        rm -rf "$ruta_backup"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 0
    fi
    
    echo ""
    echo "Generando catálogo de archivos..."
    
    # Crear archivo de catálogo
    catalogo="$ruta_backup/catalogo.txt"
    
    # Encabezado del catálogo
    echo "=========================================" > "$catalogo"
    echo "CATÁLOGO DE BACKUP" >> "$catalogo"
    echo "=========================================" >> "$catalogo"
    echo "Fecha de backup: $(date '+%Y-%m-%d %H:%M:%S')" >> "$catalogo"
    echo "Directorio origen: $directorio_origen" >> "$catalogo"
    echo "Total de archivos: $total_archivos" >> "$catalogo"
    echo "=========================================" >> "$catalogo"
    echo "" >> "$catalogo"
    echo "ARCHIVO | FECHA DE MODIFICACIÓN | TAMAÑO" >> "$catalogo"
    echo "-----------------------------------------" >> "$catalogo"
    
    # Generar catálogo con información de cada archivo
    while IFS= read -r archivo; do
        ruta_relativa="${archivo#$directorio_origen/}"
        fecha_modificacion=$(stat -c "%y" "$archivo" 2>/dev/null | cut -d'.' -f1)
        tamanio=$(stat -c "%s" "$archivo" 2>/dev/null)
        
        # Convertir tamaño a formato legible
        if [ $tamanio -lt 1024 ]; then
            tamanio_human="${tamanio}B"
        elif [ $tamanio -lt 1048576 ]; then
            tamanio_human="$(( tamanio / 1024 ))KB"
        else
            tamanio_human="$(( tamanio / 1048576 ))MB"
        fi
        
        echo "$ruta_relativa | $fecha_modificacion | $tamanio_human" >> "$catalogo"
    done < <(find "$directorio_origen" -type f)
    
    echo "Catálogo generado: $nombre_backup/catalogo.txt"
    echo ""
    echo "Comprimiendo archivos con tar..."
    echo ""
    
    # Nombre del archivo tar comprimido
    archivo_tar="$ruta_backup/${nombre_backup}.tar.gz"
    
    # Crear backup comprimido con tar
    # -c: crear archivo
    # -z: comprimir con gzip
    # -f: especificar nombre de archivo
    # -v: modo verbose (mostrar progreso)
    # -p: preservar permisos
    if tar -czf "$archivo_tar" -C "$(dirname "$directorio_origen")" "$(basename "$directorio_origen")" 2>/dev/null; then
        echo "  [✓] Backup comprimido exitosamente"
        archivos_copiados=$total_archivos
        archivos_error=0
    else
        echo "  [✗] Error al crear el backup comprimido"
        archivos_copiados=0
        archivos_error=$total_archivos
    fi
    
    echo ""
    echo "=========================================="
    echo "BACKUP COMPLETADO EXITOSAMENTE"
    echo "=========================================="
    echo ""
    echo "Resumen:"
    echo "  • Ubicación: $ruta_backup"
    echo "  • Archivo comprimido: ${nombre_backup}.tar.gz"
    echo "  • Total de archivos: $total_archivos"
    if [ $archivos_error -gt 0 ]; then
        echo "  • Error al crear el backup"
    else
        echo "  • Archivos respaldados: $archivos_copiados"
    fi
    echo "  • Catálogo generado: catalogo.txt"
    echo ""
    
    # Calcular tamaño del archivo comprimido
    if [ -f "$archivo_tar" ]; then
        tamanio_backup=$(du -sh "$archivo_tar" 2>/dev/null | cut -f1)
        tamanio_original=$(du -sh "$directorio_origen" 2>/dev/null | cut -f1)
        echo "  • Tamaño original: $tamanio_original"
        echo "  • Tamaño comprimido: $tamanio_backup"
    fi
    echo ""
    
    # Mostrar ubicación del catálogo y backup
    echo "El catálogo se encuentra en:"
    echo "   $catalogo"
    echo ""
    echo "El backup comprimido se encuentra en:"
    echo "   $archivo_tar"
    echo ""
    echo "Para restaurar el backup, use:"
    echo "   tar -xzf $archivo_tar -C /ruta/destino/"
    echo ""
    
    read -p "Presione ENTER para continuar..."
}
