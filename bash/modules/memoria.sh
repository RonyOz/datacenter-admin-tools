#!/bin/bash

mostrar_memoria() {
    clear
    echo ""
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  INFORMACIÓN DE MEMORIA Y SWAP${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo ""
    
    if [[ ! -f /proc/meminfo ]]; then
        echo -e "${COLOR_ROJO}Error: No se puede acceder a /proc/meminfo${COLOR_RESET}"
        echo ""
        return
    fi
    
    # Obtener valores de memoria en KB
    local mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    
    # Convertir a bytes
    mem_total=$((mem_total * 1024))
    mem_available=$((mem_available * 1024))
    
    # Calcular memoria usada
    local mem_used=$((mem_total - mem_available))
    
    # Calcular porcentaje de memoria usada
    local mem_percent=0
    if [[ $mem_total -gt 0 ]]; then
        mem_percent=$(echo "scale=2; ($mem_used * 100) / $mem_total" | bc)
    fi
    
    # Convertir a GB
    local mem_total_gb=$(echo "scale=2; $mem_total / (1024*1024*1024)" | bc)
    local mem_used_gb=$(echo "scale=2; $mem_used / (1024*1024*1024)" | bc)
    local mem_available_gb=$(echo "scale=2; $mem_available / (1024*1024*1024)" | bc)
    
    echo -e "${COLOR_VERDE}MEMORIA RAM:${COLOR_RESET}"
    printf "  Total:      %20s bytes (%s GB)\n" "$mem_total" "$mem_total_gb"
    printf "  En uso:     %20s bytes (%s GB)\n" "$mem_used" "$mem_used_gb"
    printf "  Disponible: %20s bytes (%s GB)\n" "$mem_available" "$mem_available_gb"
    printf "  Porcentaje: ${COLOR_AMARILLO}%s%% usado${COLOR_RESET}\n" "$mem_percent"
    echo ""
    
    # Obtener información de SWAP
    local swap_total=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
    local swap_free=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    
    # Convertir a bytes
    swap_total=$((swap_total * 1024))
    swap_free=$((swap_free * 1024))
    
    # Calcular swap usado
    local swap_used=$((swap_total - swap_free))
    
    # Calcular porcentaje de swap
    local swap_percent=0
    if [[ $swap_total -gt 0 ]]; then
        swap_percent=$(echo "scale=2; ($swap_used * 100) / $swap_total" | bc)
    fi
    
    # Convertir a GB
    local swap_total_gb=$(echo "scale=2; $swap_total / (1024*1024*1024)" | bc)
    local swap_used_gb=$(echo "scale=2; $swap_used / (1024*1024*1024)" | bc)
    local swap_free_gb=$(echo "scale=2; $swap_free / (1024*1024*1024)" | bc)
    
    echo -e "${COLOR_VERDE}MEMORIA SWAP:${COLOR_RESET}"
    if [[ $swap_total -eq 0 ]]; then
        echo -e "  ${COLOR_AMARILLO}No hay memoria swap configurada${COLOR_RESET}"
    else
        printf "  Total:      %20s bytes (%s GB)\n" "$swap_total" "$swap_total_gb"
        printf "  En uso:     %20s bytes (%s GB)\n" "$swap_used" "$swap_used_gb"
        printf "  Libre:      %20s bytes (%s GB)\n" "$swap_free" "$swap_free_gb"
        printf "  Porcentaje: ${COLOR_AMARILLO}%s%% usado${COLOR_RESET}\n" "$swap_percent"
    fi
    echo ""
}
