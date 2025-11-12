function Realizar-Backup {
    Clear-Host
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  BACKUP DE DIRECTORIO A USB" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Ingrese el directorio a respaldar: " -ForegroundColor Yellow -NoNewline
    $directorioOrigen = Read-Host
    
    # Validar que el directorio origen existe
    if (-not (Test-Path -Path $directorioOrigen -PathType Container)) {
        Write-Host ""
        Write-Host "Error: El directorio '$directorioOrigen' no existe." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione ENTER para continuar"
        return
    }
    
    Write-Host "Ingrese la ruta del USB (ej: E:\Backup): " -ForegroundColor Yellow -NoNewline
    $directorioDestino = Read-Host
    
    # Validar que el directorio destino existe
    if (-not (Test-Path -Path $directorioDestino -PathType Container)) {
        Write-Host ""
        Write-Host "Error: El directorio destino '$directorioDestino' no existe." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione ENTER para continuar"
        return
    }
    
    # Verificar permisos de escritura en el destino
    try {
        $testFile = Join-Path $directorioDestino "test_write_$(Get-Random).tmp"
        New-Item -Path $testFile -ItemType File -Force | Out-Null
        Remove-Item -Path $testFile -Force
    }
    catch {
        Write-Host ""
        Write-Host "Error: No tiene permisos de escritura en '$directorioDestino'." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione ENTER para continuar"
        return
    }
    
    Write-Host ""
    Write-Host "Preparando backup..." -ForegroundColor Green
    Write-Host "  Origen:  $directorioOrigen"
    Write-Host "  Destino: $directorioDestino"
    Write-Host ""
    
    # Crear nombre de carpeta de backup con fecha y hora
    $nombreBackup = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $rutaBackup = Join-Path $directorioDestino $nombreBackup
    
    # Crear directorio de backup
    try {
        New-Item -Path $rutaBackup -ItemType Directory -Force | Out-Null
    }
    catch {
        Write-Host "Error: No se pudo crear el directorio de backup." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione ENTER para continuar"
        return
    }
    
    Write-Host "Directorio de backup: $nombreBackup" -ForegroundColor Yellow
    Write-Host ""
    
    $archivos = Get-ChildItem -Path $directorioOrigen -File -Recurse -ErrorAction SilentlyContinue
    $totalArchivos = $archivos.Count
    Write-Host "Total de archivos a respaldar: $totalArchivos" -ForegroundColor Green
    Write-Host ""
    
    # Mostrar algunos archivos de ejemplo
    Write-Host "Archivos a respaldar (primeros 10):"
    $archivos | Select-Object -First 10 | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    if ($totalArchivos -gt 10) {
        Write-Host "  ... y $($totalArchivos - 10) más"
    }
    Write-Host ""
    
    Write-Host "¿Desea continuar con el backup? (s/n): " -ForegroundColor Yellow -NoNewline
    $confirmacion = Read-Host
    
    if ($confirmacion -notmatch "^[sS]$") {
        Write-Host ""
        Write-Host "Backup cancelado por el usuario." -ForegroundColor Red
        Remove-Item -Path $rutaBackup -Force -Recurse -ErrorAction SilentlyContinue
        Write-Host ""
        Read-Host "Presione ENTER para continuar"
        return
    }
    
    Write-Host ""
    Write-Host "Generando catálogo de archivos..." -ForegroundColor Green
    
    # Crear archivo de catálogo
    $catalogo = Join-Path $rutaBackup "catalogo.txt"
    
    # Encabezado del catálogo
    $contenidoCatalogo = @"
=========================================
CATÁLOGO DE BACKUP
=========================================
Fecha de backup: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Directorio origen: $directorioOrigen
Total de archivos: $totalArchivos
=========================================

ARCHIVO | FECHA DE MODIFICACIÓN | TAMAÑO
-----------------------------------------

"@
    
    Set-Content -Path $catalogo -Value $contenidoCatalogo -Encoding UTF8
    
    # Generar catálogo con información de cada archivo
    foreach ($archivo in $archivos) {
        # Obtener ruta relativa
        $rutaRelativa = $archivo.FullName.Substring($directorioOrigen.Length).TrimStart('\')
        $fechaModificacion = $archivo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        $tamanio = $archivo.Length
        
        # Convertir tamaño a formato legible
        if ($tamanio -lt 1KB) {
            $tamanioHuman = "$($tamanio)B"
        }
        elseif ($tamanio -lt 1MB) {
            $tamanioHuman = "$([math]::Round($tamanio / 1KB, 2))KB"
        }
        elseif ($tamanio -lt 1GB) {
            $tamanioHuman = "$([math]::Round($tamanio / 1MB, 2))MB"
        }
        else {
            $tamanioHuman = "$([math]::Round($tamanio / 1GB, 2))GB"
        }
        
        Add-Content -Path $catalogo -Value "$rutaRelativa | $fechaModificacion | $tamanioHuman" -Encoding UTF8
    }
    
    Write-Host "Catálogo generado: $nombreBackup\catalogo.txt" -ForegroundColor Green
    Write-Host ""
    Write-Host "Comprimiendo archivos con Compress-Archive..." -ForegroundColor Yellow
    Write-Host ""
    
    # Nombre del archivo ZIP comprimido
    $archivoZip = Join-Path $rutaBackup "$nombreBackup.zip"
    
    # Crear backup comprimido con Compress-Archive
    try {
        Compress-Archive -Path $directorioOrigen -DestinationPath $archivoZip -CompressionLevel Optimal -Force
        Write-Host "  [✓] Backup comprimido exitosamente" -ForegroundColor Green
        $archivosCopiados = $totalArchivos
        $archivosError = 0
    }
    catch {
        Write-Host "  [✗] Error al crear el backup comprimido: $($_.Exception.Message)" -ForegroundColor Red
        $archivosCopiados = 0
        $archivosError = $totalArchivos
    }
    
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "BACKUP COMPLETADO EXITOSAMENTE" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Resumen:" -ForegroundColor Green
    Write-Host "  • Ubicación: $rutaBackup"
    Write-Host "  • Archivo comprimido: $nombreBackup.zip"
    Write-Host "  • Total de archivos: $totalArchivos"
    if ($archivosError -gt 0) {
        Write-Host "  • Error al crear el backup" -ForegroundColor Red
    }
    else {
        Write-Host "  • Archivos respaldados: $archivosCopiados" -ForegroundColor Green
    }
    Write-Host "  • Catálogo generado: catalogo.txt"
    Write-Host ""
    
    # Calcular tamaño del archivo comprimido
    if (Test-Path $archivoZip) {
        $tamanioBackup = (Get-Item $archivoZip).Length
        $tamanioOriginal = (Get-ChildItem -Path $directorioOrigen -Recurse -File | Measure-Object -Property Length -Sum).Sum
        
        # Formatear tamaños
        $tamanioBackupHuman = if ($tamanioBackup -lt 1MB) { 
            "$([math]::Round($tamanioBackup / 1KB, 2)) KB" 
        } elseif ($tamanioBackup -lt 1GB) { 
            "$([math]::Round($tamanioBackup / 1MB, 2)) MB" 
        } else { 
            "$([math]::Round($tamanioBackup / 1GB, 2)) GB" 
        }
        
        $tamanioOriginalHuman = if ($tamanioOriginal -lt 1MB) { 
            "$([math]::Round($tamanioOriginal / 1KB, 2)) KB" 
        } elseif ($tamanioOriginal -lt 1GB) { 
            "$([math]::Round($tamanioOriginal / 1MB, 2)) MB" 
        } else { 
            "$([math]::Round($tamanioOriginal / 1GB, 2)) GB" 
        }
        
        $porcentajeCompresion = [math]::Round((1 - ($tamanioBackup / $tamanioOriginal)) * 100, 2)
        
        Write-Host "  • Tamaño original: $tamanioOriginalHuman"
        Write-Host "  • Tamaño comprimido: $tamanioBackupHuman"
        Write-Host "  • Compresión: $porcentajeCompresion%" -ForegroundColor Yellow
    }
    Write-Host ""
    
    Write-Host "El catálogo se encuentra en:"
    Write-Host "   $catalogo" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "El backup comprimido se encuentra en:"
    Write-Host "   $archivoZip" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Para restaurar el backup, use:" -ForegroundColor Green
    Write-Host "   Expand-Archive -Path '$archivoZip' -DestinationPath 'C:\Ruta\Destino\'" -ForegroundColor Yellow
    Write-Host ""
    
    Read-Host "Presione ENTER para continuar"
}
