#!/bin/bash

realizar_backup() {
    clear
    echo ""
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  BACKUP DE DIRECTORIO A USB${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo ""
    
    echo -e -n "${COLOR_AMARILLO}Ingrese el directorio a respaldar: ${COLOR_RESET}"
    read directorio_origen
    
    if [ ! -d "$directorio_origen" ]; then
        echo ""
        echo -e "${COLOR_ROJO}Error: El directorio '$directorio_origen' no existe.${COLOR_RESET}"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    echo -e -n "${COLOR_AMARILLO}Ingrese la ruta del USB (ej: /media/usb): ${COLOR_RESET}"
    read directorio_destino
    
    if [ ! -d "$directorio_destino" ]; then
        echo ""
        echo -e "${COLOR_ROJO}Error: El directorio destino '$directorio_destino' no existe.${COLOR_RESET}"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    if [ ! -w "$directorio_destino" ]; then
        echo ""
        echo -e "${COLOR_ROJO}Error: No tiene permisos de escritura en '$directorio_destino'.${COLOR_RESET}"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    echo ""
    echo -e "${COLOR_VERDE}Preparando backup...${COLOR_RESET}"
    echo "  Origen:  $directorio_origen"
    echo "  Destino: $directorio_destino"
    echo ""
    
    nombre_backup="backup_$(date +%Y%m%d_%H%M%S)"
    ruta_backup="$directorio_destino/$nombre_backup"
    
    mkdir -p "$ruta_backup"
    if [ $? -ne 0 ]; then
        echo -e "${COLOR_ROJO}Error: No se pudo crear el directorio de backup.${COLOR_RESET}"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 1
    fi
    
    echo -e "${COLOR_AMARILLO}Directorio de backup: $nombre_backup${COLOR_RESET}"
    echo ""
    
    total_archivos=$(find "$directorio_origen" -type f | wc -l)
    echo -e "${COLOR_VERDE}Total de archivos a respaldar: $total_archivos${COLOR_RESET}"
    echo ""
    
    echo "Archivos a respaldar (primeros 10):"
    find "$directorio_origen" -type f | head -n 10 | while read archivo; do
        echo "  - $(basename "$archivo")"
    done
    if [ $total_archivos -gt 10 ]; then
        echo "  ... y $((total_archivos - 10)) más"
    fi
    echo ""
    
    echo -e -n "${COLOR_AMARILLO}¿Desea continuar con el backup? (s/n): ${COLOR_RESET}"
    read confirmacion
    
    if [[ ! "$confirmacion" =~ ^[sS]$ ]]; then
        echo ""
        echo -e "${COLOR_ROJO}Backup cancelado por el usuario.${COLOR_RESET}"
        rm -rf "$ruta_backup"
        echo ""
        read -p "Presione ENTER para continuar..."
        return 0
    fi
    
    echo ""
    echo -e "${COLOR_VERDE}Generando catálogo de archivos...${COLOR_RESET}"
    
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
    
    echo -e "${COLOR_VERDE}Catálogo generado: $nombre_backup/catalogo.txt${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_AMARILLO}Comprimiendo archivos con tar...${COLOR_RESET}"
    echo ""
    
    # Nombre del archivo tar comprimido
    archivo_tar="$ruta_backup/${nombre_backup}.tar.gz"
    
    if tar -czf "$archivo_tar" -C "$(dirname "$directorio_origen")" "$(basename "$directorio_origen")" 2>/dev/null; then
        echo -e "  ${COLOR_VERDE}[✓] Backup comprimido exitosamente${COLOR_RESET}"
        archivos_copiados=$total_archivos
        archivos_error=0
    else
        echo -e "  ${COLOR_ROJO}[✗] Error al crear el backup comprimido${COLOR_RESET}"
        archivos_copiados=0
        archivos_error=$total_archivos
    fi
    
    echo ""
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}BACKUP COMPLETADO EXITOSAMENTE${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_VERDE}Resumen:${COLOR_RESET}"
    echo "  • Ubicación: $ruta_backup"
    echo "  • Archivo comprimido: ${nombre_backup}.tar.gz"
    echo "  • Total de archivos: $total_archivos"
    if [ $archivos_error -gt 0 ]; then
        echo -e "  • ${COLOR_ROJO}Error al crear el backup${COLOR_RESET}"
    else
        echo "  • Archivos respaldados: $archivos_copiados"
    fi
    echo "  • Catálogo generado: catalogo.txt"
    echo ""
    
    if [ -f "$archivo_tar" ]; then
        tamanio_backup=$(du -sh "$archivo_tar" 2>/dev/null | cut -f1)
        tamanio_original=$(du -sh "$directorio_origen" 2>/dev/null | cut -f1)
        echo "  • Tamaño original: $tamanio_original"
        echo "  • Tamaño comprimido: $tamanio_backup"
    fi
    echo ""
    
    echo "El catálogo se encuentra en:"
    echo -e "   ${COLOR_AMARILLO}$catalogo${COLOR_RESET}"
    echo ""
    echo "El backup comprimido se encuentra en:"
    echo -e "   ${COLOR_AMARILLO}$archivo_tar${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_VERDE}Para restaurar el backup, use:${COLOR_RESET}"
    echo "   tar -xzf $archivo_tar -C /ruta/destino/"
    echo ""
    
    read -p "Presione ENTER para continuar..."
}
