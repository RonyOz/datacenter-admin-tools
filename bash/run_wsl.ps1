# Script de PowerShell para ejecutar el menú bash en WSL
# Facilita la ejecución desde Windows

param(
    [switch]$Demo,
    [switch]$Test,
    [switch]$Menu
)

$bashPath = "/mnt/c/Users/David Artunduaga/Desktop/Semestre 7/Operative Systems/ProyectoFinal/datacenter-admin-tools/bash"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Herramienta de Administración Data Center" -ForegroundColor Cyan
Write-Host "  Ejecutor WSL" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que WSL está instalado
try {
    $wslCheck = wsl --list --quiet 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: WSL no está instalado o no está funcionando correctamente." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error: No se puede acceder a WSL." -ForegroundColor Red
    exit 1
}

# Preparar archivos (convertir CRLF a LF)
Write-Host "Preparando archivos..." -ForegroundColor Yellow
wsl bash -c "cd '$bashPath' && sed -i 's/\r$//' *.sh modules/*.sh test/*.sh 2>/dev/null"
Write-Host "✓ Archivos preparados" -ForegroundColor Green
Write-Host ""

# Ejecutar según parámetros
if ($Demo) {
    Write-Host "Ejecutando demostración..." -ForegroundColor Cyan
    Write-Host ""
    wsl bash -c "cd '$bashPath' && bash demo.sh"
}
elseif ($Test) {
    Write-Host "Ejecutando tests..." -ForegroundColor Cyan
    Write-Host ""
    wsl bash -c "cd '$bashPath/test' && bash test_funcionalidades.sh"
}
elseif ($Menu) {
    Write-Host "Iniciando menú principal..." -ForegroundColor Cyan
    Write-Host ""
    wsl bash -c "cd '$bashPath' && bash menu.sh"
}
else {
    Write-Host "Uso:" -ForegroundColor Yellow
    Write-Host "  .\run_wsl.ps1 -Menu    # Ejecutar menú principal"
    Write-Host "  .\run_wsl.ps1 -Demo    # Ejecutar demostración"
    Write-Host "  .\run_wsl.ps1 -Test    # Ejecutar tests"
    Write-Host ""
    Write-Host "Ejemplo:" -ForegroundColor Cyan
    Write-Host "  .\run_wsl.ps1 -Demo"
    Write-Host ""
}
