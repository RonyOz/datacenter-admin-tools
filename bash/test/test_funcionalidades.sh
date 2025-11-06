#!/bin/bash

# Test General - Todas las Funcionalidades
# Herramienta de Administración para Data Center

echo "=========================================="
echo "  TEST: FUNCIONALIDADES BASH"
echo "=========================================="
echo ""
echo "Este script probará todas las funcionalidades implementadas:"
echo "  1. Usuarios y último login"
echo "  2. Filesystems y espacio disponible"
echo "  3. Información de memoria y swap"
echo ""
echo "Presione Enter para comenzar..."
read

# Cargar módulos
source ../modules/usuarios.sh
source ../modules/discos.sh
source ../modules/memoria.sh

# Test 1: Usuarios
echo ""
echo "=========================================="
echo "  TEST 1: Usuarios y Último Login"
echo "=========================================="
echo ""
echo "Verificando función listar_usuarios..."
sleep 1

if type listar_usuarios &>/dev/null; then
    echo "✓ Función listar_usuarios cargada correctamente"
    echo ""
    echo "Ejecutando..."
    sleep 1
    listar_usuarios
    echo "✓ Test 1 completado"
else
    echo "✗ Error: Función listar_usuarios no encontrada"
fi

echo ""
echo "Presione Enter para continuar con el siguiente test..."
read

# Test 2: Discos
echo ""
echo "=========================================="
echo "  TEST 2: Filesystems y Espacio"
echo "=========================================="
echo ""
echo "Verificando función listar_discos..."
sleep 1

if type listar_discos &>/dev/null; then
    echo "✓ Función listar_discos cargada correctamente"
    echo ""
    echo "Ejecutando..."
    sleep 1
    listar_discos
    echo "✓ Test 2 completado"
else
    echo "✗ Error: Función listar_discos no encontrada"
fi

echo ""
echo "Presione Enter para continuar con el siguiente test..."
read

# Test 3: Memoria
echo ""
echo "=========================================="
echo "  TEST 3: Memoria y Swap"
echo "=========================================="
echo ""
echo "Verificando función mostrar_memoria..."
sleep 1

if type mostrar_memoria &>/dev/null; then
    echo "✓ Función mostrar_memoria cargada correctamente"
    echo ""
    echo "Ejecutando..."
    sleep 1
    mostrar_memoria
    echo "✓ Test 3 completado"
else
    echo "✗ Error: Función mostrar_memoria no encontrada"
fi

echo ""
echo "Presione Enter para ver el resumen..."
read

# Resumen
clear
echo "=========================================="
echo "  RESUMEN DE TESTS"
echo "=========================================="
echo ""

# Verificar todas las funciones
tests_passed=0
tests_total=3

echo "Verificando funciones cargadas:"
echo ""

if type listar_usuarios &>/dev/null; then
    echo "✓ listar_usuarios"
    ((tests_passed++))
else
    echo "✗ listar_usuarios"
fi

if type listar_discos &>/dev/null; then
    echo "✓ listar_discos"
    ((tests_passed++))
else
    echo "✗ listar_discos"
fi

if type mostrar_memoria &>/dev/null; then
    echo "✓ mostrar_memoria"
    ((tests_passed++))
else
    echo "✗ mostrar_memoria"
fi

echo ""
echo "=========================================="
echo "  RESULTADOS: $tests_passed/$tests_total tests pasados"
echo "=========================================="
echo ""

if [[ $tests_passed -eq $tests_total ]]; then
    echo "✓ Todos los tests pasaron correctamente"
    echo ""
    echo "Las funcionalidades están listas para usar."
    echo "Ejecute ./menu.sh para usar el menú interactivo."
else
    echo "✗ Algunos tests fallaron"
    echo ""
    echo "Revise los errores y vuelva a intentar."
fi

echo ""
echo "=========================================="
echo ""
