function Mostrar-Memoria {
    Clear-Host
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  INFORMACIÓN DE MEMORIA Y SWAP" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        $totalRAM = $os.TotalVisibleMemorySize * 1KB
        $ramLibre = $os.FreePhysicalMemory * 1KB
        $ramUsada = $totalRAM - $ramLibre
        $porcentajeRAM = [math]::Round(($ramUsada / $totalRAM) * 100, 2)
        
        Write-Host "MEMORIA RAM:" -ForegroundColor Green
        Write-Host ("  Total:      {0,20:N0} bytes ({1:N2} GB)" -f $totalRAM, ($totalRAM / 1GB))
        Write-Host ("  En uso:     {0,20:N0} bytes ({1:N2} GB)" -f $ramUsada, ($ramUsada / 1GB))
        Write-Host ("  Libre:      {0,20:N0} bytes ({1:N2} GB)" -f $ramLibre, ($ramLibre / 1GB))
        Write-Host ("  Porcentaje: {0:N2}% usado" -f $porcentajeRAM) -ForegroundColor Yellow
        
        Write-Host ""
        
        $pageFile = Get-CimInstance -ClassName Win32_PageFileUsage
        
        if ($pageFile) {
            $totalPageFile = $pageFile.AllocatedBaseSize * 1MB
            $usadoPageFile = $pageFile.CurrentUsage * 1MB
            $librePageFile = $totalPageFile - $usadoPageFile
            $porcentajePageFile = if ($totalPageFile -gt 0) {
                [math]::Round(($usadoPageFile / $totalPageFile) * 100, 2)
            } else {
                0
            }
            
            Write-Host "ARCHIVO DE PAGINACIÓN (Page File / Swap):" -ForegroundColor Green
            Write-Host ("  Ubicación:  {0}" -f $pageFile.Name)
            Write-Host ("  Total:      {0,20:N0} bytes ({1:N2} GB)" -f $totalPageFile, ($totalPageFile / 1GB))
            Write-Host ("  En uso:     {0,20:N0} bytes ({1:N2} GB)" -f $usadoPageFile, ($usadoPageFile / 1GB))
            Write-Host ("  Libre:      {0,20:N0} bytes ({1:N2} GB)" -f $librePageFile, ($librePageFile / 1GB))
            Write-Host ("  Porcentaje: {0:N2}% usado" -f $porcentajePageFile) -ForegroundColor Yellow
        } else {
            Write-Host "ARCHIVO DE PAGINACIÓN (Page File / Swap):" -ForegroundColor Green
            Write-Host "  No se encontró archivo de paginación configurado." -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "Error al obtener información de memoria: $_" -ForegroundColor Red
    }
    
    Write-Host ""
}
