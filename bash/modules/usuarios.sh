#!/bin/bash

# Módulo: Gestión de Usuarios
# Función: Desplegar usuarios y fecha/hora de último login

listar_usuarios() {
    clear
    echo "=========================================="
    echo "  USUARIOS Y ÚLTIMO LOGIN"
    echo "=========================================="
    echo ""
    
    # Encabezado de la tabla
    printf "%-20s %-30s %-15s\n" "Usuario" "Último Login" "Estado"
    echo "-----------------------------------------------------------------------"
    
    # Obtener lista de usuarios del sistema con UID >= 1000 (usuarios normales)
    # y también incluir root (UID 0)
    local contador=0
    
    # Procesar usuarios
    while IFS=: read -r username _ uid _ _ homedir shell; do
        # Filtrar usuarios del sistema (UID >= 1000) y con shell válido
        if [[ $uid -ge 1000 || $uid -eq 0 ]] && [[ "$shell" != *"nologin"* ]] && [[ "$shell" != *"false"* ]]; then
            local ultimo_login
            
            # Intentar obtener último login con lastlog
            if command -v lastlog &>/dev/null; then
                ultimo_login=$(lastlog -u "$username" 2>/dev/null | tail -n 1 | awk '{
                    if ($4 == "") print "Nunca";
                    else print $4, $5, $6, $7, $9
                }')
            fi
            
            # Si no se encontró información, marcar como "Nunca"
            [[ -z "$ultimo_login" || "$ultimo_login" == *"Never"* ]] && ultimo_login="Nunca"
            
            # Determinar si el usuario está activo
            local estado="Activo"
            if [[ "$shell" == *"nologin"* ]] || [[ "$shell" == *"false"* ]]; then
                estado="Deshabilitado"
            fi
            
            printf "%-20s %-30s %-15s\n" "$username" "$ultimo_login" "$estado"
            ((contador++))
        fi
    done < /etc/passwd
    
    echo ""
    echo "Total de usuarios: $contador"
    echo ""
}
