#!/bin/bash

# Módulo: Gestión de Discos
# Función: Listar filesystems, tamaño y espacio libre en bytes

listar_discos() {
    clear
    echo "=========================================="
    echo "  FILESYSTEMS Y ESPACIO DISPONIBLE"
    echo "=========================================="
    echo ""
    
    # Encabezado de la tabla
    printf "%-25s %20s %20s %20s %10s\n" "Filesystem" "Tamaño (bytes)" "Usado (bytes)" "Libre (bytes)" "Uso %"
    echo "--------------------------------------------------------------------------------------------------------"
    
    # Usar df para obtener información de filesystems
    # -B1 para obtener valores en bytes
    # Excluir filesystems temporales y especiales
    local output=$(df -B1 -x tmpfs -x devtmpfs -x squashfs 2>/dev/null | tail -n +2)
    local contador=0
    
    while read -r filesystem blocks used available capacity mounted; do
        # Calcular porcentaje (quitar el símbolo %)
        local uso_pct="${capacity%\%}"
        
        # Determinar color según porcentaje (solo visual en terminal)
        local color=""
        if [[ $uso_pct -gt 90 ]]; then
            color="\033[0;31m"  # Rojo
        elif [[ $uso_pct -gt 75 ]]; then
            color="\033[0;33m"  # Amarillo
        else
            color="\033[0;32m"  # Verde
        fi
        local reset="\033[0m"
        
        # Formatear salida
        printf "%-25s %20s %20s %20s ${color}%9s%%${reset}\n" \
            "$filesystem" "$blocks" "$used" "$available" "$uso_pct"
        
        ((contador++))
    done <<< "$output"
    
    echo ""
    echo "Total de filesystems: $contador"
    echo ""
}
