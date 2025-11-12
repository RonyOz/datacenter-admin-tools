#!/bin/bash

buscar_archivos_grandes() {
    clear
    echo ""
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  ARCHIVOS MÁS GRANDES${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo ""
    
    echo -e "${COLOR_VERDE}Filesystems disponibles:${COLOR_RESET}"
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
            
            # Reemplazar punto por coma para compatibilidad con locale
            size_gb="${size_gb/./,}"
            avail_gb="${avail_gb/./,}"
            
            printf "  %d. %-20s (Total: %10s GB, Libre: %10s GB)\n" "$index" "$mounted" "$size_gb" "$avail_gb"
            ((index++))
        fi
    done < <(df -B1 -x tmpfs -x devtmpfs -x squashfs 2>/dev/null | tail -n +2)
    
    if [[ ${#filesystems[@]} -eq 0 ]]; then
        echo -e "${COLOR_ROJO}No se encontraron filesystems disponibles.${COLOR_RESET}"
        echo ""
        return
    fi
    
    echo ""
    echo -e -n "${COLOR_AMARILLO}Seleccione el número del filesystem a analizar: ${COLOR_RESET}"
    read seleccion
    
    if [[ ! "$seleccion" =~ ^[0-9]+$ ]] || [[ $seleccion -lt 1 ]] || [[ $seleccion -ge $index ]]; then
        echo ""
        echo -e "${COLOR_ROJO}Error: Selección inválida.${COLOR_RESET}"
        echo ""
        return
    fi
    
    local filesystem="${filesystems[$seleccion]}"
    
    echo ""
    echo -e "${COLOR_VERDE}Analizando filesystem: $filesystem${COLOR_RESET}"
    echo -e "${COLOR_AMARILLO}Esto puede tomar varios minutos dependiendo del tamaño...${COLOR_RESET}"
    echo ""
    
    printf "${COLOR_VERDE}%-50s %20s  %s${COLOR_RESET}\n" "Nombre del Archivo" "Tamaño (bytes)" "Ruta Completa"
    echo -e "${COLOR_GRIS}--------------------------------------------------------------------------------------------------------${COLOR_RESET}"
    
    # Usar find para buscar archivos y ordenar por tamaño
    find "$filesystem" -type f -printf "%s\t%f\t%p\n" 2>/dev/null | \
        sort -rn | \
        head -10 | \
        while IFS=$'\t' read -r size name path; do
            printf "%-50s %20s  %s\n" "${name:0:50}" "$size" "$path"
        done
    
    echo ""
    echo -e "${COLOR_VERDE}Búsqueda completada.${COLOR_RESET}"
    echo ""
}
