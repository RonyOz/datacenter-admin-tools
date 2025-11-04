# Módulo: Monitoreo de Memoria
# Función: Mostrar memoria libre y swap en uso (bytes y porcentaje)

function Mostrar-Memoria {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  INFORMACIÓN DE MEMORIA Y SWAP" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "MEMORIA RAM:" -ForegroundColor Green
    Write-Host "  Total:      ..."
    Write-Host "  En uso:     ..."
    Write-Host "  Libre:      ..."
    Write-Host "  Porcentaje: ...% usado"
    Write-Host ""
    Write-Host "ARCHIVO DE PAGINACIÓN (Page File):" -ForegroundColor Green
    Write-Host "  Total:      ..."
    Write-Host "  En uso:     ..."
    Write-Host "  Libre:      ..."
    Write-Host "  Porcentaje: ...% usado"
    Write-Host ""
}
