# Test: Verificar que el menú de selección de unidades funciona correctamente
# Importar el módulo
. ..\modules\archivos_grandes.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TEST: Menú de Archivos Grandes" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este test verificará que:" -ForegroundColor Yellow
Write-Host "  1. Se muestran las unidades del sistema enumeradas" -ForegroundColor White
Write-Host "  2. Se puede seleccionar una unidad por número" -ForegroundColor White
Write-Host "  3. Se buscan los 10 archivos más grandes" -ForegroundColor White
Write-Host ""
Write-Host "Presione Enter para continuar..." -ForegroundColor Gray
Read-Host
Write-Host ""

# Ejecutar la función
Buscar-ArchivosGrandes
