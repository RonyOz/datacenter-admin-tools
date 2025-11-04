# Módulo: Búsqueda de Archivos
# Función: Encontrar los 10 archivos más grandes en un filesystem

function Buscar-ArchivosGrandes {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  ARCHIVOS MÁS GRANDES" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    $filesystem = Read-Host "Ingrese la unidad a analizar (ej: C:\)"
    Write-Host ""
    Write-Host "Analizando unidad: $filesystem" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tamaño (bytes)    Archivo"
    Write-Host "--------------------------------------------------------------"
    Write-Host "..."
    Write-Host ""
}
