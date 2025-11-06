# Test: Verificar el nuevo formato con nombre de archivo
Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  TEST: Nuevo Formato de Archivos" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Simular búsqueda de archivos grandes en la carpeta del proyecto
$rutaPrueba = "C:\Users\David Artunduaga\Desktop\Semestre 7\Operative Systems\ProyectoFinal\datacenter-admin-tools"

Write-Host "Buscando los 10 archivos más grandes en:" -ForegroundColor Yellow
Write-Host $rutaPrueba -ForegroundColor Cyan
Write-Host ""
Write-Host "Esto es solo una demostración del nuevo formato..." -ForegroundColor Gray
Write-Host ""

$archivos = Get-ChildItem -Path $rutaPrueba -File -Recurse -ErrorAction SilentlyContinue | 
            Sort-Object Length -Descending | 
            Select-Object -First 10

if ($archivos.Count -eq 0) {
    Write-Host "No se encontraron archivos." -ForegroundColor Red
} else {
    # Mostrar encabezado con las tres columnas: Nombre, Tamaño, Ruta
    Write-Host ("{0,-50}  {1,20}  {2}" -f "Nombre del Archivo", "Tamaño (bytes)", "Ruta Completa") -ForegroundColor Yellow
    Write-Host ("-" * 130) -ForegroundColor Gray
    
    foreach ($archivo in $archivos) {
        $nombre = $archivo.Name
        $tamano = $archivo.Length
        $ruta = $archivo.FullName
        
        # Determinar color según tamaño
        $color = if ($tamano -gt 1GB) { "Red" }
                elseif ($tamano -gt 100MB) { "Yellow" }
                else { "White" }
        
        Write-Host ("{0,-50}  {1,20:N0}  " -f $nombre, $tamano) -NoNewline
        Write-Host $ruta -ForegroundColor $color
    }
    
    Write-Host ""
    Write-Host "Total de archivos encontrados: $($archivos.Count)" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  FORMATO VERIFICADO ✓" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ahora la salida incluye:" -ForegroundColor Yellow
Write-Host "  1. Nombre del Archivo (columna izquierda)" -ForegroundColor White
Write-Host "  2. Tamaño en bytes (columna central)" -ForegroundColor White
Write-Host "  3. Ruta completa (columna derecha con color)" -ForegroundColor White
Write-Host ""
