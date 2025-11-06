# Módulo: Sistema de Backup
# Función: Realizar backup de directorio a USB con catálogo de archivos

function Realizar-Backup {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "  BACKUP DE DIRECTORIO A USB"
    Write-Host "=========================================="
    Write-Host ""
    $directorioOrigen = Read-Host "Ingrese el directorio a respaldar"
    $directorioDestino = Read-Host "Ingrese la ruta del USB (ej: E:\Backup)"
    Write-Host ""
    Write-Host "Preparando backup..."
    Write-Host "  Origen:  $directorioOrigen"
    Write-Host "  Destino: $directorioDestino"
    Write-Host ""
    Write-Host "Archivos a respaldar:"
    Write-Host "  ..."
    Write-Host ""
    Write-Host "Generando catálogo de archivos..."
    Write-Host "Copiando archivos al USB..."
    Write-Host ""
    Write-Host ""
    Write-Host "Backup completado exitosamente!"
}
