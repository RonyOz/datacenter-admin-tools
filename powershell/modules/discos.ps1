function Listar-Discos {
    Clear-Host
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  FILESYSTEMS Y ESPACIO DISPONIBLE" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        $discos = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null }
        
        Write-Host ("{0,-10} {1,20} {2,20} {3,20} {4,10}" -f "Unidad", "Tamaño (bytes)", "Usado (bytes)", "Libre (bytes)", "Uso %") -ForegroundColor Green
        Write-Host ("-" * 85) -ForegroundColor Gray
        
        foreach ($disco in $discos) {
            $nombre = $disco.Name + ":\"
            $tamanoTotal = $disco.Used + $disco.Free
            $usado = $disco.Used
            $libre = $disco.Free
            $porcentajeUso = if ($tamanoTotal -gt 0) { 
                [math]::Round(($usado / $tamanoTotal) * 100, 2) 
            } else { 
                0 
            }
            
            Write-Host ("{0,-10} {1,20:N0} {2,20:N0} {3,20:N0} {4,10:N2}" -f $nombre, $tamanoTotal, $usado, $libre, $porcentajeUso)
        }
        
        Write-Host ""
        Write-Host "Total de unidades: $($discos.Count)" -ForegroundColor Yellow
        
    } catch {
        Write-Host "Error al obtener información de discos: $_" -ForegroundColor Red
    }
    
    Write-Host ""
}
