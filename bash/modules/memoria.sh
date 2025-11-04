#!/bin/bash

# Módulo: Monitoreo de Memoria
# Función: Mostrar memoria libre y swap en uso (bytes y porcentaje)

mostrar_memoria() {
    clear
    echo "=========================================="
    echo "  INFORMACIÓN DE MEMORIA Y SWAP"
    echo "=========================================="
    echo ""
    echo "MEMORIA RAM:"
    echo "  Total:      ..."
    echo "  En uso:     ..."
    echo "  Libre:      ..."
    echo "  Porcentaje: ...% usado"
    echo ""
    echo "MEMORIA SWAP:"
    echo "  Total:      ..."
    echo "  En uso:     ..."
    echo "  Libre:      ..."
    echo "  Porcentaje: ...% usado"
    echo ""
}
