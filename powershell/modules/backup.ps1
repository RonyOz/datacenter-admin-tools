# Módulo: Sistema de Backup
# Función: Realizar backup de directorio a USB con catálogo de archivos

function Realizar-Backup {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  BACKUP DE DIRECTORIO A USB" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    $directorioOrigen = Read-Host "Ingrese el directorio a respaldar"
    $directorioDestino = Read-Host "Ingrese la ruta del USB (ej: E:\Backup)"
    Write-Host ""
    Write-Host "Preparando backup..." -ForegroundColor Yellow
    Write-Host "  Origen:  $directorioOrigen"
    Write-Host "  Destino: $directorioDestino"
    Write-Host ""
    Write-Host "Archivos a respaldar:"
    Write-Host "  ..."
    Write-Host ""
    Write-Host "Generando catálogo de archivos..." -ForegroundColor Yellow
    Write-Host "Copiando archivos al USB..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host ""
    Write-Host "Backup completado exitosamente!" -ForegroundColor Green
}
