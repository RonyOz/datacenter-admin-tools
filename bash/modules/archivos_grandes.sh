#!/bin/bash

# Módulo: Búsqueda de Archivos
# Función: Encontrar los 10 archivos más grandes en un filesystem

buscar_archivos_grandes() {
    clear
    echo "=========================================="
    echo "  ARCHIVOS MÁS GRANDES"
    echo "=========================================="
    echo ""
    
    # Mostrar menú de filesystems disponibles
    echo "Filesystems disponibles:"
    echo ""
    
    local -a filesystems
    local index=1
    
    # Obtener lista de puntos de montaje
    while read -r filesystem size used avail percent mounted; do
        if [[ -n "$mounted" && "$mounted" != "/dev" && "$mounted" != "/sys" && "$mounted" != "/proc" ]]; then
            filesystems[$index]="$mounted"
            
            # Convertir a GB para mostrar
            local size_gb=$(echo "scale=2; $size / (1024*1024*1024)" | bc 2>/dev/null || echo "0")
            local avail_gb=$(echo "scale=2; $avail / (1024*1024*1024)" | bc 2>/dev/null || echo "0")
            
            printf "  %d. %-20s (Total: %10.2f GB, Libre: %10.2f GB)\n" "$index" "$mounted" "$size_gb" "$avail_gb"
            ((index++))
        fi
    done < <(df -B1 -x tmpfs -x devtmpfs -x squashfs 2>/dev/null | tail -n +2)
    
    # Si no hay filesystems, salir
    if [[ ${#filesystems[@]} -eq 0 ]]; then
        echo "No se encontraron filesystems disponibles."
        echo ""
        return
    fi
    
    echo ""
    echo -n "Seleccione el número del filesystem a analizar: "
    read seleccion
    
    # Validar selección
    if [[ ! "$seleccion" =~ ^[0-9]+$ ]] || [[ $seleccion -lt 1 ]] || [[ $seleccion -ge $index ]]; then
        echo ""
        echo "Error: Selección inválida."
        echo ""
        return
    fi
    
    local filesystem="${filesystems[$seleccion]}"
    
    echo ""
    echo "Analizando filesystem: $filesystem"
    echo "Esto puede tomar varios minutos dependiendo del tamaño..."
    echo ""
    
    # Buscar los 10 archivos más grandes
    printf "%-50s %20s  %s\n" "Nombre del Archivo" "Tamaño (bytes)" "Ruta Completa"
    echo "--------------------------------------------------------------------------------------------------------"
    
    # Usar find para buscar archivos y ordenar por tamaño
    find "$filesystem" -type f -printf "%s\t%f\t%p\n" 2>/dev/null | \
        sort -rn | \
        head -10 | \
        while IFS=$'\t' read -r size name path; do
            printf "%-50s %20s  %s\n" "${name:0:50}" "$size" "$path"
        done
    
    echo ""
    echo "Búsqueda completada."
    echo ""
}
