#!/bin/bash

# Módulo: Monitoreo de Memoria
# Función: Mostrar memoria libre y swap en uso (bytes y porcentaje)

mostrar_memoria() {
    clear
    echo "=========================================="
    echo "  INFORMACIÓN DE MEMORIA Y SWAP"
    echo "=========================================="
    echo ""
    
    # Leer información de /proc/meminfo
    if [[ ! -f /proc/meminfo ]]; then
        echo "Error: No se puede acceder a /proc/meminfo"
        echo ""
        return
    fi
    
    # Obtener valores de memoria en KB y convertir a bytes
    local mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
    local mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    local buffers=$(grep Buffers /proc/meminfo | awk '{print $2}')
    local cached=$(grep "^Cached:" /proc/meminfo | awk '{print $2}')
    
    # Convertir a bytes (multiplicar por 1024)
    mem_total=$((mem_total * 1024))
    mem_free=$((mem_free * 1024))
    mem_available=$((mem_available * 1024))
    buffers=$((buffers * 1024))
    cached=$((cached * 1024))
    
    # Calcular memoria usada
    local mem_used=$((mem_total - mem_available))
    
    # Calcular porcentaje
    local mem_percent=0
    if [[ $mem_total -gt 0 ]]; then
        mem_percent=$(echo "scale=2; ($mem_used * 100) / $mem_total" | bc)
    fi
    
    # Convertir a GB para mejor legibilidad
    local mem_total_gb=$(echo "scale=2; $mem_total / (1024*1024*1024)" | bc)
    local mem_used_gb=$(echo "scale=2; $mem_used / (1024*1024*1024)" | bc)
    local mem_available_gb=$(echo "scale=2; $mem_available / (1024*1024*1024)" | bc)
    
    # Determinar color según porcentaje
    local color=""
    local reset="\033[0m"
    if (( $(echo "$mem_percent > 90" | bc -l) )); then
        color="\033[0;31m"  # Rojo
    elif (( $(echo "$mem_percent > 75" | bc -l) )); then
        color="\033[0;33m"  # Amarillo
    else
        color="\033[0;32m"  # Verde
    fi
    
    echo "MEMORIA RAM:"
    printf "  Total:      %20s bytes (%s GB)\n" "$mem_total" "$mem_total_gb"
    printf "  En uso:     %20s bytes (%s GB)\n" "$mem_used" "$mem_used_gb"
    printf "  Disponible: %20s bytes (%s GB)\n" "$mem_available" "$mem_available_gb"
    echo -e "  Porcentaje: ${color}${mem_percent}% usado${reset}"
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
    
    # Determinar color según porcentaje de swap
    local swap_color=""
    if [[ $swap_total -eq 0 ]]; then
        swap_color="\033[0;33m"  # Amarillo si no hay swap
    elif (( $(echo "$swap_percent > 90" | bc -l) )); then
        swap_color="\033[0;31m"  # Rojo
    elif (( $(echo "$swap_percent > 75" | bc -l) )); then
        swap_color="\033[0;33m"  # Amarillo
    else
        swap_color="\033[0;32m"  # Verde
    fi
    
    echo "MEMORIA SWAP:"
    if [[ $swap_total -eq 0 ]]; then
        echo -e "  ${swap_color}No hay memoria swap configurada${reset}"
    else
        printf "  Total:      %20s bytes (%s GB)\n" "$swap_total" "$swap_total_gb"
        printf "  En uso:     %20s bytes (%s GB)\n" "$swap_used" "$swap_used_gb"
        printf "  Libre:      %20s bytes (%s GB)\n" "$swap_free" "$swap_free_gb"
        echo -e "  Porcentaje: ${swap_color}${swap_percent}% usado${reset}"
    fi
    echo ""
}
