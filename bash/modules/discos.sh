#!/bin/bash

listar_discos() {
    clear
    echo ""
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  FILESYSTEMS Y ESPACIO DISPONIBLE${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==========================================${COLOR_RESET}"
    echo ""
    
    printf "${COLOR_VERDE}%-25s %20s %20s %20s %10s${COLOR_RESET}\n" "Filesystem" "Tamaño (bytes)" "Usado (bytes)" "Libre (bytes)" "Uso %"
    echo -e "${COLOR_GRIS}--------------------------------------------------------------------------------------------------------${COLOR_RESET}"
    
    # Usar df para obtener información de filesystems
    # -B1 para obtener valores en bytes
    # Excluir filesystems temporales y especiales
    local output=$(df -B1 -x tmpfs -x devtmpfs -x squashfs 2>/dev/null | tail -n +2)
    local contador=0
    
    while read -r filesystem blocks used available capacity mounted; do
        # Calcular porcentaje (quitar el símbolo %)
        local uso_pct="${capacity%\%}"
        
        # Formatear salida
        printf "%-25s %20s %20s %20s %9s%%\n" \
            "$filesystem" "$blocks" "$used" "$available" "$uso_pct"
        
        ((contador++))
    done <<< "$output"
    
    echo ""
    echo -e "${COLOR_AMARILLO}Total de filesystems: $contador${COLOR_RESET}"
    echo ""
}
